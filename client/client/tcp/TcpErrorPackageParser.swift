//
//  TcpErrorPackageParser.swift
//  LinClient
//
//  Created by lin on 1/22/16.
//  Copyright © 2016 lin. All rights reserved.
//

import LinUtil

public final class TcpErrorPackage : TcpResponsePackage{
    
    public override class var type:UInt8{
        return 0;
    }
    
    public init(code:Int,message:String,cause:String!,detial:String!) {
        _json = Json();
        _json.setIntValue(code, forName: "code");
        _json.setValue(message, forName: "message")
        _json.setValue(cause, forName: "cause");
        _json.setValue(detial, forName: "detial");
    }
    init(json:Json) {
        _json = json;
    }

    public required init() {
        fatalError("init() has not been implemented")
    }
    private var _json:Json;
    private var code:Int{
        return _json["code"].asInt!;
    }
    
    private var message:String{
        return _json["message"].asString("")!;
    }
    
    public var cause:String!{
        return _json["cause"].asString;
    }
    
    public var detial:String!{
        return _json["detial"].asString;
    }
    
    public override func write() -> [UInt8] {
        let s = _json.toString();
        
        
        let len = s.lengthOfBytesUsingEncoding(NSUTF8StringEncoding);
        let ptr:[Int8] = s.cStringUsingEncoding(NSUTF8StringEncoding)!;
        
        var r = [UInt8](count: len, repeatedValue: 0);
        for(var n=0;n<len;n++){
            r[n] = asUInt8(ptr[n]);
        }
        return r;
    }
}
public class TcpErrorPackageParser : TcpAbstractProtocolParser{
    
    public override class
        var type:UInt8{
            return 0;
    }
    
    public override func parse() -> TcpPackage! {
        let json = Json.parse(String.fromBuffer(buffer, count: size));
        return TcpErrorPackage(json: json);
    }
}