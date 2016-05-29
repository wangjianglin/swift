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
    
    private var result:((url:NSURL?)->());
    
    private init(action:((url:NSURL?)->())){
        self.result = action;
    }
    
    @objc private func cameraViewResponse(file: NSURL!) {
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
        self.actionForObjectExist {[weak self] in
            self?.result(url: file);
        }
    }
    
    //-(void)dealloc{
    //    NSLog(@"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    //}
    
}

//@implementation CameraViewController(DelegateAction)

extension CameraViewController{
    
    public func setResult(action:((url:NSURL?)->())){
        
        let delegateAction = __CameraViewControllerDelegateAction(action:action);
        
        self.delegate = delegateAction;
        delegateAction.withObjectSameLifecycle = self;
    }
    
}