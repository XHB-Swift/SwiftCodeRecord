//
//  SCRMainViewController.swift
//  SwiftCodeRecord
//
//  Created by xiehongbiao on 2020/10/31.
//

import UIKit

class SCRMainViewController: UIViewController, UITableViewDelegate {
    
    private lazy var tableView = UITableView(frame: self.view.bounds, style: .plain)
    private lazy var mainViewModel = SCRMainViewModel(tableView: self.tableView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "代码记录示例"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
    }
    
    private func setupView() {
        if self.tableView.superview == nil {
            self.tableView.backgroundColor = .white
            self.tableView.delegate = self
            self.tableView.tableFooterView = UIView(frame: .zero)
            self.view.addSubview(self.tableView)
            self.mainViewModel.loadMainTitles()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = self.mainViewModel[indexPath].attributedTitle
        let skipConfig = SCRRouterSkipConfig<String>(parameters: title.string, skipForm: .push, parameterName: "title")
        SCRRouter.router.jumpTo(url: SCRRouter.SCRRouterPageUnsplash, from: self, with: skipConfig)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.mainViewModel[indexPath].attributedTitleSize.height
    }
}
