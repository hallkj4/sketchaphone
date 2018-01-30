import UIKit

extension CGPoint {
    func distance(_ b: CGPoint) -> CGFloat {
        let xDist = x - b.x
        let yDist = y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
}
