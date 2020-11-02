//
//  UNSViewController.swift
//  SwiftCodeRecord
//
//  Created by xiehongbiao on 2020/10/31.
//

import UIKit

public class UNSViewController: UIViewController {
    
    private lazy var flowLayout = UICollectionViewLayout()
    private lazy var collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.flowLayout)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupView() {
        if self.collectionView.superview == nil {
            self.collectionView.delegate = self
            self.view.addSubview(self.collectionView)
        }
    }
}

extension UNSViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.zero
    }
}
