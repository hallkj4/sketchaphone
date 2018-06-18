import SQLite
import AWSAppSync

class LocalSQLiteManager {
    static let sharedInstance = LocalSQLiteManager()
    
    private let db : Connection
    
    private let flagsTable = Table("flags")
    private let flagsGameId = Expression<String>("gameId")
    
    private let completedGamesTable = Table("completedGames")
    private let completedGameId = Expression<String>("id")
    private let completedGameSerialized = Expression<String>("serialized")
    
    private let newlyCompletedGamesTable = Table("newlyCompletedGames")
    private let newlyCompletedGameId = Expression<String>("id")
    
    private let miscTable = Table("misc")
    private let miscKey = Expression<String>("key")
    private let miscValue = Expression<String>("value")
    
    init() {
        let basePath = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true).first!
        
        db = try! Connection("\(basePath)/doodlegame.sqlite3")
        
//        _ = Table("oldTableName").drop(ifExists: true)
        
        let createCompletedGamesTableQuery = completedGamesTable.create(ifNotExists: true) { table in
            table.column(completedGameId, unique: true)
            table.column(completedGameSerialized)
        }
        try! db.run(createCompletedGamesTableQuery)
        
        
        let createNewlyCompletedTableQuery = newlyCompletedGamesTable.create(ifNotExists: true) { table in
            table.column(newlyCompletedGameId, unique: true)
        }
        try! db.run(createNewlyCompletedTableQuery)
        
        let createFlagsTableQuery = flagsTable.create(ifNotExists: true) { table in
            table.column(flagsGameId, unique: true)
        }
        try! db.run(createFlagsTableQuery)
        
        let createMiscTableQuery = miscTable.create(ifNotExists: true) { table in
            table.column(miscKey, unique: true)
            table.column(miscValue)
        }
        try! db.run(createMiscTableQuery)
    }
    
    
    
//    func persist(completedGames: [GameDetailed]) {
//        clearCompletedGames()
//        for completedGame in completedGames {
//            persist(completedGame: completedGame)
//        }
//    }
    
    func persist(completedGame: GameDetailed) {
        NSLog("writing game \(completedGame.id)")
        do {
            let completedGameSerializedData = try JSONSerialization.data(withJSONObject: completedGame.jsonObject, options: [])
            let completedGameSerializedString = String(data: completedGameSerializedData, encoding: .utf8)!
            let insert = completedGamesTable.insert(completedGameId <- completedGame.id, completedGameSerialized <- completedGameSerializedString)
            try db.run(insert)
        }
        catch let error {
            NSLog("Error while persisting row: \(completedGame), error: \(error)")
        }
    }
    
    func delete(completedGameId: GraphQLID) {
        NSLog("deleting game \(completedGameId)")
        do {
            try db.run(completedGamesTable.where(self.completedGameId == completedGameId).delete())
        }
        catch let error {
            NSLog("error deleting completedGame \(completedGameId): \(error)")
        }
    }
    
    func clearCompletedGames() {
        do {
            try db.run(completedGamesTable.delete())  // Delete all the existing records
        }
        catch let error {
            NSLog("error clearing completedGamesTable: \(error)")
        }
    }
    
    func getCompletedGames() -> [GameDetailed] {
        var rankings = [GameDetailed]()
        do {
            let rows = try db.prepare(completedGamesTable)
            
            for row in rows {
                let rankingData = row[completedGameSerialized].data(using: .utf8)!
                let rankingJson = try JSONSerialization.jsonObject(with: rankingData, options: []) as! JSONObject
                let ranking = try GameDetailed(jsonObject: rankingJson)
                rankings.append(ranking)
            }
        }
        catch let error {
            NSLog("Error while loading getCompletedGames: \(error)")
        }
        return rankings
    }
    
    
//
//    func persist(flaggedGameIds: [GraphQLID]) {
//        clearFlags()
//        for gameId in flaggedGameIds {
//            persist(flaggedGameId: gameId)
//        }
//    }
    
    func persist(flaggedGameId: GraphQLID) {
        do {
            let insert = flagsTable.insert(flagsGameId <- flaggedGameId)
            try db.run(insert)
        }
        catch let error {
            NSLog("Error while persisting flaggedGameId: \(flaggedGameId), error: \(error)")
        }
    }
    
//    func delete(gameId: GraphQLID) {
//        do {
//            try db.run(flagsTable.where(completedGameId == gameId).delete())
//        }
//        catch let error {
//            NSLog("error deleting game \(gameId): \(error)")
//        }
//    }
    
    func clearFlags() {
        do {
            try db.run(flagsTable.delete())
        }
        catch let error {
            NSLog("error clearing all existing flags: \(error)")
        }
    }
    
    func getFlaggedGameIds() -> Set<GraphQLID> {
        var gameIds = Set<GraphQLID>()
        do {
            let rows = try db.prepare(flagsTable)
            
            for row in rows {
                gameIds.insert(row[flagsGameId])
            }
        }
        catch let error {
            NSLog("error getting all existing flags: \(error)")
        }
        return gameIds
    }
    
    
    //start newly completed game table operations
    func persist(newlyCompletedGameId: GraphQLID) {
        NSLog("writing newlyCompletedGameId \(newlyCompletedGameId)")
        do {
            let insert = newlyCompletedGamesTable.insert(self.newlyCompletedGameId <- newlyCompletedGameId)
            try db.run(insert)
        }
        catch let error {
            NSLog("Error while persisting newlyCompletedGameId: \(newlyCompletedGameId), error: \(error)")
        }
    }
    
    func delete(newlyCompletedGameId: GraphQLID) {
        NSLog("deleting newlyCompletedGameId \(newlyCompletedGameId)")
        do {
            try db.run(newlyCompletedGamesTable.where(self.newlyCompletedGameId == newlyCompletedGameId).delete())
        }
        catch let error {
            NSLog("error deleting newlyCompletedGameId \(newlyCompletedGameId): \(error)")
        }
    }
    
    func clearNewlyCompletedGames() {
        do {
            try db.run(newlyCompletedGamesTable.delete())
        }
        catch let error {
            NSLog("error clearing all existing flags: \(error)")
        }
    }
    
    func getNewlyCompletedGameIds() -> Set<GraphQLID> {
        var gameIds = Set<GraphQLID>()
        do {
            let rows = try db.prepare(newlyCompletedGamesTable)
            
            for row in rows {
                NSLog("read newlyCompletedGameId from database \(row[newlyCompletedGameId])")
                gameIds.insert(row[newlyCompletedGameId])
            }
        }
        catch let error {
            NSLog("error getting all newlyCompletedGameIds: \(error)")
        }
        return gameIds
    }
    
    func putMisc(key: String, value: String) {
        do {
            try db.run(miscTable.where(miscKey == key).delete())
            try db.run(miscTable.insert(miscKey <- key, miscValue <- value))
        }
        catch {
            NSLog("error persisting token: \(key), \(value)")
        }
    }
    
    func clearMisc() {
        do {
            try db.run(miscTable.delete())  // Delete all the existing records
        }
        catch {
            NSLog("error clearing ranking")
        }
    }
    
    func getMisc(key: String) -> String? {
        do {
            let rows = try db.prepare(miscTable.filter(miscKey == key).select(miscValue))
            for row in rows {
                return row[miscValue]
            }
            return nil
        }
        catch {
            NSLog("error getting token")
            return nil
        }
    }
}
