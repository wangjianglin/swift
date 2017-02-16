//
//  UISearchControll.swift
//  puer
//
//  Created by lin on 12/02/2017.
//  Copyright © 2017 lin. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result


private var searchAddress = 0;

extension Reactive where Base: UISearchController{
    public var search:CocoaAction<Base>?{
        get{
            return base.getAssociatedValue(forAddress: &searchAddress);
        }
        nonmutating set{
            let a = newValue;
            if let delegate = base.searchBar.delegate as? NSObject{
                delegate.reactive.trigger(for: #selector(UISearchBarDelegate.searchBarTextDidEndEditing)).observe({[weak base] observe in
                    
                    switch observe {
                    case .value(_):
                        base?.dismiss(animated: true, completion: nil);
                        a?.execute(base!);
                        break;
                    default: break
                        
                    }
                })
                
            }
            base.setAssociatedValue(value: newValue, forAddress: &searchAddress);
        }
    }
}
