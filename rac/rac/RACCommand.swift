//
//  RAC.swift
//  LinRac
//
//  Created by lin on 7/4/16.
//  Copyright © 2016 lin. All rights reserved.
//

import ReactiveCocoa
import LinCore
import LinUtil
import LinComm


public extension RACCommand{
    
    public func onSuccess(_ action:@escaping ((_:AnyObject?)->())){
        let s = self.executionListener;
        
        var dict = Dictionary<String,AnyObject!>();
        
        self.executionSignals.subscribeNext { (v) in
            if v is RACDynamicSignal {
                let signal = v as! RACDynamicSignal;
                signal.subscribeNext({ (r) in
                    dict["result"] = r;
                })
            }
        }
        
        s.subscribeNext { (v) in
            if v is Int{
                let code = v as! Int;
                if code == 2 {
                    action(dict["result"]);
                }
            }
        }
    }
    
    public func onFault(_ action:((_:NSError?)->())){
        let s = self.executionListener;
        
        s.subscribeNext { (v) in
            if !(v is Int) {
                action(v as? NSError);
            }
        }
    }
    
    public func onExecure(_ action:@escaping (()->())){
        let s = self.executionListener;
        
        s.subscribeNext { (v) in
            if v is Int{
                let code = v as! Int;
                if code == 1 {
                    action();
                }
            }
        }
    }
    
    public func addExecuteOverlayNoErrorMessage(_ view:UIView,message:String = "正在加载数据..."){
        addExecuteOverlayImpl(view,message: message,errorMessage: nil,showError: false);
    }
    public func addExecuteOverlay(_ view:UIView,message:String = "正在加载数据...",errorMessage e:String!=nil){
        addExecuteOverlayImpl(view,message: message,errorMessage: e,showError: true);
    }
    
    fileprivate func addExecuteOverlayImpl(_ view:UIView,message:String = "正在加载数据...",errorMessage e:String!,showError:Bool){
        
        var progressView:MRProgressOverlayView? = MRProgressOverlayView();
        let s = self.executionListener;
        
        s.subscribeNext { (v) in
            if v is Int{
                let code = v as! Int;
                if code == 1 {
                    progressView? = MRProgressOverlayView();
                    progressView?.mode = MRProgressOverlayViewMode.IndeterminateSmallDefault;
                    progressView?.titleLabelText = message;
                    view.addSubview(progressView!);
                    progressView?.show(true);
                }else  if code == 2 {
                    progressView?.dismiss(true);
                }
            }else if showError {
                progressView?.dismiss(true);
                if let e = e {
                    AlertView.show(e);
                }else if v is NSError{
                    let error = v as! NSError;
                    AlertView.show(error.toHttpErrorString())
                }
            }
        }
    }
    
    public var executionListener:RACSignal{
        //        return RACSignal.createSignal({[weak self] (subscriber:RACSubscriber!) -> RACDisposable! in
        //
        //            self?.executionListenerFun(subscriber);
        //            return nil;
        //        })
        
        //        RACSubject *signalOfsignals = [RACSubject subject];
        let signal = RACSubject();
        
        executionListenerFun(signal);
        
        return signal;
    }
    
    fileprivate func executionListenerFun(_ subscriber:RACSubscriber!){
        
        var hasError = false;
        
        self.errors.subscribeNext { (value) in
            var error:NSError!;
            if value is NSError {
                error = value as! NSError;
            }
            hasError = true;
            subscriber.sendNext(error);
        }
        
        self.executing.subscribeNext { (v) in
            if v is Int {
                let value = v as! Int;
                
                if value == 1 {
                    subscriber.sendNext(1);
                }else if value == 0 && !hasError{
                    hasError = false;
                    subscriber.sendNext(2)
                }
            }
        }
        
    }
    
    public func load(_ view:UIView,input: AnyObject! = nil,message:String = "正在加载数据...",errorMessage e:String! = nil)->RACSignal{
        return RACSignal.createSignal({[weak self](subscriber:RACSubscriber!)->RACDisposable! in
            
            self?.executeImpl(view, input: input, message: message, errorMessage: e, subscriber:subscriber);
            return nil;
            });
    }
    
    public func save(_ view:UIView,input: AnyObject! = nil,message:String = "正在保存数据...",errorMessage e:String! = nil)->RACSignal{
        return RACSignal.createSignal({[weak self](subscriber:RACSubscriber!)->RACDisposable! in
            
            self?.executeImpl(view, input: input, message: message, errorMessage: e, subscriber:subscriber);
            return nil;
            });
    }
    
    fileprivate func executeImpl(_ view:UIView,input: AnyObject!,message:String,errorMessage e:String!,subscriber:RACSubscriber!){
        let progressView = MRProgressOverlayView();
        progressView.mode = MRProgressOverlayViewMode.IndeterminateSmallDefault;
        progressView.titleLabelText = message;
        view.addSubview(progressView);
        progressView.show(true);
        
        let s = self.execute(nil);
        s.subscribeNext { (value) in
            subscriber.sendNext(value);
        }
        s.subscribeCompleted {
            progressView.dismiss(true);
            subscriber.sendCompleted();
        }
        s.subscribeError { (error:NSError!) in
            progressView.dismiss(true);
            AlertView.show(error.domain);
            subscriber.sendError(error);
        }
    }
}
