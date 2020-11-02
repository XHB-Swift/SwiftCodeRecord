//
//  UIImageGenerator.swift
//  SwiftCodeRecord
//
//  Created by xiehongbiao on 2020/10/31.
//

import UIKit
import Kingfisher

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

extension UIImageView {
    
    func setImage(_ urlString: String, placeHolder: UIImage?, cornerRadius: CGFloat = 10, fade: CGFloat = 1, scale: CGFloat = SCRViewScale) {
        if let url = URL(string: urlString) {
            self.setImage(url)
        }
    }
    
    func setImage(_ url: URL, placeHolder: UIImage?, cornerRadius: CGFloat = 10, fade: CGFloat = 1, scale: CGFloat = SCRViewScale) {
        self.kf.setImage(with: url, placeholder: <#T##Placeholder?#>, options: <#T##KingfisherOptionsInfo?#>, progressBlock: <#T##DownloadProgressBlock?##DownloadProgressBlock?##(Int64, Int64) -> Void#>, completionHandler: <#T##((Result<RetrieveImageResult, KingfisherError>) -> Void)?##((Result<RetrieveImageResult, KingfisherError>) -> Void)?##(Result<RetrieveImageResult, KingfisherError>) -> Void#>)
    }
}
