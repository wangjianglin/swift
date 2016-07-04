//
//  HttpModel.swift
//  LinClient
//
//  Created by lin on 1/13/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation

public class JsonModel : NSObject{
    
    private var _json:Json;
    public var json:Json{
        return _json;
    }
    
    public init(json:Json){
        self._json = json;
    }
    
    public override init(){
        self._json = Json();
    }
    
    public func assign(mode:JsonModel){
        self._json = mode._json;
    }
    
//    deinit {
//        //执行析构
//        println("Json Model deinit.");
//    }
    
    public override var description:String { return self._json.description; }
    
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
    public func setValue(value:AnyObject?,forName name:String){
        if value is JsonModel {
            self._json.setValue((value as! JsonModel)._json, forName: name);
        }else{
            self._json.setValue(value, forName: name);
        }
    }
    
    public func setIntValue(value:Int,forName name:String){
        self._json.setIntValue(value, forName: name);
    }
    
    public func setBoolValue(value:Bool,forName name:String){
        self._json.setBoolValue(value, forName: name);
    }
    
    public func setDoubleValue(value:Double,forName name:String){
        self._json.setDoubleValue(value, forName:name);
    }
    public func getValue(name:String)->AnyObject?{
        return self._json.getValue(name);
    }
    
}
