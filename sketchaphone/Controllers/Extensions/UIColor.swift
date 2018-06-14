import UIKit

extension UIColor {
    func shifted() -> UIColor {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
      
        if (brightness > 0.5) {
            return .black
        }
        
        return .white
    }
}
