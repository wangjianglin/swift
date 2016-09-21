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
open class StorageImpl{

    fileprivate var path:String;
    fileprivate var position:StoragePosition;
    fileprivate var filePath:String;
//    private var database:Database;
    
    fileprivate init(position:StoragePosition,path:String){
        self.path = path;
        self.position = position;
        self.lock = NSLock();
        switch position{
        case .document:
            filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true)[0] ;
            filePath = "\(filePath)\\(path).storage";
            
        case .cache:
            filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,FileManager.SearchPathDomainMask.userDomainMask,true)[0] ;
            filePath = "\(filePath)\\(path).storage";
            
        case .tmp:
            filePath = NSTemporaryDirectory();
            filePath = "\(filePath)\\(path).storage";
            
        case .library:
            filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory,FileManager.SearchPathDomainMask.userDomainMask,true)[0] ;
            filePath = "\(filePath)\\(path).storage";
            
        default:
            filePath = ":memory:";
            break;
        }
        //database = Database("path/to/db.sqlite3")
//        database = Database(filePath);
        
//        table = database["storage"]
//        let id = NSExpression(literal: "id")
//        key = NSExpression(literal: "key")
//        value = NSExpression(literal: "value")
        
        
//        database.create(table: table,temporary:false,ifNotExists: true) { t in
//            t.column(id, primaryKey: true)
//            t.column(self.key, unique: true)
//            t.column(self.value)
//        }
    }
//    private var table:Query;
//    private var key:NSExpression;
//    private var value:NSExpression;
    
    fileprivate var lock:NSLock;
    
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

open class StorageArgs{
    
    var insts:Dictionary<String,StorageImpl>;
    fileprivate var lock:NSLock;
    
    fileprivate init(){
        self.insts = Dictionary<String,StorageImpl>();
        self.lock = NSLock();
    }
    
    open subscript(position:StoragePosition,path:String)->StorageImpl {
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
    
    open var document:StorageImpl{
        return self[StoragePosition.document,"document.storage"];
    }
    
    open var tmp:StorageImpl{
        return self[StoragePosition.tmp,"tmp.storage"];
    }
    
    open var library:StorageImpl{
        return self[StoragePosition.library,"library.storage"];
    }
    
    open var cache:StorageImpl{
        return self[StoragePosition.cache,"cache.storage"];
    }
    
    open var memory:StorageImpl{
        return self[StoragePosition.memory,""];
    }
}

private struct YRSingleton{
    
    static var instance:StorageArgs? = nil
}

private var __once:() = {
    YRSingleton.instance = StorageArgs();
}();

public var Storage:StorageArgs{
    _ = __once;
    return YRSingleton.instance!
}
