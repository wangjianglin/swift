//
//  TcpErrorPackageParser.swift
//  LinClient
//
//  Created by lin on 1/22/16.
//  Copyright © 2016 lin. All rights reserved.
//

import CessUtil

public final class TcpErrorPackage : TcpResponsePackage{
    
    public override class var type:UInt8{
        return 0;
    }
    
    public init(code:Int,message:String,cause:String!,detial:String!) {
        _json = Json();
        _json.setIntValue(code, forName: "code");
        _json.setValue(message as NSString, forName: "message")
        _json.setValue(cause as NSString, forName: "cause");
        _json.setValue(detial as NSString, forName: "detial");
    }
    init(json:Json) {
        _json = json;
    }

    public required init() {
        fatalError("init() has not been implemented")
    }
    fileprivate var _json:Json;
    fileprivate var code:Int{
        return _json["code"].asInt!;
    }
    
    fileprivate var message:String{
        return _json["message"].asString("");
    }
    
    public var cause:String!{
        return _json["cause"].asString;
    }
    
    public var detial:String!{
        return _json["detial"].asString;
    }
    
    public override func write() -> [UInt8] {
        let s = _json.toString();
        
        
        let len = s.lengthOfBytes(using: String.Encoding.utf8);
        let ptr:[Int8] = s.cString(using: String.Encoding.utf8)!;
        
        var r = [UInt8](repeating: 0, count: len);
        for n in 0 ..< len {
            r[n] = asUInt8(ptr[n]);
        }
        return r;
    }
}
open class TcpErrorPackageParser : TcpAbstractProtocolParser{
    
    open override class
        var type:UInt8{
            return 0;
    }
    
    open override func parse() -> TcpPackage! {
        let json = Json.parse(StringExt.fromBuffer(buffer, count: size));
        return TcpErrorPackage(json: json);
    }
}
