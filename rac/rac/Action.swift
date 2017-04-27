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


private class CocoaActionData<Value>{
    weak var cocoaAction:CocoaAction<Value>?;
}

private func alertMessage(_ vc:UIViewController?,message:String?,title:String?,ok:@escaping ()->(),cancel:@escaping ()->()){
    
    if message == nil {
        ok();
        return;
    }
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
    
    let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel){ _ in
        cancel();
    }
    
    let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default){ _ in
        ok();
    }
    
    alertController.addAction(cancelAction)
    alertController.addAction(okAction)
    
    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
}

extension CocoaAction{
    
    public func addOverlay(_ vc:UIViewController!,message:String = "正在加载数据..."){
        self.setAssociatedValue(value: vc, forKey: "_view_controller", objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        self.setAssociatedValue(value: message,forKey: "_message");
    }
    
    public func show(_ error:Bool){
        self.setAssociatedValue(value: error,forKey: "_show_message_");
    }
    
    public func confirm(_ message:String = "是否确认！",title:String=""){
        self.setAssociatedValue(value: message,forKey: "_confirm_message_");
        self.setAssociatedValue(value: title,forKey: "_confirm_message_title_");
    }
    
    fileprivate convenience init<Output, Error>(_ action: Action<(), Output, Error>,observer:Observer<Bool, NoError>) {
        self.init(action, { _ in })
        self.setAssociatedValue(value: observer, forKey: "_cocoa_action_observer_");
    }
    
    fileprivate convenience init<Input,Error>(_ action: Action<Input, (), Error>,observer:Observer<Bool, NoError>,inputTransform: @escaping (Sender) -> Input) {
        self.init(action, inputTransform)
        self.setAssociatedValue(value: observer, forKey: "_cocoa_action_observer_");
    }
    
    public var enabled:BindingTarget<Bool>{
        return BindingTarget<Bool>(on: UIScheduler(), lifetime: self.reactive.lifetime, action: { (value) in
            if let observer:Observer<Bool, NoError> = self.getAssociatedValue(forKey: "_cocoa_action_observer_"){
                observer.send(value: value);
            }
        })
    }
    
    public var progress:BindingTarget<Float?>{
        self.setAssociatedValue(value: true, forKey: "_is_cocoa_action_progress_view_");
        return BindingTarget<Float?>(on: UIScheduler(), lifetime: self.reactive.lifetime, action: { (value) in
            if let view:MRProgressOverlayView = self.getAssociatedValue(forKey: "_cocoa_action_progress_view_"){
                view.progress = value ?? 0;
            }
        })
    }
    
    public func addComplete(_ action:@escaping ((Any!)->())){
        let a = ActionObj();
        a.action = action;
        self.setAssociatedValue(value: a, forKey: "_cocoa_action_complete_action_");
    }
    
    fileprivate func fireComplete(_ obj:Any!){
        let action:ActionObj? = self.getAssociatedValue(forKey: "_cocoa_action_complete_action_");
        if let action =  action?.action {
            action(obj);
        }
    }
    
}


extension CocoaAction{
    public class func from<Base>(action: @escaping ()->())->CocoaAction<Base> {
        
        let data = CocoaActionData<Base>();
        
        let enabledIf = MutableProperty<Bool>(true);
        var isEnable = true;
        let (signal,observer) = Signal<Bool,NoError>.pipe();
        
        signal.observe({observer in
            if let value = observer.value {
                isEnable = value;
                enabledIf.value = isEnable && enabledIf.value;
            }
        })
        
        let _action = Action<(),(),NSError>(enabledIf: enabledIf){[weak data] () -> SignalProducer<(), NSError> in
            
            let cocoaAction = data?.cocoaAction;
            let vc:UIViewController? = cocoaAction?.getAssociatedValue(forKey: "_view_controller");
            let confirmMessage:String? = cocoaAction?.getAssociatedValue(forKey: "_confirm_message_");
            let confirmMessageTitle:String? = cocoaAction?.getAssociatedValue(forKey: "_confirm_message_title_");
            
            alertMessage(vc,message:confirmMessage,title:confirmMessageTitle,ok:{
                action();
                cocoaAction?.fireComplete(nil);
            },cancel: {
                cocoaAction?.fireComplete(nil);
            });
            
            return SignalProducer.init(value: ());
        }
        
        
        let cocoaAction = CocoaAction<Base>.init(_action,observer:observer);
        data.cocoaAction = cocoaAction;
        cocoaAction.setAssociatedValue(value: data, forKey: "__cocoa_action_from_data__)")
        return cocoaAction;
    }
}
prefix operator ~
prefix public func ~ <Value>(action: @escaping ()->())->CocoaAction<Value> {
    
    return CocoaAction<Value>.from(action: action);
}

private func showMessage<Value>(cocoaAction:CocoaAction<Value>?,obj:Any?,vc:UIViewController?){
    if cocoaAction?.getAssociatedValue(forKey: "_show_message_") != false{
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

private func showOverlayView<Value>(cocoaAction:CocoaAction<Value>?,vc:UIViewController)->MRProgressOverlayView{
    let progressView = MRProgressOverlayView();
    cocoaAction?.setAssociatedValue(value:progressView,forKey: "_cocoa_action_progress_view_");
    let isBar:Bool? = cocoaAction?.getAssociatedValue(forKey: "_is_cocoa_action_progress_view_");
    if isBar == true{
        progressView.mode = MRProgressOverlayViewMode.determinateHorizontalBar;
    }else{
        progressView.mode = MRProgressOverlayViewMode.indeterminateSmallDefault;
    }
    progressView.titleLabelText = cocoaAction?.getAssociatedValue(forKey: "_message");
    vc.view.addSubview(progressView);
    vc.view.bringSubview(toFront: progressView);
    progressView.show(true);
    return progressView;
}

extension CocoaAction{
    
    public class func from<Base,Value>(action: @escaping (Value,@escaping((Any?)->()))->(),inputTransform: @escaping (Base) -> Value)->CocoaAction<Base>{
        
        
        let data = CocoaActionData<Base>();
        
        let enabledIf = MutableProperty<Bool>(true);
        var isEnable = true;
        let (signal,observer) = Signal<Bool,NoError>.pipe();
        
        signal.observe({observer in
            if let value = observer.value {
                isEnable = value;
                enabledIf.value = isEnable && enabledIf.value;
            }
        })
        let _action = Action<Value,(),NSError>(enabledIf: enabledIf) {[weak data] v -> SignalProducer<(), NSError> in
            
            let cocoaAction = data?.cocoaAction;
            let vc:UIViewController? = cocoaAction?.getAssociatedValue(forKey: "_view_controller");
            let confirmMessage:String? = cocoaAction?.getAssociatedValue(forKey: "_confirm_message_");
            let confirmMessageTitle:String? = cocoaAction?.getAssociatedValue(forKey: "_confirm_message_title_");
            
            alertMessage(vc,message:confirmMessage,title:confirmMessageTitle,ok:{
            
                var progressView:MRProgressOverlayView? = nil;
                
                enabledIf.value = false;
                var complete = false;
                action(v,{ (obj) in
                    complete = true;
                    Queue.mainQueue {
                        enabledIf.value = isEnable;
                        progressView?.dismiss(true);
                        progressView?.removeFromSuperview();
                        
                        showMessage(cocoaAction: cocoaAction, obj: obj, vc:vc);
                        cocoaAction?.fireComplete(obj);
                    }
                });
                
                if !complete, let vc = vc {
                    progressView = showOverlayView(cocoaAction: cocoaAction, vc: vc);
                }
            },cancel: {
               cocoaAction?.fireComplete(nil);
            });
            
            return SignalProducer.init(value: ());
        }
        
        let cocoaAction = CocoaAction<Base>.init(_action,observer:observer,inputTransform: inputTransform);
        data.cocoaAction = cocoaAction;
        cocoaAction.setAssociatedValue(value: data, forKey: "__cocoa_action_from2_data__)")
        return cocoaAction;
    }
}


extension CocoaAction{
    
    public class func from<Base>(action: @escaping (@escaping(Any!)->())->())->CocoaAction<Base> {
        
        let data = CocoaActionData<Base>();
        
        let enabledIf = MutableProperty<Bool>(true);
        var isEnable = true;
        let (signal,observer) = Signal<Bool,NoError>.pipe();
        
        signal.observe({observer in
            if let value = observer.value {
                isEnable = value;
                enabledIf.value = isEnable && enabledIf.value;
            }
        })
        let _action = Action<(),(),NSError>(enabledIf: enabledIf) {[weak data]() -> SignalProducer<(), NSError> in
            
            let cocoaAction:CocoaAction<Base>? = data?.cocoaAction;
            let vc:UIViewController? = cocoaAction?.getAssociatedValue(forKey: "_view_controller");
            let confirmMessage:String? = cocoaAction?.getAssociatedValue(forKey: "_confirm_message_");
            let confirmMessageTitle:String? = cocoaAction?.getAssociatedValue(forKey: "_confirm_message_title_");
            
            alertMessage(vc,message:confirmMessage,title:confirmMessageTitle,ok:{
                var progressView:MRProgressOverlayView? = nil;
                
                enabledIf.value = false;
                var complete = false;
                action({ obj in
                    complete = true;
                    Queue.mainQueue {
                        enabledIf.value = isEnable;
                        progressView?.dismiss(true);
                        progressView?.removeFromSuperview();
                        
                        showMessage(cocoaAction: cocoaAction, obj: obj,vc:vc);
                        
                        cocoaAction?.fireComplete(obj);
                    }
                })
                
                if !complete, let vc = vc {
                    progressView = showOverlayView(cocoaAction: cocoaAction, vc: vc);
                }
            },cancel: {
               cocoaAction?.fireComplete(nil);
            });
            
            return SignalProducer.init(value: ());
        }
        
        let cocoaAction = CocoaAction<Base>.init(_action,observer:observer);
        data.cocoaAction = cocoaAction;
        cocoaAction.setAssociatedValue(value: data, forKey: "__cocoa_action_from_data__)")
        return cocoaAction;
    }
}

public prefix func ~ <Value>(action: @escaping (@escaping(Any!)->())->())->CocoaAction<Value> {
    return CocoaAction<Value>.from(action: action);
}

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

fileprivate class ActionObj{
    fileprivate var action:((Any?)->())?;
}

