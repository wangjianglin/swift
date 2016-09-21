//
//  HttpModel.swift
//  LinClient
//
//  Created by lin on 1/13/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation

open class JsonModel : NSObject{
    
    fileprivate var _json:Json;
    open var json:Json{
        return _json;
    }
    
    public init(json:Json){
        self._json = json;
    }
    
    public override init(){
        self._json = Json();
    }
    
    open func assign(_ mode:JsonModel){
        self._json = mode._json;
    }
    
//    deinit {
//        //执行析构
//        println("Json Model deinit.");
//    }
    
    open override var description:String { return self._json.description; }
    
}

extension JsonModel{
    
//    public func asObject<T:JsonModel>(name:String)->T?{
//        var json = self._json[name];
//        if json.isError || json.isNull {
//            return nil;
//        }
//        return T(json: self._json[name]);
//    }
    
//    public func asArray<T:JsonModel>(name:String)->[T]{
//        
//        var result = [T]();
//        if let array = self._json.asArray {
//            for item in array {
//                result.append(T(json: item));
//            }
//        }
//        return result;
//    }
    
    public subscript(name:String) -> Json {
        get { return self._json[name];}
        set { self.json[name] = newValue;}
    }
    
//    public func setValue(name:String,value:AnyObject?){
    public func setValue(_ value:AnyObject?,forName name:String){
        if value is JsonModel {
            self._json.setValue((value as! JsonModel)._json, forName: name);
        }else{
            self._json.setValue(value, forName: name);
        }
    }
    
    public func setIntValue(_ value:Int,forName name:String){
        self._json.setIntValue(value, forName: name);
    }
    
    public func setBoolValue(_ value:Bool,forName name:String){
        self._json.setBoolValue(value, forName: name);
    }
    
    public func setDoubleValue(_ value:Double,forName name:String){
        self._json.setDoubleValue(value, forName:name);
    }
    public func getValue(_ name:String)->Any?{
        return self._json.getValue(name);
    }
    
}
