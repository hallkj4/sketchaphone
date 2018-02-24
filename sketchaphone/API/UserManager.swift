import Foundation

let userManager = UserManager()

class UserManager {
    var currentUser: User?
    
    func set(name: String) {
        if (currentUser == nil) {
            currentUser = User(name)
        }
        else {
            currentUser!.name = name
        }
    }
}
