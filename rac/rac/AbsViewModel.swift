//
//  AbsViewModel.swift
//  LinRac
//
//  Created by lin on 14/02/2017.
//  Copyright © 2017 lin. All rights reserved.
//

import Foundation

open class AbsViewModel<T:BaseView>: NSObject,ViewModel {
    public typealias ViewType = T
    
    open func start() {
        
    }
}
