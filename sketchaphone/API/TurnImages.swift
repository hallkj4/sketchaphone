import Foundation

extension OpenGameDetailed.Turn {
    func imageURL() -> URL? {
        if let drawing = drawing {
            return URL(string: "https://s3-us-west-2.amazonaws.com/skechaphone-drawings/\(drawing.key)")
        }
        return nil
    }
}

extension GameDetailed.Turn {
    func imageURL() -> URL? {
        if let drawing = drawing {
            return URL(string: "https://s3-us-west-2.amazonaws.com/skechaphone-drawings/\(drawing.key)")
        }
        return nil
    }
}
