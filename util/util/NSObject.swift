//
//  NSObject.swift
//  LinUtil
//
//  Created by lin on 20/11/2016.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation

extension NSObject {
    @nonobjc internal final func sync<Result>(execute: () throws -> Result) rethrows -> Result {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        return try execute()
    }
    
    //    @objc(class)
    //    var objcClass: AnyClass! { get }
}

@objc internal protocol ObjCClassReporting {
    // An alias for `-class`, which is unavailable in Swift.
    @objc(class)
    var objClass: AnyClass! { get }
}

internal func sync<Result>(_ token: AnyObject, execute: () throws -> Result) rethrows -> Result {
    objc_sync_enter(token)
    defer { objc_sync_exit(token) }
    return try execute()
}

public typealias KeyAddr = UnsafeRawPointer!;

extension NSObject{
    public func setAssociatedValue(value:Any!,forKey key: StaticString, _ policy: objc_AssociationPolicy) {
        setAssociatedValue(value: value, forAddress: key.utf8Start, policy);
    }
    public func setAssociatedValue(value:Any!,forKey key: StaticString) {
        setAssociatedValue(value: value, forAddress: key.utf8Start);
    }
    public func setAssociatedValue(value:Any!,forAddress key: KeyAddr) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
    public func setAssociatedValue(value:Any!,forAddress key: KeyAddr, _ policy: objc_AssociationPolicy) {
        objc_setAssociatedObject(self, key, value, policy);
    }
    public func getAssociatedValue<T>(forKey key: StaticString)->T! {
        return getAssociatedValue(forAddress:key.utf8Start);
    }
    public func getAssociatedValue<T>(forAddress key: KeyAddr)->T! {
        let value = objc_getAssociatedObject(self, key) as! T?
        //        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN)
        if let value = value {
            return value;
        }
        return nil;
    }
}

public protocol ExtProvider : class {
}
extension NSObject: ExtProvider {}


public struct Ext<Base : NSObject> {
    public let base: Base
    
    fileprivate init(_ base: Base) {
        self.base = base
    }
}


extension ExtProvider where Self : NSObject  {
    /// A proxy which hosts reactive extensions for `self`.
    public var ext: Ext<Self> {
        return Ext(self)
    }
}

//extension ViewModelStruct where Base: ReactiveExtensionsProvider {

/// Holds the `Lifetime` of the object.
//fileprivate let isSwizzledKey = AssociationKey<Bool>(default: false)
//
///// Holds the `Lifetime` of the object.
fileprivate let lifetimeKey = "AssociationKey<Lifetime?>(default: nil)";
//
///// Holds the `Lifetime.Token` of the object.
//fileprivate let lifetimeTokenKey = AssociationKey<Lifetime.Token?>(default: nil)

//extension Reactive where Base: NSObject {
extension Ext where Base: NSObject {
    //    /// Returns a lifetime that ends when the object is deallocated.
    @nonobjc public var lifetime: Lifetime {
        objc_sync_enter(self);
        
        return base.sync {
            if let lifetime:Lifetime = base.getAssociatedValue(forKey: "lifetimeKey") {
                return lifetime
            }
            //
            let token = Lifetime.Token()
            let lifetime = Lifetime(token)
            //
            let objcClass: AnyClass = (base as AnyObject).objClass
            let obj = objcClass as AnyObject;
            //            let objcClassAssociations = Associations(objcClass as AnyObject)
            //
            let deallocSelector = sel_registerName("dealloc")!
            //
            //            // Swizzle `-dealloc` so that the lifetime token is released at the
            //            // beginning of the deallocation chain, and only after the KVO `-dealloc`.
            sync(objcClass) {
                //                // Swizzle the class only if it has not been swizzled before.
                if objc_getAssociatedObject(obj,"isSwizzledKey") as? Bool != true{
                    objc_setAssociatedObject(obj,"isSwizzledKey",true,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    
                    var existingImpl: IMP? = nil
                    
                    let newImplBlock: @convention(block) (UnsafeRawPointer) -> Void = { objectRef in
                        // A custom trampoline of `objc_setAssociatedObject` is used, since
                        // the imported version has been inserted with ARC calls that would
                        // mess with the object deallocation chain.
                        
                        
                        rac_objc_setAssociatedObject(objectRef, "lifetimeTokenKey", nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                        
                        let impl: IMP
                        
                        // Call the existing implementation if one has been caught. Otherwise,
                        // call the one first available in the superclass hierarchy.
                        if let existingImpl = existingImpl {
                            impl = existingImpl
                        } else {
                            let superclass: AnyClass = class_getSuperclass(objcClass)
                            impl = class_getMethodImplementation(superclass, deallocSelector)
                        }
                        
                        typealias Impl = @convention(c) (UnsafeRawPointer, Selector) -> Void
                        unsafeBitCast(impl, to: Impl.self)(objectRef, deallocSelector)
                    }
                    
                    let newImpl =  imp_implementationWithBlock(newImplBlock as Any)
                    
                    if !class_addMethod(objcClass, deallocSelector, newImpl, "v@:") {
                        // The class has an existing `dealloc`. Preserve that as `existingImpl`.
                        let deallocMethod = class_getInstanceMethod(objcClass, deallocSelector)
                        
                        // Store the existing implementation to `existingImpl` to ensure it is
                        // available before our version is swapped in.
                        existingImpl = method_getImplementation(deallocMethod)
                        
                        // Store the swapped-out implementation to `existingImpl` in case
                        // the implementation has been changed concurrently.
                        existingImpl = method_setImplementation(deallocMethod, newImpl)
                    }
                    
                }
                
            }
            //
            base.setAssociatedValue(value: token, forKey: "lifetimeTokenKey");
            base.setAssociatedValue(value: lifetime, forKey: "lifetimeKey")
            //
            return lifetime
        }
    }
}

extension Ext where Base: NSObject{
    public weak var withObjectSameLifecycle:NSObject? {
        nonmutating set{
            if let withObjectSameLifecycle = newValue {
                var w:[String:NSObject]? = withObjectSameLifecycle.getAssociatedValue(forKey: "__delegate_action_dict_value__");
                if w == nil {
                    w = [:];
                }
                w?["__delegate_action\(base.hashValue)"] = base;
                withObjectSameLifecycle.setAssociatedValue(value: w, forKey: "__delegate_action_dict_value__");
            }
        }
        get{
            return nil;
        }
    }
}
