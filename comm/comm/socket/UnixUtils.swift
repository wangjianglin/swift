//
//  UnixUtils.swift
//  LinUtil
//
//  Created by lin on 1/19/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Darwin


/* network utility functions */

func ntohs(_ value: CUnsignedShort) -> CUnsignedShort {
    // hm, htons is not a func in OSX and the macro is not mapped
    return (value << 8) + (value >> 8);
}
let htons = ntohs // same thing, swap bytes :-)



/* ioctl / ioccom stuff */

let IOC_OUT  : CUnsignedLong = 0x40000000

// hh: not sure this is producing the right value
let FIONREAD : CUnsignedLong =
( IOC_OUT
    | ((CUnsignedLong(MemoryLayout<Int32>.size) & CUnsignedLong(IOCPARM_MASK)) << 16)
    | (102 /* 'f' */ << 8) | 127)


/* dispatch convenience */

import Dispatch

extension DispatchSource {
    
    func onEvent(_ cb: @escaping (DispatchSource, CUnsignedLong) -> Void) {
        self.setEventHandler {
            //let data = self.data
            cb(self, self.data)
        }
    }
}
