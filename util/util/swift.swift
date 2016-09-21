//
//  swift.swift
//  LinUtil
//
//  Created by lin on 5/18/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation



open class IndexProperty<Key:Hashable,Value>{
    
    fileprivate var values = Dictionary<Key,Value>();
    public init(){
        
    }
    
    open subscript(key:Key)->Value?{
        get{
            return values[key];
        }
        set{
            values[key] = newValue;
        }
    }
    
    open func remove(_ key:Key){
        values.removeValue(forKey: key);
    }
}

//MARK:SequenceType
extension IndexProperty : Sequence {
    
//    public typealias Generator = DictionaryGenerator<Key, Value>
    
    //public func makeIterator()->DictionaryGenerator<Key,Value> {
    //    return values.makeIterator();
    //}
    
    
    
    
    public func makeIterator()->DictionaryIterator<Key, Value> {
        return values.makeIterator();
    }
//    public func mutableCopyOfTheObject() -> AnyObject {
//        return values.mutableCopy()
//    }
}
