//
//  TcpAbstractCommunicate.swift
//  LinClient
//
//  Created by lin on 1/21/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


public class TcpAbstractCommunicate: TcpCommunicate{
    public var mainThread:Bool = false;
    
    public func send(pack: TcpPackage)->TcpPackageResponse {
        return TcpPackageResponse();
    }
    
    public func close() {
        
    }
    
    public func start() -> Bool {
        return false;
    }
    
}