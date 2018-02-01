import Foundation
import UIKit

class Game {
    let id = arc4random()
    let creator = User("Michael")
    var turns = [Turn]()
}

class User {
    let id = arc4random()
    var name: String
    
    init(_ name: String) {
        self.name = name
    }
}

struct Turn {
    let phrase: String?
    let image: UIImage?
    let user = User("Michael")
    
    init(phrase: String) {
        self.phrase = phrase
        self.image = nil
    }
    
    init(image: UIImage) {
        self.image = image
        self.phrase = nil
    }
}
