//
//  UIViewControllers.swift
//  LinCore
//
//  Created by lin on 5/28/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import CessUtil


extension Ext where Base : UIViewController {
    
    public func performUnwindSegueWithAction(_ action:String, sender:AnyObject!){
        
        let selector = NSSelectorFromString(action);

        var parent = base.parent;
        while parent != nil {
        
            let vc = parent! as UIViewController;
            let obj = vc.forUnwindSegueAction(selector, from: base, withSender: nil);
            
            if let obj = obj {
                base.navigationController?.present(obj, animated:true, completion:nil);
                
                break;
            }
            
            parent = parent!.parent;
        }
        
    }
    
    
    public func initFromXIB(_ nibName:String? = nil) {

        let bundle = Bundle(for: base.classForCoder)

        let nib:UINib!;
        if let nibName = nibName {
            nib = UINib(nibName: nibName, bundle: bundle)
        }else{
            var nibName = NSStringFromClass(self.base.classForCoder)
            if let className = nibName.components(separatedBy: ".").last {
                nibName = className
            }

            nib = UINib(nibName: nibName, bundle: bundle)
        }
        nib.instantiate(withOwner: base, options: nil)
    }
}
