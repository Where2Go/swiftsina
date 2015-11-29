//
//  CZModalAnimation.swift
//  GZWeibo05
//
//  Created by zhangping on 15/11/9.
//  Copyright © 2015年 zhangping. All rights reserved.
//

import UIKit

class CZModalAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    // 返回动画的时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    // 实现动画
    /*
        当实现这个方法,model出来的控制器的view是需要我们自己添加到容器视图
    
        transitionContext: 
            转场的上下文.提供转场相关的元素
    
            containerView():
                容器视图
    
            completeTransition:
                当转场完成一定要调用,否则系统会认为转场没有完成,不能继续交互
    
            viewControllerForKey(key: String):
                拿到对应的控制器:
                    modal时:
                        UITransitionContextFromViewControllerKey: 调用presentViewController的对象
                    UITransitionContextToViewControllerKey:
                        modal出来的控制器
    
            viewForKey
                拿到对应的控制器的view
                    UITransitionContextFromViewKey
                    UITransitionContextToViewKey
    */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 将modal出来的控制器的view添加到容器视图
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // 设置缩放
        toView.transform = CGAffineTransformMakeScale(1, 0)
        toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        // 添加到容器视图
        transitionContext.containerView()?.addSubview(toView)
        UIView.animateWithDuration(transitionDuration(nil), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            toView.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                // 转场完成
                transitionContext.completeTransition(true)
        }
    }
}
