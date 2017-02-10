//
//  json.swift
//  json
//
//  Created by Dan Kogai on 7/15/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//
import Foundation
/// init
open class Json : NSObject {

//    fileprivate var _value:AnyObject
    fileprivate var _value:Any
    public var originalValue:Any{return self._value;}
    public var value:Any{return self._value;}
    public init(isArray:Bool = false){
        if isArray {
            _value = NSMutableArray();//[AnyObject]();
        }else{
            _value = NSMutableDictionary()//Dictionary<String,AnyObject>();
        }
    }
    /// pass the object that was returned from
    /// NSJSONSerialization
//    public init(_ obj:AnyObject) {self._value = obj}
//    public init(_ json:Json){ self._value = json._value; }
    
//    public  init(_ obj:AnyObject) {
//        let cls = NSStringFromClass(obj.classForCoder);
//        if cls == "NSDictionary" {
//            self._value = NSMutableDictionary(dictionary: obj as! NSDictionary);
//        }else if cls == "NSArray" {
//            self._value = NSMutableArray(array: obj as! NSArray);
//        }else{
//            self._value = obj
//        }
//    }
    
    public init(_ obj:Any){
        switch obj {
        case let obj as NSDictionary:
            self._value = NSMutableDictionary(dictionary: obj);
        case let obj as NSArray:
            self._value = NSMutableArray(array: obj);
        default:
            self._value = obj;
        }
//        switch obj {
//        case let obj as AnyObject:
////            self.init(obj)
//            let cls = NSStringFromClass(obj.classForCoder);
//            if cls == "NSDictionary" {
//                let dic = obj as? NSDictionary;
////                NSMutableDictionary.init(dictionary: dic);
//                let mdic = NSMutableDictionary();
////                for var key in dic.allKeys {
//////                    mdic[key] = dic[key];
////                    mdic.setObject(dic[key], forKey: key as! NSCopying);
////                }
//                self._value = mdic;
//                self._value = NSMutableDictionary(dictionary: obj as! NSDictionary);
//            }else if cls == "NSArray" {
//                self._value = NSMutableArray(array: obj as! NSArray);
//            }else{
//                self._value = obj
//            }
//        default:
//            self._value = obj;
//        }
    }
    
    public init(array:[AnyObject]){
        let arr = NSMutableArray();
        for item in array {
            arr.add(item);
        }
        self._value = arr;
    }
    
    public init(array:[Any?]){
        let arr = NSMutableArray();
        for item in array {
            if let item = item {
                arr.add(item);
            }else{
                arr.add(NSNull.init());
            }
        }
        self._value = arr;
    }
    
//    public init(value array:[Hashable:AnyObject]){
////        var  a = Dictionary<String,String>()
//        self._value = NSMutableArray();
//    }
    public init(value json:Json){
        self._value = json._value;
    }
    open override var description:String { return toString() }
    
    open func copyDescription()->String{return toString();}
}

//extension Json {
//    public override func copy()->Json{
//        return Json(string:self.toString());
//    }
//}
/// class properties
extension Json {
    public typealias NSNull = Foundation.NSNull
    public typealias NSError = Foundation.NSError
    public class var null:NSNull { return NSNull() }
    
    /// constructs JSON object from data
    public convenience init(data:Data) {
        var err:NSError?
        var obj:Any?
        do {
            obj = try JSONSerialization.jsonObject(
                        with: data, options:[.allowFragments,.mutableLeaves])
        } catch let error as NSError {
            err = error
            obj = nil
        }
        self.init(err != nil ? err! : obj!)
    }
    /// constructs JSON object from string
    public convenience init(string:String) {
        let enc:String.Encoding = String.Encoding.utf8
        self.init(data: string.data(using: enc)!)
    }
    /// parses string to the JSON object
    /// same as JSON(string:String)
    public class func parse(_ string:String)->Json {
        return Json(string:string)
    }
    /// constructs JSON object from the content of NSURL
    public convenience init(nsurl:URL) {
        var enc:String.Encoding = String.Encoding.utf8
        var err:NSError?
        let str:String?
        do {
            //str = try String(
                        //contentsOfURL:nsurl, usedEncoding:&enc)
            str = try String(contentsOf: nsurl, usedEncoding: &enc)
        } catch let error as NSError {
            err = error
            str = nil
        }
        if err != nil { self.init(err!) }
        else { self.init(string:str!) }
    }
    /// fetch the JSON string from NSURL and parse it
    /// same as JSON(nsurl:NSURL)
    public class func fromNSURL(_ nsurl:URL) -> Json {
        return Json(nsurl:nsurl)
    }
    /// constructs JSON object from the content of URL
    public convenience init(url:String) {
        if let nsurl = URL(string:url) as URL? {
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
    public class func fromURL(_ url:String) -> Json {
        return Json(url:url)
    }
    /// does what JSON.stringify in ES5 does.
    /// when the 2nd argument is set to true it pretty prints
    public class func stringify(_ obj:AnyObject, pretty:Bool=false) -> String! {
        if !JSONSerialization.isValidJSONObject(obj) {
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
//MARK:instance properties
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
            case var ary as [Any]:
                
                if 0 <= idx && idx < ary.count {
//                    return Json(ary[idx])
                    //ary[idx] = newValue.value;
                    ary[idx] = newValue.originalValue;
                }else{
                    synchronized(self){
                        var count = ary.count;
                        while idx == count - 1 {
                            ary.append(Json.null);
                            count += 1;
                        }
                        ary.append(newValue.originalValue);
                        self._value = ary as AnyObject;
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
    
    public func setValue(_ value:Any?,forName name:String){
        if let value = value{
            if value is Json {
                self[name] = Json((value as! Json)._value);
            }else{
                self[name] = Json(value);
            }
        }else{
            self.remove(name);
        }
    }
    
    public func setStrValue(_ value:String,forName name:String){
        self.setValue(value as NSString, forName: name);
    }
    
    public func setIntValue(_ value:Int,forName name:String){
        self.setValue(value as NSNumber, forName: name);
    }
    
    public func setDoubleValue(_ value:Double,forName name:String){
        self.setValue(value as NSNumber,forName:name);
    }
    
    public func setBoolValue(_ value:Bool,forName name:String){
        self.setValue(value as NSNumber, forName: name);
    }
    
    
    public func remove(_ name:String){
        switch _value {
//        case let err as NSError:
//            return self
        case let dic as NSMutableDictionary://Dictionary<String,AnyObject>:
            if var _:Any = dic[name] {
//                dic.removeValueForKey(name);
                //dic.removeAtIndex(dic.indexForKey(name));
                dic[name] = nil;
//                self._value = dic;
            }
        default:
            break;
        }
    }
    
    public func getValue(_ name:String)->Any?{
        return self[name].originalValue;
    }
    /// access the element like dictionary
    public subscript(key:String)->Json {
        get{
        switch _value {
        case _ as NSError:
            return self
        case let dic as NSDictionary://Dictionary<String,AnyObject>:
            if let val:Any = dic[key] {
                return Json(val)
            }
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
            if _value is NSMutableDictionary {
                let dict = _value as! NSMutableDictionary;
                dict[key] = newValue._value;
            }else if _value is NSDictionary{
                let rdict = _value as! NSDictionary;
                let dict = NSMutableDictionary(dictionary: rdict)
                
                dict[key] = newValue._value;
                
                _value = dict;
            }
        }
    }
    
    
    
    
    /// access Json data object
    public var data:Any? {
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
        switch String(cString: o.objCType) {
        case "c", "C":              return "Bool"
        case "q", "l", "i", "s":    return "Int"
        case "Q", "L", "I", "S":    return "UInt"
        default:                    return "Double"
        }
    case is NSString:               return "String"
    case is NSArray:                return "Array"
    case is NSDictionary:           return "Dictionary"
    case is Date:              return "Date"
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
        let t = String(cString: o.objCType)
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
        switch String(cString: o.objCType) {
        case "c", "C":  return Bool(o.boolValue)
        default:
            return nil
        }
    default: return nil
        }
    }
    public func asBool(_ def:Bool = false)->Bool{
        if let v = self.asBool {
            return v;
        }
//        _value = def;
        return def;
    }
    /// gives Int if self holds it. nil otherwise
    public var asInt:Int? {
        switch _value {
        case let o as NSNumber:
            switch String(cString: o.objCType) {
            case "c", "C":
                return nil
            default:
                return o.intValue;
            }
        default: return nil
        }
    }
    public func asInt(_ def:Int = 0)->Int{
        if let v = self.asInt {
            return v;
        }
//        _value = def;
        return def;
    }
    public var asInt64:Int64? {
        switch _value {
        case let o as NSNumber:
            switch String(cString: o.objCType) {
            case "c", "C":
                return nil
            default:
                return o.int64Value
            }
        default: return nil
        }
    }
    public func asInt64(_ def:Int64 = 0)->Int64{
        if let v = self.asInt64 {
            return v;
        }
//        _value = NSNumber(longLong: def);
        return def;
    }
    /// gives Double if self holds it. nil otherwise
    public var asDouble:Double? {
    switch _value {
    case let o as NSNumber:
        switch String(cString: o.objCType) {
        case "c", "C":
            return nil
        default:
            return Double(o.doubleValue)
        }
    default: return nil
        }
    }
    public func asDouble(_ def:Double = 0)->Double{
        if let v = self.asDouble {
            return v;
        }
//        _value = def;
        return def;
    }
    // an alias to asDouble
    public var asNumber:NSNumber? { return asDouble as NSNumber? }
    public func asNumber(_ def:NSNumber = 0)->NSNumber{
        if let v = self.asNumber {
            return v;
        }
//        _value = def;
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
    public func asString(_ def:String = "")->String{
        if let v = self.asString {
            return v;
        }
//        _value = def;
        return def;
    }
    /// if self holds NSArray, gives a [Json]
    /// with elements therein. nil otherwise
    public var asArray:[Json]? {
    switch _value {
    case let o as NSArray:
        var result = [Json]()
        for v:Any in o {
            result.append(Json(v))
        }
        return result
    default:
        return nil
        }
    }
    public func asObjectArray<T>(item itemCreate:(Json)->T)->[T]{
        
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
        for (k, v): (Any, Any) in o {
            result[k as! String] = Json(v)
        }
        return result
    default: return nil
        }
    }
    /// Yields date from string
    public var asDate:Date? {
        if let dateString = _value as? NSString {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
            //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.date(from: dateString as String)
        }
        return nil
    }
    
    public func asDateDef()->Date{
        if let v = self.asDate {
            return v;
        }
        let def = Date();
//        _value = def;
        return def;
    }
//    public var asObject:T<T:JsonModel>?{
//    
//        if self.isError || self.isNull {
//            return nil;
//        }
//        return T(self);
//    }
    

    public func asObject<T:JsonModel>(_ create:(Json)->T)->T?{
        if self.isError || self.isNull {
            return nil;
        }
        return create(self);
    }
    public func asObject<T:AnyObject>(_ def: @escaping()->T)->T{
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
//        self._value = defValue!
        return defValue!;
    }
    
    /// gives the number of elements if an array or a dictionary.
    /// you can use this to check if you can iterate.
    public var count:Int {
    switch _value {
    case let o as NSArray:      return o.count
    case let o as NSDictionary: return o.count
    default: return 0
        }
    }
}
//MARK:SequenceType
extension Json : Sequence {
    public func makeIterator()->AnyIterator<(AnyObject,Json)> {
        switch _value {
        case let o as NSArray:
            var i = -1
            return AnyIterator {
                i += 1
                if i == o.count { return nil }
                return (i as NSNumber, Json(o[i]))
            }
        case let o as NSDictionary:
            var ks = Array(o.allKeys.reversed())
            return AnyIterator {
                if ks.isEmpty { return nil }
                let k = ks.removeLast() as! String
                return (k as NSString, Json(o.value(forKey: k)!))
            }
        default:
            return AnyIterator{ nil }
        }
    }
//    public func mutableCopyOfTheObject() -> Any {
//        return (_value as AnyObject).mutableCopy as Any
//    }
}
//MARK:CustomStringConvertible
extension Json {
    /// stringifies self.
    /// if pretty:true it pretty prints
    public func toString(_ pretty:Bool=false)->String {
        
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
    
    fileprivate func toStringJson(_ value:Any)->String?{
        ///var dic = Dictionary<String,String>();
        var string:String = "";
        //var dic2 = dic;
        var t:Int = 0;
        var realValue: Any = value;
        if let realValue = realValue as AnyObject? {
            if realValue.responds(to: Selector(("jsonSkip:"))) {
                return nil;
            }
        }
        switch value{
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
            realValue = json.originalValue;
        default:
            if value is NSArray{
                t = 1;
            }else if value is NSDictionary{
                t = 2;
            }else if value is String{
                t = 3;
            }else if value is Date{
                t = 4;
            }
        }
        
        switch t{
        case -1:
            string = "null";
        case 0:
            string = "\(realValue)";
        case 4:
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
            string = dateFormatter.string(from: realValue as! Date);
        case 1:
            string = toArrayString(realValue as! [AnyObject]);
        case 2:
//            if pre.lengthOfBytesUsingEncoding(1) != 0{
                string = toDicString(realValue as! Dictionary<String,AnyObject>)
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
            string = "\"\(realValue)\"";
        default:
            string = "\(realValue)";
        }
        return string;
    }
    
    fileprivate func toArrayString(_ value:[AnyObject])->String{
        var string:String = "[";
        for (index,item) in value.enumerated(){
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
    
    fileprivate func toDicString(_ value:Dictionary<String,AnyObject>)->String{
        
        var string:String = "{";
        var n:Int = 0;
        for (name,item) in value{
            if let s = toStringJson(item) {
                if n != 0 {
                    string += ",";
                }
                
                n += 1;
                
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
        
        return self.toParamsJson("", value: self);
        
        
//        return dic;
        
    }
    
    fileprivate func toParamsJson(_ pre:String,value:AnyObject)->Dictionary<String,String>{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // superset of OP's format
        //let str = dateFormatter.stringFromDate(NSDate())
        //println("date:\(str)");
        
        var dic = Dictionary<String,String>();
        //var dic2 = dic;
        
        //-1、nil，1、数据，2：字典，4：日期
        var t:Int = 0;
        var realValue: Any = value;
        
        if let realValue = realValue as AnyObject? {
            if realValue.responds(to: Selector(("jsonSkip:"))) {
                return dic;
            }
        }
        
        switch value{
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
            realValue = jsonModel.json.originalValue;
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
            realValue = json.originalValue;
        default:
            if value is NSArray{
                t = 1;
            }else if value is NSDictionary{
                t = 2;
            }else if value is Date {
                t = 4;
            }
        }
        
        switch t{
        case -1:
            dic[pre] = "null";
        case 0:
            dic[pre] = "\(realValue)";
        case 4:
            dic[pre] = dateFormatter.string(from: realValue as! Date);
        case 1:
            let d = toArrayParams(pre,value:realValue as! [AnyObject]);
            for (name,item) in d{
                dic[name] = item;
            }
        case 2:
            if pre.lengthOfBytes(using: String.Encoding(rawValue: UInt(1))) != 0{
                let d = toDicParams("\(pre).", value: realValue as! Dictionary<String,AnyObject>)
                for (name,item) in d{
                    dic[name] = item;
                }
            }else{
                let d = toDicParams("", value: realValue as! Dictionary<String,AnyObject>)
                for (name,item) in d{
                    dic[name] = item;
                }
            }
        default:
            dic[pre] = "\(realValue)";
        }
        return dic;
    }
    
    fileprivate func toArrayParams(_ pre:String,value:[AnyObject])->Dictionary<String,String>{
        var dic = Dictionary<String,String>();
        for (index,item) in value.enumerated(){
            let d = toParamsJson("\(pre)[\(index)]",value:item);
            for (name,item) in d{
                dic[name] = item;
            }
        }
        return dic;
    }
    
    fileprivate func toDicParams(_ pre:String,value:Dictionary<String,AnyObject>)->Dictionary<String,String>{
        
        var dic = Dictionary<String,String>();
        for (name,item) in value{
            let d = toParamsJson("\(pre)\(name)",value:item);
            for (name,item) in d{
                dic[name] = item;
            }
        }
        return dic;
    }
}
