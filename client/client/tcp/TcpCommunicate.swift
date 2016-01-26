//
//  TcpCommunicate.swift
//  LinClient
//
//  Created by lin on 1/19/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


public protocol TcpCommunicate{
    
    var mainThread:Bool{get set};// = false;
    
    func send(pack:TcpPackage)->TcpPackageResponse;
    
    func start()->Bool;
    func close();
    
//    func var connected:Bool;
    
//    func reconnection();
   
}

