//
//  CZStatusDAL.swift
//  GZWeibo05
//
//  Created by zhangping on 15/11/13.
//  Copyright © 2015年 zhangping. All rights reserved.
//

import UIKit

// 只负责加载数据,有可能从网络加载,也有可能从本地数据库加载

/*
    1. 先从本地数据库加载
    2. 本地数据库有数据,直接返回数据库中的数据
    3. 本地数据库有没有数据,调用网络工具类去网络加载数据
    4. 将网络返回的数据保存到数据库
    5. 返回数据
*/
class CZStatusDAL: NSObject {
    
    // 单例
    static let sharedInstance = CZStatusDAL()
    
    // 1.先从本地数据库加载
    func loadCacheStatus() {
        
    }
    
    /**
    将网络返回的数据保存到数据库
    - parameter statuses: 网络返回的微博数据
    */
    func saveStatus(statuses: [[String: AnyObject]]) {
        assert(CZUserAccount.loadAccount()?.uid != nil, "uid 为空")
        
        let userid = Int(CZUserAccount.loadAccount()!.uid!)!
        
        // 生成sql语句
        let sql = "INSERT INTO T_Status (statusId, status, userId) VALUES(?, ?, ?)"
        
        // 遍历微博数组,获取每一条微博的id
        for dict in statuses {
            // 获取微博id
            let statusId = dict["id"] as! Int
            
            // 不能直接往数据库存放字典, 将字典转成String
            // 字典(json) -> NSData -> String
            let data = try! NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: 0))
            
            // 转成String
            let statusString = String(data: data, encoding: NSUTF8StringEncoding)!
            
            // 添加微博数据到数据库
            CZSQLiteManager.sharedManager.dbQueue.inDatabase({ (db) -> Void in
                if !db.executeUpdate(sql, statusId, statusString, userid) {
                    print("添加微博数据失败")
                }
            })
        }
        
        print("缓存数据,添加:\(statuses.count) 条数据到数据库")
    }
}
