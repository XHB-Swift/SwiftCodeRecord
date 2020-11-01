//
//  UIImageGenerator.swift
//  SwiftCodeRecord
//
//  Created by xiehongbiao on 2020/10/31.
//

import UIKit

public typealias SCRDrawContentHandler = (CGContext)->Void
public typealias SCRDrawCompletionHandler = (UIImage)->Void
private let SCRViewScale = UIScreen.main.scale

public class SCRDrawGenerator {
    
    public static func drawImage(size: CGSize,
                                 contentHandler: @escaping SCRDrawContentHandler,
                                 completionHandler: @escaping SCRDrawCompletionHandler) {
        
        DispatchQueue.global().async {
            UIGraphicsBeginImageContextWithOptions(size, false, SCRViewScale)
            if let context = UIGraphicsGetCurrentContext() {
                contentHandler(context)
            }
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            DispatchQueue.main.async {
                if let img = image {
                    completionHandler(img)
                }
            }
        }
    }
}

extension UIImage: SCRDrawbale {
    
}

extension NSAttributedString: SCRDrawbale {
    
    func drawIn(size: CGSize,
                completionHandler: @escaping SCRDrawCompletionHandler) {
        SCRDrawGenerator.drawImage(size: size, contentHandler: { (context) in
            
            let attrSize = self.boundingRect(with: size, options: [.usesFontLeading,.usesLineFragmentOrigin], context: nil).size
            let drawPoint = CGPoint(x: (size.width - attrSize.width)/2, y: (size.height-attrSize.height)/2)
            self.draw(at: drawPoint)
            
        }, completionHandler: completionHandler)
    }
}
