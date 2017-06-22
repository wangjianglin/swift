//
//  CameraViewController.swift
//  LinCore
//
//  Created by lin on 5/27/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import LinUtil


//@interface CameraViewControllerDelegateAction : DelegateAction<CameraViewDelegate>{
//    void (^result)(NSURL *);
//}
//-(id)initWithAction:(void(^)(NSURL*))action;
////-(void)action:(NSObject*)sender;
//@end

private class __CameraViewControllerDelegateAction : DelegateAction,CameraViewDelegate {
    
    fileprivate var result:((_ url:URL?)->());
    
    fileprivate init(action:@escaping ((_ url:URL?)->())){
        self.result = action;
    }
    
    @objc fileprivate func cameraViewResponse(_ file: URL!) {
        //
        //
        //    - (void)cameraViewResponse:(NSURL*)file{
        //-(void)action:(NSObject*)sender{
        //        if (result == nil) {
        //            return;
        //        }
        //        [self actionForObjectExist:^{
        //            result(file);
        //            }];
//        self.actionForObjectExist {[weak self] in
            self.result(file);
//        }
    }
    
    //-(void)dealloc{
    //    NSLog(@"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    //}
    
}

//@implementation CameraViewController(DelegateAction)

extension CameraViewController{
    
    
    
    
    public func setResult(_ action:@escaping ((_ url:URL?)->())){
        
        let delegateAction = __CameraViewControllerDelegateAction(action:action);
        
        self.delegate = delegateAction;
        delegateAction.ext.withObjectSameLifecycle = self;
    }
    
}
