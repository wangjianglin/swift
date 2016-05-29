//
//  UIViewControllers.swift
//  LinCore
//
//  Created by lin on 5/28/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import LinUtil


extension UIViewController{
    
    //@implementation UIViewController (UIViewControllers)
    
    
    public func performUnwindSegueWithAction(action:String, sender:AnyObject!){
        //    - (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender
        
        
        //    SEL select = @selector(viewControllerForUnwindAction:fromViewController:withSender:);
                let selector = NSSelectorFromString(action);
//        let selector = #selector(self.viewControllerForUnwindSegueAction(_:fromViewController:withSender:));
        
        var parent = self.parentViewController;
        while parent != nil {
//            if parent!.respondsToSelector(selector) {
            if parent! is UIViewController {
                
                let vc = parent! as UIViewController;
                let obj = vc.viewControllerForUnwindSegueAction(selector, fromViewController: self, withSender: nil);
                //            NSLog(@"ok.");
                //            NSMutableArray * objs = @[action,self,sender];
                //            NSMutableArray * objs = [[NSMutableArray alloc] init];
//                let objs = [action,self,sender];
//                //            if action == nil {
//                //                objs addObject:@""];
//                //            }else{
//                //                [objs addObject:action];
//                //            }
//                //            [objs addObject:self];
//                //            if (sender == nil) {
//                //                [objs addObject:[NSNull null]];
//                //            }else{
//                //                [objs addObject:sender];
//                //            }
//                
//                //            id obj = parent performSelector:select withObjects:objs];
//                
//                let obj = parent!.performSelector(selector,withObjects:objs);
                
                if let obj = obj {
                    self.navigationController?.presentViewController(obj, animated:true, completion:nil);
                    
                    break;
                }
            }
            parent = parent!.parentViewController;
        }
        //    self performSelector:(SEL) withObject:(id) withObject:(id)
        //    self per
    }
}
