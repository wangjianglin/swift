//
//  TableTestController.swift
//  demo
//
//  Created by lin on 27/04/2017.
//  Copyright © 2017 lin. All rights reserved.
//

import Foundation
import UIKit
import CessRac
import ReactiveCocoa
import ReactiveSwift

public class TableTestController : UITableViewController,BaseView{
    
    private lazy var vm:TableTestViewModel = {
        var _vm = TableTestViewModel();
        _vm.view = self;
        return _vm;
    }();
    
    public override func viewDidLoad() {
        
        
        self.tableView.reactive.refresh = ~vm.refresh
        self.tableView.reactive.refresh?.addOverlay(self);
        self.tableView.reactive.refresh?.confirm("ok");
        
        self.tableView.reactive.loadmore = ~vm.loadmore
        self.tableView.reactive.loadmore?.addOverlay(self);
        
        self.tableView.mj_header.beginRefreshing();
    }
    
    deinit {
        print("deinit table ...");
    }
}
