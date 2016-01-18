//
//  Storage.swift
//  LinCore
//
//  Created by lin on 12/17/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation
import LinUtil

/*
*
*  把数据存储到本地
*
*/
public class StorageImpl{

    private var path:String;
    private var position:StoragePosition;
    private var filePath:String;
//    private var database:Database;
    
    private init(position:StoragePosition,path:String){
        self.path = path;
        self.position = position;
        self.lock = NSLock();
        switch position{
        case .Document:
            filePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask,true)[0] as! String;
            filePath = "\(filePath)\\(path).storage";
            
        case .Cache:
            filePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory,NSSearchPathDomainMask.UserDomainMask,true)[0] as! String;
            filePath = "\(filePath)\\(path).storage";
            
        case .Tmp:
            filePath = NSTemporaryDirectory();
            filePath = "\(filePath)\\(path).storage";
            
        case .Library:
            filePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory,NSSearchPathDomainMask.UserDomainMask,true)[0] as! String;
            filePath = "\(filePath)\\(path).storage";
            
        default:
            filePath = ":memory:";
            break;
        }
        //database = Database("path/to/db.sqlite3")
//        database = Database(filePath);
        
//        table = database["storage"]
        let id = Expression<Int>(literal: "id")
        key = Expression<String>(literal: "key")
        value = Expression<String>(literal: "value")
        
        
//        database.create(table: table,temporary:false,ifNotExists: true) { t in
//            t.column(id, primaryKey: true)
//            t.column(self.key, unique: true)
//            t.column(self.value)
//        }
    }
//    private var table:Query;
    private var key:Expression<String>;
    private var value:Expression<String>;
    
    private var lock:NSLock;
    
//    public subscript(key:String)->AnyObject!{
//        get{
//            lock.lock();
//            var r:AnyObject! = nil;
//            if let query = getItem(key) {
//                var valueString = query.first?.get(self.value);
////                let decodedData = NSData(base64EncodedString: resp!, options: NSDataBase64DecodingOptions(0))
//                var data = NSData(base64EncodedString: valueString!,options: NSDataBase64DecodingOptions(0));
//                r = NSKeyedUnarchiver.unarchiveObjectWithData(data!)
//            }
//            lock.unlock();
//            return r;
//        }
//        set{
//            lock.lock();
//            var data:NSData=NSKeyedArchiver.archivedDataWithRootObject(newValue);
//            var base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0));
//            
//            if let query = getItem(key) {
//                query.update(self.value <- base64String)?;
//            }else{
//                self.table.insert(self.key <- key, self.value <- base64String)?
//                //self.table.update(<#values: Setter#>...)
////                if let insertedID = self.table.insert(self.key <- key, self.value <- base64String) {
////                    //println("inserted id: \(insertedID)")
////                    // inserted id: 1
////                    //alice = users.filter(id == insertedID)
////                }
//            }
//            lock.unlock();
//        }
//    }
//    
//    private func getItem(key:String)->Query?{
//        return self.table.filter(self.key == key);
//    }

}

public class StorageArgs{
    
    var insts:Dictionary<String,StorageImpl>;
    private var lock:NSLock;
    
    private init(){
        self.insts = Dictionary<String,StorageImpl>();
        self.lock = NSLock();
    }
    
    public subscript(position:StoragePosition,path:String)->StorageImpl {
        get{
            //线程同步
            //@synchronized(self){
            let name = "\(position):\(path)";
            var impl = insts[name];
            if let i = impl{
                return i;
            }
            lock.lock();
            impl = insts[name];
            if impl == nil{
                impl = StorageImpl(position:position,path:path);
                insts[name] = impl;
            }
            lock.unlock();
            return impl!;
            //   return HttpCommunicate(name:name);
            //}
        }
        //            set{
        //
        //            }
    }
    
    public var document:StorageImpl{
        return self[StoragePosition.Document,"document.storage"];
    }
    
    public var tmp:StorageImpl{
        return self[StoragePosition.Tmp,"tmp.storage"];
    }
    
    public var library:StorageImpl{
        return self[StoragePosition.Library,"library.storage"];
    }
    
    public var cache:StorageImpl{
        return self[StoragePosition.Cache,"cache.storage"];
    }
    
    public var memory:StorageImpl{
        return self[StoragePosition.Memory,""];
    }
}
public var Storage:StorageArgs{
    struct YRSingleton{
        static var predicate:dispatch_once_t = 0
        static var instance:StorageArgs? = nil
    }
    dispatch_once(&YRSingleton.predicate,{
        YRSingleton.instance = StorageArgs()
    })
    return YRSingleton.instance!
}