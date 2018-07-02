import AWSAppSync
import AWSS3

let gamesManager = GamesManager()

protocol JoinGameDelgate {
    func gameJoined()
    func couldNotJoinGame(message: String)
}

protocol RenewLockDelegate {
    func renewLockError(_ error: String)
}

class GamesManager {
    var currentGame: OpenGameDetailed?
    private var renewLockTimer: Timer?
    var renewLockDelegate: RenewLockDelegate?
    private var skipGameIds = [String]()
    private let maxGamesToSkip = 5
    
    let numRounds = 9
    
    func new(phrase: String, callback: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            NSLog("attempting to create game: " + phrase)
            appSyncClient?.perform(mutation: StartGameMutation(phrase: phrase), queue: DispatchQueue.global(qos: .userInitiated), resultHandler: { (result, error) in
                if let error = error {
                    NSLog("unexpected error type" + error.localizedDescription)
                    callback(error)
                    return
                }
                if let error = result?.errors?.first {
                    callback(error)
                    return
                }
                guard let newGame = result?.data?.startGame.fragments.openGameDetailed else {
                    NSLog("game data was not sent")
                    callback(NilDataError())
                    return
                }
                NSLog("game created: " + phrase)
                completedGameManager.appendCompleted(game: newGame)
                callback(nil)
            })
        }
    }
    
    func draw(image: UIImage, callback: @escaping (Error?, OpenGameDetailed?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.uploadDrawing(image: image, callback: {(drawing, error) in
                if let error = error {
                    callback(error, nil)
                    return
                }
                appSyncClient!.perform(mutation: TakeTurnMutation(drawing: drawing), queue: DispatchQueue.global(qos: .userInitiated), resultHandler: {(result, error) in
                    self.takeTurnCallback(result: result, error: error, callback: callback)
                })
            })
        }
    }
    
    private func skipGame(id: String) {
        if let index = skipGameIds.index(of: id) {
            skipGameIds.remove(at: index)
        }
        
        while (skipGameIds.count >= maxGamesToSkip) {
            var _ = skipGameIds.popLast()
        }
        skipGameIds.insert(id, at: 0)
    }
    
    private func uploadDrawing(image: UIImage, callback: @escaping (S3ObjectInput?, Error?) -> Void) {
        
        guard let uploadRequest = AWSS3TransferManagerUploadRequest() else {
            callback(nil, GenericError("couldn't create AWSS3TransferManagerUploadRequest"))
            return
        }
        uploadRequest.key = "\(UUID().uuidString).png"
        uploadRequest.bucket = S3BUCKET
        uploadRequest.contentType = "image/png"
        do {
            try uploadRequest.body = writeToFile(key: uploadRequest.key!, image: image)
        }
        catch {
            callback(nil, GenericError("couldn't write png to file system: \(error.localizedDescription)"))
            return
        }
        
        AWSS3TransferManager.default().upload(uploadRequest).continueWith(block: {(task) in
            if let error = task.error {
                callback(nil, error)
                return nil
            }
            callback(S3ObjectInput(bucket: S3BUCKET, key: uploadRequest.key!, region: AWSRegionString), nil)
            return nil
        })
    }
    
    private func writeToFile(key: String, image: UIImage) throws -> URL {
        guard let pngData = UIImagePNGRepresentation(image) else {
            throw GenericError("couldn't make PNG data from image")
        }
        let filePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(key)
        try pngData.write(to: filePath)
        return filePath
    }
    
    func guess(phrase: String, callback: @escaping (Error?, OpenGameDetailed?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            appSyncClient!.perform(mutation: TakeTurnMutation(phrase: phrase), queue: DispatchQueue.global(qos: .userInitiated), resultHandler: {(result, error) in
                self.takeTurnCallback(result: result, error: error, callback: callback)
            })
        }
    }
    
    private func takeTurnCallback(result: GraphQLResult<TakeTurnMutation.Data>?, error: Error?, callback: @escaping (Error?, OpenGameDetailed?) -> Void) {
        if let error = error {
            NSLog("unexpected error type" + error.localizedDescription)
            callback(error, nil)
            return
        }
        if let error = result?.errors?.first {
            callback(error, nil)
            return
        }
        
        guard let game = result?.data?.takeTurn else {
            NSLog("game data was not sent")
            callback(NilDataError(), nil)
            return
        }
        
        stopRenewing()
        completedGameManager.appendCompleted(game: game.fragments.openGameDetailed)
        callback(nil, game.fragments.openGameDetailed)
    }
    
    private func renewLock(timer: Timer) {
        NSLog("renewing lock")
        DispatchQueue.global(qos: .userInitiated).async {
            appSyncClient?.perform(mutation: RenewLockMutation(), queue: DispatchQueue.global(qos: .userInitiated), resultHandler: {(result, error) in
                if let error = error {
                    NSLog("Error renewing lock on game: \(error.localizedDescription)")
                    self.stopRenewing()
                    self.renewLockDelegate?.renewLockError(error.localizedDescription)
                    return
                }
                if let error = result?.errors?.first {
                    NSLog("Error renewing lock on game: \(error.localizedDescription)")
                    self.stopRenewing()
                    self.renewLockDelegate?.renewLockError(error.localizedDescription)
                    return
                }
                guard let game = result?.data?.renewLock.fragments.openGameDetailed else {
                    self.stopRenewing()
                    self.renewLockDelegate?.renewLockError("Renew did not return the locked game.")
                    return
                }
                if (game.id != self.currentGame?.id) {
                    self.stopRenewing()
                    self.renewLockDelegate?.renewLockError("Renew returned a different locked game!?")
                    return
                }
                NSLog("lock renewed")
            })
        }
    }
    
    private func stopRenewing() {
        DispatchQueue.main.async {
            self.renewLockTimer?.invalidate()
            self.renewLockTimer = nil
        }
    }
    
    func release() {
        if let id = currentGame?.id {
            skipGame(id: id)
        }
        DispatchQueue.global(qos: .userInitiated).async {
            self.stopRenewing()
            appSyncClient?.perform(mutation: ReleaseGameMutation(), queue: DispatchQueue.global(qos: .userInitiated), resultHandler: {(result, error) in
                if let error = error {
                    NSLog("Error occurred: \(error.localizedDescription)")
                    return
                }
                if let error = result?.errors?.first {
                    NSLog("Error occurred: \(error.localizedDescription)")
                    return
                }
                self.currentGame = nil
                
                NSLog("lock released successfully")
            })
        }
    }
    
    func joinGame(delegate: JoinGameDelgate) {
        DispatchQueue.global(qos: .userInitiated).async {
            NSLog("attempting to join a game")
            appSyncClient!.perform(mutation: JoinGameMutation(skipGameIds: self.skipGameIds), queue: DispatchQueue.global(qos: .userInitiated), resultHandler: { (result, error) in
                NSLog("joinGame responded, handling response")
                if let error = error {
                    NSLog("could not join game, encountered error: " + error.localizedDescription)
                    delegate.couldNotJoinGame(message: error.localizedDescription)
                    return
                }
                if let error = result?.errors?.first {
                    delegate.couldNotJoinGame(message: error.localizedDescription)
                    return
                }
                guard let gameRaw = result?.data?.joinGame else {
                    NSLog("could not join game: no games were found")
                    delegate.couldNotJoinGame(message: "No games were found")
                    return
                }
                let game = gameRaw.fragments.openGameDetailed
                NSLog("Joined a game: " + game.id)
                self.currentGame = game
                delegate.gameJoined()
                DispatchQueue.main.async {
                    self.renewLockTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: self.renewLock)
                }
            })
        }
    }
    
    func handleSignOut() {
        self.currentGame = nil
        self.renewLockDelegate = nil
        stopRenewing()
    }
}
