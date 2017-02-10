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

public func writeInt8( _ buffer: inout [UInt8],value:Int8,offset:Int = 0){
    buffer[offset] = (UInt8)(value);
}

public func readInt8(_ buffer:[UInt8],offset:Int = 0)->Int8{

    return Int8(buffer[offset]);
    
}

public func writeInt16(_ buffer:inout [UInt8],value:Int16,offset:Int = 0){
    var value = value
    withUnsafePointer(to: &value) { ptr -> () in
//        let uptr = UnsafePointer<UInt8>(ptr);
        let uptr = UnsafeRawPointer(ptr).bindMemory(to: UInt8.self, capacity: 2);
        for n in 0 ..< 2 {
            buffer[n + offset] = (UInt8)(uptr[1-n]);
        }
    };
}

public func readInt16(_ buffer:[UInt8],offset:Int = 0)->Int16{
    
    var value:Int16 = 0;
    
    withUnsafeMutablePointer(to: &value) { ptr -> () in
        
//        let uptr = UnsafeMutablePointer<UInt8>(ptr);
        ptr.withMemoryRebound(to: UInt8.self, capacity: 2, { uptr -> () in
            for n in 0 ..< 2 {
                uptr[1-n] = buffer[n + offset];
            }
        })
        
    };
    
    return value;
    
}

public func writeInt32(_ buffer:inout [UInt8],value:Int32,offset:Int = 0){
    var value = value
    withUnsafePointer(to: &value) { ptr -> () in
//        let uptr = UnsafePointer<UInt8>(ptr);
        let uptr = UnsafeRawPointer(ptr).bindMemory(to: UInt8.self, capacity: 4);
        for n in 0 ..< 4 {
            buffer[n + offset] = (UInt8)(uptr[3-n]);
        }
    };
}

public func readInt32(_ buffer:[UInt8],offset:Int)->Int32{
    
    var value:Int32 = 0;
    
    withUnsafeMutablePointer(to: &value) { ptr -> () in
        
//        let uptr = UnsafeMutablePointer<UInt8>(ptr);
//        let uptr = UnsafeRawPointer(ptr).bindMemory(to: UInt8.self, capacity: 4);
//        for n in 0 ..< 4 {
//            uptr[3-n] = buffer[n + offset];
//        }
        ptr.withMemoryRebound(to: UInt8.self, capacity: 4, { uptr -> () in
            for n in 0 ..< 4 {
                uptr[3-n] = buffer[n + offset];
            }
        })
    };
    
    return value;

}

public func writeInt64(_ buffer:inout [UInt8],value:Int64,offset:Int = 0){
    var value = value
    withUnsafePointer(to: &value) { ptr -> () in
//        let uptr = UnsafePointer<UInt8>(ptr);
        let uptr = UnsafeRawPointer(ptr).bindMemory(to: UInt8.self, capacity: 8);
        for n in 0 ..< 8 {
            buffer[n + offset] = (UInt8)(uptr[7-n]);
        }
    };
}

public func readInt64(_ buffer:[UInt8],offset:Int = 0)->Int64{
    
    var value:Int64 = 0;
    
    withUnsafeMutablePointer(to: &value) { ptr -> () in
        
//        let uptr = UnsafeMutablePointer<UInt8>(ptr);
//        let uptr = UnsafeRawPointer(ptr).bindMemory(to: UInt8.self, capacity: 8);
        ptr.withMemoryRebound(to: UInt8.self, capacity: 4, { uptr -> () in
            for n in 0 ..< 8 {
                uptr[7-n] = buffer[n + offset];
            }
        })
    };
    
    return value;

}

public func writeBytes(_ dest:inout [UInt8],value:[UInt8],length:Int,destOffset:Int = 0,sourceOffset:Int = 0){
    //for(var n=0;n<length && sourceOffset + n < value.count && destOffset + n < value.count;n += 1){
    
    var count = length;
    if count > value.count - sourceOffset {
        count = value.count - sourceOffset;
    }
    
    if count > value.count - destOffset {
        count = value.count - destOffset;
    }
    
    for n in 0 ..< count {
        dest[sourceOffset + n] = value[destOffset + n];
    }
}

public func readBytes(_ dest:[UInt8],value:inout [UInt8],length:Int,destOffset:Int = 0,sourceOffset:Int = 0){
    //for var n=0;n<length && sourceOffset + n < value.count && destOffset + n < value.count;n += 1 {
    var count = length;
    if count > value.count - sourceOffset {
        count = value.count - sourceOffset;
    }
    
    if count > value.count - destOffset {
        count = value.count - destOffset;
    }
    
    for n in 0 ..< count {
        value[sourceOffset + n] = dest[destOffset + n];
    }
}

public func writeFloat(_ buffer:inout [UInt8],value:Float32,offset:Int = 0){
    var value = value
    withUnsafePointer(to: &value) { ptr -> () in
//        let uptr = UnsafePointer<UInt8>(ptr);
        let uptr = UnsafeRawPointer(ptr).bindMemory(to: UInt8.self, capacity: 8);
        for n in 0 ..< 4 {
            buffer[n + offset] = (UInt8)(uptr[7-n]);
        }
    };
}

public func readFloat(_ buffer:[UInt8],offset:Int = 0)->Float32{
    
    var value:Float32 = 0.0;
    
    withUnsafeMutablePointer(to: &value) { ptr -> () in
        
//        let uptr = UnsafeMutablePointer<UInt8>(ptr);
//        let uptr = UnsafeRawPointer(ptr).bindMemory(to: UInt8.self, capacity: 8);
        ptr.withMemoryRebound(to: UInt8.self, capacity: 4, { uptr -> () in
            for n in 0 ..< 8 {
                uptr[7-n] = buffer[n + offset];
            }
        })
    };
    
    return value;
}

public func writeDouble(_ buffer:inout [UInt8],value:Float64,offset:Int = 0){
    var value = value
    withUnsafePointer(to: &value) { ptr -> () in
//        let uptr = UnsafePointer<UInt8>(ptr);
        let uptr = UnsafeRawPointer(ptr).bindMemory(to: UInt8.self, capacity: 8);
        for n in 0 ..< 8 {
            buffer[n + offset] = (UInt8)(uptr[7-n]);
        }
    };
}

public func readDouble(_ buffer:[UInt8],offset:Int = 0)->Float64{
    
    var value:Float64 = 0.0;

    withUnsafeMutablePointer(to: &value) { ptr -> () in
        
//        let uptr = UnsafeMutablePointer<UInt8>(ptr);
//        let uptr = UnsafeRawPointer(ptr).bindMemory(to: UInt8.self, capacity: 8);
        ptr.withMemoryRebound(to: UInt8.self, capacity: 4, { uptr -> () in
            for n in 0 ..< 8 {
                uptr[7-n] = buffer[n + offset];
            }
        })
    };
    
    return value;
}

//=============================================================================================
//
//
//
//=============================================================================================

public func asInt8(value:UInt8)->Int8{
    var value = value
    
    var r:Int8 = 0;
    
    withUnsafeMutableBytes(of: &r, {(dest) -> () in
        withUnsafeMutableBytes(of: &value, { (src) -> () in
            dest[0] = src[0];
        })
    });
    
    return r;
}

public func asUInt8(_ value:Int8)->UInt8{
    var value = value
    
    var r:UInt8 = 0;
    
    withUnsafeMutableBytes(of: &r, {(dest) -> () in
        withUnsafeMutableBytes(of: &value, { (src) -> () in
            dest[0] = src[0];
        })
    });
    
    return r;
}

public func asInt32(_ value:UInt32)->Int32{
    var value = value
    
    var r:Int32 = 0;
    
//    withUnsafeMutablePointers(&r, &value) { (dest, src) -> () in
//        let destPtr = UnsafeMutablePointer<UInt8>(dest);
//        let srcPtr = UnsafeMutablePointer<UInt8>(src);
//        for n in 0 ..< 4 {
//            destPtr[n] = srcPtr[n];
//        }
//    }
    withUnsafeMutableBytes(of: &r, {(dest) -> () in
        withUnsafeMutableBytes(of: &value, { (src) -> () in
            for n in 0 ..< 4 {
                dest[n] = src[n];
            }
        })
    });
    return r;
}

public func asUInt32(_ value:Int32)->UInt32{
    var value = value
    
    var r:UInt32 = 0;
    
    withUnsafeMutableBytes(of: &r) { (dest) -> () in
        withUnsafeMutableBytes(of: &value, { (src) -> () in
            
            for n in 0 ..< 4 {
                dest[n] = src[n];
            }
        })
    }
    
    return r;
}

public func asInt64(_ value:UInt64)->Int64{
    var value = value
    
    var r:Int64 = 0;
    
//    withUnsafeMutablePointers(&r, &value) { (dest, src) -> () in
//        let destPtr = UnsafeMutablePointer<UInt8>(dest);
//        let srcPtr = UnsafeMutablePointer<UInt8>(src);
//        for n in 0 ..< 8 {
//            destPtr[n] = srcPtr[n];
//        }
//    }
    
    withUnsafeMutableBytes(of: &r) { (dest) -> () in
        withUnsafeMutableBytes(of: &value, { (src) -> () in
            
            for n in 0 ..< 8 {
                dest[n] = src[n];
            }
        })
    }
    
    return r;
}

public func asUInt64(_ value:Int64)->UInt64{
    var value = value
    
    var r:UInt64 = 0;
    
//    withUnsafeMutablePointers(&r, &value) { (dest, src) -> () in
//        let destPtr = UnsafeMutablePointer<UInt8>(dest);
//        let srcPtr = UnsafeMutablePointer<UInt8>(src);
//        for n in 0 ..< 8 {
//            destPtr[n] = srcPtr[n];
//        }
//    }
    
    withUnsafeMutableBytes(of: &r) { (dest) -> () in
        withUnsafeMutableBytes(of: &value, { (src) -> () in
            
            for n in 0 ..< 8 {
                dest[n] = src[n];
            }
        })
    }
    
    return r;
}
