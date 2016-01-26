//
//  json.swift
//  json
//
//  Created by Dan Kogai on 7/15/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//
import Foundation
/// init
public class Json {
    private var _value:AnyObject
    public var value:AnyObject{return self._value;}
    public init(isArray:Bool = false){
        if isArray {
            _value = [AnyObject]();
        }else{
            _value = Dictionary<String,AnyObject>();
        }
    }
    /// pass the object that was returned from
    /// NSJSONSerialization
    public init(_ obj:AnyObject) {self._value = obj}
    /// pass the JSON object for another instance
    public init(_ json:Json){ self._value = json._value; }
    
    public var description:String { return toString() }
    
    public func copyDescription()->String{return toString();}
}

extension Json {
    public func copy()->Json{
        return Json(string:self.toString());
    }
}
/// class properties
extension Json {
    public typealias NSNull = Foundation.NSNull
    public typealias NSError = Foundation.NSError
    public class var null:NSNull { return NSNull() }
    /// constructs JSON object from data
    public convenience init(data:NSData) {
        var err:NSError?
        var obj:AnyObject?
        do {
            obj = try NSJSONSerialization.JSONObjectWithData(
                        data, options:[])
        } catch let error as NSError {
            err = error
            obj = nil
        }
        self.init(err != nil ? err! : obj!)
    }
    /// constructs JSON object from string
    public convenience init(string:String) {
        let enc:NSStringEncoding = NSUTF8StringEncoding
        self.init(data: string.dataUsingEncoding(enc)!)
    }
    /// parses string to the JSON object
    /// same as JSON(string:String)
    public class func parse(string:String)->Json {
        return Json(string:string)
    }
    /// constructs JSON object from the content of NSURL
    public convenience init(nsurl:NSURL) {
        var enc:NSStringEncoding = NSUTF8StringEncoding
        var err:NSError?
        let str:String?
        do {
            str = try String(
                        contentsOfURL:nsurl, usedEncoding:&enc)
        } catch let error as NSError {
            err = error
            str = nil
        }
        if err != nil { self.init(err!) }
        else { self.init(string:str!) }
    }
    /// fetch the JSON string from NSURL and parse it
    /// same as JSON(nsurl:NSURL)
    public class func fromNSURL(nsurl:NSURL) -> Json {
        return Json(nsurl:nsurl)
    }
    /// constructs JSON object from the content of URL
    public convenience init(url:String) {
        if let nsurl = NSURL(string:url) as NSURL? {
            self.init(nsurl:nsurl)
        } else {
            self.init(NSError(
                domain:"JSONErrorDomain",
                code:400,
                userInfo:[NSLocalizedDescriptionKey: "malformed URL"]
                )
            )
        }
    }
    /// fetch the JSON string from URL in the string
    public class func fromURL(url:String) -> Json {
        return Json(url:url)
    }
    /// does what JSON.stringify in ES5 does.
    /// when the 2nd argument is set to true it pretty prints
    public class func stringify(obj:AnyObject, pretty:Bool=false) -> String! {
        if !NSJSONSerialization.isValidJSONObject(obj) {
//            Json(NSError(
//                domain:"JSONErrorDomain",
//                code:422,
//                userInfo:[NSLocalizedDescriptionKey: "not an JSON object"]
//                ))
            return nil
        }
        return Json(obj).toString(pretty)
    }
}
/// instance properties
extension Json {
    /// access the element like array
    public subscript(idx:Int) -> Json {
        get{
            switch _value {
            case _ as NSError:
                return self
            case let ary as NSArray:
                if 0 <= idx && idx < ary.count {
                    return Json(ary[idx])
                }
                return Json(NSError(
                    domain:"JsonErrorDomain", code:404, userInfo:[
                        NSLocalizedDescriptionKey:
                        "[\(idx)] is out of range"
                    ]))
            default:
                return Json(NSError(
                    domain:"JsonErrorDomain", code:500, userInfo:[
                        NSLocalizedDescriptionKey: "not an array"
                    ]))
                }
        }
        set{
            switch _value {
//            case let err as NSError:
//                return self
            case var ary as [AnyObject]:
                
                if 0 <= idx && idx < ary.count {
//                    return Json(ary[idx])
                    //ary[idx] = newValue.value;
                    ary[idx] = newValue.value;
                }else{
                    synchronized(self){
                        var count = ary.count;
                        while idx == count - 1 {
                            ary.append(Json.null);
                            count++;
                        }
                        ary.append(newValue.value);
                        self._value = ary;
                    }
                }
//                return Json(NSError(
//                    domain:"JsonErrorDomain", code:404, userInfo:[
//                        NSLocalizedDescriptionKey:
//                        "[\(idx)] is out of range"
//                    ]))
            default:
                break;
            }
        }
    }
    
//    public func setValue(name:String,value:AnyObject?){
    
    public func setValue(value:AnyObject?,forName name:String){
        if value == nil{
            //            self[name] = Json();
            self.remove(name);
        }else{
            self[name] = Json(value!);
        }
    }
    
    public func setIntValue(value:Int,forName name:String){
        self.setValue(NSNumber(integer: value), forName: name);
    }
    
    
    
    public func remove(name:String){
        switch _value {
//        case let err as NSError:
//            return self
        case var dic as Dictionary<String,AnyObject>:
            if let _:AnyObject = dic[name] {
//                dic.removeValueForKey(name);
                //dic.removeAtIndex(dic.indexForKey(name));
                dic[name] = nil;
                self._value = dic;
            }
        default:
            break;
        }
    }
    
    public func getValue(name:String)->AnyObject?{
        return self[name].value;
    }
    /// access the element like dictionary
    public subscript(key:String)->Json {
        get{
        switch _value {
        case _ as NSError:
            return self
        case let dic as Dictionary<String,AnyObject>:
            if let val:AnyObject = dic[key] { return Json(val) }
            return Json(NSError(
                domain:"JsonErrorDomain", code:404, userInfo:[
                    NSLocalizedDescriptionKey:
                    "[\"\(key)\"] not found"
                ]))
        default:
            return Json(NSError(
                domain:"JsonErrorDomain", code:500, userInfo:[
                    NSLocalizedDescriptionKey: "not an object"
                ]))
            }
        }
        set{
            var dic = _value as! Dictionary<String,AnyObject>;
            dic[key] = newValue._value;
            _value = dic;
        }
    }
    
    
    
    
    /// access Json data object
    public var data:AnyObject? {
        return self.isError ? nil : self._value
    }
    /// Gives the type name as string.
    /// e.g.  if it returns "Double"
    ///       .asDouble returns Double
    public var type:String {
    switch _value {
    case is NSError:        return "NSError"
    case is NSNull:         return "NSNull"
    case let o as NSNumber:
        switch String.fromCString(o.objCType)! {
        case "c", "C":              return "Bool"
        case "q", "l", "i", "s":    return "Int"
        case "Q", "L", "I", "S":    return "UInt"
        default:                    return "Double"
        }
    case is NSString:               return "String"
    case is NSArray:                return "Array"
    case is NSDictionary:           return "Dictionary"
    case is NSDate:              return "Date"
    default:                        return "NSError"
        }
    }
    /// check if self is NSError
    public var isError:      Bool { return _value is NSError }
    /// check if self is NSNull
    public var isNull:       Bool { return _value is NSNull }
    /// check if self is Bool
    public var isBool:       Bool { return type == "Bool" }
    /// check if self is Int
    public var isInt:        Bool { return type == "Int" }
    /// check if self is UInt
    public var isUInt:       Bool { return type == "UInt" }
    /// check if self is Double
    public var isDouble:     Bool { return type == "Double" }
    public var isDate:     Bool { return type == "Date" }
    /// check if self is any type of number
    public var isNumber:     Bool {
    if let o = _value as? NSNumber {
        let t = String.fromCString(o.objCType)!
        return  t != "c" && t != "C"
    }
    return false
    }
    /// check if self is String
    public var isString:     Bool { return _value is NSString }
    /// check if self is Array
    public var isArray:      Bool { return _value is NSArray }
    /// check if self is Dictionary
    public var isDictionary: Bool { return _value is NSDictionary }
    /// check if self is a valid leaf node.
    public var isLeaf:       Bool {
        return !(isArray || isDictionary || isError)
    }
    /// gives NSError if it holds the error. nil otherwise
    public var asError:NSError? {
    return _value as? NSError
    }
    /// gives NSNull if self holds it. nil otherwise
    public var asNull:NSNull? {
    return _value is NSNull ? Json.null : nil
    }
    /// gives Bool if self holds it. nil otherwise
    public var asBool:Bool? {
    switch _value {
    case let o as NSNumber:
        switch String.fromCString(o.objCType)! {
        case "c", "C":  return Bool(o.boolValue)
        default:
            return nil
        }
    default: return nil
        }
    }
    public func asBool(def:Bool = false)->Bool{
        if let v = self.asBool {
            return v;
        }
        _value = def;
        return def;
    }
    /// gives Int if self holds it. nil otherwise
    public var asInt:Int? {
        switch _value {
        case let o as NSNumber:
            switch String.fromCString(o.objCType)! {
            case "c", "C":
                return nil
            default:
                return Int(o.longLongValue)
            }
        default: return nil
        }
    }
    public func asInt(def:Int = 0)->Int{
        if let v = self.asInt {
            return v;
        }
        _value = def;
        return def;
    }
    /// gives Double if self holds it. nil otherwise
    public var asDouble:Double? {
    switch _value {
    case let o as NSNumber:
        switch String.fromCString(o.objCType)! {
        case "c", "C":
            return nil
        default:
            return Double(o.doubleValue)
        }
    default: return nil
        }
    }
    public func asDouble(def:Double = 0)->Double{
        if let v = self.asDouble {
            return v;
        }
        _value = def;
        return def;
    }
    // an alias to asDouble
    public var asNumber:Double? { return asDouble }
    public func asNumber(def:Double = 0)->Double{
        if let v = self.asNumber {
            return v;
        }
        _value = def;
        return def;
    }
    /// gives String if self holds it. nil otherwise
    public var asString:String? {
    switch _value {
    case let o as NSString:
        return o as String
    default: return nil
        }
    }
    public func asString(def:String = "")->String?{
        if let v = self.asString {
            return v;
        }
        _value = def;
        return def;
    }
    /// if self holds NSArray, gives a [Json]
    /// with elements therein. nil otherwise
    public var asArray:[Json]? {
    switch _value {
    case let o as NSArray:
        var result = [Json]()
        for v:AnyObject in o { result.append(Json(v)) }
        return result
    default:
        return nil
        }
    }
    public func asObjectArray<T:JsonModel>(item itemCreate:(Json)->T)->[T]{
        
        var result = [T]();
        if let array = self.asArray {
            for item in array {
                result.append(itemCreate(item));
//                result.append(T(json:item));
            }
        }
        return result;
    }
    
    /// if self holds NSDictionary, gives a [String:Json]
    /// with elements therein. nil otherwise
    public var asDictionary:[String:Json]? {
    switch _value {
    case let o as NSDictionary:
        var result = [String:Json]()
        for (k, v): (AnyObject, AnyObject) in o {
            result[k as! String] = Json(v)
        }
        return result
    default: return nil
        }
    }
    /// Yields date from string
    public var asDate:NSDate? {
        if let dateString = _value as? NSString {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
            //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.dateFromString(dateString as String)
        }
        return nil
    }
    
    public func asDateDef()->NSDate{
        if let v = self.asDate {
            return v;
        }
        let def = NSDate();
        _value = def;
        return def;
    }
//    public var asObject:T<T:JsonModel>?{
//    
//        if self.isError || self.isNull {
//            return nil;
//        }
//        return T(self);
//    }
    

    public func asObject<T:JsonModel>(create:(Json)->T)->T?{
        if self.isError || self.isNull {
            return nil;
        }
        return create(self);
    }
    public func asObject<T:AnyObject>(def:()->T)->T{
//        var _value:AnyObject! = self[name];
        switch _value {
        case let o as T:
            return o;
        default:
            break;
        }
        var defValue:T?;
        
        synchronized(self){
//            _value = self[name];
            switch self._value {
            case let o as T:
                defValue = o;
            default:
                break;
            }
            
            if defValue == nil {
                defValue = def();
            }
        }
        self._value = defValue!
        return defValue!;
    }
    
    /// gives the number of elements if an array or a dictionary.
    /// you can use this to check if you can iterate.
    public var length:Int {
    switch _value {
    case let o as NSArray:      return o.count
    case let o as NSDictionary: return o.count
    default: return 0
        }
    }
}
extension Json : SequenceType {
    public func generate()->AnyGenerator<(AnyObject,Json)> {
        switch _value {
        case let o as NSArray:
            var i = -1
            return anyGenerator {
                if ++i == o.count { return nil }
                return (i, Json(o[i]))
            }
        case let o as NSDictionary:
            var ks = Array(o.allKeys.reverse())
            return anyGenerator {
                if ks.isEmpty { return nil }
                let k = ks.removeLast() as! String
                return (k, Json(o.valueForKey(k)!))
            }
        default:
            return anyGenerator{ nil }
        }
    }
    public func mutableCopyOfTheObject() -> AnyObject {
        return _value.mutableCopy()
    }
}
extension Json : CustomStringConvertible {
    /// stringifies self.
    /// if pretty:true it pretty prints
    public func toString(pretty:Bool=false)->String {
        
        if let str = toStringJson(self){
            return str;
        }
        return "";
        //println("start.");
        
//        switch _value {
//        case is NSError: return "\(_value)"
//        case is NSNull: return "null"
//        case let o as NSNumber:
//            switch String.fromCString(o.objCType)! {
//            case "c", "C":
//                return o.boolValue.description
//            case "q", "l", "i", "s":
//                return o.longLongValue.description
//            case "Q", "L", "I", "S":
//                return o.unsignedLongLongValue.description
//            default:
//                switch o.doubleValue {
//                case 0.0/0.0:   return "0.0/0.0"    // NaN
//                case -1.0/0.0:  return "-1.0/0.0"   // -infinity
//                case +1.0/0.0:  return "+1.0/0.0"   //  infinity
//                default:
//                    return o.doubleValue.description
//                }
//            }
//        case let o as NSString:
//            return o.debugDescription
//        default:
//            let opts = pretty
//                ? NSJsonWritingOptions.PrettyPrinted : nil
//            if let data = NSJsonSerialization.dataWithJsonObject(
//                _value, options:opts, error:nil
//            ) as NSData? {
//                if let nsstring = NSString(
//                    data:data, encoding:NSUTF8StringEncoding
//                ) as NSString? {
//                    return nsstring
//                }
//            }
//            return "YOU ARE NOT SUPPOSED TO SEE THIS!"
//        }
    }
    
    private func toStringJson(v:AnyObject)->String?{
        ///var dic = Dictionary<String,String>();
        var string:String = "";
        //var dic2 = dic;
        var t:Int = 0;
        var tmpv: AnyObject = v;
        if tmpv.respondsToSelector("jsonSkip:") {
            return nil;
        }
        switch v{
        case is NSNull:
            t = -1;
        case let json as Json:
            if json.isError{
                //dic[pre] = "\(json.value)";
            }else if json.isArray {
                t = 1;
            }else if json.isDictionary{
                t = 2;
            }else if json.isString{
                t = 3;
            }else if json.isDate{
                t = 4;
            }
            tmpv = json.value;
        default:
            if v is NSArray{
                t = 1;
            }else if v is NSDictionary{
                t = 2;
            }else if v is String{
                t = 3;
            }else if v is NSDate{
                t = 4;
            }
        }
        
        switch t{
        case -1:
            string = "null";
        case 0:
            string = "\(v)";
        case 4:
            let dateFormatter = NSDateFormatter();
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
            string = dateFormatter.stringFromDate(v as! NSDate);
        case 1:
            string = toArrayString(tmpv as! [AnyObject]);
        case 2:
//            if pre.lengthOfBytesUsingEncoding(1) != 0{
                string = toDicString(tmpv as! Dictionary<String,AnyObject>)
//                for (name,item) in d{
//                    dic[name] = item;
//                }
//            }else{
//                var d = toDicString(tmpv as Dictionary<String,AnyObject>)
//                for (name,item) in d{
//                    dic[name] = item;
//                }
//            }
        case 3:
            string = "\"\(tmpv)\"";
        default:
            string = "\(tmpv)";
        }
        return string;
    }
    
    private func toArrayString(v:[AnyObject])->String{
        var string:String = "[";
        for (index,item) in v.enumerate(){
            if let s = toStringJson(item){
                if index != 0 {
                    string += ",";
                }
                string += s;
            }
            
            
        }
        string += "]";
        return string;
    }
    
    private func toDicString(v:Dictionary<String,AnyObject>)->String{
        
        var string:String = "{";
        var n:Int = 0;
        for (name,item) in v{
            if let s = toStringJson(item) {
                if n != 0 {
                    string += ",";
                }
                
                n++;
                
                string += "\"\(name)\":"
                string += s;
            }
        }
        string += "}";
        return string;
    }
    
//    public var description:String { return toString() }
//    
//    public func copyDescription()->String{return toString();}
}


extension Json{
    public func toParams()->Dictionary<String,String>{
        
//        var dic = Dictionary<String,String>();
        
        return self.toParamsJson("", v: self);
        
        
//        return dic;
        
    }
    
    private func toParamsJson(pre:String,v:AnyObject)->Dictionary<String,String>{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // superset of OP's format
        //let str = dateFormatter.stringFromDate(NSDate())
        //println("date:\(str)");
        
        var dic = Dictionary<String,String>();
        //var dic2 = dic;
        
        //-1、nil，1、数据，2：字典，4：日期
        var t:Int = 0;
        var tmpv: AnyObject = v;
        
        if tmpv.respondsToSelector("jsonSkip:") {
            return dic;
        }
        
        switch v{
        case is NSNull:
            t = -1;
        case let jsonModel as JsonModel:
            if jsonModel.json.isError{
                //dic[pre] = "\(json.value)";
            }else if jsonModel.json.isArray {
                t = 1;
            }else if jsonModel.json.isDictionary{
                t = 2;
            }else if jsonModel.json.isDate {
                t = 4;
            }
            tmpv = jsonModel.json.value;
            break;
        case let json as Json:
            if json.isError{
                //dic[pre] = "\(json.value)";
            }else if json.isArray {
                t = 1;
            }else if json.isDictionary{
                t = 2;
            }else if json.isDate {
                t = 4;
            }
            tmpv = json.value;
        default:
            if v is NSArray{
                t = 1;
            }else if v is NSDictionary{
                t = 2;
            }else if v is NSDate {
                t = 4;
            }
        }
        
        switch t{
        case -1:
            dic[pre] = "null";
        case 0:
            dic[pre] = "\(v)";
        case 4:
            dic[pre] = dateFormatter.stringFromDate(v as! NSDate);
        case 1:
            let d = toArrayParams(pre,v:tmpv as! [AnyObject]);
            for (name,item) in d{
                dic[name] = item;
            }
        case 2:
            if pre.lengthOfBytesUsingEncoding(1) != 0{
                let d = toDicParams("\(pre).", v: tmpv as! Dictionary<String,AnyObject>)
                for (name,item) in d{
                    dic[name] = item;
                }
            }else{
                let d = toDicParams("", v: tmpv as! Dictionary<String,AnyObject>)
                for (name,item) in d{
                    dic[name] = item;
                }
            }
        default:
            dic[pre] = "\(tmpv)";
        }
        return dic;
    }
    
    private func toArrayParams(pre:String,v:[AnyObject])->Dictionary<String,String>{
        var dic = Dictionary<String,String>();
        for (index,item) in v.enumerate(){
            let d = toParamsJson("\(pre)[\(index)]",v:item);
            for (name,item) in d{
                dic[name] = item;
            }
        }
        return dic;
    }
    
    private func toDicParams(pre:String,v:Dictionary<String,AnyObject>)->Dictionary<String,String>{
        
        var dic = Dictionary<String,String>();
        for (name,item) in v{
            let d = toParamsJson("\(pre)\(name)",v:item);
            for (name,item) in d{
                dic[name] = item;
            }
        }
        return dic;
    }
}
