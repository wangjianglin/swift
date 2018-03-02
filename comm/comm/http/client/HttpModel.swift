//
//  Model.swift
//  LinComm
//
//  Created by lin on 5/28/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import CessUtil

open class HttpModel : JsonModel{
    
    public var infoStr:[String] = []
    
    required public override init(json: Json){
        super.init(json: json);
        
        self.getPro()
        self.getMethodNames()
    }
    
    public override init(){
        super.init()
        self.getPro()
        self.getMethodNames()
    }
    
    public func getInfoStr() -> [String] {
        return infoStr
    }
    
    private func getPro(){
        var count: UInt32 = 0
        
        let list = class_copyPropertyList(object_getClass(self), &count)
        
        print("类名:\(String(utf8String: object_getClassName(self))!)" + "属性个数:\(count)")
        
        for i in 0..<Int(count) {
            
            let pty = list?[i]
            
            let cName = property_getName(pty!)
            let cType = property_getAttributes(pty!)
            
            let name:String = String(utf8String: cName)!
            let type:String = String(utf8String: cType!)!
            print(name + " type:" +  type)
            
            //Double 属性
            if type.range(of: "Td") != nil{
               
                infoStr.append("===double类型属性：" + name)
                print("===double类型属性：" + name)
                self.doubleGetSet(pName: name)
            }
            //String 属性
            else if type.range(of: "NSString") != nil{
                infoStr.append("===字符串类型属性：" + name)
                print("===字符串类型属性：" + name)
                
            }
            //Int 属性
            else if type.range(of: "Tq") != nil{
                infoStr.append("===Int类型属性：" + name)
                print("===Int类型属性：" + name)
                
            }
            //Bool 属性
            else if type.range(of: "TB") != nil{
                infoStr.append("===Bool类型属性：" + name)
                print("===Bool类型属性：" + name)
                
            }
            //数组类型 属性
            else if type.range(of: "NSArray") != nil{
                infoStr.append("===NSArray类型属性：" + name)
                print("===NSArray类型属性：" + name)
                
            }
            
        }
        free(list) //释放list
    }
    
    func getMethodNames(){
        
        var outCount:UInt32 = 0
        
        let methods =  class_copyMethodList(self.classForCoder, &outCount)
        
        let count:Int = Int(outCount);
        
        
        for i in 0...(count-1) {
            
            let aMet = methods?[i]
            
            //            let imp_f = method_getImplementation(aMet)
            
            print("\(String(utf8String:sel_getName(method_getName(aMet!)))!)")
            
        }
        
    }
    
    func getSetMethodName(pName:String) -> String {
        return "set" + pName.capitalized
    }
    
    //double 设置
    func doubleGetSet(pName:String){
        let getSelector = sel_registerName(pName)
        let getMethod = class_getInstanceMethod(object_getClass(self),getSelector)

        
        let setSelector = sel_registerName(self.getSetMethodName(pName: pName))
        let setMethod = class_getInstanceMethod(object_getClass(self),setSelector)
        
        
//        let m = doubleGet("")
    }
    
    func doubleGet(pName:String) -> (()->Double){
        
       
        return {() in
            self[pName].asDouble();
        }
//        return 0.0
    }

}
