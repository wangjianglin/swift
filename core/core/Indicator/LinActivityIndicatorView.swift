//
//  LinActivityIndicatorView.swift
//  LinControls
//
//  Created by lin on 1/4/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import UIKit


//public class LinActivityIndicatorView : UIActivityIndicatorView{
public class LinActivityIndicatorView : UIView{
    
    private var indicator:UIActivityIndicatorView!;
    
    private var _label:UILabel!
    public var label:UILabel{
        return _label;
    }
    // sizes the view according to the style
//    init!(activityIndicatorStyle style: UIActivityIndicatorViewStyle){
//        //indicator = UIActivityIndicatorView(activityIndicatorStyle: style);
//        super.init();
//        self.userInteractionEnabled = true;
//    }
    
//    public override init(frame:CGRect){
//        
//    }

    public init(){
        //indicator = UIActivityIndicatorView();
        super.init(frame:CGRectMake(0, 0, 0, 0));
        self.userInteractionEnabled = true;
        
        indicator = UIActivityIndicatorView();
        
        indicator.startAnimating();
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge;
        
        _label = UILabel();
        _label.textAlignment = NSTextAlignment.Center;
        _label.font = UIFont(name: "STHeitiSC-Light", size: 12.0);
        _label.textColor = UIColor.grayColor();
//        super.init(frame: frame);
        //self.backgroundColor = UIColor.redColor();
        self.addSubview(indicator);
        self.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.3);
        
        self.addSubview(_label);
        
        _label.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addConstraints([NSLayoutConstraint(item: _label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self ,attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: _label, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: _label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 25),
            //            NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
            ]);
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // default is UIActivityIndicatorViewStyleWhite
    public var activityIndicatorViewStyle: UIActivityIndicatorViewStyle {
        get{return indicator.activityIndicatorViewStyle;}
        set{indicator.activityIndicatorViewStyle = newValue;}
    }
    // default is YES. calls -setHidden when animating gets set to NO
    public var hidesWhenStopped: Bool{
        get{return indicator.hidesWhenStopped;}
        set{indicator.hidesWhenStopped = newValue;}
    }
    
    @available(iOS, introduced=5.0)
    public var color: UIColor!{
        get{return indicator.color;}
        set{indicator.color = newValue;}
    }
    
    public func startAnimating(){
        indicator.startAnimating();
    }
    public func stopAnimating(){
        indicator.stopAnimating();
    }
    public func isAnimating() -> Bool{
        return indicator.isAnimating();
    }
    
    public override func layoutSubviews() {
       

        if let rect = self.superview?.bounds {
            self.frame = rect;
            indicator.center = CGPointMake(rect.width*0.5, rect.height*0.5);
        }
        super.layoutSubviews();
    }
    
    public func remove(){
        indicator.stopAnimating();
        self.removeFromSuperview();
    }
}