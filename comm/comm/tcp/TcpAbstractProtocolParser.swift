//
//  TcpAbstractProtocolParser.swift
//  LinClient
//
//  Created by lin on 1/26/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation

open class TcpAbstractProtocolParser:TcpProtocolParser{
    required public init(){
        //fatalError("can't init.")
    }
    open class
        var type:UInt8{
            return 255;
    }
    
    
    public final var state:TcpPackageState = TcpPackageState.request;
    
    //已经读取的数据个数
    fileprivate var packageSize:Int = 0;
    //packageBody的大小、
    fileprivate var maxPackageSize:Int = 100;
    //存储消息，包括消息头体
    fileprivate var packageBody = [UInt8](repeating: 0, count: 100);
    
    open var buffer:[UInt8]{
        return packageBody;
    }
    
    open var size:Int{
        return packageSize;
    }
    
    open func parse()->TcpPackage!{
        
        return nil;
    }

    open func put(_ bs:UInt8...){
        if(packageSize + bs.count > maxPackageSize){
            var newPackageBody = [UInt8](repeating: 0, count: maxPackageSize + 100);
            for n in 0 ..< packageSize {
                newPackageBody[n] = packageBody[n];
            }
            packageBody = newPackageBody;
            maxPackageSize += 100;
        }
        
        for n in 0 ..< bs.count {
            packageBody[packageSize + n] = bs[n]
        }
        
        packageSize += bs.count;
        
    }
    
    open func clear(){
        packageSize = 0;
    }
}
