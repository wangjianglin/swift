//
//  Arrays.swift
//  LinUtil
//
//  Created by lin on 7/4/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation

public extension Array{
    
    public mutating func addObjectsFromArray(arr:Array?){
        if let arr = arr {
            for item in arr {
                self.append(item);
            }
        }
    }
    
    public mutating func addObjectsFromArray(arr:Array?,isEqual:((a:Element,b:Element)->Bool)){
        
        if let arr = arr {
            
            if self.count == 0 || arr.count == 0 {
                self.addObjectsFromArray(arr);
                return;
            }
            
            var tmp = Array();
            var addFalsg = true;
            for item in arr {
                addFalsg = true;
                for obj in self {
                    if isEqual(a: item,b: obj) {
                        addFalsg = false;
                        break;
                    }
                }
                if addFalsg {
                    tmp.append(item);
                }
            }
            self.addObjectsFromArray(tmp);
        }
    }
}