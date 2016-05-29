//
//  EmptyProtocolParser.swift
//  LinClient
//
//  Created by lin on 1/26/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


public class TcpEmptyPackage : TcpResponsePackage{
    
    override public class var type:UInt8{
        return 255;
    }
}

public class TcpEmptyProtocolParser : TcpAbstractProtocolParser{
    required public init(){
        
    }
    
    public override func parse()->TcpPackage!{
        return TcpEmptyPackage();
    }
    
    public override class
    var type:UInt8{
        return 255;
    }

}

