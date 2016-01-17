//
//  server.h
//  server
//
//  Created by lin on 6/3/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for server.
FOUNDATION_EXPORT double serverVersionNumber;

//! Project version string for server.
FOUNDATION_EXPORT const unsigned char serverVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <server/PublicHeader.h>


#import "CocoaHTTPServer/HTTPServer.h"
#import "CocoaHTTPServer/HTTPConnection.h"
#import "CocoaHTTPServer/HTTPMessage.h"
#import "CocoaHTTPServer/HTTPResponse.h"
#import "CocoaHTTPServer/Responses/HTTPDataResponse.h"