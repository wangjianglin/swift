//
//  Bytes.swift
//  LinUtil
//
//  Created by lin on 1/23/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


//public func write(inout buffer:[UInt8],value:UInt16,offset:Int = 0){
//    
//    buffer[offset] = (UInt8) ((value & 0xFF00) >> 8);
//    buffer[offset + 1] = (UInt8) (value & 0x00FF);
//}

public func writeInt8(inout buffer:[UInt8],value:Int8,offset:Int = 0){
    buffer[offset] = (UInt8)(value);
}

public func readInt8(buffer:[UInt8],offset:Int = 0)->Int8{

    return Int8(buffer[offset]);
    
}

public func writeInt16(inout buffer:[UInt8],var value:Int16,offset:Int = 0){
    withUnsafePointer(&value) { ptr -> () in
        let uptr = UnsafePointer<UInt8>(ptr);
        for(var n=0;n<2;n++){
            buffer[n + offset] = (UInt8)(uptr[1-n]);
        }
    };
}

public func readInt16(buffer:[UInt8],offset:Int = 0)->Int16{
    
    var value:Int16 = 0;
    
    withUnsafeMutablePointer(&value) { ptr -> () in
        
        let uptr = UnsafeMutablePointer<UInt8>(ptr);
        for(var n=0;n<2;n++){
            uptr[1-n] = buffer[n + offset];
        }
    };
    
    return value;
    
}

public func writeInt32(inout buffer:[UInt8],var value:Int32,offset:Int = 0){
    withUnsafePointer(&value) { ptr -> () in
        let uptr = UnsafePointer<UInt8>(ptr);
        for(var n=0;n<4;n++){
            buffer[n + offset] = (UInt8)(uptr[3-n]);
        }
    };
}

public func readInt32(buffer:[UInt8],offset:Int)->Int32{
    
    var value:Int32 = 0;
    
    withUnsafeMutablePointer(&value) { ptr -> () in
        
        let uptr = UnsafeMutablePointer<UInt8>(ptr);
        for(var n=0;n<4;n++){
            uptr[3-n] = buffer[n + offset];
        }
    };
    
    return value;

}

public func writeInt64(inout buffer:[UInt8],var value:Int64,offset:Int = 0){
    withUnsafePointer(&value) { ptr -> () in
        let uptr = UnsafePointer<UInt8>(ptr);
        for(var n=0;n<8;n++){
            buffer[n + offset] = (UInt8)(uptr[7-n]);
        }
    };
}

public func readInt64(buffer:[UInt8],offset:Int = 0)->Int64{
    
    var value:Int64 = 0;
    
    withUnsafeMutablePointer(&value) { ptr -> () in
        
        let uptr = UnsafeMutablePointer<UInt8>(ptr);
        for(var n=0;n<8;n++){
            uptr[7-n] = buffer[n + offset];
        }
    };
    
    return value;

}

public func writeBytes(inout dest:[UInt8],value:[UInt8],length:Int,destOffset:Int = 0,sourceOffset:Int = 0){
    for(var n=0;n<length && sourceOffset + n < value.count && destOffset + n < value.count;n++){
        dest[sourceOffset + n] = value[destOffset + n];
    }
}

public func readBytes(dest:[UInt8],inout value:[UInt8],length:Int,destOffset:Int = 0,sourceOffset:Int = 0){
    for(var n=0;n<length && sourceOffset + n < value.count && destOffset + n < value.count;n++){
        value[sourceOffset + n] = dest[destOffset + n];
    }
}

public func writeFloat(inout buffer:[UInt8],var value:Float32,offset:Int = 0){
    withUnsafePointer(&value) { ptr -> () in
        let uptr = UnsafePointer<UInt8>(ptr);
        for(var n=0;n<4;n++){
            buffer[n + offset] = (UInt8)(uptr[7-n]);
        }
    };
}

public func readFloat(buffer:[UInt8],offset:Int = 0)->Float32{
    
    var value:Float32 = 0.0;
    
    withUnsafeMutablePointer(&value) { ptr -> () in
        
        let uptr = UnsafeMutablePointer<UInt8>(ptr);
        for(var n=0;n<8;n++){
            uptr[7-n] = buffer[n + offset];
        }
    };
    
    return value;
}

public func writeDouble(inout buffer:[UInt8],var value:Float64,offset:Int = 0){
    withUnsafePointer(&value) { ptr -> () in
        let uptr = UnsafePointer<UInt8>(ptr);
        for(var n=0;n<8;n++){
            buffer[n + offset] = (UInt8)(uptr[7-n]);
        }
    };
}

public func readDouble(buffer:[UInt8],offset:Int = 0)->Float64{
    
    var value:Float64 = 0.0;

    withUnsafeMutablePointer(&value) { ptr -> () in
        
        let uptr = UnsafeMutablePointer<UInt8>(ptr);
        for(var n=0;n<8;n++){
            uptr[7-n] = buffer[n + offset];
        }
    };
    
    return value;
}

//=============================================================================================
//
//
//
//=============================================================================================

public func asInt8(var value:UInt8)->Int8{
    
    var r:Int8 = 0;
    
    withUnsafeMutablePointers(&r, &value) { (dest, src) -> () in
        let destPtr = UnsafeMutablePointer<UInt8>(dest);
        let srcPtr = UnsafeMutablePointer<UInt8>(src);
        destPtr[0] = srcPtr[0];
    }
    
    return r;
}

public func asUInt8(var value:Int8)->UInt8{
    
    var r:UInt8 = 0;
    
    withUnsafeMutablePointers(&r, &value) { (dest, src) -> () in
        let destPtr = UnsafeMutablePointer<UInt8>(dest);
        let srcPtr = UnsafeMutablePointer<UInt8>(src);
        
        destPtr[0] = srcPtr[0];
        
    }
    
    return r;
}

public func asInt32(var value:UInt32)->Int32{
    
    var r:Int32 = 0;
    
    withUnsafeMutablePointers(&r, &value) { (dest, src) -> () in
        let destPtr = UnsafeMutablePointer<UInt8>(dest);
        let srcPtr = UnsafeMutablePointer<UInt8>(src);
        for(var n=0;n<4;n++){
            destPtr[n] = srcPtr[n];
        }
    }
    
    return r;
}

public func asUInt32(var value:Int32)->UInt32{
    
    var r:UInt32 = 0;
    
    withUnsafeMutablePointers(&r, &value) { (dest, src) -> () in
        let destPtr = UnsafeMutablePointer<UInt8>(dest);
        let srcPtr = UnsafeMutablePointer<UInt8>(src);
        for(var n=0;n<4;n++){
            destPtr[n] = srcPtr[n];
        }
    }
    
    return r;
}

public func asInt64(var value:UInt64)->Int64{
    
    var r:Int64 = 0;
    
    withUnsafeMutablePointers(&r, &value) { (dest, src) -> () in
        let destPtr = UnsafeMutablePointer<UInt8>(dest);
        let srcPtr = UnsafeMutablePointer<UInt8>(src);
        for(var n=0;n<8;n++){
            destPtr[n] = srcPtr[n];
        }
    }
    
    return r;
}

public func asUInt64(var value:Int64)->UInt64{
    
    var r:UInt64 = 0;
    
    withUnsafeMutablePointers(&r, &value) { (dest, src) -> () in
        let destPtr = UnsafeMutablePointer<UInt8>(dest);
        let srcPtr = UnsafeMutablePointer<UInt8>(src);
        for(var n=0;n<8;n++){
            destPtr[n] = srcPtr[n];
        }
    }
    
    return r;
}