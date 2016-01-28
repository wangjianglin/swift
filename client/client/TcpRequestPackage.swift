//
//  TcpRequestPackage.swift
//  LinClient
//
//  Created by lin on 1/27/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation

public class TcpRequestPackage : TcpAbstractPackage{
    
    public final override class var state:TcpPackageState{
        return TcpPackageState.REQUEST;
    }

    public class var resp:TcpResponsePackage.Type{
        return TcpResponsePackage.self;
    }

    public final var resp:TcpResponsePackage.Type{
        return (Mirror(reflecting: self).subjectType as! TcpRequestPackage.Type).resp;
    }
    
    public required override init(){
    }
}