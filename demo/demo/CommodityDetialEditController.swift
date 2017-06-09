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
        _spreadcommission = "加价";
        _percentageCommission = "提成";
        
        _isSaveing = false;
        textColor = UIColor(red:0x7b/255.0, green:0x7b/255.0, blue:0x7b/255.0, alpha:1.0);
        
     
        
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
        //self.update();
    }
    
       
   
    fileprivate func initView(){
        
        _imagesView = ImagesView();
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
        
        pre = addGoodsCountInPic(pre);
        
        priceText = UITextField();
//        priceText.setup();
        suggestLabel = UILabel();
        suggestLabel.translatesAutoresizingMaskIntoConstraints = false;

        suggestLabel.font = UIFont.systemFont(ofSize: 13);
        suggestLabel.textColor = UIColor.black;
      
        
        
        
        holdGoldView = UILabel();
        
             holdGoldView.textColor = textColor;//[UIColor colorWithRed:0xc7/255.0 green:0xc7/255.0 blue:0xc7/255.0 alpha:1.0];
        holdGoldView.backgroundColor = UIColor.white;
        holdGoldView.font = UIFont(name:"STHeitiSC-Light", size:12.0);
        
        holdGoldView.isUserInteractionEnabled = true;
        onePieceButton = QCheckBox();
       
        
        
        onePieceButton.didSelectedCheckBoxAction = {[weak self](checkBox:QCheckBox!) in
            
            if !checkBox.checked && !(self?.multiPieceButton.checked ?? false){
                checkBox.checked = true;
                return;
            }
            if checkBox.checked {
                self?.multiPiece = false;
                self?.multiPieceButton.checked = false;
                //sself->remberButton.checked = true;
                //checkBox.checked = true;
            }
        };
        
        
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
        
        
        
        markupText = UITextView();
//        markupText.setup();
        markupText.font = UIFont(name:"STHeitiSC-Light", size:12.0);
        markupText.textColor = textColor;
        markupText.returnKeyType = UIReturnKeyType.done;
        markupText.textViewShouldBeginEditing = {[weak self](_:UITextView!)->Bool in
            
            self?.pickView?.remove();
            return true;
        };
        
        let users = ["","13202906158"
            ,"13433902340"
            ,"18674758462"
            //                        ,"13425621550"
            ,"18580721882"
            ,"13619648031"
            ,""
            ,""
            ,""
            ,"","",""];
        
        
        var h = pre.frame.size.height+pre.frame.origin.y;
        if h<scrollView.frame.size.height {
            h = scrollView.frame.size.height;
        }
         self.addProtocolBtn(pre: pre)
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width,height: h + self.protocolLabel.frame.size.height - 20 + 10);
       
       
        
        
         }
 
    
   //添加协议的按钮
    func addProtocolBtn(pre:UIView) {
        
        self.protocolLabel.numberOfLines = 0;
        self.protocolLabel.font = UIFont.systemFont(ofSize: 13);
        self.protocolLabel.textColor = UIColor.red;
        //self.protocolLabel.text = "注：\n\n1、上传的商品按《委托销售合作协议》执行。\n2、审核通过后，系统会测算出建议零售价，如果平台降价销售，由平台承担损失。";
        let text = "注：\n1、上传的商品按《委托销售合作协议》执行。\n2、审核通过后，系统会测算出建议零售价，如果平台降价销售，由平台承担损失。"
        
        let paragraphStyle = NSMutableParagraphStyle.init();
        paragraphStyle.lineSpacing = 10;
        let attr = NSMutableAttributedString.init(string: text, attributes: [NSParagraphStyleAttributeName:paragraphStyle]);
        self.protocolLabel.attributedText = attr;
        let size = self.protocolLabel.sizeThatFits(CGSize.init(width: UIScreen.main.bounds.size.width - 20, height: CGFloat(MAXFLOAT)));
        
        
        
      

    }
       fileprivate func addMasterInfo(_ pre:UIView)->UIView{
        
        masterCheckButton = QCheckBox();
        masterCheckButton.setTitle("大师作品", for:UIControlState.normal);
        masterCheckButton.setTitleColor(textColor, for:UIControlState.normal);
        masterCheckButton.setTitleColor(UIColor.gray, for:UIControlState.highlighted);
        masterCheckButton.setTitleColor(textColor, for:UIControlState.selected);
        masterCheckButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0);
        
        return self.addItem(pre, title:"", right:masterCheckButton, leftHeight:30, rightHeight:30, top:0);
    }
      fileprivate func addGoodsCountInPic(_ pre:UIView)->UIView{
        let goodsCountView = UIView();
        
        //        goodsCountOneButton:QCheckBox!;
        //        private var goodsCountMultiButton:QCheckBox!;
        
        goodsCountOneButton = QCheckBox();
        goodsCountOneButton.setTitle("只有一件", for:UIControlState.normal);
        goodsCountOneButton.setTitleColor(textColor, for:UIControlState.normal);
        goodsCountOneButton.setTitleColor(UIColor.gray, for:UIControlState.highlighted);
        goodsCountOneButton.setTitleColor(textColor, for:UIControlState.selected);
        goodsCountOneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0);
        goodsCountOneButton.type = QCheckBoxType.Radio;
        goodsCountOneButton.checked = true;
        
        goodsCountOneButton.didSelectedCheckBoxAction = {[weak self](checkBox:QCheckBox!) in
            
            
            
            if !checkBox.checked && !(self?.goodsCountMultiButton.checked ?? false) {
                checkBox.checked = true;
                return;
            }
            if checkBox.checked {
                //                self?.multiPiece = true;
                self?.goodsCountMultiButton.checked = false;
                
            }
            
            self?.priceType = 0;
            
//            if self?.goods?.id ?? 0 == 0 {
            
                self?.oneGoodsPriceButton.checked = false;
                self?.oneGoodsPriceButton.isUserInteractionEnabled = false;
                
                self?.multiGoodsPriceButton.checked = false;
                self?.multiGoodsPriceButton.isUserInteractionEnabled = false;
//            }
        };
        
        
       
        

   
        
        goodsCountOneButton.frame = CGRect(x: 10, y: 0, width: 97, height: 30);
    
        goodsCountView.translatesAutoresizingMaskIntoConstraints = false;
        
        return self.addItem(pre, title:"", right:goodsCountView, leftHeight:35, rightHeight:30, top:10);
    }
    
    fileprivate func addGoodsPriceType(_ pre:UIView)->UIView{
        let priceTypeView = UIView();
        
        
        oneGoodsPriceButton = QCheckBox();
        oneGoodsPriceButton.setTitle("单件商品价", for:UIControlState.normal);
        oneGoodsPriceButton.setTitleColor(textColor, for:UIControlState.normal);
        oneGoodsPriceButton.setTitleColor(UIColor.gray, for:UIControlState.highlighted);
        oneGoodsPriceButton.setTitleColor(textColor, for:UIControlState.selected);
        oneGoodsPriceButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0);
        oneGoodsPriceButton.type = QCheckBoxType.Radio;
        oneGoodsPriceButton.isUserInteractionEnabled = false;
        
        oneGoodsPriceButton.didSelectedCheckBoxAction = {[weak self](checkBox:QCheckBox!) in
            
            if !checkBox.checked && self?.priceType ?? 0 == 1 {
                checkBox.checked = true;
                return;
            }
            if checkBox.checked {
                //                self?.multiPiece = true;
                self?.priceType = 1;
                self?.multiGoodsPriceButton.checked = false;
            }
        };
        
        
        multiGoodsPriceButton = QCheckBox();
        multiGoodsPriceButton.setTitle("一手价", for:UIControlState.normal);
        multiGoodsPriceButton.setTitleColor(textColor, for:UIControlState.normal);
        multiGoodsPriceButton.setTitleColor(UIColor.gray, for:UIControlState.highlighted);
        multiGoodsPriceButton.setTitleColor(textColor, for:UIControlState.selected);
        multiGoodsPriceButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0);
        multiGoodsPriceButton.type = QCheckBoxType.Radio;
        multiGoodsPriceButton.isUserInteractionEnabled = false;
        
        priceTypeView.addSubview(oneGoodsPriceButton);
        priceTypeView.addSubview(multiGoodsPriceButton);
        
        multiGoodsPriceButton.didSelectedCheckBoxAction = {[weak self](checkBox:QCheckBox!) in
            
            if !checkBox.checked && self?.priceType ?? 0 == 2 {
                checkBox.checked = true;
                return;
            }
            if checkBox.checked {
                //                self?.multiPiece = false;
                self?.priceType = 2;
                self?.oneGoodsPriceButton.checked = false;
                //sself->remberButton.checked = true;
                //checkBox.checked = true;
            }
        };
        
        oneGoodsPriceButton.frame = CGRect(x: 10, y: 0, width: 97, height: 30);
        multiGoodsPriceButton.frame = CGRect(x: 110, y: 0, width: 97, height: 30);
        
        
        return self.addItem(pre, title:"", right:priceTypeView, leftHeight:35, rightHeight:30, top:0);
    }
    
    
    
    fileprivate func addItem(_ preItem:UIView, title leftLabelString:String, right:UIView, leftHeight:CGFloat, rightHeight:CGFloat, top:CGFloat)->UIView{
        
        //let leftWidth:CGFloat = 70;
        var leftWidth:CGFloat = 0;
        if right == self.protocolLabel {
            leftWidth = 10;
        } else {
            leftWidth = 70;
        }
        let leftLabel = UILabel();
        leftLabel.text = leftLabelString;
        leftLabel.textAlignment = NSTextAlignment.right;
        leftLabel.font = UIFont(name:"STHeitiSC-Light", size:12.0);
        leftLabel.textColor = textColor;
        leftLabel.backgroundColor = UIColor.clear;
        scrollView.addSubview(leftLabel);
        
        leftLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        self.view.addConstraints(
            [
                NSLayoutConstraint(item:leftLabel, attribute:NSLayoutAttribute.top, relatedBy:NSLayoutRelation.equal, toItem:preItem, attribute:NSLayoutAttribute.bottom, multiplier:1.0, constant:top),
                NSLayoutConstraint(item:leftLabel, attribute:NSLayoutAttribute.left, relatedBy:NSLayoutRelation.equal, toItem:self.view, attribute:NSLayoutAttribute.left, multiplier:1.0, constant:0.0),
                NSLayoutConstraint(item:leftLabel, attribute:NSLayoutAttribute.width, relatedBy:NSLayoutRelation.equal, toItem:nil, attribute:NSLayoutAttribute.notAnAttribute, multiplier:1.0, constant:leftWidth),
                NSLayoutConstraint(item:leftLabel, attribute:NSLayoutAttribute.height, relatedBy:NSLayoutRelation.equal, toItem:nil, attribute:NSLayoutAttribute.notAnAttribute, multiplier:1.0, constant:leftHeight)
            ]);
        scrollView.addSubview(right);
        right.translatesAutoresizingMaskIntoConstraints = false;
        
          
        return leftLabel;
    }
    
    fileprivate func setImagePaths(_ images:[String]){
        _imagesView.images = images as [AnyObject];
        
    }
    

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dest = segue.destination;

    }
    
    
}
