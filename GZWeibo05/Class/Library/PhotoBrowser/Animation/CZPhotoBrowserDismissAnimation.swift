//
//  CZPhotoBrowserDismissAnimation.swift
//  GZWeibo05
//
//  Created by zhangping on 15/11/9.
//  Copyright © 2015年 zhangping. All rights reserved.
//

import UIKit

class CZPhotoBrowserDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    // 返回动画时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    // 控制转场动画
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 获取dismiss的控制器
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! CZPhotoBrowserViewController
        
        // 获取过渡视图
        let tempImageView = fromVC.dismissTempImageView()
        
        if tempImageView != nil {
            // 添加到容器视图
            transitionContext.containerView()?.addSubview(tempImageView!)
        }
        
        // 获取到dismiss控制器的view
        let formView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        // 隐藏collectionView
        fromVC.collectionView.hidden = true
        
        // 动画
        UIView.animateWithDuration(transitionDuration(nil), animations: { () -> Void in
            formView?.alpha = 0
            
            if tempImageView != nil {
                // 动画到缩小的位置
                tempImageView!.frame = fromVC.dismissTargetFrame()
            }
            }) { (_) -> Void in
                // 完成转场
                transitionContext.completeTransition(true)
        }
    }
}
