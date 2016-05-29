//
//  HttpMethod.swift
//  LinComm
//
//  Created by lin on 5/15/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


/// HTTP Verbs.
///
/// - GET: For GET requests.
/// - POST: For POST requests.
/// - PUT: For PUT requests.
/// - HEAD: For HEAD requests.
/// - DELETE: For DELETE requests.
public enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case HEAD = "HEAD"
    case DELETE = "DELETE"
}