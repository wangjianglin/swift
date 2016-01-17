//
//  HttpCommunicateResult.swift
//  LinClient
//
//  Created by lin on 12/1/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation
#if !iOS7
import LinUtil
#endif

public class HttpCommunicateResult {
    
    private var _r:Bool = false;
    internal var set:AutoResetEvent?;
    
    internal init(){}
    
    public func abort(){
    
    }
    
    public func waitForEnd(){
        if let set = self.set{
            set.waitOne();
        }
    }
    
    
    public var isSuccess:Bool{
        get{
            self.waitForEnd();
            return self._r;
        }
    }
    internal func setResult(result:Bool){
        self._r = result;
    }
    
}