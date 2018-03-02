//
//  TableTestViewModel.swift
//  demo
//
//  Created by lin on 27/04/2017.
//  Copyright © 2017 lin. All rights reserved.
//

import CessRac
import CessUtil

public class TableTestViewModel : AbsViewModel<TableTestController>{
    
    public func refresh(_ complete:@escaping (Any?)->()){
        
        Queue.asynThread {
            Thread.sleep(forTimeInterval: 3);
            Queue.mainQueue {
                complete(nil);
            }
        }
    }
    
    public func loadmore(_ complete:@escaping (Any?)->()){
        
        Queue.asynThread {
            Thread.sleep(forTimeInterval: 3);
            Queue.mainQueue {
                complete(nil);
            }
        }
    }
    
    deinit {
        print("deinit table vm...");
    }
}
