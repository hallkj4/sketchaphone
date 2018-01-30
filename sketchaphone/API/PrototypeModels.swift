import Foundation
import UIKit

class Game {
    let id = arc4random()
    let creator = User()
    var turns = [Turn]()
}

class User {
    let id = arc4random()
    let name = "Michael"
}

struct Turn {
    let phrase: String?
    let image: UIImage?
    
    init(phrase: String) {
        self.phrase = phrase
        self.image = nil
    }
    
    init(image: UIImage) {
        self.image = image
        self.phrase = nil
    }
}
