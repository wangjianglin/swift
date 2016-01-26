//
//  TcpCommandDetectPackage.swift
//  LinClient
//
//  Created by lin on 1/23/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


public class TcpCommandDetectPackage : TcpCommandPackage{
    
    override public class var command:Int32{
        return 0x1;
    }
}