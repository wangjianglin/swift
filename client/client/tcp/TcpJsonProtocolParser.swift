//
//  TcpJsonProtocolParser.swift
//  LinClient
//
//  Created by lin on 1/22/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


//加入编码信息

public class TcpJsonProtocolParser : TcpAbstractProtocolParser{
    
    public override func parse()->TcpPackage!{
        
        return TcpJsonPackage();
    }
    
    public override class
        var type:UInt8{
            return 6;
    }
}