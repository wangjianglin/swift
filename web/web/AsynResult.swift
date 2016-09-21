//
//  AsynResult.swift
//  LinWeb
//
//  Created by lin on 9/18/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import LinUtil
//@interface AsynResult:NSObject
//
//
//-(void)setResult:(Json*)result;
//
//@end

public class AsynResult:NSObject {
    
//    public var result:Any?{
//        didSet{
//            set.set();
//        }
//    }
    
    
//    @interface AsynResult(){
//    Json * _result;
//    //    NSLock * lock;
//    AutoResetEvent * set;
//    }
    
    private var set:AutoResetEvent = AutoResetEvent();
    private var _result:Any?;
    
//    -(void)setWeb:(LinWebURLProtocol*)web;
//    -(NSString*)waitResult;
//    
//    @end
//    
//    @implementation AsynResult
//    
//    -(instancetype)init{
//        self = [super init];
//        if(self){
//            //        lock = [[NSLock alloc] init];
//            set = [[AutoResetEvent alloc] init];
//        }
//        return self;
//    }
    
    internal func waitResult()->Any?{
        set.waitOne();
//        if let result = self.result {
//            return result.description;
//        }
        return _result;
    }
    
//    -(NSString*)waitResult{
//    [set waitOne];
//    if (_result != nil) {
//    return [_result description];
//    }
//    return nil;
//    }
    
//    -(void)setResult:(Json *)result{
//    _result = result;
//    [set set];
//    }
    public func setResult(_ result:Any? = nil){
        _result = result;
        set.set();
    }
    
//    
//    @end
    
}
