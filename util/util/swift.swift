//
//  swift.swift
//  LinUtil
//
//  Created by lin on 5/18/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation



public class IndexProperty<Key:Hashable,Value>{
    
    private var values = Dictionary<Key,Value>();
    public init(){
        
    }
    
    public subscript(key:Key)->Value?{
        get{
            return values[key];
        }
        set{
            values[key] = newValue;
        }
    }
    
    public func remove(key:Key){
        values.removeValueForKey(key);
    }
}

//MARK:SequenceType
extension IndexProperty : SequenceType {
    
//    public typealias Generator = DictionaryGenerator<Key, Value>
    
    public func generate()->DictionaryGenerator<Key,Value> {
        return values.generate();
    }
//    public func mutableCopyOfTheObject() -> AnyObject {
//        return values.mutableCopy()
//    }
}