//
//  AbsViewModel.swift
//  LinRac
//
//  Created by lin on 14/02/2017.
//  Copyright © 2017 lin. All rights reserved.
//

import Foundation

public class AbsViewModel<T:BaseView>: NSObject,ViewModel {
    public typealias ViewType = T
    
    public func start() {
        
    }
}
