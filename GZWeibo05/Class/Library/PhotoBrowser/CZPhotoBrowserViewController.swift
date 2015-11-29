//
//  CZPhotoBrowserViewController.swift
//  GZWeibo05
//
//  Created by zhangping on 15/11/7.
//  Copyright © 2015年 zhangping. All rights reserved.
//

import UIKit
import SVProgressHUD

let CZPhotoBrowserMinimumLineSpacing: CGFloat = 10

class CZPhotoBrowserViewController: UIViewController {
    
    // MARK: - 属性
    /// cell重用id
    private let cellIdentifier = "cellIdentifier"
    
    /// 大图的urls
    private var photoModels: [CZPhotoBrowserModel]
    
    private var selectedIndex: Int
    
    // MARK: - 构造函数
    init(models: [CZPhotoBrowserModel], selectedIndex: Int) {
        self.photoModels = models
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 显示点击对应的大图
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 滚动到对应的张数 selectedIndex-> IndexPath
        let indexPath = NSIndexPath(forItem: selectedIndex, inSection: 0)
        
        // 滚动到对应的张数
        collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.Left)
    }
    
    /// 流水布局
    private var layout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()

        prepareUI()
        
        // 设置页数  当前页 / 总页数
        pageLabel.text = "\(selectedIndex + 1) / \(photoModels.count)"
    }
    
    // MARK: - 按钮点击事件
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 保存图片
    func save() {
        let indexPath = collectionView.indexPathsForVisibleItems().first!
        
        // 获取正在显示的cell
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CZPhotoBrowserCell
        
        // 获取正在显示的图片
        if let image = cell.imageView.image {
            // 保存图片
            
            // completionTarget: 保存成功或失败,回调这个对象
            // completionSelector: 回调的方法
            // - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
            // image didFinishSavingWithError contextInfo : 前面的名称 都相当于swift里面的外部参数名
            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
        }
    }
    
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            // 保存失败
            SVProgressHUD.showErrorWithStatus("保存失败", maskType: SVProgressHUDMaskType.Black)
            return
        }
        
        SVProgressHUD.showSuccessWithStatus("保存成功", maskType: SVProgressHUDMaskType.Black)
    }
    
    private func prepareUI() {
        // 添加子控件
        
        // 注意背景视图添加在最底部
        view.addSubview(bkgView)
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        view.addSubview(pageLabel)
        
        // 按钮添加点击事件
        closeButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        
        // 添加约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        pageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 设置 背景视图的frame
        bkgView.frame = view.bounds
        
        let views = [
            "cv": collectionView,
            "cb": closeButton,
            "sb": saveButton,
            "pl": pageLabel
        ]
        // collectionView, 填充父控件
        // 将colllectionView的宽度+间距
        collectionView.frame =  CGRect(x: 0, y: 0, width: UIScreen.width() + CZPhotoBrowserMinimumLineSpacing, height: UIScreen.height())
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        // 页码
        view.addConstraint(NSLayoutConstraint(item: pageLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: pageLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20))
        
        // 关闭、保存按钮
        // 高度35距离父控件底部8
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cb(35)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[sb(35)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        // 水平方向
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[cb(75)]-(>=0)-[sb(75)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        // 设置collectionView
        prepareCollectionView()
    }
    
    private func prepareCollectionView() {
        // 注册cell
        collectionView.registerClass(CZPhotoBrowserCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        // 设置collelctionView的背景颜色
        collectionView.backgroundColor = UIColor.clearColor()
        
        // layout.item
        layout.itemSize = view.bounds.size
        
        // 滚动方向
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CZPhotoBrowserMinimumLineSpacing)
        
        // 间距设置为0
        layout.minimumInteritemSpacing = CZPhotoBrowserMinimumLineSpacing
        layout.minimumLineSpacing = CZPhotoBrowserMinimumLineSpacing
        
        // 不需要弹簧效果
        collectionView.bounces = false
        
        // 分页显示
        collectionView.pagingEnabled = true
        
        // 数据源和代理
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - 懒加载
    /// collectionView
    lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
    
    /// 关闭
    private lazy var closeButton: UIButton = UIButton(bkgImageName: "health_button_orange_line", title: "关闭", titleColor: UIColor.whiteColor(), fontSzie: 12)
    
    /// 保存
    private lazy var saveButton: UIButton = UIButton(bkgImageName: "health_button_orange_line", title: "保存", titleColor: UIColor.whiteColor(), fontSzie: 12)
    
    /// 页码的label
    private lazy var pageLabel = UILabel(fonsize: 15, textColor: UIColor.whiteColor())
    
    /// 背景视图,用于修改alpha
    private lazy var bkgView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        
        return view
    }()
}

// MARK: - 扩展 CZPhotoBrowserViewController 实现 UICollectionViewDataSource 和 UICollectionViewDelegate
extension CZPhotoBrowserViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // 返回cell的个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModels.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CZPhotoBrowserCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        // 设置cell要显示的url
        cell.photoModel = photoModels[indexPath.item]
        
        // 设置控制器为cell的代理
        cell.cellDelegate = self
        
        return cell
    }
    
    // scrolView停止滚动,获取当前显示cell的indexPath
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 获取正在显示的cell
        let indexPath = collectionView.indexPathsForVisibleItems().first!
        
        // 赋值 selectedIndex,
        selectedIndex = indexPath.item
        
        // 设置页数
        // 设置页数  当前页 / 总页数
        pageLabel.text = "\(selectedIndex + 1) / \(photoModels.count)"
    }
}

// MARK: - 扩展 CZPhotoBrowserViewController 实现 CZPhotoBrowserCellDelegate 协议
extension CZPhotoBrowserViewController: CZPhotoBrowserCellDelegate {
    // 返回需要设置alpha的view
    func viewForTransparent() -> UIView {
        return bkgView
    }
    
    // 关闭控制器
    func cellDismiss() {
        // 关闭是不需要动画
        dismissViewControllerAnimated(false, completion: nil)
    }
}

extension CZPhotoBrowserViewController: UIViewControllerTransitioningDelegate {
    // 返回 控制 modal动画 对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // 创建 控制 modal动画 对象
        return CZPhotoBrowserModalAnimation()
    }
    
    // 控制 dismiss动画 对象
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CZPhotoBrowserDismissAnimation()
    }
}

// MARK: - 转场动画
extension CZPhotoBrowserViewController {
    // 提供转场动画的过渡视图, 需要知道显示的图片,还需要知道点击的cell的frame
    
    // MARK: - modal动画相关
    /**
    返回modal出来时需要的过渡视图
    - returns: modal出来时需要的过渡视图
    */
    func modalTempImageView() -> UIImageView {
        // 缩略图的view
        let thumbImageView = photoModels[selectedIndex].imageView!
        
        // 创建过渡视图
        let tempImageView = UIImageView(image: thumbImageView.image)
        
        // 设置参数
        tempImageView.contentMode = thumbImageView.contentMode
        tempImageView.clipsToBounds = true
        
        // 设置过渡视图的frame
        // 直接设置是不行的,坐标系不一样
//        tempImageView.frame = thumbImageView.frame
        
        // thumbImageView.superview!: 转换前的坐标系
        // rect: 需要转换的frame
        // toCoordinateSpace: 转换后的坐标系
        let rect = thumbImageView.superview!.convertRect(thumbImageView.frame, toCoordinateSpace: view)
        
        // 设置转换好的frame
        tempImageView.frame = rect
        
        return tempImageView
    }
    
    /**
    返回 modal动画时放大的frame
    - returns: modal动画时放大的frame
    */
    func modalTargetFrame() -> CGRect? {
        // 获取到对应的缩略图
        let thumbImageView = photoModels[selectedIndex].imageView!
        
        if thumbImageView.image == nil {
            return nil
        }
        // 获取缩略图
        let thumbImage = thumbImageView.image!
        
        // 计算宽高
        var newSize = thumbImage.displaySize()
        
        // 判断长短图
        var offestY: CGFloat = 0
        if newSize.height < UIScreen.height() {
            offestY = (UIScreen.height() - newSize.height) * 0.5
        } else {
            newSize.height = UIScreen.height()
        }
        
        return CGRect(x: 0, y: offestY, width: newSize.width, height: newSize.height)
    }
    
    // MARK: - dismiss动画相关
    /**
    返回dismiss时的过渡视图
    - returns: dismiss时的过渡视图
    */
    func dismissTempImageView() -> UIImageView? {
        // 获取正在显示的cell
        let indexPath = collectionView.indexPathsForVisibleItems().first!
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CZPhotoBrowserCell
        
        // 判断图片是否存在
        if cell.imageView.image == nil {
            return nil
        }
        
        // 获取正在显示的图片
        let image = cell.imageView.image!
        
        // 创建过渡视图
        let tempImageView = UIImageView(image: image)
        
        // 设置过渡视图
        tempImageView.contentMode = UIViewContentMode.ScaleAspectFill
        tempImageView.clipsToBounds = true
        
        // 设置frame
        // 转换坐标系
        let rect = cell.imageView.superview!.convertRect(cell.imageView.frame, toCoordinateSpace: view)
        tempImageView.frame = rect
        
        return tempImageView
    }
    
    /**
    返回缩小后的fram
    - returns: 缩小后的fram
    */
    func dismissTargetFrame() -> CGRect {
        let model = photoModels[selectedIndex]
        let thumbImageView = model.imageView
        
        // 坐标系转换
        let rect = model.imageView!.superview!.convertRect(model.imageView!.frame, toCoordinateSpace: view)
        
        return rect
    }
}