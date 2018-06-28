//  This file was automatically generated and should not be edited.

import AWSAppSync

public struct S3ObjectInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(bucket: String, key: String, region: String, localUri: Optional<String?> = nil, mimeType: Optional<String?> = nil) {
    graphQLMap = ["bucket": bucket, "key": key, "region": region, "localUri": localUri, "mimeType": mimeType]
  }

  public var bucket: String {
    get {
      return graphQLMap["bucket"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "bucket")
    }
  }

  public var key: String {
    get {
      return graphQLMap["key"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "key")
    }
  }

  public var region: String {
    get {
      return graphQLMap["region"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "region")
    }
  }

  public var localUri: Optional<String?> {
    get {
      return graphQLMap["localUri"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "localUri")
    }
  }

  public var mimeType: Optional<String?> {
    get {
      return graphQLMap["mimeType"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mimeType")
    }
  }
}

public final class FlagGameMutation: GraphQLMutation {
  public static let operationString =
    "mutation flagGame($gameId: ID!, $reason: String!) {\n  flagGame(gameId: $gameId, reason: $reason) {\n    __typename\n    gameId\n  }\n}"

  public var gameId: GraphQLID
  public var reason: String

  public init(gameId: GraphQLID, reason: String) {
    self.gameId = gameId
    self.reason = reason
  }

  public var variables: GraphQLMap? {
    return ["gameId": gameId, "reason": reason]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("flagGame", arguments: ["gameId": GraphQLVariable("gameId"), "reason": GraphQLVariable("reason")], type: .nonNull(.object(FlagGame.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(flagGame: FlagGame) {
      self.init(snapshot: ["__typename": "Mutation", "flagGame": flagGame.snapshot])
    }

    public var flagGame: FlagGame {
      get {
        return FlagGame(snapshot: snapshot["flagGame"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "flagGame")
      }
    }

    public struct FlagGame: GraphQLSelectionSet {
      public static let possibleTypes = ["Flag"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("gameId", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(gameId: GraphQLID) {
        self.init(snapshot: ["__typename": "Flag", "gameId": gameId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var gameId: GraphQLID {
        get {
          return snapshot["gameId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "gameId")
        }
      }
    }
  }
}

public final class JoinGameMutation: GraphQLMutation {
  public static let operationString =
    "mutation joinGame {\n  joinGame {\n    __typename\n    ...OpenGameDetailed\n  }\n}"

  public static var requestString: String { return operationString.appending(OpenGameDetailed.fragmentString).appending(GameDetailed.fragmentString).appending(UserBasic.fragmentString) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("joinGame", type: .object(JoinGame.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(joinGame: JoinGame? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "joinGame": joinGame.flatMap { $0.snapshot }])
    }

    public var joinGame: JoinGame? {
      get {
        return (snapshot["joinGame"] as? Snapshot).flatMap { JoinGame(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "joinGame")
      }
    }

    public struct JoinGame: GraphQLSelectionSet {
      public static let possibleTypes = ["OpenGame"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
        GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
        GraphQLField("lockedAt", type: .scalar(String.self)),
        GraphQLField("lockedById", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, turns: [Turn], flags: [Flag], lockedAt: String? = nil, lockedById: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "OpenGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }, "lockedAt": lockedAt, "lockedById": lockedById])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var turns: [Turn] {
        get {
          return (snapshot["turns"] as! [Snapshot]).map { Turn(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "turns")
        }
      }

      public var flags: [Flag] {
        get {
          return (snapshot["flags"] as! [Snapshot]).map { Flag(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "flags")
        }
      }

      public var lockedAt: String? {
        get {
          return snapshot["lockedAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lockedAt")
        }
      }

      public var lockedById: GraphQLID? {
        get {
          return snapshot["lockedById"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "lockedById")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var openGameDetailed: OpenGameDetailed {
          get {
            return OpenGameDetailed(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        public var gameDetailed: GameDetailed {
          get {
            return GameDetailed(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      public struct Turn: GraphQLSelectionSet {
        public static let possibleTypes = ["OpenTurn", "CompletedTurn"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("order", type: .nonNull(.scalar(Int.self))),
          GraphQLField("user", type: .nonNull(.object(User.selections))),
          GraphQLField("phrase", type: .scalar(String.self)),
          GraphQLField("drawing", type: .object(Drawing.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public static func makeOpenTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
          return Turn(snapshot: ["__typename": "OpenTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
        }

        public static func makeCompletedTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
          return Turn(snapshot: ["__typename": "CompletedTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var order: Int {
          get {
            return snapshot["order"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "order")
          }
        }

        public var user: User {
          get {
            return User(snapshot: snapshot["user"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "user")
          }
        }

        public var phrase: String? {
          get {
            return snapshot["phrase"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phrase")
          }
        }

        public var drawing: Drawing? {
          get {
            return (snapshot["drawing"] as? Snapshot).flatMap { Drawing(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "drawing")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public struct User: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, name: String) {
            self.init(snapshot: ["__typename": "User", "id": id, "name": name])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var name: String {
            get {
              return snapshot["name"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }

          public struct Fragments {
            public var snapshot: Snapshot

            public var userBasic: UserBasic {
              get {
                return UserBasic(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }
          }
        }

        public struct Drawing: GraphQLSelectionSet {
          public static let possibleTypes = ["S3Object"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("key", type: .nonNull(.scalar(String.self))),
            GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
            GraphQLField("region", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(key: String, bucket: String, region: String) {
            self.init(snapshot: ["__typename": "S3Object", "key": key, "bucket": bucket, "region": region])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var key: String {
            get {
              return snapshot["key"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "key")
            }
          }

          public var bucket: String {
            get {
              return snapshot["bucket"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "bucket")
            }
          }

          public var region: String {
            get {
              return snapshot["region"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "region")
            }
          }
        }
      }

      public struct Flag: GraphQLSelectionSet {
        public static let possibleTypes = ["Flag"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("reason", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(userId: GraphQLID, reason: String) {
          self.init(snapshot: ["__typename": "Flag", "userId": userId, "reason": reason])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        public var reason: String {
          get {
            return snapshot["reason"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "reason")
          }
        }
      }
    }
  }
}

public final class ReleaseGameMutation: GraphQLMutation {
  public static let operationString =
    "mutation releaseGame {\n  releaseGame {\n    __typename\n    id\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("releaseGame", type: .nonNull(.object(ReleaseGame.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(releaseGame: ReleaseGame) {
      self.init(snapshot: ["__typename": "Mutation", "releaseGame": releaseGame.snapshot])
    }

    public var releaseGame: ReleaseGame {
      get {
        return ReleaseGame(snapshot: snapshot["releaseGame"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "releaseGame")
      }
    }

    public struct ReleaseGame: GraphQLSelectionSet {
      public static let possibleTypes = ["CompletedGame", "OpenGame"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public static func makeCompletedGame(id: GraphQLID) -> ReleaseGame {
        return ReleaseGame(snapshot: ["__typename": "CompletedGame", "id": id])
      }

      public static func makeOpenGame(id: GraphQLID) -> ReleaseGame {
        return ReleaseGame(snapshot: ["__typename": "OpenGame", "id": id])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class RenewLockMutation: GraphQLMutation {
  public static let operationString =
    "mutation renewLock {\n  renewLock {\n    __typename\n    ...OpenGameDetailed\n  }\n}"

  public static var requestString: String { return operationString.appending(OpenGameDetailed.fragmentString).appending(GameDetailed.fragmentString).appending(UserBasic.fragmentString) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("renewLock", type: .nonNull(.object(RenewLock.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(renewLock: RenewLock) {
      self.init(snapshot: ["__typename": "Mutation", "renewLock": renewLock.snapshot])
    }

    public var renewLock: RenewLock {
      get {
        return RenewLock(snapshot: snapshot["renewLock"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "renewLock")
      }
    }

    public struct RenewLock: GraphQLSelectionSet {
      public static let possibleTypes = ["OpenGame"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
        GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
        GraphQLField("lockedAt", type: .scalar(String.self)),
        GraphQLField("lockedById", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, turns: [Turn], flags: [Flag], lockedAt: String? = nil, lockedById: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "OpenGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }, "lockedAt": lockedAt, "lockedById": lockedById])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var turns: [Turn] {
        get {
          return (snapshot["turns"] as! [Snapshot]).map { Turn(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "turns")
        }
      }

      public var flags: [Flag] {
        get {
          return (snapshot["flags"] as! [Snapshot]).map { Flag(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "flags")
        }
      }

      public var lockedAt: String? {
        get {
          return snapshot["lockedAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lockedAt")
        }
      }

      public var lockedById: GraphQLID? {
        get {
          return snapshot["lockedById"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "lockedById")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var openGameDetailed: OpenGameDetailed {
          get {
            return OpenGameDetailed(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        public var gameDetailed: GameDetailed {
          get {
            return GameDetailed(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      public struct Turn: GraphQLSelectionSet {
        public static let possibleTypes = ["OpenTurn", "CompletedTurn"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("order", type: .nonNull(.scalar(Int.self))),
          GraphQLField("user", type: .nonNull(.object(User.selections))),
          GraphQLField("phrase", type: .scalar(String.self)),
          GraphQLField("drawing", type: .object(Drawing.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public static func makeOpenTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
          return Turn(snapshot: ["__typename": "OpenTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
        }

        public static func makeCompletedTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
          return Turn(snapshot: ["__typename": "CompletedTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var order: Int {
          get {
            return snapshot["order"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "order")
          }
        }

        public var user: User {
          get {
            return User(snapshot: snapshot["user"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "user")
          }
        }

        public var phrase: String? {
          get {
            return snapshot["phrase"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phrase")
          }
        }

        public var drawing: Drawing? {
          get {
            return (snapshot["drawing"] as? Snapshot).flatMap { Drawing(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "drawing")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public struct User: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, name: String) {
            self.init(snapshot: ["__typename": "User", "id": id, "name": name])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var name: String {
            get {
              return snapshot["name"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }

          public struct Fragments {
            public var snapshot: Snapshot

            public var userBasic: UserBasic {
              get {
                return UserBasic(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }
          }
        }

        public struct Drawing: GraphQLSelectionSet {
          public static let possibleTypes = ["S3Object"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("key", type: .nonNull(.scalar(String.self))),
            GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
            GraphQLField("region", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(key: String, bucket: String, region: String) {
            self.init(snapshot: ["__typename": "S3Object", "key": key, "bucket": bucket, "region": region])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var key: String {
            get {
              return snapshot["key"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "key")
            }
          }

          public var bucket: String {
            get {
              return snapshot["bucket"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "bucket")
            }
          }

          public var region: String {
            get {
              return snapshot["region"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "region")
            }
          }
        }
      }

      public struct Flag: GraphQLSelectionSet {
        public static let possibleTypes = ["Flag"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("reason", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(userId: GraphQLID, reason: String) {
          self.init(snapshot: ["__typename": "Flag", "userId": userId, "reason": reason])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        public var reason: String {
          get {
            return snapshot["reason"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "reason")
          }
        }
      }
    }
  }
}

public final class SetDeviceTokenMutation: GraphQLMutation {
  public static let operationString =
    "mutation setDeviceToken($token: String, $sandbox: Boolean) {\n  setDeviceToken(token: $token, sandbox: $sandbox)\n}"

  public var token: String?
  public var sandbox: Bool?

  public init(token: String? = nil, sandbox: Bool? = nil) {
    self.token = token
    self.sandbox = sandbox
  }

  public var variables: GraphQLMap? {
    return ["token": token, "sandbox": sandbox]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("setDeviceToken", arguments: ["token": GraphQLVariable("token"), "sandbox": GraphQLVariable("sandbox")], type: .nonNull(.scalar(Bool.self))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(setDeviceToken: Bool) {
      self.init(snapshot: ["__typename": "Mutation", "setDeviceToken": setDeviceToken])
    }

    public var setDeviceToken: Bool {
      get {
        return snapshot["setDeviceToken"]! as! Bool
      }
      set {
        snapshot.updateValue(newValue, forKey: "setDeviceToken")
      }
    }
  }
}

public final class SetNameMutation: GraphQLMutation {
  public static let operationString =
    "mutation setName($name: String!) {\n  setName(name: $name) {\n    __typename\n    ...UserBasic\n  }\n}"

  public static var requestString: String { return operationString.appending(UserBasic.fragmentString) }

  public var name: String

  public init(name: String) {
    self.name = name
  }

  public var variables: GraphQLMap? {
    return ["name": name]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("setName", arguments: ["name": GraphQLVariable("name")], type: .nonNull(.object(SetName.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(setName: SetName) {
      self.init(snapshot: ["__typename": "Mutation", "setName": setName.snapshot])
    }

    public var setName: SetName {
      get {
        return SetName(snapshot: snapshot["setName"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "setName")
      }
    }

    public struct SetName: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var userBasic: UserBasic {
          get {
            return UserBasic(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }
    }
  }
}

public final class StartGameMutation: GraphQLMutation {
  public static let operationString =
    "mutation startGame($phrase: String!) {\n  startGame(phrase: $phrase) {\n    __typename\n    ...OpenGameDetailed\n  }\n}"

  public static var requestString: String { return operationString.appending(OpenGameDetailed.fragmentString).appending(GameDetailed.fragmentString).appending(UserBasic.fragmentString) }

  public var phrase: String

  public init(phrase: String) {
    self.phrase = phrase
  }

  public var variables: GraphQLMap? {
    return ["phrase": phrase]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("startGame", arguments: ["phrase": GraphQLVariable("phrase")], type: .nonNull(.object(StartGame.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(startGame: StartGame) {
      self.init(snapshot: ["__typename": "Mutation", "startGame": startGame.snapshot])
    }

    public var startGame: StartGame {
      get {
        return StartGame(snapshot: snapshot["startGame"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "startGame")
      }
    }

    public struct StartGame: GraphQLSelectionSet {
      public static let possibleTypes = ["CompletedGame", "OpenGame"]

      public static let selections: [GraphQLSelection] = [
        GraphQLTypeCase(
          variants: ["OpenGame": AsOpenGame.selections],
          default: [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
            GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
          ]
        )
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public static func makeCompletedGame(id: GraphQLID, turns: [Turn], flags: [Flag]) -> StartGame {
        return StartGame(snapshot: ["__typename": "CompletedGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }])
      }

      public static func makeOpenGame(id: GraphQLID, turns: [AsOpenGame.Turn], flags: [AsOpenGame.Flag], lockedAt: String? = nil, lockedById: GraphQLID? = nil) -> StartGame {
        return StartGame(snapshot: ["__typename": "OpenGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }, "lockedAt": lockedAt, "lockedById": lockedById])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var turns: [Turn] {
        get {
          return (snapshot["turns"] as! [Snapshot]).map { Turn(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "turns")
        }
      }

      public var flags: [Flag] {
        get {
          return (snapshot["flags"] as! [Snapshot]).map { Flag(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "flags")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var openGameDetailed: OpenGameDetailed {
          get {
            return OpenGameDetailed(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        public var gameDetailed: GameDetailed {
          get {
            return GameDetailed(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      public struct Turn: GraphQLSelectionSet {
        public static let possibleTypes = ["OpenTurn", "CompletedTurn"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("order", type: .nonNull(.scalar(Int.self))),
          GraphQLField("user", type: .nonNull(.object(User.selections))),
          GraphQLField("phrase", type: .scalar(String.self)),
          GraphQLField("drawing", type: .object(Drawing.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public static func makeOpenTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
          return Turn(snapshot: ["__typename": "OpenTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
        }

        public static func makeCompletedTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
          return Turn(snapshot: ["__typename": "CompletedTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var order: Int {
          get {
            return snapshot["order"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "order")
          }
        }

        public var user: User {
          get {
            return User(snapshot: snapshot["user"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "user")
          }
        }

        public var phrase: String? {
          get {
            return snapshot["phrase"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phrase")
          }
        }

        public var drawing: Drawing? {
          get {
            return (snapshot["drawing"] as? Snapshot).flatMap { Drawing(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "drawing")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public struct User: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, name: String) {
            self.init(snapshot: ["__typename": "User", "id": id, "name": name])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var name: String {
            get {
              return snapshot["name"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }

          public struct Fragments {
            public var snapshot: Snapshot

            public var userBasic: UserBasic {
              get {
                return UserBasic(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }
          }
        }

        public struct Drawing: GraphQLSelectionSet {
          public static let possibleTypes = ["S3Object"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("key", type: .nonNull(.scalar(String.self))),
            GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
            GraphQLField("region", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(key: String, bucket: String, region: String) {
            self.init(snapshot: ["__typename": "S3Object", "key": key, "bucket": bucket, "region": region])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var key: String {
            get {
              return snapshot["key"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "key")
            }
          }

          public var bucket: String {
            get {
              return snapshot["bucket"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "bucket")
            }
          }

          public var region: String {
            get {
              return snapshot["region"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "region")
            }
          }
        }
      }

      public struct Flag: GraphQLSelectionSet {
        public static let possibleTypes = ["Flag"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("reason", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(userId: GraphQLID, reason: String) {
          self.init(snapshot: ["__typename": "Flag", "userId": userId, "reason": reason])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        public var reason: String {
          get {
            return snapshot["reason"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "reason")
          }
        }
      }

      public var asOpenGame: AsOpenGame? {
        get {
          if !AsOpenGame.possibleTypes.contains(__typename) { return nil }
          return AsOpenGame(snapshot: snapshot)
        }
        set {
          guard let newValue = newValue else { return }
          snapshot = newValue.snapshot
        }
      }

      public struct AsOpenGame: GraphQLSelectionSet {
        public static let possibleTypes = ["OpenGame"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
          GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
          GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
          GraphQLField("lockedAt", type: .scalar(String.self)),
          GraphQLField("lockedById", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, turns: [Turn], flags: [Flag], lockedAt: String? = nil, lockedById: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "OpenGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }, "lockedAt": lockedAt, "lockedById": lockedById])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var turns: [Turn] {
          get {
            return (snapshot["turns"] as! [Snapshot]).map { Turn(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "turns")
          }
        }

        public var flags: [Flag] {
          get {
            return (snapshot["flags"] as! [Snapshot]).map { Flag(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "flags")
          }
        }

        public var lockedAt: String? {
          get {
            return snapshot["lockedAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lockedAt")
          }
        }

        public var lockedById: GraphQLID? {
          get {
            return snapshot["lockedById"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "lockedById")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        public struct Fragments {
          public var snapshot: Snapshot

          public var openGameDetailed: OpenGameDetailed {
            get {
              return OpenGameDetailed(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }

          public var gameDetailed: GameDetailed {
            get {
              return GameDetailed(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }
        }

        public struct Turn: GraphQLSelectionSet {
          public static let possibleTypes = ["OpenTurn", "CompletedTurn"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("order", type: .nonNull(.scalar(Int.self))),
            GraphQLField("user", type: .nonNull(.object(User.selections))),
            GraphQLField("phrase", type: .scalar(String.self)),
            GraphQLField("drawing", type: .object(Drawing.selections)),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("order", type: .nonNull(.scalar(Int.self))),
            GraphQLField("user", type: .nonNull(.object(User.selections))),
            GraphQLField("phrase", type: .scalar(String.self)),
            GraphQLField("drawing", type: .object(Drawing.selections)),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public static func makeOpenTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
            return Turn(snapshot: ["__typename": "OpenTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
          }

          public static func makeCompletedTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
            return Turn(snapshot: ["__typename": "CompletedTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var order: Int {
            get {
              return snapshot["order"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "order")
            }
          }

          public var user: User {
            get {
              return User(snapshot: snapshot["user"]! as! Snapshot)
            }
            set {
              snapshot.updateValue(newValue.snapshot, forKey: "user")
            }
          }

          public var phrase: String? {
            get {
              return snapshot["phrase"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "phrase")
            }
          }

          public var drawing: Drawing? {
            get {
              return (snapshot["drawing"] as? Snapshot).flatMap { Drawing(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "drawing")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public struct User: GraphQLSelectionSet {
            public static let possibleTypes = ["User"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(id: GraphQLID, name: String) {
              self.init(snapshot: ["__typename": "User", "id": id, "name": name])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: GraphQLID {
              get {
                return snapshot["id"]! as! GraphQLID
              }
              set {
                snapshot.updateValue(newValue, forKey: "id")
              }
            }

            public var name: String {
              get {
                return snapshot["name"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "name")
              }
            }

            public var fragments: Fragments {
              get {
                return Fragments(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }

            public struct Fragments {
              public var snapshot: Snapshot

              public var userBasic: UserBasic {
                get {
                  return UserBasic(snapshot: snapshot)
                }
                set {
                  snapshot += newValue.snapshot
                }
              }
            }
          }

          public struct Drawing: GraphQLSelectionSet {
            public static let possibleTypes = ["S3Object"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("key", type: .nonNull(.scalar(String.self))),
              GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
              GraphQLField("region", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("key", type: .nonNull(.scalar(String.self))),
              GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
              GraphQLField("region", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(key: String, bucket: String, region: String) {
              self.init(snapshot: ["__typename": "S3Object", "key": key, "bucket": bucket, "region": region])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var key: String {
              get {
                return snapshot["key"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "key")
              }
            }

            public var bucket: String {
              get {
                return snapshot["bucket"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "bucket")
              }
            }

            public var region: String {
              get {
                return snapshot["region"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "region")
              }
            }
          }
        }

        public struct Flag: GraphQLSelectionSet {
          public static let possibleTypes = ["Flag"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("reason", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("reason", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(userId: GraphQLID, reason: String) {
            self.init(snapshot: ["__typename": "Flag", "userId": userId, "reason": reason])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var userId: GraphQLID {
            get {
              return snapshot["userId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }

          public var reason: String {
            get {
              return snapshot["reason"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "reason")
            }
          }
        }
      }
    }
  }
}

public final class TakeTurnMutation: GraphQLMutation {
  public static let operationString =
    "mutation takeTurn($phrase: String, $drawing: S3ObjectInput) {\n  takeTurn(phrase: $phrase, drawing: $drawing) {\n    __typename\n    ...OpenGameDetailed\n  }\n}"

  public static var requestString: String { return operationString.appending(OpenGameDetailed.fragmentString).appending(GameDetailed.fragmentString).appending(UserBasic.fragmentString) }

  public var phrase: String?
  public var drawing: S3ObjectInput?

  public init(phrase: String? = nil, drawing: S3ObjectInput? = nil) {
    self.phrase = phrase
    self.drawing = drawing
  }

  public var variables: GraphQLMap? {
    return ["phrase": phrase, "drawing": drawing]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("takeTurn", arguments: ["phrase": GraphQLVariable("phrase"), "drawing": GraphQLVariable("drawing")], type: .nonNull(.object(TakeTurn.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(takeTurn: TakeTurn) {
      self.init(snapshot: ["__typename": "Mutation", "takeTurn": takeTurn.snapshot])
    }

    public var takeTurn: TakeTurn {
      get {
        return TakeTurn(snapshot: snapshot["takeTurn"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "takeTurn")
      }
    }

    public struct TakeTurn: GraphQLSelectionSet {
      public static let possibleTypes = ["CompletedGame", "OpenGame"]

      public static let selections: [GraphQLSelection] = [
        GraphQLTypeCase(
          variants: ["OpenGame": AsOpenGame.selections],
          default: [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
            GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
          ]
        )
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public static func makeCompletedGame(id: GraphQLID, turns: [Turn], flags: [Flag]) -> TakeTurn {
        return TakeTurn(snapshot: ["__typename": "CompletedGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }])
      }

      public static func makeOpenGame(id: GraphQLID, turns: [AsOpenGame.Turn], flags: [AsOpenGame.Flag], lockedAt: String? = nil, lockedById: GraphQLID? = nil) -> TakeTurn {
        return TakeTurn(snapshot: ["__typename": "OpenGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }, "lockedAt": lockedAt, "lockedById": lockedById])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var turns: [Turn] {
        get {
          return (snapshot["turns"] as! [Snapshot]).map { Turn(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "turns")
        }
      }

      public var flags: [Flag] {
        get {
          return (snapshot["flags"] as! [Snapshot]).map { Flag(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "flags")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var openGameDetailed: OpenGameDetailed {
          get {
            return OpenGameDetailed(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        public var gameDetailed: GameDetailed {
          get {
            return GameDetailed(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      public struct Turn: GraphQLSelectionSet {
        public static let possibleTypes = ["OpenTurn", "CompletedTurn"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("order", type: .nonNull(.scalar(Int.self))),
          GraphQLField("user", type: .nonNull(.object(User.selections))),
          GraphQLField("phrase", type: .scalar(String.self)),
          GraphQLField("drawing", type: .object(Drawing.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public static func makeOpenTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
          return Turn(snapshot: ["__typename": "OpenTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
        }

        public static func makeCompletedTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
          return Turn(snapshot: ["__typename": "CompletedTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var order: Int {
          get {
            return snapshot["order"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "order")
          }
        }

        public var user: User {
          get {
            return User(snapshot: snapshot["user"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "user")
          }
        }

        public var phrase: String? {
          get {
            return snapshot["phrase"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phrase")
          }
        }

        public var drawing: Drawing? {
          get {
            return (snapshot["drawing"] as? Snapshot).flatMap { Drawing(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "drawing")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public struct User: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, name: String) {
            self.init(snapshot: ["__typename": "User", "id": id, "name": name])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var name: String {
            get {
              return snapshot["name"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }

          public struct Fragments {
            public var snapshot: Snapshot

            public var userBasic: UserBasic {
              get {
                return UserBasic(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }
          }
        }

        public struct Drawing: GraphQLSelectionSet {
          public static let possibleTypes = ["S3Object"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("key", type: .nonNull(.scalar(String.self))),
            GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
            GraphQLField("region", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(key: String, bucket: String, region: String) {
            self.init(snapshot: ["__typename": "S3Object", "key": key, "bucket": bucket, "region": region])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var key: String {
            get {
              return snapshot["key"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "key")
            }
          }

          public var bucket: String {
            get {
              return snapshot["bucket"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "bucket")
            }
          }

          public var region: String {
            get {
              return snapshot["region"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "region")
            }
          }
        }
      }

      public struct Flag: GraphQLSelectionSet {
        public static let possibleTypes = ["Flag"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("reason", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(userId: GraphQLID, reason: String) {
          self.init(snapshot: ["__typename": "Flag", "userId": userId, "reason": reason])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        public var reason: String {
          get {
            return snapshot["reason"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "reason")
          }
        }
      }

      public var asOpenGame: AsOpenGame? {
        get {
          if !AsOpenGame.possibleTypes.contains(__typename) { return nil }
          return AsOpenGame(snapshot: snapshot)
        }
        set {
          guard let newValue = newValue else { return }
          snapshot = newValue.snapshot
        }
      }

      public struct AsOpenGame: GraphQLSelectionSet {
        public static let possibleTypes = ["OpenGame"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
          GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
          GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
          GraphQLField("lockedAt", type: .scalar(String.self)),
          GraphQLField("lockedById", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, turns: [Turn], flags: [Flag], lockedAt: String? = nil, lockedById: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "OpenGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }, "lockedAt": lockedAt, "lockedById": lockedById])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var turns: [Turn] {
          get {
            return (snapshot["turns"] as! [Snapshot]).map { Turn(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "turns")
          }
        }

        public var flags: [Flag] {
          get {
            return (snapshot["flags"] as! [Snapshot]).map { Flag(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "flags")
          }
        }

        public var lockedAt: String? {
          get {
            return snapshot["lockedAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lockedAt")
          }
        }

        public var lockedById: GraphQLID? {
          get {
            return snapshot["lockedById"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "lockedById")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        public struct Fragments {
          public var snapshot: Snapshot

          public var openGameDetailed: OpenGameDetailed {
            get {
              return OpenGameDetailed(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }

          public var gameDetailed: GameDetailed {
            get {
              return GameDetailed(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }
        }

        public struct Turn: GraphQLSelectionSet {
          public static let possibleTypes = ["OpenTurn", "CompletedTurn"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("order", type: .nonNull(.scalar(Int.self))),
            GraphQLField("user", type: .nonNull(.object(User.selections))),
            GraphQLField("phrase", type: .scalar(String.self)),
            GraphQLField("drawing", type: .object(Drawing.selections)),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("order", type: .nonNull(.scalar(Int.self))),
            GraphQLField("user", type: .nonNull(.object(User.selections))),
            GraphQLField("phrase", type: .scalar(String.self)),
            GraphQLField("drawing", type: .object(Drawing.selections)),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public static func makeOpenTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
            return Turn(snapshot: ["__typename": "OpenTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
          }

          public static func makeCompletedTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
            return Turn(snapshot: ["__typename": "CompletedTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var order: Int {
            get {
              return snapshot["order"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "order")
            }
          }

          public var user: User {
            get {
              return User(snapshot: snapshot["user"]! as! Snapshot)
            }
            set {
              snapshot.updateValue(newValue.snapshot, forKey: "user")
            }
          }

          public var phrase: String? {
            get {
              return snapshot["phrase"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "phrase")
            }
          }

          public var drawing: Drawing? {
            get {
              return (snapshot["drawing"] as? Snapshot).flatMap { Drawing(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "drawing")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public struct User: GraphQLSelectionSet {
            public static let possibleTypes = ["User"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(id: GraphQLID, name: String) {
              self.init(snapshot: ["__typename": "User", "id": id, "name": name])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: GraphQLID {
              get {
                return snapshot["id"]! as! GraphQLID
              }
              set {
                snapshot.updateValue(newValue, forKey: "id")
              }
            }

            public var name: String {
              get {
                return snapshot["name"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "name")
              }
            }

            public var fragments: Fragments {
              get {
                return Fragments(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }

            public struct Fragments {
              public var snapshot: Snapshot

              public var userBasic: UserBasic {
                get {
                  return UserBasic(snapshot: snapshot)
                }
                set {
                  snapshot += newValue.snapshot
                }
              }
            }
          }

          public struct Drawing: GraphQLSelectionSet {
            public static let possibleTypes = ["S3Object"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("key", type: .nonNull(.scalar(String.self))),
              GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
              GraphQLField("region", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("key", type: .nonNull(.scalar(String.self))),
              GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
              GraphQLField("region", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(key: String, bucket: String, region: String) {
              self.init(snapshot: ["__typename": "S3Object", "key": key, "bucket": bucket, "region": region])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var key: String {
              get {
                return snapshot["key"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "key")
              }
            }

            public var bucket: String {
              get {
                return snapshot["bucket"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "bucket")
              }
            }

            public var region: String {
              get {
                return snapshot["region"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "region")
              }
            }
          }
        }

        public struct Flag: GraphQLSelectionSet {
          public static let possibleTypes = ["Flag"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("reason", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("reason", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(userId: GraphQLID, reason: String) {
            self.init(snapshot: ["__typename": "Flag", "userId": userId, "reason": reason])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var userId: GraphQLID {
            get {
              return snapshot["userId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }

          public var reason: String {
            get {
              return snapshot["reason"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "reason")
            }
          }
        }
      }
    }
  }
}

public final class CompletedGameQuery: GraphQLQuery {
  public static let operationString =
    "query completedGame($id: ID!) {\n  completedGame(id: $id) {\n    __typename\n    ...GameDetailed\n  }\n}"

  public static var requestString: String { return operationString.appending(GameDetailed.fragmentString).appending(UserBasic.fragmentString) }

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("completedGame", arguments: ["id": GraphQLVariable("id")], type: .object(CompletedGame.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(completedGame: CompletedGame? = nil) {
      self.init(snapshot: ["__typename": "Query", "completedGame": completedGame.flatMap { $0.snapshot }])
    }

    public var completedGame: CompletedGame? {
      get {
        return (snapshot["completedGame"] as? Snapshot).flatMap { CompletedGame(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "completedGame")
      }
    }

    public struct CompletedGame: GraphQLSelectionSet {
      public static let possibleTypes = ["CompletedGame"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
        GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, turns: [Turn], flags: [Flag]) {
        self.init(snapshot: ["__typename": "CompletedGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var turns: [Turn] {
        get {
          return (snapshot["turns"] as! [Snapshot]).map { Turn(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "turns")
        }
      }

      public var flags: [Flag] {
        get {
          return (snapshot["flags"] as! [Snapshot]).map { Flag(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "flags")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var gameDetailed: GameDetailed {
          get {
            return GameDetailed(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      public struct Turn: GraphQLSelectionSet {
        public static let possibleTypes = ["OpenTurn", "CompletedTurn"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("order", type: .nonNull(.scalar(Int.self))),
          GraphQLField("user", type: .nonNull(.object(User.selections))),
          GraphQLField("phrase", type: .scalar(String.self)),
          GraphQLField("drawing", type: .object(Drawing.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public static func makeOpenTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
          return Turn(snapshot: ["__typename": "OpenTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
        }

        public static func makeCompletedTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
          return Turn(snapshot: ["__typename": "CompletedTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var order: Int {
          get {
            return snapshot["order"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "order")
          }
        }

        public var user: User {
          get {
            return User(snapshot: snapshot["user"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "user")
          }
        }

        public var phrase: String? {
          get {
            return snapshot["phrase"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phrase")
          }
        }

        public var drawing: Drawing? {
          get {
            return (snapshot["drawing"] as? Snapshot).flatMap { Drawing(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "drawing")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public struct User: GraphQLSelectionSet {
          public static let possibleTypes = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, name: String) {
            self.init(snapshot: ["__typename": "User", "id": id, "name": name])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var name: String {
            get {
              return snapshot["name"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }

          public struct Fragments {
            public var snapshot: Snapshot

            public var userBasic: UserBasic {
              get {
                return UserBasic(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }
          }
        }

        public struct Drawing: GraphQLSelectionSet {
          public static let possibleTypes = ["S3Object"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("key", type: .nonNull(.scalar(String.self))),
            GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
            GraphQLField("region", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(key: String, bucket: String, region: String) {
            self.init(snapshot: ["__typename": "S3Object", "key": key, "bucket": bucket, "region": region])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var key: String {
            get {
              return snapshot["key"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "key")
            }
          }

          public var bucket: String {
            get {
              return snapshot["bucket"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "bucket")
            }
          }

          public var region: String {
            get {
              return snapshot["region"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "region")
            }
          }
        }
      }

      public struct Flag: GraphQLSelectionSet {
        public static let possibleTypes = ["Flag"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("reason", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(userId: GraphQLID, reason: String) {
          self.init(snapshot: ["__typename": "Flag", "userId": userId, "reason": reason])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userId")
          }
        }

        public var reason: String {
          get {
            return snapshot["reason"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "reason")
          }
        }
      }
    }
  }
}

public final class CompletedGamesQuery: GraphQLQuery {
  public static let operationString =
    "query completedGames($limit: Int, $nextToken: String) {\n  completedGames(limit: $limit, nextToken: $nextToken) {\n    __typename\n    games {\n      __typename\n      ...GameDetailed\n    }\n    nextToken\n  }\n}"

  public static var requestString: String { return operationString.appending(GameDetailed.fragmentString).appending(UserBasic.fragmentString) }

  public var limit: Int?
  public var nextToken: String?

  public init(limit: Int? = nil, nextToken: String? = nil) {
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("completedGames", arguments: ["limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .nonNull(.object(CompletedGame.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(completedGames: CompletedGame) {
      self.init(snapshot: ["__typename": "Query", "completedGames": completedGames.snapshot])
    }

    public var completedGames: CompletedGame {
      get {
        return CompletedGame(snapshot: snapshot["completedGames"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "completedGames")
      }
    }

    public struct CompletedGame: GraphQLSelectionSet {
      public static let possibleTypes = ["GameConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("games", type: .nonNull(.list(.nonNull(.object(Game.selections))))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(games: [Game], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "GameConnection", "games": games.map { $0.snapshot }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var games: [Game] {
        get {
          return (snapshot["games"] as! [Snapshot]).map { Game(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "games")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Game: GraphQLSelectionSet {
        public static let possibleTypes = ["CompletedGame"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
          GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, turns: [Turn], flags: [Flag]) {
          self.init(snapshot: ["__typename": "CompletedGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var turns: [Turn] {
          get {
            return (snapshot["turns"] as! [Snapshot]).map { Turn(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "turns")
          }
        }

        public var flags: [Flag] {
          get {
            return (snapshot["flags"] as! [Snapshot]).map { Flag(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "flags")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        public struct Fragments {
          public var snapshot: Snapshot

          public var gameDetailed: GameDetailed {
            get {
              return GameDetailed(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }
        }

        public struct Turn: GraphQLSelectionSet {
          public static let possibleTypes = ["OpenTurn", "CompletedTurn"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("order", type: .nonNull(.scalar(Int.self))),
            GraphQLField("user", type: .nonNull(.object(User.selections))),
            GraphQLField("phrase", type: .scalar(String.self)),
            GraphQLField("drawing", type: .object(Drawing.selections)),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public static func makeOpenTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
            return Turn(snapshot: ["__typename": "OpenTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
          }

          public static func makeCompletedTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
            return Turn(snapshot: ["__typename": "CompletedTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var order: Int {
            get {
              return snapshot["order"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "order")
            }
          }

          public var user: User {
            get {
              return User(snapshot: snapshot["user"]! as! Snapshot)
            }
            set {
              snapshot.updateValue(newValue.snapshot, forKey: "user")
            }
          }

          public var phrase: String? {
            get {
              return snapshot["phrase"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "phrase")
            }
          }

          public var drawing: Drawing? {
            get {
              return (snapshot["drawing"] as? Snapshot).flatMap { Drawing(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "drawing")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public struct User: GraphQLSelectionSet {
            public static let possibleTypes = ["User"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(id: GraphQLID, name: String) {
              self.init(snapshot: ["__typename": "User", "id": id, "name": name])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: GraphQLID {
              get {
                return snapshot["id"]! as! GraphQLID
              }
              set {
                snapshot.updateValue(newValue, forKey: "id")
              }
            }

            public var name: String {
              get {
                return snapshot["name"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "name")
              }
            }

            public var fragments: Fragments {
              get {
                return Fragments(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }

            public struct Fragments {
              public var snapshot: Snapshot

              public var userBasic: UserBasic {
                get {
                  return UserBasic(snapshot: snapshot)
                }
                set {
                  snapshot += newValue.snapshot
                }
              }
            }
          }

          public struct Drawing: GraphQLSelectionSet {
            public static let possibleTypes = ["S3Object"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("key", type: .nonNull(.scalar(String.self))),
              GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
              GraphQLField("region", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(key: String, bucket: String, region: String) {
              self.init(snapshot: ["__typename": "S3Object", "key": key, "bucket": bucket, "region": region])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var key: String {
              get {
                return snapshot["key"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "key")
              }
            }

            public var bucket: String {
              get {
                return snapshot["bucket"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "bucket")
              }
            }

            public var region: String {
              get {
                return snapshot["region"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "region")
              }
            }
          }
        }

        public struct Flag: GraphQLSelectionSet {
          public static let possibleTypes = ["Flag"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("reason", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(userId: GraphQLID, reason: String) {
            self.init(snapshot: ["__typename": "Flag", "userId": userId, "reason": reason])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var userId: GraphQLID {
            get {
              return snapshot["userId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }

          public var reason: String {
            get {
              return snapshot["reason"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "reason")
            }
          }
        }
      }
    }
  }
}

public final class CurrentUserQuery: GraphQLQuery {
  public static let operationString =
    "query currentUser {\n  currentUser {\n    __typename\n    ...UserBasic\n  }\n}"

  public static var requestString: String { return operationString.appending(UserBasic.fragmentString) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("currentUser", type: .object(CurrentUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(currentUser: CurrentUser? = nil) {
      self.init(snapshot: ["__typename": "Query", "currentUser": currentUser.flatMap { $0.snapshot }])
    }

    public var currentUser: CurrentUser? {
      get {
        return (snapshot["currentUser"] as? Snapshot).flatMap { CurrentUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "currentUser")
      }
    }

    public struct CurrentUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var userBasic: UserBasic {
          get {
            return UserBasic(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }
    }
  }
}

public final class InProgressTurnsQuery: GraphQLQuery {
  public static let operationString =
    "query inProgressTurns {\n  inProgressTurns {\n    __typename\n    game {\n      __typename\n      ...OpenGameDetailed\n    }\n  }\n}"

  public static var requestString: String { return operationString.appending(OpenGameDetailed.fragmentString).appending(GameDetailed.fragmentString).appending(UserBasic.fragmentString) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("inProgressTurns", type: .nonNull(.list(.nonNull(.object(InProgressTurn.selections))))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(inProgressTurns: [InProgressTurn]) {
      self.init(snapshot: ["__typename": "Query", "inProgressTurns": inProgressTurns.map { $0.snapshot }])
    }

    public var inProgressTurns: [InProgressTurn] {
      get {
        return (snapshot["inProgressTurns"] as! [Snapshot]).map { InProgressTurn(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "inProgressTurns")
      }
    }

    public struct InProgressTurn: GraphQLSelectionSet {
      public static let possibleTypes = ["OpenTurn"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("game", type: .nonNull(.object(Game.selections))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(game: Game) {
        self.init(snapshot: ["__typename": "OpenTurn", "game": game.snapshot])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var game: Game {
        get {
          return Game(snapshot: snapshot["game"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "game")
        }
      }

      public struct Game: GraphQLSelectionSet {
        public static let possibleTypes = ["CompletedGame", "OpenGame"]

        public static let selections: [GraphQLSelection] = [
          GraphQLTypeCase(
            variants: ["OpenGame": AsOpenGame.selections],
            default: [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
              GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
            ]
          )
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public static func makeCompletedGame(id: GraphQLID, turns: [Turn], flags: [Flag]) -> Game {
          return Game(snapshot: ["__typename": "CompletedGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }])
        }

        public static func makeOpenGame(id: GraphQLID, turns: [AsOpenGame.Turn], flags: [AsOpenGame.Flag], lockedAt: String? = nil, lockedById: GraphQLID? = nil) -> Game {
          return Game(snapshot: ["__typename": "OpenGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }, "lockedAt": lockedAt, "lockedById": lockedById])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var turns: [Turn] {
          get {
            return (snapshot["turns"] as! [Snapshot]).map { Turn(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "turns")
          }
        }

        public var flags: [Flag] {
          get {
            return (snapshot["flags"] as! [Snapshot]).map { Flag(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "flags")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        public struct Fragments {
          public var snapshot: Snapshot

          public var openGameDetailed: OpenGameDetailed {
            get {
              return OpenGameDetailed(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }

          public var gameDetailed: GameDetailed {
            get {
              return GameDetailed(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }
        }

        public struct Turn: GraphQLSelectionSet {
          public static let possibleTypes = ["OpenTurn", "CompletedTurn"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("order", type: .nonNull(.scalar(Int.self))),
            GraphQLField("user", type: .nonNull(.object(User.selections))),
            GraphQLField("phrase", type: .scalar(String.self)),
            GraphQLField("drawing", type: .object(Drawing.selections)),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public static func makeOpenTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
            return Turn(snapshot: ["__typename": "OpenTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
          }

          public static func makeCompletedTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
            return Turn(snapshot: ["__typename": "CompletedTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var order: Int {
            get {
              return snapshot["order"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "order")
            }
          }

          public var user: User {
            get {
              return User(snapshot: snapshot["user"]! as! Snapshot)
            }
            set {
              snapshot.updateValue(newValue.snapshot, forKey: "user")
            }
          }

          public var phrase: String? {
            get {
              return snapshot["phrase"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "phrase")
            }
          }

          public var drawing: Drawing? {
            get {
              return (snapshot["drawing"] as? Snapshot).flatMap { Drawing(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "drawing")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public struct User: GraphQLSelectionSet {
            public static let possibleTypes = ["User"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(id: GraphQLID, name: String) {
              self.init(snapshot: ["__typename": "User", "id": id, "name": name])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: GraphQLID {
              get {
                return snapshot["id"]! as! GraphQLID
              }
              set {
                snapshot.updateValue(newValue, forKey: "id")
              }
            }

            public var name: String {
              get {
                return snapshot["name"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "name")
              }
            }

            public var fragments: Fragments {
              get {
                return Fragments(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }

            public struct Fragments {
              public var snapshot: Snapshot

              public var userBasic: UserBasic {
                get {
                  return UserBasic(snapshot: snapshot)
                }
                set {
                  snapshot += newValue.snapshot
                }
              }
            }
          }

          public struct Drawing: GraphQLSelectionSet {
            public static let possibleTypes = ["S3Object"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("key", type: .nonNull(.scalar(String.self))),
              GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
              GraphQLField("region", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(key: String, bucket: String, region: String) {
              self.init(snapshot: ["__typename": "S3Object", "key": key, "bucket": bucket, "region": region])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var key: String {
              get {
                return snapshot["key"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "key")
              }
            }

            public var bucket: String {
              get {
                return snapshot["bucket"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "bucket")
              }
            }

            public var region: String {
              get {
                return snapshot["region"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "region")
              }
            }
          }
        }

        public struct Flag: GraphQLSelectionSet {
          public static let possibleTypes = ["Flag"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("reason", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(userId: GraphQLID, reason: String) {
            self.init(snapshot: ["__typename": "Flag", "userId": userId, "reason": reason])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var userId: GraphQLID {
            get {
              return snapshot["userId"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "userId")
            }
          }

          public var reason: String {
            get {
              return snapshot["reason"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "reason")
            }
          }
        }

        public var asOpenGame: AsOpenGame? {
          get {
            if !AsOpenGame.possibleTypes.contains(__typename) { return nil }
            return AsOpenGame(snapshot: snapshot)
          }
          set {
            guard let newValue = newValue else { return }
            snapshot = newValue.snapshot
          }
        }

        public struct AsOpenGame: GraphQLSelectionSet {
          public static let possibleTypes = ["OpenGame"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
            GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
            GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
            GraphQLField("lockedAt", type: .scalar(String.self)),
            GraphQLField("lockedById", type: .scalar(GraphQLID.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, turns: [Turn], flags: [Flag], lockedAt: String? = nil, lockedById: GraphQLID? = nil) {
            self.init(snapshot: ["__typename": "OpenGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }, "lockedAt": lockedAt, "lockedById": lockedById])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var turns: [Turn] {
            get {
              return (snapshot["turns"] as! [Snapshot]).map { Turn(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "turns")
            }
          }

          public var flags: [Flag] {
            get {
              return (snapshot["flags"] as! [Snapshot]).map { Flag(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "flags")
            }
          }

          public var lockedAt: String? {
            get {
              return snapshot["lockedAt"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "lockedAt")
            }
          }

          public var lockedById: GraphQLID? {
            get {
              return snapshot["lockedById"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "lockedById")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }

          public struct Fragments {
            public var snapshot: Snapshot

            public var openGameDetailed: OpenGameDetailed {
              get {
                return OpenGameDetailed(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }

            public var gameDetailed: GameDetailed {
              get {
                return GameDetailed(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }
          }

          public struct Turn: GraphQLSelectionSet {
            public static let possibleTypes = ["OpenTurn", "CompletedTurn"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("order", type: .nonNull(.scalar(Int.self))),
              GraphQLField("user", type: .nonNull(.object(User.selections))),
              GraphQLField("phrase", type: .scalar(String.self)),
              GraphQLField("drawing", type: .object(Drawing.selections)),
              GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("order", type: .nonNull(.scalar(Int.self))),
              GraphQLField("user", type: .nonNull(.object(User.selections))),
              GraphQLField("phrase", type: .scalar(String.self)),
              GraphQLField("drawing", type: .object(Drawing.selections)),
              GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public static func makeOpenTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
              return Turn(snapshot: ["__typename": "OpenTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
            }

            public static func makeCompletedTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
              return Turn(snapshot: ["__typename": "CompletedTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var order: Int {
              get {
                return snapshot["order"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "order")
              }
            }

            public var user: User {
              get {
                return User(snapshot: snapshot["user"]! as! Snapshot)
              }
              set {
                snapshot.updateValue(newValue.snapshot, forKey: "user")
              }
            }

            public var phrase: String? {
              get {
                return snapshot["phrase"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "phrase")
              }
            }

            public var drawing: Drawing? {
              get {
                return (snapshot["drawing"] as? Snapshot).flatMap { Drawing(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "drawing")
              }
            }

            public var createdAt: String {
              get {
                return snapshot["createdAt"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "createdAt")
              }
            }

            public struct User: GraphQLSelectionSet {
              public static let possibleTypes = ["User"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(id: GraphQLID, name: String) {
                self.init(snapshot: ["__typename": "User", "id": id, "name": name])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var id: GraphQLID {
                get {
                  return snapshot["id"]! as! GraphQLID
                }
                set {
                  snapshot.updateValue(newValue, forKey: "id")
                }
              }

              public var name: String {
                get {
                  return snapshot["name"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "name")
                }
              }

              public var fragments: Fragments {
                get {
                  return Fragments(snapshot: snapshot)
                }
                set {
                  snapshot += newValue.snapshot
                }
              }

              public struct Fragments {
                public var snapshot: Snapshot

                public var userBasic: UserBasic {
                  get {
                    return UserBasic(snapshot: snapshot)
                  }
                  set {
                    snapshot += newValue.snapshot
                  }
                }
              }
            }

            public struct Drawing: GraphQLSelectionSet {
              public static let possibleTypes = ["S3Object"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("key", type: .nonNull(.scalar(String.self))),
                GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
                GraphQLField("region", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("key", type: .nonNull(.scalar(String.self))),
                GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
                GraphQLField("region", type: .nonNull(.scalar(String.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(key: String, bucket: String, region: String) {
                self.init(snapshot: ["__typename": "S3Object", "key": key, "bucket": bucket, "region": region])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var key: String {
                get {
                  return snapshot["key"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "key")
                }
              }

              public var bucket: String {
                get {
                  return snapshot["bucket"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "bucket")
                }
              }

              public var region: String {
                get {
                  return snapshot["region"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "region")
                }
              }
            }
          }

          public struct Flag: GraphQLSelectionSet {
            public static let possibleTypes = ["Flag"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("reason", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("reason", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(userId: GraphQLID, reason: String) {
              self.init(snapshot: ["__typename": "Flag", "userId": userId, "reason": reason])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var userId: GraphQLID {
              get {
                return snapshot["userId"]! as! GraphQLID
              }
              set {
                snapshot.updateValue(newValue, forKey: "userId")
              }
            }

            public var reason: String {
              get {
                return snapshot["reason"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "reason")
              }
            }
          }
        }
      }
    }
  }
}

public final class MyCompletedTurnsQuery: GraphQLQuery {
  public static let operationString =
    "query myCompletedTurns($limit: Int, $nextToken: String) {\n  myCompletedTurns(limit: $limit, nextToken: $nextToken) {\n    __typename\n    turns {\n      __typename\n      game {\n        __typename\n        ...GameDetailed\n      }\n    }\n    nextToken\n  }\n}"

  public static var requestString: String { return operationString.appending(GameDetailed.fragmentString).appending(UserBasic.fragmentString) }

  public var limit: Int?
  public var nextToken: String?

  public init(limit: Int? = nil, nextToken: String? = nil) {
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("myCompletedTurns", arguments: ["limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .nonNull(.object(MyCompletedTurn.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(myCompletedTurns: MyCompletedTurn) {
      self.init(snapshot: ["__typename": "Query", "myCompletedTurns": myCompletedTurns.snapshot])
    }

    public var myCompletedTurns: MyCompletedTurn {
      get {
        return MyCompletedTurn(snapshot: snapshot["myCompletedTurns"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "myCompletedTurns")
      }
    }

    public struct MyCompletedTurn: GraphQLSelectionSet {
      public static let possibleTypes = ["TurnConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(turns: [Turn], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "TurnConnection", "turns": turns.map { $0.snapshot }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var turns: [Turn] {
        get {
          return (snapshot["turns"] as! [Snapshot]).map { Turn(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "turns")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Turn: GraphQLSelectionSet {
        public static let possibleTypes = ["CompletedTurn"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("game", type: .nonNull(.object(Game.selections))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(game: Game) {
          self.init(snapshot: ["__typename": "CompletedTurn", "game": game.snapshot])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var game: Game {
          get {
            return Game(snapshot: snapshot["game"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "game")
          }
        }

        public struct Game: GraphQLSelectionSet {
          public static let possibleTypes = ["CompletedGame", "OpenGame"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
            GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public static func makeCompletedGame(id: GraphQLID, turns: [Turn], flags: [Flag]) -> Game {
            return Game(snapshot: ["__typename": "CompletedGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }])
          }

          public static func makeOpenGame(id: GraphQLID, turns: [Turn], flags: [Flag]) -> Game {
            return Game(snapshot: ["__typename": "OpenGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var turns: [Turn] {
            get {
              return (snapshot["turns"] as! [Snapshot]).map { Turn(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "turns")
            }
          }

          public var flags: [Flag] {
            get {
              return (snapshot["flags"] as! [Snapshot]).map { Flag(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "flags")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }

          public struct Fragments {
            public var snapshot: Snapshot

            public var gameDetailed: GameDetailed {
              get {
                return GameDetailed(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }
          }

          public struct Turn: GraphQLSelectionSet {
            public static let possibleTypes = ["OpenTurn", "CompletedTurn"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("order", type: .nonNull(.scalar(Int.self))),
              GraphQLField("user", type: .nonNull(.object(User.selections))),
              GraphQLField("phrase", type: .scalar(String.self)),
              GraphQLField("drawing", type: .object(Drawing.selections)),
              GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public static func makeOpenTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
              return Turn(snapshot: ["__typename": "OpenTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
            }

            public static func makeCompletedTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
              return Turn(snapshot: ["__typename": "CompletedTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var order: Int {
              get {
                return snapshot["order"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "order")
              }
            }

            public var user: User {
              get {
                return User(snapshot: snapshot["user"]! as! Snapshot)
              }
              set {
                snapshot.updateValue(newValue.snapshot, forKey: "user")
              }
            }

            public var phrase: String? {
              get {
                return snapshot["phrase"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "phrase")
              }
            }

            public var drawing: Drawing? {
              get {
                return (snapshot["drawing"] as? Snapshot).flatMap { Drawing(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "drawing")
              }
            }

            public var createdAt: String {
              get {
                return snapshot["createdAt"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "createdAt")
              }
            }

            public struct User: GraphQLSelectionSet {
              public static let possibleTypes = ["User"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(id: GraphQLID, name: String) {
                self.init(snapshot: ["__typename": "User", "id": id, "name": name])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var id: GraphQLID {
                get {
                  return snapshot["id"]! as! GraphQLID
                }
                set {
                  snapshot.updateValue(newValue, forKey: "id")
                }
              }

              public var name: String {
                get {
                  return snapshot["name"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "name")
                }
              }

              public var fragments: Fragments {
                get {
                  return Fragments(snapshot: snapshot)
                }
                set {
                  snapshot += newValue.snapshot
                }
              }

              public struct Fragments {
                public var snapshot: Snapshot

                public var userBasic: UserBasic {
                  get {
                    return UserBasic(snapshot: snapshot)
                  }
                  set {
                    snapshot += newValue.snapshot
                  }
                }
              }
            }

            public struct Drawing: GraphQLSelectionSet {
              public static let possibleTypes = ["S3Object"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("key", type: .nonNull(.scalar(String.self))),
                GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
                GraphQLField("region", type: .nonNull(.scalar(String.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(key: String, bucket: String, region: String) {
                self.init(snapshot: ["__typename": "S3Object", "key": key, "bucket": bucket, "region": region])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var key: String {
                get {
                  return snapshot["key"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "key")
                }
              }

              public var bucket: String {
                get {
                  return snapshot["bucket"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "bucket")
                }
              }

              public var region: String {
                get {
                  return snapshot["region"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "region")
                }
              }
            }
          }

          public struct Flag: GraphQLSelectionSet {
            public static let possibleTypes = ["Flag"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("reason", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(userId: GraphQLID, reason: String) {
              self.init(snapshot: ["__typename": "Flag", "userId": userId, "reason": reason])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var userId: GraphQLID {
              get {
                return snapshot["userId"]! as! GraphQLID
              }
              set {
                snapshot.updateValue(newValue, forKey: "userId")
              }
            }

            public var reason: String {
              get {
                return snapshot["reason"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "reason")
              }
            }
          }
        }
      }
    }
  }
}

public final class MyFlagsQuery: GraphQLQuery {
  public static let operationString =
    "query myFlags($nextToken: String) {\n  myFlags(nextToken: $nextToken) {\n    __typename\n    flags {\n      __typename\n      gameId\n      createdAt\n    }\n    nextToken\n  }\n}"

  public var nextToken: String?

  public init(nextToken: String? = nil) {
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("myFlags", arguments: ["nextToken": GraphQLVariable("nextToken")], type: .nonNull(.object(MyFlag.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(myFlags: MyFlag) {
      self.init(snapshot: ["__typename": "Query", "myFlags": myFlags.snapshot])
    }

    public var myFlags: MyFlag {
      get {
        return MyFlag(snapshot: snapshot["myFlags"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "myFlags")
      }
    }

    public struct MyFlag: GraphQLSelectionSet {
      public static let possibleTypes = ["FlagConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(flags: [Flag], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "FlagConnection", "flags": flags.map { $0.snapshot }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var flags: [Flag] {
        get {
          return (snapshot["flags"] as! [Snapshot]).map { Flag(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "flags")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Flag: GraphQLSelectionSet {
        public static let possibleTypes = ["Flag"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("gameId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(gameId: GraphQLID, createdAt: String) {
          self.init(snapshot: ["__typename": "Flag", "gameId": gameId, "createdAt": createdAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var gameId: GraphQLID {
          get {
            return snapshot["gameId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "gameId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }
      }
    }
  }
}

public final class UserCompletedTurnsQuery: GraphQLQuery {
  public static let operationString =
    "query userCompletedTurns($userId: ID!, $limit: Int, $nextToken: String) {\n  userCompletedTurns(userId: $userId, limit: $limit, nextToken: $nextToken) {\n    __typename\n    turns {\n      __typename\n      game {\n        __typename\n        ...GameDetailed\n      }\n    }\n    nextToken\n  }\n}"

  public static var requestString: String { return operationString.appending(GameDetailed.fragmentString).appending(UserBasic.fragmentString) }

  public var userId: GraphQLID
  public var limit: Int?
  public var nextToken: String?

  public init(userId: GraphQLID, limit: Int? = nil, nextToken: String? = nil) {
    self.userId = userId
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["userId": userId, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("userCompletedTurns", arguments: ["userId": GraphQLVariable("userId"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .nonNull(.object(UserCompletedTurn.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(userCompletedTurns: UserCompletedTurn) {
      self.init(snapshot: ["__typename": "Query", "userCompletedTurns": userCompletedTurns.snapshot])
    }

    public var userCompletedTurns: UserCompletedTurn {
      get {
        return UserCompletedTurn(snapshot: snapshot["userCompletedTurns"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "userCompletedTurns")
      }
    }

    public struct UserCompletedTurn: GraphQLSelectionSet {
      public static let possibleTypes = ["TurnConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(turns: [Turn], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "TurnConnection", "turns": turns.map { $0.snapshot }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var turns: [Turn] {
        get {
          return (snapshot["turns"] as! [Snapshot]).map { Turn(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "turns")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Turn: GraphQLSelectionSet {
        public static let possibleTypes = ["CompletedTurn"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("game", type: .nonNull(.object(Game.selections))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(game: Game) {
          self.init(snapshot: ["__typename": "CompletedTurn", "game": game.snapshot])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var game: Game {
          get {
            return Game(snapshot: snapshot["game"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "game")
          }
        }

        public struct Game: GraphQLSelectionSet {
          public static let possibleTypes = ["CompletedGame", "OpenGame"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
            GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public static func makeCompletedGame(id: GraphQLID, turns: [Turn], flags: [Flag]) -> Game {
            return Game(snapshot: ["__typename": "CompletedGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }])
          }

          public static func makeOpenGame(id: GraphQLID, turns: [Turn], flags: [Flag]) -> Game {
            return Game(snapshot: ["__typename": "OpenGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var turns: [Turn] {
            get {
              return (snapshot["turns"] as! [Snapshot]).map { Turn(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "turns")
            }
          }

          public var flags: [Flag] {
            get {
              return (snapshot["flags"] as! [Snapshot]).map { Flag(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "flags")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }

          public struct Fragments {
            public var snapshot: Snapshot

            public var gameDetailed: GameDetailed {
              get {
                return GameDetailed(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }
          }

          public struct Turn: GraphQLSelectionSet {
            public static let possibleTypes = ["OpenTurn", "CompletedTurn"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("order", type: .nonNull(.scalar(Int.self))),
              GraphQLField("user", type: .nonNull(.object(User.selections))),
              GraphQLField("phrase", type: .scalar(String.self)),
              GraphQLField("drawing", type: .object(Drawing.selections)),
              GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public static func makeOpenTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
              return Turn(snapshot: ["__typename": "OpenTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
            }

            public static func makeCompletedTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
              return Turn(snapshot: ["__typename": "CompletedTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var order: Int {
              get {
                return snapshot["order"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "order")
              }
            }

            public var user: User {
              get {
                return User(snapshot: snapshot["user"]! as! Snapshot)
              }
              set {
                snapshot.updateValue(newValue.snapshot, forKey: "user")
              }
            }

            public var phrase: String? {
              get {
                return snapshot["phrase"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "phrase")
              }
            }

            public var drawing: Drawing? {
              get {
                return (snapshot["drawing"] as? Snapshot).flatMap { Drawing(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "drawing")
              }
            }

            public var createdAt: String {
              get {
                return snapshot["createdAt"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "createdAt")
              }
            }

            public struct User: GraphQLSelectionSet {
              public static let possibleTypes = ["User"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(id: GraphQLID, name: String) {
                self.init(snapshot: ["__typename": "User", "id": id, "name": name])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var id: GraphQLID {
                get {
                  return snapshot["id"]! as! GraphQLID
                }
                set {
                  snapshot.updateValue(newValue, forKey: "id")
                }
              }

              public var name: String {
                get {
                  return snapshot["name"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "name")
                }
              }

              public var fragments: Fragments {
                get {
                  return Fragments(snapshot: snapshot)
                }
                set {
                  snapshot += newValue.snapshot
                }
              }

              public struct Fragments {
                public var snapshot: Snapshot

                public var userBasic: UserBasic {
                  get {
                    return UserBasic(snapshot: snapshot)
                  }
                  set {
                    snapshot += newValue.snapshot
                  }
                }
              }
            }

            public struct Drawing: GraphQLSelectionSet {
              public static let possibleTypes = ["S3Object"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("key", type: .nonNull(.scalar(String.self))),
                GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
                GraphQLField("region", type: .nonNull(.scalar(String.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(key: String, bucket: String, region: String) {
                self.init(snapshot: ["__typename": "S3Object", "key": key, "bucket": bucket, "region": region])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var key: String {
                get {
                  return snapshot["key"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "key")
                }
              }

              public var bucket: String {
                get {
                  return snapshot["bucket"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "bucket")
                }
              }

              public var region: String {
                get {
                  return snapshot["region"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "region")
                }
              }
            }
          }

          public struct Flag: GraphQLSelectionSet {
            public static let possibleTypes = ["Flag"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("reason", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(userId: GraphQLID, reason: String) {
              self.init(snapshot: ["__typename": "Flag", "userId": userId, "reason": reason])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var userId: GraphQLID {
              get {
                return snapshot["userId"]! as! GraphQLID
              }
              set {
                snapshot.updateValue(newValue, forKey: "userId")
              }
            }

            public var reason: String {
              get {
                return snapshot["reason"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "reason")
              }
            }
          }
        }
      }
    }
  }
}

public struct GameDetailed: GraphQLFragment {
  public static let fragmentString =
    "fragment GameDetailed on Game {\n  __typename\n  id\n  turns {\n    __typename\n    order\n    user {\n      __typename\n      ...UserBasic\n    }\n    phrase\n    drawing {\n      __typename\n      key\n      bucket\n      region\n    }\n    createdAt\n  }\n  flags {\n    __typename\n    userId\n    reason\n  }\n}"

  public static let possibleTypes = ["CompletedGame", "OpenGame"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
    GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
  ]

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public static func makeCompletedGame(id: GraphQLID, turns: [Turn], flags: [Flag]) -> GameDetailed {
    return GameDetailed(snapshot: ["__typename": "CompletedGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }])
  }

  public static func makeOpenGame(id: GraphQLID, turns: [Turn], flags: [Flag]) -> GameDetailed {
    return GameDetailed(snapshot: ["__typename": "OpenGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }])
  }

  public var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return snapshot["id"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "id")
    }
  }

  public var turns: [Turn] {
    get {
      return (snapshot["turns"] as! [Snapshot]).map { Turn(snapshot: $0) }
    }
    set {
      snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "turns")
    }
  }

  public var flags: [Flag] {
    get {
      return (snapshot["flags"] as! [Snapshot]).map { Flag(snapshot: $0) }
    }
    set {
      snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "flags")
    }
  }

  public struct Turn: GraphQLSelectionSet {
    public static let possibleTypes = ["OpenTurn", "CompletedTurn"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("order", type: .nonNull(.scalar(Int.self))),
      GraphQLField("user", type: .nonNull(.object(User.selections))),
      GraphQLField("phrase", type: .scalar(String.self)),
      GraphQLField("drawing", type: .object(Drawing.selections)),
      GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public static func makeOpenTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
      return Turn(snapshot: ["__typename": "OpenTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
    }

    public static func makeCompletedTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
      return Turn(snapshot: ["__typename": "CompletedTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    public var order: Int {
      get {
        return snapshot["order"]! as! Int
      }
      set {
        snapshot.updateValue(newValue, forKey: "order")
      }
    }

    public var user: User {
      get {
        return User(snapshot: snapshot["user"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "user")
      }
    }

    public var phrase: String? {
      get {
        return snapshot["phrase"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "phrase")
      }
    }

    public var drawing: Drawing? {
      get {
        return (snapshot["drawing"] as? Snapshot).flatMap { Drawing(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "drawing")
      }
    }

    public var createdAt: String {
      get {
        return snapshot["createdAt"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "createdAt")
      }
    }

    public struct User: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var userBasic: UserBasic {
          get {
            return UserBasic(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }
    }

    public struct Drawing: GraphQLSelectionSet {
      public static let possibleTypes = ["S3Object"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("key", type: .nonNull(.scalar(String.self))),
        GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
        GraphQLField("region", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(key: String, bucket: String, region: String) {
        self.init(snapshot: ["__typename": "S3Object", "key": key, "bucket": bucket, "region": region])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var key: String {
        get {
          return snapshot["key"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "key")
        }
      }

      public var bucket: String {
        get {
          return snapshot["bucket"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "bucket")
        }
      }

      public var region: String {
        get {
          return snapshot["region"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "region")
        }
      }
    }
  }

  public struct Flag: GraphQLSelectionSet {
    public static let possibleTypes = ["Flag"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("reason", type: .nonNull(.scalar(String.self))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(userId: GraphQLID, reason: String) {
      self.init(snapshot: ["__typename": "Flag", "userId": userId, "reason": reason])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    public var userId: GraphQLID {
      get {
        return snapshot["userId"]! as! GraphQLID
      }
      set {
        snapshot.updateValue(newValue, forKey: "userId")
      }
    }

    public var reason: String {
      get {
        return snapshot["reason"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "reason")
      }
    }
  }
}

public struct OpenGameDetailed: GraphQLFragment {
  public static let fragmentString =
    "fragment OpenGameDetailed on Game {\n  __typename\n  ...GameDetailed\n  ... on OpenGame {\n    lockedAt\n    lockedById\n  }\n}"

  public static let possibleTypes = ["CompletedGame", "OpenGame"]

  public static let selections: [GraphQLSelection] = [
    GraphQLTypeCase(
      variants: ["OpenGame": AsOpenGame.selections],
      default: [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
        GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
      ]
    )
  ]

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public static func makeCompletedGame(id: GraphQLID, turns: [Turn], flags: [Flag]) -> OpenGameDetailed {
    return OpenGameDetailed(snapshot: ["__typename": "CompletedGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }])
  }

  public static func makeOpenGame(id: GraphQLID, turns: [AsOpenGame.Turn], flags: [AsOpenGame.Flag], lockedAt: String? = nil, lockedById: GraphQLID? = nil) -> OpenGameDetailed {
    return OpenGameDetailed(snapshot: ["__typename": "OpenGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }, "lockedAt": lockedAt, "lockedById": lockedById])
  }

  public var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return snapshot["id"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "id")
    }
  }

  public var turns: [Turn] {
    get {
      return (snapshot["turns"] as! [Snapshot]).map { Turn(snapshot: $0) }
    }
    set {
      snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "turns")
    }
  }

  public var flags: [Flag] {
    get {
      return (snapshot["flags"] as! [Snapshot]).map { Flag(snapshot: $0) }
    }
    set {
      snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "flags")
    }
  }

  public var fragments: Fragments {
    get {
      return Fragments(snapshot: snapshot)
    }
    set {
      snapshot += newValue.snapshot
    }
  }

  public struct Fragments {
    public var snapshot: Snapshot

    public var gameDetailed: GameDetailed {
      get {
        return GameDetailed(snapshot: snapshot)
      }
      set {
        snapshot += newValue.snapshot
      }
    }
  }

  public struct Turn: GraphQLSelectionSet {
    public static let possibleTypes = ["OpenTurn", "CompletedTurn"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("order", type: .nonNull(.scalar(Int.self))),
      GraphQLField("user", type: .nonNull(.object(User.selections))),
      GraphQLField("phrase", type: .scalar(String.self)),
      GraphQLField("drawing", type: .object(Drawing.selections)),
      GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public static func makeOpenTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
      return Turn(snapshot: ["__typename": "OpenTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
    }

    public static func makeCompletedTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
      return Turn(snapshot: ["__typename": "CompletedTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    public var order: Int {
      get {
        return snapshot["order"]! as! Int
      }
      set {
        snapshot.updateValue(newValue, forKey: "order")
      }
    }

    public var user: User {
      get {
        return User(snapshot: snapshot["user"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "user")
      }
    }

    public var phrase: String? {
      get {
        return snapshot["phrase"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "phrase")
      }
    }

    public var drawing: Drawing? {
      get {
        return (snapshot["drawing"] as? Snapshot).flatMap { Drawing(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "drawing")
      }
    }

    public var createdAt: String {
      get {
        return snapshot["createdAt"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "createdAt")
      }
    }

    public struct User: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var userBasic: UserBasic {
          get {
            return UserBasic(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }
    }

    public struct Drawing: GraphQLSelectionSet {
      public static let possibleTypes = ["S3Object"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("key", type: .nonNull(.scalar(String.self))),
        GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
        GraphQLField("region", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(key: String, bucket: String, region: String) {
        self.init(snapshot: ["__typename": "S3Object", "key": key, "bucket": bucket, "region": region])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var key: String {
        get {
          return snapshot["key"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "key")
        }
      }

      public var bucket: String {
        get {
          return snapshot["bucket"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "bucket")
        }
      }

      public var region: String {
        get {
          return snapshot["region"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "region")
        }
      }
    }
  }

  public struct Flag: GraphQLSelectionSet {
    public static let possibleTypes = ["Flag"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("reason", type: .nonNull(.scalar(String.self))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(userId: GraphQLID, reason: String) {
      self.init(snapshot: ["__typename": "Flag", "userId": userId, "reason": reason])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    public var userId: GraphQLID {
      get {
        return snapshot["userId"]! as! GraphQLID
      }
      set {
        snapshot.updateValue(newValue, forKey: "userId")
      }
    }

    public var reason: String {
      get {
        return snapshot["reason"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "reason")
      }
    }
  }

  public var asOpenGame: AsOpenGame? {
    get {
      if !AsOpenGame.possibleTypes.contains(__typename) { return nil }
      return AsOpenGame(snapshot: snapshot)
    }
    set {
      guard let newValue = newValue else { return }
      snapshot = newValue.snapshot
    }
  }

  public struct AsOpenGame: GraphQLSelectionSet {
    public static let possibleTypes = ["OpenGame"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("turns", type: .nonNull(.list(.nonNull(.object(Turn.selections))))),
      GraphQLField("flags", type: .nonNull(.list(.nonNull(.object(Flag.selections))))),
      GraphQLField("lockedAt", type: .scalar(String.self)),
      GraphQLField("lockedById", type: .scalar(GraphQLID.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(id: GraphQLID, turns: [Turn], flags: [Flag], lockedAt: String? = nil, lockedById: GraphQLID? = nil) {
      self.init(snapshot: ["__typename": "OpenGame", "id": id, "turns": turns.map { $0.snapshot }, "flags": flags.map { $0.snapshot }, "lockedAt": lockedAt, "lockedById": lockedById])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return snapshot["id"]! as! GraphQLID
      }
      set {
        snapshot.updateValue(newValue, forKey: "id")
      }
    }

    public var turns: [Turn] {
      get {
        return (snapshot["turns"] as! [Snapshot]).map { Turn(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "turns")
      }
    }

    public var flags: [Flag] {
      get {
        return (snapshot["flags"] as! [Snapshot]).map { Flag(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "flags")
      }
    }

    public var lockedAt: String? {
      get {
        return snapshot["lockedAt"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "lockedAt")
      }
    }

    public var lockedById: GraphQLID? {
      get {
        return snapshot["lockedById"] as? GraphQLID
      }
      set {
        snapshot.updateValue(newValue, forKey: "lockedById")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(snapshot: snapshot)
      }
      set {
        snapshot += newValue.snapshot
      }
    }

    public struct Fragments {
      public var snapshot: Snapshot

      public var gameDetailed: GameDetailed {
        get {
          return GameDetailed(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }
    }

    public struct Turn: GraphQLSelectionSet {
      public static let possibleTypes = ["OpenTurn", "CompletedTurn"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("order", type: .nonNull(.scalar(Int.self))),
        GraphQLField("user", type: .nonNull(.object(User.selections))),
        GraphQLField("phrase", type: .scalar(String.self)),
        GraphQLField("drawing", type: .object(Drawing.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public static func makeOpenTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
        return Turn(snapshot: ["__typename": "OpenTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
      }

      public static func makeCompletedTurn(order: Int, user: User, phrase: String? = nil, drawing: Drawing? = nil, createdAt: String) -> Turn {
        return Turn(snapshot: ["__typename": "CompletedTurn", "order": order, "user": user.snapshot, "phrase": phrase, "drawing": drawing.flatMap { $0.snapshot }, "createdAt": createdAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var order: Int {
        get {
          return snapshot["order"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "order")
        }
      }

      public var user: User {
        get {
          return User(snapshot: snapshot["user"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "user")
        }
      }

      public var phrase: String? {
        get {
          return snapshot["phrase"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phrase")
        }
      }

      public var drawing: Drawing? {
        get {
          return (snapshot["drawing"] as? Snapshot).flatMap { Drawing(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "drawing")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String) {
          self.init(snapshot: ["__typename": "User", "id": id, "name": name])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        public struct Fragments {
          public var snapshot: Snapshot

          public var userBasic: UserBasic {
            get {
              return UserBasic(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }
        }
      }

      public struct Drawing: GraphQLSelectionSet {
        public static let possibleTypes = ["S3Object"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("key", type: .nonNull(.scalar(String.self))),
          GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
          GraphQLField("region", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(key: String, bucket: String, region: String) {
          self.init(snapshot: ["__typename": "S3Object", "key": key, "bucket": bucket, "region": region])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var key: String {
          get {
            return snapshot["key"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "key")
          }
        }

        public var bucket: String {
          get {
            return snapshot["bucket"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "bucket")
          }
        }

        public var region: String {
          get {
            return snapshot["region"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "region")
          }
        }
      }
    }

    public struct Flag: GraphQLSelectionSet {
      public static let possibleTypes = ["Flag"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("reason", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(userId: GraphQLID, reason: String) {
        self.init(snapshot: ["__typename": "Flag", "userId": userId, "reason": reason])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userId")
        }
      }

      public var reason: String {
        get {
          return snapshot["reason"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "reason")
        }
      }
    }
  }
}

public struct UserBasic: GraphQLFragment {
  public static let fragmentString =
    "fragment UserBasic on User {\n  __typename\n  id\n  name\n}"

  public static let possibleTypes = ["User"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
  ]

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(id: GraphQLID, name: String) {
    self.init(snapshot: ["__typename": "User", "id": id, "name": name])
  }

  public var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return snapshot["id"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String {
    get {
      return snapshot["name"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "name")
    }
  }
}