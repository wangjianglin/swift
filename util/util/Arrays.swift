//
//  Arrays.swift
//  LinUtil
//
//  Created by lin on 7/4/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import UIKit

public struct ArrayExt<Element>{
    public var arr: Array<Element>
    
    fileprivate init(_ arr: Array<Element>) {
        self.arr = arr
    }
}

public extension Array{
    
    public var ext:ArrayExt<Element>{
        get{
            return ArrayExt<Element>.init(self);
        }
        mutating set{
            self = newValue.arr
        }
    }
}
extension ArrayExt{
    
    public mutating func addObjectsFromArray(_ arr:Array<Element>?){
        if let arr = arr {
            for item in arr {
                self.arr.append(item);
            }
        }
    }
    
    public mutating func addObjectsFromArray(_ arr:Array<Element>?,isEqual:((_ a:Element,_ b:Element)->Bool)){
        
        if let arr = arr {
            
            if self.arr.count == 0 || arr.count == 0 {
                self.addObjectsFromArray(arr);
                return;
            }
            
            var tmp = Array<Element>();
            var addFalsg = true;
            for item in arr {
                addFalsg = true;
                for obj in self.arr {
                    if isEqual(item,obj) {
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



extension ArrayExt where Element : Equatable{
    
    /// 删除数组指定的元素
    ///
    /// - parameter element: 需要删除的元素
    public mutating func remove(_ element : Element) -> () {
        if let index = self.arr.index(of: element) {
            self.arr.remove(at: index)
        }
    }
    
    /// 删除数组指定的多个元素
    ///
    /// - parameter element: 需要删除的元素数组
    public mutating func remove(_ elements : [Element]) -> () {
        var removeIndexes = [Int]()
        for (ix,e) in self.arr.enumerated() {
            if elements.contains(e) {
                removeIndexes.append(ix)
            }
        }
        removeIndexes = removeIndexes.sorted().reversed()
    }
    
    /// 去重子数组
    public var duplicateRemovalArray : Array<Element> {
        var dArr = [Element]()
        for item in self.arr {
            if !dArr.contains(item) {
                dArr.append(item)
            }
        }
        return dArr
    }
}
