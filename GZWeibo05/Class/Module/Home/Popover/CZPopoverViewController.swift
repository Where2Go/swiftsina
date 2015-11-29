//
//  CZPopoverViewController.swift
//  GZWeibo05
//
//  Created by zhangping on 15/11/9.
//  Copyright © 2015年 zhangping. All rights reserved.
//

import UIKit

class CZPopoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var content: [String] = ["首页", "好友圈", "群微博", "我的微博", "新浪微博"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareTableView()
    }
    
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("popoverCell")!
        
        cell.textLabel?.text = content[indexPath.row]
        
        return cell
    }
}
