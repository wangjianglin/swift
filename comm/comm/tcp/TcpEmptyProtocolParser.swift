//
//  EmptyProtocolParser.swift
//  LinClient
//
//  Created by lin on 1/26/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


open class TcpEmptyPackage : TcpResponsePackage{
    
    override open class var type:UInt8{
        return 255;
    }
}

open class TcpEmptyProtocolParser : TcpAbstractProtocolParser{
    required public init(){
        
    }
    
    open override func parse()->TcpPackage!{
        return TcpEmptyPackage();
    }
    
    open override class
    var type:UInt8{
        return 255;
    }

}

