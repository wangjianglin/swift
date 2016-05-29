//
//  TcpAbstractProtocolParser.swift
//  LinClient
//
//  Created by lin on 1/26/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation

public class TcpAbstractProtocolParser:TcpProtocolParser{
    required public init(){
        //fatalError("can't init.")
    }
    public class
        var type:UInt8{
            return 255;
    }
    
    
    public final var state:TcpPackageState = TcpPackageState.REQUEST;
    
    //已经读取的数据个数
    private var packageSize:Int = 0;
    //packageBody的大小、
    private var maxPackageSize:Int = 100;
    //存储消息，包括消息头体
    private var packageBody = [UInt8](count: 100, repeatedValue: 0);
    
    public var buffer:[UInt8]{
        return packageBody;
    }
    
    public var size:Int{
        return packageSize;
    }
    
    public func parse()->TcpPackage!{
        
        return nil;
    }

    public func put(bs:UInt8...){
        if(packageSize + bs.count > maxPackageSize){
            var newPackageBody = [UInt8](count: maxPackageSize + 100, repeatedValue: 0);
            for(var n=0;n<packageSize;n++){
                newPackageBody[n] = packageBody[n];
            }
            packageBody = newPackageBody;
            maxPackageSize += 100;
        }
        
        for(var n=0;n<bs.count;n++){
            packageBody[packageSize + n] = bs[n]
        }
        
        packageSize += bs.count;
        
    }
    
    public func clear(){
        packageSize = 0;
    }
}