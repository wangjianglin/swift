//
//  UIControls.swift
//  LinRac
//
//  Created by lin on 20/11/2016.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import CessUtil
import ReactiveCocoa
import ReactiveSwift

extension Reactive where Base: UIControl {
    
    //    public static var touchDown: UIControlEvents { get } // on all touch downs
    public var touchDown:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchUpOutside,key:"_touch_down_action");
        }
        nonmutating set{
            self.setActionForEvent(UIControlEvents.touchUpOutside,action:newValue,key:"_touch_down_action")
        }
    }
    //
    //    public static var touchDownRepeat: UIControlEvents { get } // on multiple touchdowns (tap count > 1)
    public var touchDownRepeat:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchDownRepeat,key:"_touch_down_repeat_action");
        }
        nonmutating set{
            self.setActionForEvent(UIControlEvents.touchDownRepeat,action:newValue,key:"_touch_down_repeat_action")
        }
    }
    //
    //    public static var touchDragInside: UIControlEvents { get }
    public var touchDragInside:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchDragInside,key:"_touch_drag_in_side_action");
        }
        nonmutating set{
            self.setActionForEvent(UIControlEvents.touchDragInside,action:newValue,key:"_touch_drag_in_side_action")
        }
    }
    //
    //    public static var touchDragOutside: UIControlEvents { get }
    public var touchDragOutside:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchDragOutside,key:"_touch_drag_out_side_action");
        }
        nonmutating set{
            self.setActionForEvent(UIControlEvents.touchDragOutside,action:newValue,key:"_touch_drag_out_side_action")
        }
    }
    //
    //    public static var touchDragEnter: UIControlEvents { get }
    public var touchDragEnter:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchDragEnter,key:"_touch_drag_enter_action");
        }
        nonmutating set{
            self.setActionForEvent(UIControlEvents.touchDragEnter,action:newValue,key:"_touch_drag_enter_action")
        }
    }
    //
    //    public static var touchDragExit: UIControlEvents { get }
    public var touchDragExit:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchDragExit,key:"_touch_drag_exit_action");
        }
        nonmutating set{
            self.setActionForEvent(UIControlEvents.touchDragExit,action:newValue,key:"_touch_drag_exit_action")
        }
    }
    //
    //    public static var touchUpInside: UIControlEvents { get }
    public var touchUpInside:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchUpInside,key:"_touch_up_in_side_action");
        }
        nonmutating set{
            self.setActionForEvent(UIControlEvents.touchUpInside,action:newValue,key:"_touch_up_in_side_action")
        }
    }
    //
    //    public static var touchUpOutside: UIControlEvents { get }
    public var touchUpOutside:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchUpOutside,key:"_touch_up_out_side_action");
        }
        nonmutating set{
            self.setActionForEvent(UIControlEvents.touchUpOutside,action:newValue,key:"_touch_up_out_side_action")
        }
    }
    //
    //    public static var touchCancel: UIControlEvents { get }
    public var touchCancel:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchCancel,key:"_touch_cancel_action");
        }
        nonmutating set{
            self.setActionForEvent(UIControlEvents.touchCancel,action:newValue,key:"_touch_cancel_action")
        }
    }
    //
    //
    //    public static var valueChanged: UIControlEvents { get }
    public var valueChanged:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.valueChanged,key:"_touch_value_changed_action");
        }
        nonmutating set{
            self.setActionForEvent(UIControlEvents.valueChanged,action:newValue,key:"_touch_value_changed_action")
        }
    }
    
    @available(iOS 9.0, *)
    public var primaryActionTriggered:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.primaryActionTriggered,key:"_primary_action_triggered_action");
        }
        nonmutating set{
            
            self.setActionForEvent(UIControlEvents.primaryActionTriggered,action:newValue,key:"_primary_action_triggered_action")
        }
    }
    
    
//    public static var editingDidBegin: UIControlEvents { get } // UITextField
    public var editingDidBegin:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.editingDidBegin,key:"_editing_did_begin_action");
        }
        nonmutating set{
            self.setActionForEvent(UIControlEvents.editingDidBegin,action:newValue,key:"_editing_did_begin_action")
        }
    }
    
//    public static var editingChanged: UIControlEvents { get }
    public var editingChanged:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.editingChanged,key:"_editing_changed_action");
        }
        nonmutating set{
            
            self.setActionForEvent(UIControlEvents.editingChanged,action:newValue,key:"_editing_changed_action")
        }
    }
    
//    public static var editingDidEnd: UIControlEvents { get }
    public var editingDidEnd:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.editingDidEnd,key:"_editing_did_end_action");
        }
        nonmutating set{
            
            self.setActionForEvent(UIControlEvents.editingDidEnd,action:newValue,key:"_editing_did_end_action")
        }
    }
    
//    public static var editingDidEndOnExit: UIControlEvents { get } // 'return key' ending editing
    public var editingDidEndOnExit:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.editingDidEndOnExit,key:"_editing_didEnd_on_exit_action");
        }
        nonmutating set{
            self.setActionForEvent(UIControlEvents.editingDidEndOnExit,action:newValue,key:"_editing_didEnd_on_exit_action")
        }
    }
    
    
//    public static var allTouchEvents: UIControlEvents { get } // for touch events
    public var allTouchEvents:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.allTouchEvents,key:"_all_touch_events_action");
        }
        nonmutating set{
            
            self.setActionForEvent(UIControlEvents.allTouchEvents,action:newValue,key:"_all_touch_events_action")
        }
    }
    
//    public static var allEditingEvents: UIControlEvents { get } // for UITextField
    public var allEditingEvents:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.allEditingEvents,key:"_all_editing_events_action");
        }
        nonmutating set{
            self.setActionForEvent(UIControlEvents.allEditingEvents,action:newValue,key:"_all_editing_events_action")
        }
    }
    
//    public static var applicationReserved: UIControlEvents { get } // range available for application use
    public var applicationReserved:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.applicationReserved,key:"_application_reserved_action");
        }
        nonmutating set{
            
            self.setActionForEvent(UIControlEvents.applicationReserved,action:newValue,key:"_application_reserved_action")
        }
    }
    
//    public static var systemReserved: UIControlEvents { get } // range reserved for internal framework use
    public var systemReserved:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.systemReserved,key:"_system_reserved_action");
        }
        nonmutating set{
            
            self.setActionForEvent(UIControlEvents.systemReserved,action:newValue,key:"_system_reserved_action")
        }
    }
    
//    public static var allEvents: UIControlEvents { get }
    public var allEvents:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.allEvents,key:"_value_all_events_action");
        }
        nonmutating set{
            
            self.setActionForEvent(UIControlEvents.allEvents,action:newValue,key:"_value_all_events_action")
        }
    }
    
    
    //    public var touchUpOutside:CocoaAction<Base>?{
    //        get{
    //            let a:(action:CocoaAction<Base>?,scope:ScopedDisposable<CompositeDisposable>)? = base.getAssociatedValue(forKey: "_touch_up_out_side_action");
    //             return a?.action;
    //        }
    //        nonmutating set{
    //
    //            if let action = newValue {
    //                base.addTarget(action, action: CocoaAction<Base>.selector, for: UIControlEvents.touchUpOutside)
    //
    //                let disposable = CompositeDisposable()
    //                disposable += { [weak base = self.base] in
    //                    base?.removeTarget(action, action: CocoaAction<Base>.selector, for: UIControlEvents.touchUpOutside)
    //                }
    //
    //                base.setAssociatedValue(value: (newValue, ScopedDisposable(disposable)), forKey: "_touch_up_out_side_action")
    //            }else{
    //                base.setAssociatedValue(value: nil, forKey: "_touch_up_out_side_action")
    //            }
    //        }
    //    }
//    public var touchUpOutside:CocoaAction<Base>?{
//        get{
//            return self.getActionForEvent(UIControlEvents.touchUpOutside,key:"_touch_up_out_side_action");
//        }
//        nonmutating set{
//            
//            self.setActionForEvent(UIControlEvents.touchUpOutside,action:newValue,key:"_touch_up_out_side_action")
//        }
//    }
    
    fileprivate func getActionForEvent(_ event:UIControlEvents,key:StaticString)->CocoaAction<Base>?{
        let a:(action:CocoaAction<Base>,scope:ScopedDisposable<CompositeDisposable>)? = base.getAssociatedValue(forKey: key);
        return a?.action;
    }
    fileprivate func setActionForEvent(_ event:UIControlEvents,action:CocoaAction<Base>?,key:StaticString){
        if let action = action {
            base.addTarget(action, action: CocoaAction<Base>.selector, for: UIControlEvents.touchUpOutside)
            
            let disposable = CompositeDisposable()
            disposable += { [weak base = self.base] in
                base?.removeTarget(action, action: CocoaAction<Base>.selector, for: UIControlEvents.touchUpOutside)
            }
            
            base.setAssociatedValue(value: (action, ScopedDisposable(disposable)), forKey: key)
        }else{
            base.setAssociatedValue(value: nil, forKey: key)
        }
    }
    //    private func setEventAction(_ event:UIControlEvents,action:CocoaAction<Base>?){
    //        let s = self.trigger(for: event);
    ////        let action:CocoaAction<()>? = nil;
    ////        base.setAssociatedValue(value: Any!, forKey: StaticString)
    //        s.observe({[weak base,action] observe in
    //            if let sender = base {
    //                action?.execute(sender);
    //            }
    //        });
    //    }
}
