//
//  CZImageView.swift
//  GZWeibo05
//
//  Created by zhangping on 15/11/9.
//  Copyright © 2015年 zhangping. All rights reserved.
//

import UIKit

class CZImageView: UIImageView {

    // 覆盖父类的属性
    override var transform: CGAffineTransform {
        didSet {
            // 当设置的缩放比例小于指定的最小缩放比例时.重新设置
            if transform.a < CZPhotoBrowserCellMinimumZoomScale {
//                print("设置 transform.a:\(transform.a)")
                transform = CGAffineTransformMakeScale(CZPhotoBrowserCellMinimumZoomScale, CZPhotoBrowserCellMinimumZoomScale)
            }
        }
    }

}
