//
//  CZDismissAnimation.swift
//  GZWeibo05
//
//  Created by zhangping on 15/11/9.
//  Copyright © 2015年 zhangping. All rights reserved.
//

import UIKit

class CZDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    // 返回 动画 时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    // 在这个方法里面实现动画
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 获取到modal出来的控制器的view
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        print("fromView:\(fromView?.frame)")
        UIView.animateWithDuration(transitionDuration(nil), animations: { () -> Void in
            fromView?.transform = CGAffineTransformMakeScale(1, 0.01)
            }) { (_) -> Void in
                transitionContext.completeTransition(true)
        }
        
//        UIView.animateWithDuration(transitionDuration(nil), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
//            // 将formView的Y方向的scale设置为0
//            fromView?.transform = CGAffineTransformMakeScale(1, 0.01)
//            }) { (_) -> Void in
//                // 一定要记得告诉系统,转场完成
//                transitionContext.completeTransition(true)
//        }
    }
}
