//#import <Foundation/Foundation.h>
//
//#if TARGET_OS_IPHONE
//  // Note: You may need to add the CFNetwork Framework to your project
//  #import <CFNetwork/CFNetwork.h>
//#endif
//
//@class HTTPMessage;
//
//
//@interface HTTPAuthenticationRequest : NSObject
//{
//	BOOL isBasic;
//	BOOL isDigest;
//	
//	NSString *base64Credentials;
//	
//	NSString *username;
//	NSString *realm;
//	NSString *nonce;
//	NSString *uri;
//	NSString *qop;
//	NSString *nc;
//	NSString *cnonce;
//	NSString *response;
//}
//- (id)initWithRequest:(HTTPMessage *)request;
//
////- (BOOL)isBasic;
////- (BOOL)isDigest;
//@property(readonly) Boolean isBasic;
//@property(readonly) Boolean isDigest;
//
//// Basic
////- (NSString *)base64Credentials;
//@property(readonly) NSString * base64Credentials;
//
//// Digest
////- (NSString *)username;
////- (NSString *)realm;
////- (NSString *)nonce;
////- (NSString *)uri;
////- (NSString *)qop;
////- (NSString *)nc;
////- (NSString *)cnonce;
////- (NSString *)response;
//@property(readonly) NSString * username;
//@property(readonly) NSString * realm;
//@property(readonly) NSString * nonce;
//@property(readonly) NSString * uri;
//@property(readonly) NSString * qop;
//@property(readonly) NSString * nc;
//@property(readonly) NSString * cnonce;
//@property(readonly) NSString * response;
//
//@end
