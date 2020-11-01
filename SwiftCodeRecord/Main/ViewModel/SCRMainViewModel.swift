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
        self.accessoryType = .disclosureIndicator
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func configCell(_ data: SCRDrawbale) {
        if let attributedText = data as? NSAttributedString {
            self.textLabel?.attributedText = attributedText
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
        self.tableView?.separatorStyle = .singleLine
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
                        let commonAttributes: [NSAttributedString.Key:Any] = [.font:UIFont.systemFont(ofSize: 18),.foregroundColor:UIColor.black]
                        _ = titles.map {
                            let attrTitle = NSAttributedString(string: $0, attributes: commonAttributes)
                            let attrSize = attrTitle.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil).size
                            let newSize = CGSize(width: attrSize.width, height: attrSize.height + 36)
                            let mainConfig = SCRMainCellConfiguration(attributedTitle: attrTitle, attributedTitleSize: newSize)
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
                    self.titles.append(contentsOf: mainTitleConfigs)
                    let oldRowCount = self.tableView!.numberOfRows(inSection: 0)
                    let newRowCount = mainTitleConfigs.count
                    let newCount = oldRowCount + newRowCount
                    let newRange = oldRowCount..<newCount
                    let newIndexPaths = newRange.map { IndexPath(row: $0, section: 0) }
                    self.tableView?.insertRows(at: newIndexPaths, with: UITableView.RowAnimation.none)
                }
            }
        }
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SCRMainTableCell
        cell.configCell(titles[indexPath.row].attributedTitle)
        return cell
    }
    
    public subscript(index: IndexPath) -> SCRMainCellConfiguration {
        return titles[index.row]
    }
}
