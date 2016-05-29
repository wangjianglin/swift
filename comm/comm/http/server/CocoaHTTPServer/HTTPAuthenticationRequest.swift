//#import "HTTPAuthenticationRequest.h"
//#import "HTTPMessage.h"
//
//#if ! __has_feature(objc_arc)
//#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
//#endif
//
//@interface HTTPAuthenticationRequest (PrivateAPI)
//- (NSString *)quotedSubHeaderFieldValue:(NSString *)param fromHeaderFieldValue:(NSString *)header;
//- (NSString *)nonquotedSubHeaderFieldValue:(NSString *)param fromHeaderFieldValue:(NSString *)header;
//@end
import Foundation

public class HTTPAuthenticationRequest{

    private var _request:HTTPMessage;
    
    private var _isBasic:Bool = false;
    private var _isDigest:Bool = false;
    //
    private var _base64Credentials:String? = nil;
    //
    private var _username:String? = nil;
    private var _realm:String? = nil;
    private var _nonce:String? = nil;
    private var _uri:String? = nil;
    private var _qop:String? = nil;
    private var _nc:String? = nil;
    private var _cnonce:String? = nil;
    private var _response:String? = nil;

//    private init(){}
    public init(request:HTTPMessage){
        _request = request;
        
        let authInfo = request.headerField("Authorization") ?? "";
		
		_isBasic = false;
		if (authInfo as NSString).length >= 6 {
			_isBasic = ((authInfo as NSString).substringToIndex(6) as NSString).caseInsensitiveCompare("Basic ") == NSComparisonResult.OrderedSame;
		}
		
		_isDigest = false;
		if (authInfo as NSString).length >= 7 {
			_isDigest = ((authInfo as NSString).substringToIndex(7)).caseInsensitiveCompare("Digest ") == NSComparisonResult.OrderedSame;
		}
		
		if _isBasic {
            let temp = (authInfo as NSString).substringFromIndex(6);// mutableCopy];
//			CFStringTrimWhitespace(temp);
            _base64Credentials = temp.trim();
			
//            _base64Credentials =  temp;//[temp copy];
		}
//        super.init();
//        super.init();
		if _isDigest {
			_username = self.quotedSubHeaderFieldValue("username", fromHeaderFieldValue:authInfo);
			_realm    = self.quotedSubHeaderFieldValue("realm", fromHeaderFieldValue:authInfo);
			_nonce    = self.quotedSubHeaderFieldValue("nonce", fromHeaderFieldValue:authInfo);
			_uri      = self.quotedSubHeaderFieldValue("uri", fromHeaderFieldValue:authInfo);
			
			// It appears from RFC 2617 that the qop is to be given unquoted
			// Tests show that Firefox performs this way, but Safari does not
			// Thus we'll attempt to retrieve the value as nonquoted, but we'll verify it doesn't start with a quote
			_qop      = self.nonquotedSubHeaderFieldValue("qop", fromHeaderFieldValue:authInfo);
			if _qop != nil && (_qop! as NSString).characterAtIndex(0) == unichar("\"") {
				_qop  = self.quotedSubHeaderFieldValue("qop", fromHeaderFieldValue:authInfo);
			}
			
			_nc       = self.nonquotedSubHeaderFieldValue("nc", fromHeaderFieldValue:authInfo);
			_cnonce   = self.quotedSubHeaderFieldValue("cnonce", fromHeaderFieldValue:authInfo);
			_response = self.quotedSubHeaderFieldValue("response", fromHeaderFieldValue:authInfo);
		}
	}
    


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//MARK: Accessors:
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public var isBasic:Bool {
        return _isBasic;
    }

    public var isDigest:Bool {
        return _isDigest;
    }

    public var base64Credentials:String? {
        return _base64Credentials;
    }

    public var username:String? {
        return _username;
    }

    public var realm:String? {
        return _realm;
    }

    public var nonce:String? {
        return _nonce;
    }

    public var uri:String? {
        return _uri;
    }

    public var qop:String? {
        return _qop;
    }

    public var nc:String? {
        return _nc;
    }

    public var cnonce:String? {
        return _cnonce;
    }

    public var response:String? {
        return _response;
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//MARK:Private API:
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Retrieves a "Sub Header Field Value" from a given header field value.
 * The sub header field is expected to be quoted.
 * 
 * In the following header field:
 * Authorization: Digest username="Mufasa", qop=auth, response="6629fae4939"
 * The sub header field titled 'username' is quoted, and this method would return the value @"Mufasa".
**/
    private func quotedSubHeaderFieldValue(param:String, fromHeaderFieldValue header:String)->String?{
        var startRange = header.rangeOfString("\(param)=\"");
        if startRange == nil {//unichar|| startRange.location == NSNotFound {
            // The param was not found anywhere in the header
            return nil;
        }
        
//        let postStartRangeLocation = startRange.location + startRange.length;
//        let postStartRangeLength = header.length - postStartRangeLocation;
//        let postStartRange = NSMakeRange(startRange!.startIndex, startRange!.endIndex);
//        NSMakeRange(<#T##loc: Int##Int#>, <#T##len: Int##Int#>)
        startRange!.startIndex = startRange!.endIndex;
        startRange!.endIndex = header.endIndex;
        
        let endRange = header.rangeOfString("\"", options:NSStringCompareOptions.init(rawValue: 0), range:startRange!);
        if endRange == nil {//|| endRange.location == NSNotFound {
            // The ending double-quote was not found anywhere in the header
            return nil;
        }
        
//        let subHeaderRange = NSMakeRange(postStartRangeLocation, endRange.location - postStartRangeLocation);
//        let subHeaderRange = Range<String.CharacterView.Index>(start: startRange!.startIndex, end: endRange!.endIndex);
//        return header.substringWithRange(subHeaderRange);
        startRange?.endIndex = endRange!.endIndex;
        return header.substringWithRange(startRange!);
    }

/**
 * Retrieves a "Sub Header Field Value" from a given header field value.
 * The sub header field is expected to not be quoted.
 * 
 * In the following header field:
 * Authorization: Digest username="Mufasa", qop=auth, response="6629fae4939"
 * The sub header field titled 'qop' is nonquoted, and this method would return the value @"auth".
**/
    public func nonquotedSubHeaderFieldValue(param:String, fromHeaderFieldValue header:String)->String?{
        var startRange = header.rangeOfString("\(param)=")
        if startRange == nil {//|| startRange.location == NSNotFound {
            // The param was not found anywhere in the header
            return nil;
        }
        
//        let postStartRangeLocation = startRange.location + startRange.length;
//        let postStartRangeLength = header.length - postStartRangeLocation;
//        let postStartRange = NSMakeRange(postStartRangeLocation, postStartRangeLength);
        
        startRange?.startIndex = startRange!.endIndex;
        startRange?.endIndex = header.endIndex;
        
        let endRange = header.rangeOfString(",", options:NSStringCompareOptions.init(rawValue: 0), range:startRange!);
        if endRange == nil {//|| endRange.location == NSNotFound {
            // The ending comma was not found anywhere in the header
            // However, if the nonquoted param is at the end of the string, there would be no comma
            // This is only possible if there are no spaces anywhere
            let endRange2 = header.rangeOfString(" ", options:NSStringCompareOptions.init(rawValue: 0), range:startRange!);
            if endRange2 == nil {//|| endRange2.location != NSNotFound {
                return nil;
            }
            else{
                return header.substringWithRange(startRange!);
            }
        }
        else{
            startRange?.endIndex = endRange!.endIndex;
//            let subHeaderRange = NSMakeRange(postStartRangeLocation, endRange.location - postStartRangeLocation);
//            return header.substringWithRange(subHeaderRange);
            return header.substringWithRange(startRange!);
        }
    }
}
