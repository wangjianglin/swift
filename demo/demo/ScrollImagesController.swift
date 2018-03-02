//
//  ScrollImagesController.swift
//  demo
//
//  Created by lin on 6/27/16.
//  Copyright © 2016 lin. All rights reserved.
//

import UIKit
import CessCore


open class ScrollImagesController : UIViewController{
    
    open override func viewDidLoad() {
        initView();
    }
    
    fileprivate var scrollView:UIScrollView!
    fileprivate func initView(){
        scrollView = UIScrollView();
        self.view.addSubview(scrollView);
        scrollView.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.flexibleHeight.rawValue | UIViewAutoresizing.flexibleWidth.rawValue);
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height);
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        
        
        //        let _imagesView = ImagesView();
        let _imagesView = ScrollImagesView();
        
        _imagesView.backgroundColor = UIColor.gray;
        
        _imagesView.edited = true;
        _imagesView.isHidden = false;
        
        
        scrollView.addSubview(_imagesView);
        
        _imagesView.translatesAutoresizingMaskIntoConstraints = false;
        
        self.view.addConstraints([
            NSLayoutConstraint(item:_imagesView, attribute:NSLayoutAttribute.top, relatedBy:NSLayoutRelation.equal, toItem:scrollView, attribute:NSLayoutAttribute.top, multiplier:1.0, constant:60.0),
            NSLayoutConstraint(item:_imagesView, attribute:NSLayoutAttribute.left, relatedBy:NSLayoutRelation.equal, toItem:self.view, attribute:NSLayoutAttribute.left, multiplier:1.0, constant:10.0),
            NSLayoutConstraint(item:_imagesView, attribute:NSLayoutAttribute.right, relatedBy:NSLayoutRelation.equal, toItem:self.view, attribute:NSLayoutAttribute.right, multiplier:1.0, constant:-10.0)
            ,
            NSLayoutConstraint(item:_imagesView, attribute:NSLayoutAttribute.height, relatedBy:NSLayoutRelation.equal, toItem:nil, attribute:NSLayoutAttribute.notAnAttribute, multiplier:1.0, constant:200.0)
            ]);
        
        
        _imagesView.edited = true;
        _imagesView.showPositionLabel = true;
        
        
        _imagesView.imagePaths = ["http://i.feicuibaba.com/upload/store/401/9BE87A04-3B53-4FA5-8240-1A3EC7A2E1F6.jpg","http://i.feicuibaba.com/upload/store/401/9BE87A04-3B53-4FA5-8240-1A3EC7A2E1F6.jpg"]
        
        
    }
}
