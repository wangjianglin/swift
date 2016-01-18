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
    case Off = 0
//    case Fatal = 0
    case Error = 3
    case Warn = 4
    case Info = 6
    case Debug = 7
    case Trace = 8
//    case All = 8

    public var description:String{
        switch self{
        case Off:
            return "Off";
        case Error:
            return "Error";
        case Warn:
            return "Warn";
        case Info:
            return "Info";
        case Debug:
            return "Debug";
        case Trace:
            return "Trace";
        }
    }
}
public class Log{
    
    private var name:String;
    public var level:LogLevel = LogLevel.Info;
    
    public init(name:String){
        self.name = name;
//        self.level = level;
    }
    
    public func info(info infoStr:String){
        Log.logStr(name,str:infoStr,level:LogLevel.Info,log:self);
    }
    
    public func error(error erroStr:String){
        Log.logStr(name,str:erroStr,level:LogLevel.Error,log:self);
    }
    
    public func warn(warn warnStr:String){
        Log.logStr(name,str:warnStr,level:LogLevel.Warn,log:self);
    }
    
    public func debug(debug debugStr:String){
        Log.logStr(name,str:debugStr,level:LogLevel.Debug,log:self);
    }
    
    public func trace(trace traceStr:String){
        Log.logStr(name,str:traceStr,level:LogLevel.Trace,log:self);
    }
    
    public class var log:Log{
        struct NSLockStruct{
            static var one:dispatch_once_t = 0;
            static var install:Log!;
        }
        dispatch_once(&NSLockStruct.one,{
            NSLockStruct.install = Log(name:"log");
        });
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
    
 
    
    private class var lock:NSLock{
        struct NSLockStruct{
            static var one:dispatch_once_t = 0;
            static var install:NSLock!;
        }
        dispatch_once(&NSLockStruct.one,{
            NSLockStruct.install = NSLock();
        });
        return NSLockStruct.install;
    }
    private class func logStr(name:String,str:String,level:LogLevel,log:Log){
        
        if level.rawValue > log.level.rawValue {
            return;
        }
        let newstr = (str as NSString).stringByReplacingOccurrencesOfString("\n", withString:"\n\t");
        let date = NSDate();
        let filename = Log.getFilename(name,date:date);
        let format = NSDateFormatter();
        format.dateFormat = "yyyy-MM-dd HH:mm:ss";
        Log.lock.lock();
        Log.logStrImpl("[\(level.description)]\(format.stringFromDate(date)) \(newstr)\n",filename:filename);
        Log.lock.unlock();
    }
    private class func getFilename(name:String,date:NSDate)->String{
        var fileManager = NSFileManager.defaultManager();
        
        var format = NSDateFormatter();
        format.dateFormat = "yyyy-MM-dd";
        #if iOS7
            var path = seller.pathFor(Documents.Document,"log")!;
            #else
            var path = LinUtil.pathFor(Documents.Document,path: "log")!;
        #endif
        
        var isDir = UnsafeMutablePointer<ObjCBool>.alloc(1);
        isDir.initialize(ObjCBool(false));
        fileManager.fileExistsAtPath(path, isDirectory: isDir);
        
        if !isDir.move().boolValue {
            do {
                try fileManager.createDirectoryAtPath(path,withIntermediateDirectories:true,attributes:nil)
            } catch _ {
            };
        }
        var filename = "\(path)/\(name)-\(format.stringFromDate(date)).txt";
        
        
//        if filesize > 600 * 1024 {
        for var n=1 ; ; n++ {
            if fileManager.fileExistsAtPath(filename) {
                var filesize = ((try? fileManager.attributesOfItemAtPath(filename))?["NSFileSize"] as? Int) ?? 0;
                if filesize > 600 * 1024 {
                    filename = "\(path)/\(name)-\(format.stringFromDate(date))-\(n).txt";
                    continue;
                }
            }
            break;
        }
        
        if !fileManager.fileExistsAtPath(filename) {
            //写设备信息
            var str:NSString = UIDevice.currentDevice().toString() + "\n\n";
            fileManager.createFileAtPath(filename, contents: str.dataUsingEncoding(0), attributes: nil);
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
    private class func logStrImpl(str:String,filename:String){
        

        let outFile = NSFileHandle(forWritingAtPath:filename);
        
        if outFile == nil
        {
            return;
        }
        
        //找到并定位到outFile的末尾位置(在此后追加文件)
        //[outFile seekToEndOfFile];
        if outFile?.seekToEndOfFile() > 500 * 1024 {
            
        }
        
        //读取inFile并且将其内容写到outFile中
        
        let buffer = (str as NSString).dataUsingEncoding(NSUTF8StringEncoding);
        
        
        if let buffer = buffer {
            outFile?.writeData(buffer);
        }
        
        //关闭读写文件
        outFile?.closeFile();
     }
}