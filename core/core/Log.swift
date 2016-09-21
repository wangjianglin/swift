//
//  Log.swift
//  LinCore
//
//  Created by lin on 1/29/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation
import UIKit
import LinUtil

public enum LogLevel:Int{
    case off = 0
//    case Fatal = 0
    case error = 3
    case warn = 4
    case info = 6
    case debug = 7
    case trace = 8
//    case All = 8

    public var description:String{
        switch self{
        case .off:
            return "Off";
        case .error:
            return "Error";
        case .warn:
            return "Warn";
        case .info:
            return "Info";
        case .debug:
            return "Debug";
        case .trace:
            return "Trace";
        }
    }
}
open class Log{
    
    struct NSLockStruct{
        static var install:Log!;
    }
    
    struct NSLockStruct1{
        static var install:NSLock!;
    }
    
    fileprivate static var __once1: () = {

            NSLockStruct1.install = NSLock();

        }()

    

    fileprivate static var __once: () = {

            NSLockStruct.install = Log(name:"log");

        }()

    

    fileprivate var name:String;
    open var level:LogLevel = LogLevel.info;
    
    public init(name:String){
        self.name = name;
//        self.level = level;
    }
    
    open func info(info infoStr:String){
        Log.logStr(name,str:infoStr,level:LogLevel.info,log:self);
    }
    
    open func error(error erroStr:String){
        Log.logStr(name,str:erroStr,level:LogLevel.error,log:self);
    }
    
    open func warn(warn warnStr:String){
        Log.logStr(name,str:warnStr,level:LogLevel.warn,log:self);
    }
    
    open func debug(debug debugStr:String){
        Log.logStr(name,str:debugStr,level:LogLevel.debug,log:self);
    }
    
    open func trace(trace traceStr:String){
        Log.logStr(name,str:traceStr,level:LogLevel.trace,log:self);
    }
    
    open class var log:Log{
        
        _ = Log.__once;
        return NSLockStruct.install;
    }
    
//    public class func setUncaughtExceptionLog(){
////        NSSetUncaughtExceptionHandler(exceptionHandlerPtr);
//        
//        UncaughtExceptionHandler.setExceptionHandler(uncaughtExceptionHandlerLog);
//        NSException(name: "Raven test exception", reason: "No reason", userInfo: nil).raise()
//    }
    
//    private class func uncaughtExceptionHandlerLogImpl(exception: NSException!, method:String? = __FUNCTION__, file:String? = __FILE__, line:Int = __LINE__) {
//        
//        var str = "";
//        let message = "\(exception.name): \(exception.reason!)"
//        str = str + message;
//        str = str + "\n" + "type:" + exception.name;
//        str = str + "\n" + "value:" + (exception.reason? ?? "");
//        
//        if (method != nil && file != nil && line > 0) {
//            str = str + "\nfilename\t" + file!.lastPathComponent + " function\t" + method! + "lineno\t\(line)";
//        }
//        
//        let callStack = exception.callStackSymbols
//        
//        for call in callStack {
//            str = str + "\nfunction:\(call)";
//        }
//        Log.log.error(error: str);
//
//        
//    }
//    
//
//    private class func uncaughtExceptionHandlerLog(exception:NSException!)->(){
//        Log.uncaughtExceptionHandlerLogImpl(exception);
//    }
    
 
    
    fileprivate class var lock:NSLock{
        _ = Log.__once1;
        return NSLockStruct1.install;
    }
    fileprivate class func logStr(_ name:String,str:String,level:LogLevel,log:Log){
        
        if level.rawValue > log.level.rawValue {
            return;
        }
        let newstr = (str as NSString).replacingOccurrences(of: "\n", with:"\n\t");
        let date = Date();
        let filename = Log.getFilename(name,date:date);
        let format = DateFormatter();
        format.dateFormat = "yyyy-MM-dd HH:mm:ss";
        Log.lock.lock();
        Log.logStrImpl("[\(level.description)]\(format.string(from: date)) \(newstr)\n",filename:filename);
        Log.lock.unlock();
    }
    fileprivate class func getFilename(_ name:String,date:Date)->String{
        let fileManager = FileManager.default;
        
        let format = DateFormatter();
        format.dateFormat = "yyyy-MM-dd";
       
        let path = LinUtil.pathFor(Documents.document,path: "log")!;
        
        
//        var isDir = UnsafeMutablePointer<ObjCBool>(allocatingCapacity: 1);
        let isDir = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1);
        isDir.initialize(to: ObjCBool(false));
        fileManager.fileExists(atPath: path, isDirectory: isDir);
        
        if !isDir.move().boolValue {
            do {
                try fileManager.createDirectory(atPath: path,withIntermediateDirectories:true,attributes:nil)
            } catch _ {
            };
        }
        var filename = "\(path)/\(name)-\(format.string(from: date)).txt";
        
        
//        if filesize > 600 * 1024 {
        //for var n=1 ; ; n += 1 {
        for n in 1 ... 100000 {
            if fileManager.fileExists(atPath: filename) {
                let filesize = (try? fileManager.attributesOfItem(atPath: filename)[FileAttributeKey("NSFileSize")] as? Int) ?? 0;
//                var filesize = ((try? fileManager.attributesOfItem(atPath: filename))?["NSFileSize"] as? Int) ?? 0;
                if filesize! > 600 * 1024 {
                    filename = "\(path)/\(name)-\(format.string(from: date))-\(n).txt";
                    continue;
                }
            }
            break;
        }
        
        if !fileManager.fileExists(atPath: filename) {
            //写设备信息
            let str = UIDevice.current.toString() + "\n\n";
            fileManager.createFile(atPath: filename, contents: (str as NSString).data(using: 0), attributes: nil);
        }
//        else{
//            //fileManager.[manager attributesOfItemAtPath:filePath error:nil] fileSize
//            var filesize = (fileManager.attributesOfItemAtPath(filename,error:nil)?["NSFileSize"] as? Int)? ?? 0;
//            if filesize > 600 * 1024 {
//                for var n=1 ; ; n++ {
//                    filename = "\(path)/\(name)-\(format.stringFromDate(date))-\(n).txt";
//                    if !fileManager.fileExistsAtPath(filename) {
//                        //写设备信息
//                        var str:NSString = UIDevice.currentDevice().toString();
//                        fileManager.createFileAtPath(filename, contents: str.dataUsingEncoding(0), attributes: nil);
//                        break;
//                    }
//                }
//            }
//        }
        
        return filename;
    }
    private class func logStrImpl(_ str:String,filename:String){
        

        let outFile = FileHandle(forWritingAtPath:filename);
        
        if outFile == nil
        {
            return;
        }
        
        //找到并定位到outFile的末尾位置(在此后追加文件)
        //[outFile seekToEndOfFile];
//        if (outFile?.seekToEndOfFile())! > 500 * 1024 {
//            
//        }
        
        //读取inFile并且将其内容写到outFile中
        
        let buffer = (str as NSString).data(using: String.Encoding.utf8.rawValue);
        
        
        if let buffer = buffer {
            outFile?.write(buffer);
        }
        
        //关闭读写文件
        outFile?.closeFile();
     }
}
