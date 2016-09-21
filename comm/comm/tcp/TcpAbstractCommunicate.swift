//
//  TcpAbstractCommunicate.swift
//  LinClient
//
//  Created by lin on 1/21/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


open class TcpAbstractCommunicate: TcpCommunicate{
    open var mainThread:Bool = false;
    
    open func send(_ pack: TcpRequestPackage)->TcpPackageResponse {
        return TcpPackageResponse();
    }
    
    public init(){
        //fatalError("init() has not been implemented")
    }
    
    open func close() {
        
    }
    
    open func start() -> Bool {
        return false;
    }
    
}
