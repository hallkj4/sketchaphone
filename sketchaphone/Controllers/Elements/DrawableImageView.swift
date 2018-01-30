import UIKit

class DrawableImageView: UIImageView {
    var lastPoint = CGPoint.zero
    var swiped = false
    var multitouching = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if (touches.count != 1) {
            multitouching = true
            return
        }
        multitouching = false
        lastPoint = touches.first!.location(in: self)
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        image!.draw(in: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        context?.setLineCap(.round)
        context?.setLineWidth(3.0)
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setBlendMode(.normal)
        
        context?.strokePath()
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.count != 1 || multitouching) {
            multitouching = true
            return
        }
        
        let touch = touches.first!
        let currentPoint = touch.location(in: self)
        if (lastPoint.distance(currentPoint) > 20.0) {
            multitouching = true
            return
        }
        
        swiped = true
        drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
        
        lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.count != 1 || multitouching) {
            return
        }
        if !swiped {
            // draw a single point
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
}
