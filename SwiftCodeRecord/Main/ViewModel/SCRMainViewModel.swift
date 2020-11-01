//
//  SCRMainViewModel.swift
//  SwiftCodeRecord
//
//  Created by xiehongbiao on 2020/10/31.
//

import UIKit

private class SCRMainTableCell: SCRTableCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func configCell(_ data: SCRDrawbale) {
        if let d = data as? NSAttributedString {
            d.drawIn(size: self.contentView.bounds.size) { (image) in
                self.contentView.layer.contents = image.cgImage
            }
        }
    }
}

public struct SCRMainCellConfiguration {
    var attributedTitle: NSAttributedString
    var attributedTitleSize: CGSize
}

public class SCRMainViewModel: NSObject, UITableViewDataSource {
    
    private var titles = Array<SCRMainCellConfiguration>()
    private var reuseIdentifier = "SCRMainTableCell"
    private weak var tableView: UITableView?
    
    init(tableView: UITableView?) {
        super.init()
        self.tableView = tableView
        self.tableView?.dataSource = self
        self.tableView?.register(SCRMainTableCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    public func loadMainTitles() {
        let maxWidth = self.tableView?.bounds.size.width ?? SCRScreenSize.width
        let maxSize = CGSize(width: maxWidth, height: CGFloat(MAXFLOAT))
        DispatchQueue.global().async {
            
            var mainTitleConfigs = Array<SCRMainCellConfiguration>()
            var loadError: Error?
            if let filePath = Bundle.main.path(forResource: "SCRMainTitles", ofType: "plist"),
               let plistData = FileManager.default.contents(atPath: filePath) {
                do {
                    var format = PropertyListSerialization.PropertyListFormat.xml
                    if let titles = try PropertyListSerialization.propertyList(from: plistData, options: .mutableContainersAndLeaves, format: &format) as? [String] {
                        _ = titles.map {
                            let commonAttributes: [NSAttributedString.Key:Any] = [.font:UIFont.systemFont(ofSize: 18),
                                                                                  .foregroundColor:UIColor.black]
                            let attrTitle = NSAttributedString(string: $0, attributes: commonAttributes)
                            let attrSize = attrTitle.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil).size
                            let mainConfig = SCRMainCellConfiguration(attributedTitle: attrTitle, attributedTitleSize: attrSize)
                            mainTitleConfigs.append(mainConfig)
                        }
                    }
                } catch {
                    loadError = error
                }
            }else {
                loadError = SCRErrorEnum.noFilePath
            }
            
            DispatchQueue.main.async {
                if let e = loadError {
                    print("error = \(e)")
                }else {
                    self.titles = mainTitleConfigs
                    self.tableView?.reloadData()
                }
            }
        }
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? SCRMainTableCell
        if cell != nil {
            cell?.configCell(titles[indexPath.row].attributedTitle)
        }else {
            cell = SCRMainTableCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        }
        return cell!
    }
    
    public func tableViewRowHeight(at indexPath: IndexPath) -> CGFloat {
        return titles[indexPath.row].attributedTitleSize.height
    }
}
