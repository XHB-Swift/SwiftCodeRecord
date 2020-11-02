//
//  UNSViewModel.swift
//  SwiftCodeRecord
//
//  Created by xiehongbiao on 2020/11/2.
//

import UIKit
import Alamofire

private class UNSCollectionPhotoCell: UICollectionViewCell {
    
    private var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: self.bounds)
        self.contentView.addSubview(imageView!)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func configImage(_ image: UIImage) {
        self.imageView?.image = image
    }
}

public struct UNSCollectionPhotoCellConfig {
    var photo: UNSPhoto
    var size: CGSize
}

public class UNSViewModel: NSObject, UICollectionViewDataSource {
    
    private var photos = Array<UNSCollectionPhotoCellConfig>()
    private var reuseIdentifier = "UNSCollectionPhotoCell"
    private weak var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
        self.collectionView?.dataSource = self
        self.collectionView?.register(UNSCollectionPhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UNSCollectionPhotoCell
        return cell
    }
    
}
