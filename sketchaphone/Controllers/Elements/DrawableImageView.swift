import UIKit

class DrawableImageView: UIImageView {
    var lastPoint = CGPoint.zero
    var swiped = false
    var didDraw = false
    var multitouching = false
    var color = UIColor.black
    
    var undos = [UIImage]()
    let maxUndos = 10
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if (touches.count != 1) {
            multitouching = true
            return
        }
        multitouching = false
        lastPoint = touches.first!.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (multitouching) {
            return
        }
        
        let touch = touches.first!
        let currentPoint = touch.location(in: self)
        if (!didDraw && lastPoint.distance(currentPoint) > 20.0) {
            multitouching = true
            return
        }
        
        swiped = true
        drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
        
        lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (multitouching) {
            return
        }
        if !swiped {
            // draw a single point
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        if (didDraw) {
            didDraw = false
            putUndo()
        }
    }
    
    private func putUndo() {
        undos.append(image!)
        if (undos.count > maxUndos) {
            undos.removeFirst()
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        image!.draw(in: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        context?.setLineCap(.round)
        var width: CGFloat = 3.0
        if (color == .white) {
            width = 20.0
        }
        context?.setLineWidth(width)
        context?.setStrokeColor(color.cgColor)
        context?.setBlendMode(.normal)
        
        context?.strokePath()
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        didDraw = true
    }
    
    func undo() {
        if (undos.count <= 1) {
            return
        }
        if (undos.popLast() != nil) {
            if let image = undos.last {
                self.image = image
            }
        }
    }
    
    func reset() {
        undos.removeAll()
        image = UIImage()
        putUndo()
    }
    
    func clear() {
        image = UIImage()
        putUndo()
    }
}
