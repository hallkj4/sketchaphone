import Foundation
import Reachability

func networkOffline() -> Bool {
    return Reachability(hostname: API_HOST)!.connection == .none
}
