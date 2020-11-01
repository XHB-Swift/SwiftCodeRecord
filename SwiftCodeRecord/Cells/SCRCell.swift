//
//  SCRCell.swift
//  SwiftCodeRecord
//
//  Created by xiehongbiao on 2020/10/31.
//

import UIKit

public protocol SCRDrawbale {
    
}

 
public class SCRTableCell: UITableViewCell {
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func configCell(_ data: SCRDrawbale) {
        
    }
    
}
