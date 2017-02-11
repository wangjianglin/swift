//
//  RAC.swift
//  LinRac
//
//  Created by lin on 7/4/16.
//  Copyright © 2016 lin. All rights reserved.
//

import ReactiveSwift
import LinCore
import LinUtil
import LinComm
import ReactiveCocoa
import ReactiveSwift
import Result

extension CocoaAction{
    public func addOverlay(_ vc:UIViewController!,message:String = "正在加载数据..."){
        self.setAssociatedValue(value: vc,forKey: "_view_controller");
        self.setAssociatedValue(value: message,forKey: "_message");
    }
    
    public func show(_ error:Bool){
        self.setAssociatedValue(value: error,forKey: "_show_message_");
    }
    
    fileprivate convenience init<Output, Error>(_ action: Action<(), Output, Error>,observer:Observer<Bool, NoError>) {
        self.init(action, { _ in })
        //        signal.observe(Observer<Any, NoError>)
        self.setAssociatedValue(value: observer, forKey: "_cocoa_action_observer_");
        //        self.isEnabled
        //        self.isEnabled
    }
    
    public var addEnabled:BindingTarget<Bool>{
        return BindingTarget<Bool>(on: UIScheduler(), lifetime: self.reactive.lifetime, setter: { (value) in
            if let observer:Observer<Bool, NoError> = self.getAssociatedValue(forKey: "_cocoa_action_observer_"){
                observer.send(value: value);
            }
        })
    }
}


prefix operator ~
prefix public func ~ <Value>(action: @escaping ()->())->CocoaAction<Value> {
    
    var cocoaAction:CocoaAction<Value>! = nil;
    
    let action = Action<(), (), NSError>.init { () -> SignalProducer<(), NSError> in
        action();
        return SignalProducer.init(value: ());
    }
    
    cocoaAction = CocoaAction<Value>.init(action);
    return cocoaAction;
}

public prefix func ~ <Value>(action: @escaping (@escaping(Any!)->())->())->CocoaAction<Value> {
    
    var cocoaAction:CocoaAction<Value>! = nil;
    
    let enabledIf = MutableProperty<Bool>(true);
    var isEnable = true;
    let (signal,observer) = Signal<Bool,NoError>.pipe();
    
    signal.observe({observer in
        if let value = observer.value {
            isEnable = value;
            enabledIf.value = isEnable && enabledIf.value;
        }
    })
    let _action = Action<(),(),NSError>(enabledIf: enabledIf) { () -> SignalProducer<(), NSError> in
        
        let vc:UIViewController? = cocoaAction.getAssociatedValue(forKey: "_view_controller");
        var progressView:MRProgressOverlayView? = nil;
        if let vc = vc {
            progressView = MRProgressOverlayView();
            progressView?.mode = MRProgressOverlayViewMode.indeterminateSmallDefault;
            progressView?.titleLabelText = cocoaAction.getAssociatedValue(forKey: "_message");
            vc.view.addSubview(progressView!);
            progressView?.show(true);
        }
        
        enabledIf.value = false;
        action({ obj in
            Queue.mainQueue {
                enabledIf.value = isEnable;
                progressView?.dismiss(true);
                
                if cocoaAction.getAssociatedValue(forKey: "_show_message_") != false{
                    switch obj {
                    case let error as HttpError:
                        if let vc = vc {
                            UIAlertController.showAlert(vc: vc, title: "", message: error.description);
                        }
                        break;
                    case let str as String:
                        if let vc = vc {
                            UIAlertController.showAlert(vc: vc, title: "", message: str);
                        }
                        break;
                    case let str as NSString:
                        if let vc = vc {
                            UIAlertController.showAlert(vc: vc, title: "", message: str as String);
                        }
                        break;
                    default:
                        break;
                    }
                }
            }
        })
        return SignalProducer.init(value: ());
    }
    
    cocoaAction = CocoaAction<Value>.init(_action,observer:observer);
    
    return cocoaAction;
}


//precedencegroup BindingPrecedence {
//    associativity: right
//
//    // Binds tighter than assignment but looser than everything else
//    higherThan: AssignmentPrecedence
//}
//
//infix operator <~ : BindingPrecedence

public func <~ <Value:ReactiveExtensionsProvider>(target: Value?, action: @escaping (()->()))
    where Value: UIButton{
        target?.reactive.pressed = ~action;
}
public func <~ <Value:ReactiveExtensionsProvider>(target: Value?, action: @escaping ((@escaping(Any!)->())->()))
    where Value: UIButton {
        
        target?.reactive.pressed = ~action;
}

public func <~ <Value:ReactiveExtensionsProvider>(target: Value?, action: @escaping ((@escaping(Any!)->())->()))
    where Value: UIBarButtonItem {
        target?.reactive.pressed = ~action;
}

public func <~ <Value:ReactiveExtensionsProvider>(target: Value?, action: @escaping (()->()))
    where Value: UIBarButtonItem {
        target?.reactive.pressed = ~action;
}

public func <~ <Value>(action: @escaping ((Value!)->()),signal: Signal<Value, NoError>?) {
    if let signal = signal {
        signal.observe({ event in
            switch event{
            case let .value(value):
                action(value);
                break;
            default:
                break;
            }
            
        })
    }
}
public func <~ (action: @escaping (()->()),signal: Signal<(), NoError>?) {
    if let signal = signal {
        signal.observe({ event in
        switch event{
            case .value(_):
                action();
                break;
            default:
                break;
            }
            
        })
    }
}


//public extension Action{
//
//    public func onSuccess(_ action:@escaping ((_:AnyObject?)->())){
//        let s = self.executionListener;
//
//        var dict = Dictionary<String,AnyObject!>();
//
////        self.
//        self.executionSignals.subscribeNext { (v) in
//            if v is RACDynamicSignal {
//                let signal = v as! RACDynamicSignal;
//                signal.subscribeNext({ (r) in
//                    dict["result"] = r;
//                })
//            }
//        }
//
//        s.subscribeNext { (v) in
//            if v is Int{
//                let code = v as! Int;
//                if code == 2 {
//                    action(dict["result"]);
//                }
//            }
//        }
//    }
//
//    public func onFault(_ action:((_:NSError?)->())){
//        let s = self.executionListener;
//
//        s.subscribeNext { (v) in
//            if !(v is Int) {
//                action(v as? NSError);
//            }
//        }
//    }
//
//    public func onExecure(_ action:@escaping (()->())){
//        let s = self.executionListener;
//
//        s.subscribeNext { (v) in
//            if v is Int{
//                let code = v as! Int;
//                if code == 1 {
//                    action();
//                }
//            }
//        }
//    }
//
//    public func addExecuteOverlayNoErrorMessage(_ view:UIView,message:String = "正在加载数据..."){
//        addExecuteOverlayImpl(view,message: message,errorMessage: nil,showError: false);
//    }
//    public func addExecuteOverlay(_ view:UIView,message:String = "正在加载数据...",errorMessage e:String!=nil){
//        addExecuteOverlayImpl(view,message: message,errorMessage: e,showError: true);
//    }
//
//    fileprivate func addExecuteOverlayImpl(_ view:UIView,message:String = "正在加载数据...",errorMessage e:String!,showError:Bool){
//
//        var progressView:MRProgressOverlayView? = MRProgressOverlayView();
//        let s = self.executionListener;
//
//        s.subscribeNext { (v) in
//            if v is Int{
//                let code = v as! Int;
//                if code == 1 {
//                    progressView? = MRProgressOverlayView();
//                    progressView?.mode = MRProgressOverlayViewMode.IndeterminateSmallDefault;
//                    progressView?.titleLabelText = message;
//                    view.addSubview(progressView!);
//                    progressView?.show(true);
//                }else  if code == 2 {
//                    progressView?.dismiss(true);
//                }
//            }else if showError {
//                progressView?.dismiss(true);
//                if let e = e {
//                    AlertView.show(e);
//                }else if v is NSError{
//                    let error = v as! NSError;
//                    AlertView.show(error.toHttpErrorString())
//                }
//            }
//        }
//    }
//
//    public var executionListener:RACSignal{
//        //        return RACSignal.createSignal({[weak self] (subscriber:RACSubscriber!) -> RACDisposable! in
//        //
//        //            self?.executionListenerFun(subscriber);
//        //            return nil;
//        //        })
//
//        //        RACSubject *signalOfsignals = [RACSubject subject];
//        let signal = RACSubject();
//
//        executionListenerFun(signal);
//
//        return signal;
//    }
//
//    fileprivate func executionListenerFun(_ subscriber:RACSubscriber!){
//
//        var hasError = false;
//
//        self.errors.subscribeNext { (value) in
//            var error:NSError!;
//            if value is NSError {
//                error = value as! NSError;
//            }
//            hasError = true;
//            subscriber.sendNext(error);
//        }
//
//        self.executing.subscribeNext { (v) in
//            if v is Int {
//                let value = v as! Int;
//
//                if value == 1 {
//                    subscriber.sendNext(1);
//                }else if value == 0 && !hasError{
//                    hasError = false;
//                    subscriber.sendNext(2)
//                }
//            }
//        }
//
//    }
//
//    public func load(_ view:UIView,input: AnyObject! = nil,message:String = "正在加载数据...",errorMessage e:String! = nil)->RACSignal{
//        return RACSignal.createSignal({[weak self](subscriber:RACSubscriber!)->RACDisposable! in
//
//            self?.executeImpl(view, input: input, message: message, errorMessage: e, subscriber:subscriber);
//            return nil;
//            });
//    }
//
//    public func save(_ view:UIView,input: AnyObject! = nil,message:String = "正在保存数据...",errorMessage e:String! = nil)->RACSignal{
//        return RACSignal.createSignal({[weak self](subscriber:RACSubscriber!)->RACDisposable! in
//
//            self?.executeImpl(view, input: input, message: message, errorMessage: e, subscriber:subscriber);
//            return nil;
//            });
//    }
//
//    fileprivate func executeImpl(_ view:UIView,input: AnyObject!,message:String,errorMessage e:String!,subscriber:RACSubscriber!){
//        let progressView = MRProgressOverlayView();
//        progressView.mode = MRProgressOverlayViewMode.IndeterminateSmallDefault;
//        progressView.titleLabelText = message;
//        view.addSubview(progressView);
//        progressView.show(true);
//
//        let s = self.execute(nil);
//        s.subscribeNext { (value) in
//            subscriber.sendNext(value);
//        }
//        s.subscribeCompleted {
//            progressView.dismiss(true);
//            subscriber.sendCompleted();
//        }
//        s.subscribeError { (error:NSError!) in
//            progressView.dismiss(true);
//            AlertView.show(error.domain);
//            subscriber.sendError(error);
//        }
//    }
//}
