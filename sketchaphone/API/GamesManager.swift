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
    
    let numRounds = 9
    
    func new(phrase: String, callback: @escaping (Error?) -> Void) {
        NSLog("attempting to create game: " + phrase)
        appSyncClient?.perform(mutation: StartGameMutation(phrase: phrase), resultHandler: { (result, error) in
            if let error = error {
                NSLog("unexpected error type" + error.localizedDescription)
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
    
    func draw(image: UIImage, callback: @escaping (Error?, OpenGameDetailed?) -> Void) {
        uploadDrawing(image: image, callback: {(drawing, error) in
            if let error = error {
                callback(error, nil)
                return
            }
            appSyncClient!.perform(mutation: TakeTurnMutation(drawing: drawing), resultHandler: {(result, error) in
                self.takeTurnCallback(result: result, error: error, callback: callback)
            })
        })
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
        appSyncClient!.perform(mutation: TakeTurnMutation(phrase: phrase), resultHandler: {(result, error) in
            self.takeTurnCallback(result: result, error: error, callback: callback)
        })
    }
    
    private func takeTurnCallback(result: GraphQLResult<TakeTurnMutation.Data>?, error: Error?, callback: @escaping (Error?, OpenGameDetailed?) -> Void) {
        if let error = error {
            NSLog("unexpected error type" + error.localizedDescription)
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
        appSyncClient!.perform(mutation: RenewLockMutation(), resultHandler: {(result, error) in
            if let error = error {
                NSLog("Error renewing lock on game: \(error.localizedDescription)")
                self.renewLockTimer?.invalidate()
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
    
    private func stopRenewing() {
        self.renewLockTimer?.invalidate()
        self.renewLockTimer = nil
    }
    
    func release() {
        self.stopRenewing()
        appSyncClient?.perform(mutation: ReleaseGameMutation(), resultHandler: {(result, error) in
            if let error = error {
                NSLog("Error occurred: \(error.localizedDescription )")
                return
            }
            self.currentGame = nil
            
            NSLog("lock released successfully")
        })
    }
    
    func joinGame(delegate: JoinGameDelgate) {
        NSLog("attempting to join a game")
        appSyncClient!.perform(mutation: JoinGameMutation(), resultHandler: { (result, error) in
            NSLog("joinGame responded, handling response")
            if let error = error {
                NSLog("could not join game, encountered error: " + error.localizedDescription)
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
            self.renewLockTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: self.renewLock)
        })
    }
    
    func handleSignOut() {
        self.currentGame = nil
        self.renewLockDelegate = nil
        stopRenewing()
    }
}
