//
//  TcpRespPackage.swift
//  LinClient
//
//  Created by lin on 1/27/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation

public class TcpResponsePackage : TcpAbstractPackage{
    
    public final override class var state:TcpPackageState{
        return TcpPackageState.RESPONSE;
    }
    
    
    public required override init() {
        
    }
}