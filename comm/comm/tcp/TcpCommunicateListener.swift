//
//  TcpCommunicateListener.swift
//  LinClient
//
//  Created by lin on 1/21/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


public typealias TcpCommunicateListener = ((_ session:TcpSession,_ pack:TcpPackage,_ response:TcpResponse)->()) ;
