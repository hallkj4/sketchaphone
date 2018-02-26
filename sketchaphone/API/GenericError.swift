import Foundation
class GenericError: LocalizedError {
    
    var message: String
    var localizedDescription: String {
        get {
            return message
        }
    }
    
    init(_ message: String) {
        self.message = message
    }
    
}
