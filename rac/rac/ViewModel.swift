//
//  ViewModel.swift
//  LinRac
//
//  Created by lin on 20/11/2016.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result
import LinComm

public protocol BaseView : class{
    
}

public struct ViewModelStruct<Base : NSObject> {
    public let base: Base
    
    fileprivate init(_ base: Base) {
        self.base = base
    }
}
//
public protocol ViewModel : class {
    associatedtype ViewType:BaseView
    func start();
}

extension ViewModel where Self : NSObject  {
    /// A proxy which hosts reactive extensions for `self`.
    public var bind: ViewModelStruct<Self> {
        return ViewModelStruct(self)
    }
    
    public weak var view:ViewType?{
        set{
            self.setAssociatedValue(value: newValue, forKey: "_view_model_view_obj_",.OBJC_ASSOCIATION_ASSIGN);
        }
        get{
            return self.getAssociatedValue(forKey: "_view_model_view_obj_");
        }
    }
    
}

extension ViewModelStruct where Base: ReactiveExtensionsProvider {
    //    public func producer<Value>(keyPath:String)->SignalProducer<Value?, NoError>{
    //        return DynamicProperty.init(object: base, keyPath: keyPath).producer;
    //    }
    public func changed(keyPath:String)->Signal<(), NoError>{
        
        let p = DynamicProperty<Any?>.init(object: base, keyPath: keyPath);
        let (signal,observer) = Signal<(),NoError>.pipe();
        p.signal.observe({event in
            switch event {
            case .value(_):
                observer.send(value: ());
                break;
            case .completed:
                observer.sendCompleted();
                break;
            case let .failed(error):
                observer.send(error: error);
                break;
            case .interrupted:
                observer.sendInterrupted();
                break;
            }
            
        });
        
        return signal;
        //        return SignalProducer<(),NoError>(signal);
    }
    public func property<Value>(keyPath:String)->DynamicProperty<Value>{
        return DynamicProperty.init(object: base, keyPath: keyPath);
    }
    
    public func target<Value>(keyPath:String)->BindingTarget<Value>{
        return BindingTarget<Value>(on:UIScheduler(),lifetime:base.reactive.lifetime){[weak base] value in
            let oldValue = base?.value(forKey: keyPath);
            if(oldValue == nil){
                return;
            }
            
            
            let _v:_OptionalNilComparisonType? = value as?  _OptionalNilComparisonType;
            if(_v != nil && oldValue == _v!){
                return;
            }
            let ov:NSObjectProtocol? = value as? NSObjectProtocol;
            if(ov?.isEqual(oldValue) == true){
                return;
            }
            
            base?.setValue(value, forKey: keyPath);
        }
    }
    
    public func set<Value>(keyPath:String,ofSignal signal:Signal<Value, NoError>?){
        //        self.target(keyPath: keyPath) <~ signal;
        if let signal = signal {
            DynamicProperty.init(object: base, keyPath: keyPath) <~ SignalProducer<Value,NoError>(signal)
        }
    }
    
    
    public func action<Value>(_ action:@escaping (()->()))->CocoaAction<Value>{
        let a = Action<(), (), NSError>.init { () -> SignalProducer<(), NSError> in
            action();
            return SignalProducer.init(value: ());
        }
        return CocoaAction<Value>.init(a)
    }
}
public func <~ (target: @escaping (Any?)->(), result: HttpCommunicateResult) {
    
    result.onSuccess { (obj) in
        target(nil);
    }
    result.onFault { (error) in
        target(error);
    }
}

