//
//  CommandProtocolParser_010.swift
//  LinClient
//
//  Created by lin on 1/21/16.
//  Copyright © 2016 lin. All rights reserved.
//

import LinUtil

public class TcpCommandProtocolParser_010:TcpAbstractProtocolParser{
    required public init(){
        
    }
    
    public override func parse()->TcpPackage!{
        
        let command = readInt32(buffer, offset: 3);
        //        let cls = YRSingleton.instance[Int32(command)]?.resp;
        //        if cls == nil{
        //            return nil;
        //        }
        //        let pack = cls!.init();
        //
        //        if pack is TcpCommandResponsePackage {
        //            (pack as! TcpCommandResponsePackage).parse(buffer,offset: offset);
        //        }
        //        
        //        return pack;
        var commandPack:TcpCommandPackage! = nil;
        if state == TcpPackageState.REQUEST {
            //return TcpCommandPackageManager.requestParse(buffer);
            commandPack = TcpCommandPackageManager.newRequestInstance(command);
        }else{
            commandPack = TcpCommandPackageManager.newResponseInstance(command);
        }
        return commandPack;
    }
    
  public override class
    var type:UInt8{
        return 1;
    }
   
}

//除了ErrorParser外，全部加版本号  主.副.修.build  8bit.8bit.8bit.32bit

//如果版本号全0，且无内容数据，则表示请求对端所有支持的版本号，返回格式固定为 (8bit.8bit.8bit)* 无build版本号 在最后加一个32bit的build版本号