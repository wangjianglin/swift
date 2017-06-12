//
//  CommodityDetialEdit.m
//  seller
//
//  Created by lin on 12/24/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit
import LinCore
import LinUtil
import LinComm
import ReactiveSwift
import LinRac
import ReactiveCocoa
import Result
open class CommodityDetialEditController:UIViewController, BaseView{
    
       //
 
    var scrollView:AutoScrollView!;
    var priceText:UITextField!;
    var descText:UITextView!;
    var markupText:UITextView!;
    var infoTypeView:UILabel!;
    var detialLabel:UILabel!;
    var pricePos:UIView!;
    var textColor:UIColor!;
    
    dynamic var _imagesView:ImagesView!;
    dynamic var imagesViewOne:ImagesView!;
    dynamic var imagesViewTwo:ImagesView!;
    var holdGoldView:UILabel!;
    var pickView:ZHPickView!;
    var _spreadcommission:String!;// * _spreadcommission;//差价提成
    var _percentageCommission:String!;//比例提成
    var _isSaveing = false;
    var multiPiece = false;
    var onePieceButton:QCheckBox!;
    var multiPieceButton:QCheckBox!;
    var sortBtn:UIButton!;
    var masterButton:QCheckBox!;
    var isReadProtocol = true
    
    var suggestLabel:UILabel!;
    var wsPrice = Double(0);
    var goodsCountOneButton:QCheckBox!;
    var goodsCountMultiButton:QCheckBox!;
    var selectedSortData = NSDictionary();
    var oneGoodsPriceButton:QCheckBox!;
    var multiGoodsPriceButton:QCheckBox!;
    
    var  masterCheckButton:QCheckBox!
    dynamic var protocolLabel = UILabel();
    
    var masterView:UILabel!;
    var pre:UIView!
    var priceType:Int = 0;// 是否已经同步到纯翠网  0未定义 1单件价  2多件价
    
    
    open override func viewDidLoad() {
        
        
        self.view.backgroundColor = UIColor.white
    
        super.viewDidLoad();
        _isSaveing = false;
        
        let rightButton = UIBarButtonItem();
        rightButton.title = "保存";
        rightButton.setDelegateAction(){[weak self](sender:AnyObject) in
        };
        self.navigationItem.rightBarButtonItem = rightButton;
        
        scrollView = AutoScrollView();
        self.view.addSubview(scrollView);
        scrollView.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.flexibleHeight.rawValue | UIViewAutoresizing.flexibleWidth.rawValue);
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height);
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        
        
        
        self.initView();
    }
    
       
   
    fileprivate func initView(){
        
        _imagesView = ImagesView();
        _imagesView.selectType = .allSelect
        scrollView.addSubview(_imagesView);
        
        _imagesView.translatesAutoresizingMaskIntoConstraints = false;
        
        self.view.addConstraints([
            NSLayoutConstraint(item:_imagesView, attribute:NSLayoutAttribute.top, relatedBy:NSLayoutRelation.equal, toItem:scrollView, attribute:NSLayoutAttribute.top, multiplier:1.0, constant:10.0),
            NSLayoutConstraint(item:_imagesView, attribute:NSLayoutAttribute.left, relatedBy:NSLayoutRelation.equal, toItem:self.view, attribute:NSLayoutAttribute.left, multiplier:1.0, constant:10.0),
            NSLayoutConstraint(item:_imagesView, attribute:NSLayoutAttribute.right, relatedBy:NSLayoutRelation.equal, toItem:self.view, attribute:NSLayoutAttribute.right, multiplier:1.0, constant:-10.0)
            ]);
        
        let lab = UILabel()
        lab.frame = CGRect(x: 170, y: _imagesView.frame.origin.y + 40, width: 200, height: 30);
        lab.text = "相机相册获取图片"
        self.scrollView.addSubview(lab)
        
        imagesViewOne = ImagesView();
        imagesViewOne.selectType = .carmer
        scrollView.addSubview(imagesViewOne);
        imagesViewOne.translatesAutoresizingMaskIntoConstraints = false;

        self.view.addConstraints([
            NSLayoutConstraint(item:imagesViewOne, attribute:NSLayoutAttribute.top, relatedBy:NSLayoutRelation.equal, toItem:_imagesView, attribute:NSLayoutAttribute.top, multiplier:1.0, constant:100.0),
            NSLayoutConstraint(item:imagesViewOne, attribute:NSLayoutAttribute.left, relatedBy:NSLayoutRelation.equal, toItem:self.view, attribute:NSLayoutAttribute.left, multiplier:1.0, constant:10.0),
            NSLayoutConstraint(item:imagesViewOne, attribute:NSLayoutAttribute.right, relatedBy:NSLayoutRelation.equal, toItem:self.view, attribute:NSLayoutAttribute.right, multiplier:1.0, constant:-10.0)
            ]);
        
        let lab1 = UILabel()
        lab1.frame = CGRect(x: 170, y: imagesViewOne.frame.origin.y + 155, width: 200, height: 30);
        lab1.text = "相机获取图片"
        self.scrollView.addSubview(lab1)

        
        imagesViewTwo = ImagesView();
        imagesViewTwo.selectType = .photoAlbum
        scrollView.addSubview(imagesViewTwo);
        imagesViewTwo.translatesAutoresizingMaskIntoConstraints = false;
        
        self.view.addConstraints([
            NSLayoutConstraint(item:imagesViewTwo, attribute:NSLayoutAttribute.top, relatedBy:NSLayoutRelation.equal, toItem:imagesViewOne, attribute:NSLayoutAttribute.top, multiplier:1.0, constant:100.0),
            NSLayoutConstraint(item:imagesViewTwo, attribute:NSLayoutAttribute.left, relatedBy:NSLayoutRelation.equal, toItem:self.view, attribute:NSLayoutAttribute.left, multiplier:1.0, constant:10.0),
            NSLayoutConstraint(item:imagesViewTwo, attribute:NSLayoutAttribute.right, relatedBy:NSLayoutRelation.equal, toItem:self.view, attribute:NSLayoutAttribute.right, multiplier:1.0, constant:-10.0)
            ]);
        
        let lab2 = UILabel()
        lab2.frame = CGRect(x: 170, y: imagesViewTwo.frame.origin.y + 240, width: 200, height: 30);
        lab2.text = "相册获取图片"
        self.scrollView.addSubview(lab2)

        
        let infoLabel = UILabel();
        infoLabel.text = " ";
        infoLabel.font = UIFont(name:"STHeitiSC-Light", size:12.0);
        infoLabel.textColor = textColor;
        infoLabel.backgroundColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:0.6);
        scrollView.addSubview(infoLabel);
        infoLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        self.view.addConstraints([
            NSLayoutConstraint(item:infoLabel, attribute:NSLayoutAttribute.top, relatedBy:NSLayoutRelation.equal, toItem:_imagesView, attribute:NSLayoutAttribute.bottom, multiplier:1.0, constant:10.0),
            NSLayoutConstraint(item:infoLabel, attribute:NSLayoutAttribute.left, relatedBy:NSLayoutRelation.equal, toItem:self.view, attribute:NSLayoutAttribute.left, multiplier:1.0, constant:0.0),
            NSLayoutConstraint(item:infoLabel, attribute:NSLayoutAttribute.right, relatedBy:NSLayoutRelation.equal, toItem:self.view, attribute:NSLayoutAttribute.right, multiplier:1.0, constant:0.0),
            NSLayoutConstraint(item:infoLabel, attribute:NSLayoutAttribute.height, relatedBy:NSLayoutRelation.equal, toItem:nil, attribute:NSLayoutAttribute.notAnAttribute, multiplier:1.0, constant:30.0)
            ]);
        pre = infoLabel;
        
        priceText = UITextField();
//        priceText.setup();
        
        
        holdGoldView = UILabel();
        
             holdGoldView.textColor = textColor;//[UIColor colorWithRed:0xc7/255.0 green:0xc7/255.0 blue:0xc7/255.0 alpha:1.0];
        holdGoldView.backgroundColor = UIColor.white;
        holdGoldView.font = UIFont(name:"STHeitiSC-Light", size:12.0);
        
        holdGoldView.isUserInteractionEnabled = true;
        onePieceButton = QCheckBox();
       
        
        
        let pieceView = UIView();
        
      
        
        onePieceButton.frame = CGRect(x: 10, y: 0, width: 67, height: 30);
        pieceView.translatesAutoresizingMaskIntoConstraints = false;
        
        descText = UITextView();
//        descText.setup();
        descText.font = UIFont(name:"STHeitiSC-Light", size:12.0);
        descText.textColor = textColor;
        descText.returnKeyType = UIReturnKeyType.done;
        descText.textViewShouldBeginEditing = {[weak self](_:UITextView)->Bool in
            
            
            //        if self?.pickView != nil {
            self?.pickView?.remove();
            //        }
            return true;
        };
        
        
        
        
        var h = pre.frame.size.height+pre.frame.origin.y;
        if h<scrollView.frame.size.height {
            h = scrollView.frame.size.height;
        }
       
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width,height: h + self.protocolLabel.frame.size.height - 20 + 10);
         }
  
    
    fileprivate func setImagePaths(_ images:[String]){
        _imagesView.images = images as [AnyObject];
        
    }
    

    
}
