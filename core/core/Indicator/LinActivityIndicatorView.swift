//
//  LinActivityIndicatorView.swift
//  LinControls
//
//  Created by lin on 1/4/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import UIKit


//public class LinActivityIndicatorView : UIActivityIndicatorView{
open class LinActivityIndicatorView : UIView{
    
    fileprivate var indicator:UIActivityIndicatorView!;
    
    fileprivate var _label:UILabel!
    open var label:UILabel{
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
        super.init(frame:CGRect(x: 0, y: 0, width: 0, height: 0));
        self.isUserInteractionEnabled = true;
        
        indicator = UIActivityIndicatorView();
        
        indicator.startAnimating();
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge;
        
        _label = UILabel();
        _label.textAlignment = NSTextAlignment.center;
        _label.font = UIFont(name: "STHeitiSC-Light", size: 12.0);
        _label.textColor = UIColor.gray;
//        super.init(frame: frame);
        //self.backgroundColor = UIColor.redColor();
        self.addSubview(indicator);
        self.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.3);
        
        self.addSubview(_label);
        
        _label.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addConstraints([NSLayoutConstraint(item: _label, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self ,attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: _label, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: _label, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 25),
            //            NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
            ]);
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // default is UIActivityIndicatorViewStyleWhite
    open var activityIndicatorViewStyle: UIActivityIndicatorViewStyle {
        get{return indicator.activityIndicatorViewStyle;}
        set{indicator.activityIndicatorViewStyle = newValue;}
    }
    // default is YES. calls -setHidden when animating gets set to NO
    open var hidesWhenStopped: Bool{
        get{return indicator.hidesWhenStopped;}
        set{indicator.hidesWhenStopped = newValue;}
    }
    
    @available(iOS, introduced: 5.0)
    open var color: UIColor!{
        get{return indicator.color;}
        set{indicator.color = newValue;}
    }
    
    open func startAnimating(){
        indicator.startAnimating();
    }
    open func stopAnimating(){
        indicator.stopAnimating();
    }
    open func isAnimating() -> Bool{
        return indicator.isAnimating;
    }
    
    open override func layoutSubviews() {
       

        if let rect = self.superview?.bounds {
            self.frame = rect;
            indicator.center = CGPoint(x: rect.width*0.5, y: rect.height*0.5);
        }
        super.layoutSubviews();
    }
    
    open func remove(){
        indicator.stopAnimating();
        self.removeFromSuperview();
    }
}
