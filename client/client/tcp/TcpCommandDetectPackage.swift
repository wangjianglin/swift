//
//  TcpCommandDetectPackage.swift
//  LinClient
//
//  Created by lin on 1/23/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


//@objc
public class TcpCommandDetectPackage : TcpCommandRequestPackage{
    
    override public class var command:Int32{
        return 0x1;
    }
    
    
    public override class var resp:TcpResponsePackage.Type{
        return TcpCommandDetectResponsePackage.self;
    }
    
}