//
//  Storage.swift
//  LinCore
//
//  Created by lin on 12/17/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation
import CessUtil

/*
*
*  把数据存储到本地
*
*/
open class StorageImpl{

    fileprivate var path:String;
    fileprivate var position:StoragePosition;
    fileprivate var filePath:String;
    private var database:KeyValueDatabase;
    
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
        database = KeyValueDatabase.open(filePath);
        
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
    
    public subscript(key:String)->Any!{
        get{
            return getItem(key);
        }
        set{
            setItem(newValue, forKey: key);
        }
    }
    
    public func getItem(_ key:String)->Any!{
        lock.lock();
        var r:Any! = nil;
        if let valueString = self.database.getItem(key) {
        //                var valueString = query.first?.get(self.value);
        //                let decodedData = NSData(base64EncodedString: resp!, options: NSDataBase64DecodingOptions(0))
        let data = NSData(base64Encoded: valueString,options: NSData.Base64DecodingOptions.init(rawValue: 0));
        r = NSKeyedUnarchiver.unarchiveObject(with:data! as Data)
        }
        lock.unlock();
        return r;
    }
    
    public func setItem(_ value:Any!,forKey key:String){
        lock.lock();
        let data:NSData=NSKeyedArchiver.archivedData(withRootObject: value) as NSData;
        let base64String = data.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0));
        
        database.setItem(key, value: base64String);
        //            if let query = getItem(key) {
        //                query.
        ////                self.value = base64String;
        ////                query.update(self.value <- base64String)?;
        //            }else{
        //                self.table.insert(self.key <- key, self.value <- base64String)?
        //                //self.table.update(<#values: Setter#>...)
        ////                if let insertedID = self.table.insert(self.key <- key, self.value <- base64String) {
        ////                    //println("inserted id: \(insertedID)")
        ////                    // inserted id: 1
        ////                    //alice = users.filter(id == insertedID)
        ////                }
        //            }
        lock.unlock();
    }
    
    public func removeItem(_ key : String){
        database.removeItem(key);
    }
    
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

private struct LocalStorageYRSingleton{
    
    static var instance:StorageImpl? = nil
}

private var __localStorage_once:() = {
    _ = __once;
    LocalStorageYRSingleton.instance = YRSingleton.instance?[StoragePosition.cache,"local_storage.storage"];
}();

public var LocalStorage:StorageImpl{
    _ = __localStorage_once;
    return LocalStorageYRSingleton.instance!
}
