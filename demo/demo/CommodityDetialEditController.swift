//
//  CommodityDetialEdit.m
//  seller
//
//  Created by lin on 12/24/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit
import CessCore
import CessUtil
import CessComm
import ReactiveSwift
import CessRac
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
    
    @objc dynamic var _imagesView:ImagesView!;
    @objc dynamic var imagesViewOne:ImagesView!;
    @objc dynamic var imagesViewTwo:ImagesView!;
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
    @objc dynamic var protocolLabel = UILabel();
    
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
        holdGoldView = UILabel();
        
        holdGoldView.textColor = textColor;
        holdGoldView.backgroundColor = UIColor.white;
        holdGoldView.font = UIFont(name:"STHeitiSC-Light", size:12.0);
        
        holdGoldView.isUserInteractionEnabled = true;
        onePieceButton = QCheckBox();
       
        let pieceView = UIView();
        onePieceButton.frame = CGRect(x: 10, y: 0, width: 67, height: 30);
        pieceView.translatesAutoresizingMaskIntoConstraints = false;
        descText = UITextView();
        descText.font = UIFont(name:"STHeitiSC-Light", size:12.0);
        descText.textColor = textColor;
        descText.returnKeyType = UIReturnKeyType.done;
        descText.textViewShouldBeginEditing = {[weak self](_:UITextView)->Bool in
            
        self?.pickView?.remove();
        
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
