//
//  ScrollImagesController.swift
//  demo
//
//  Created by lin on 6/27/16.
//  Copyright © 2016 lin. All rights reserved.
//

import UIKit
import LinCore


public class ScrollImagesController : UIViewController{
    
    public override func viewDidLoad() {
        initView();
    }
    
    private var scrollView:UIScrollView!
    private func initView(){
        scrollView = UIScrollView();
        self.view.addSubview(scrollView);
        scrollView.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleHeight.rawValue | UIViewAutoresizing.FlexibleWidth.rawValue);
        scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        
        
        //        let _imagesView = ImagesView();
        let _imagesView = ScrollImagesView();
        
        _imagesView.backgroundColor = UIColor.grayColor();
        
        _imagesView.edited = true;
        _imagesView.hidden = false;
        
        
        scrollView.addSubview(_imagesView);
        
        _imagesView.translatesAutoresizingMaskIntoConstraints = false;
        
        self.view.addConstraints([
            NSLayoutConstraint(item:_imagesView, attribute:NSLayoutAttribute.Top, relatedBy:NSLayoutRelation.Equal, toItem:scrollView, attribute:NSLayoutAttribute.Top, multiplier:1.0, constant:60.0),
            NSLayoutConstraint(item:_imagesView, attribute:NSLayoutAttribute.Left, relatedBy:NSLayoutRelation.Equal, toItem:self.view, attribute:NSLayoutAttribute.Left, multiplier:1.0, constant:10.0),
            NSLayoutConstraint(item:_imagesView, attribute:NSLayoutAttribute.Right, relatedBy:NSLayoutRelation.Equal, toItem:self.view, attribute:NSLayoutAttribute.Right, multiplier:1.0, constant:-10.0)
            ,
            NSLayoutConstraint(item:_imagesView, attribute:NSLayoutAttribute.Height, relatedBy:NSLayoutRelation.Equal, toItem:nil, attribute:NSLayoutAttribute.NotAnAttribute, multiplier:1.0, constant:200.0)
            ]);
        
        
        _imagesView.edited = true;
        _imagesView.showPositionLabel = true;
        
        
        _imagesView.imagePaths = ["http://i.feicuibaba.com/upload/store/401/9BE87A04-3B53-4FA5-8240-1A3EC7A2E1F6.jpg","http://i.feicuibaba.com/upload/store/401/9BE87A04-3B53-4FA5-8240-1A3EC7A2E1F6.jpg"]
        
        
    }
}
