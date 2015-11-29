//
//  CZHomeWebViewController.swift
//  GZWeibo05
//
//  Created by zhangping on 15/11/10.
//  Copyright © 2015年 zhangping. All rights reserved.
//

import UIKit
import SVProgressHUD

class CZHomeWebViewController: UIViewController, UIWebViewDelegate {
    
    // MARK: - 属性
    /// url地址
    var url: NSURL?
    
    override func loadView() {
        view = webView
        
        webView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let urlString = self.url {
            
            let request = NSURLRequest(URL: urlString)
            
            // 开始加载网址
            webView.loadRequest(request)
        }
    }
    
    // 已经开始加载内容
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.showWithStatus("正在加载", maskType: SVProgressHUDMaskType.Black)
    }
    
    // webView加载完毕
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    // MARK: - 懒加载webView
    private lazy var webView = UIWebView()
}
