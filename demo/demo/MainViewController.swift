//
//  RACTable.swift
//  demo
//
//  Created by lin on 18/11/2016.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import Result
import LinRac
import LinCore


public class MainViewController : UIViewController,UITableViewDataSource,UITableViewDelegate,BaseView{
    
    private lazy var vm:MainViewModel = {
        var _vm = MainViewModel();
        _vm.view = self;
        return _vm;
    }();
    
    private var table:UITableView!;
    
    
    public override func loadView() {
        table = UITableView();
        
        table.dataSource = self;
        table.delegate = self;
        
        table.reactive.reloadData <~ vm.bind.changed(keyPath: "datas");
        self.view = table;
    }
    
    public override func viewDidLoad() {
        
        let moreButton = MoreBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add);
        moreButton.vc = self;
//        refresh.target = refresh;
//        refresh.action = "action2:"
//        let refresh = MoreBarButtonItem.init(title: "加载", style: UIBarButtonItemStyle.plain, target: nil, action: nil);
        
//        self.navigationController?.navigationItem.rightBarButtonItem = refresh;
        self.navigationItem.rightBarButtonItem = moreButton;
        
        let add = UIBarButtonItem.init(title: "checkbox1_", style: UIBarButtonItemStyle.plain, target: nil, action: nil);
        add.image = UIImage.init(named: "add.png");
        moreButton.add(button: add);
        moreButton.add(button: add);
        moreButton.add(button: add);
        moreButton.add(button: add);
        moreButton.add(button: add);
        
        moreButton.backgroundColor = UIColor.gray;
        
//        refresh.reactive.pressed = ~vm.refresh2;
//        refresh <~ vm.refresh;
        
//        refresh.reactive.pressed?.addOverlay(self.navigationController)
        
        
        vm.start();
        
//        refresh.reactive.pressed?.execute(refresh);
        
        
//        let s:SignalProducer<(), NoError> = vm.bind.producer(keyPath: "datas");
//        table.reactive.reloadData <~ s;
//        refresh.reactive.pressed = ~vm.refresh;
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return vm.datas?[section].items.count ?? 0;
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return vm.datas?[section].title ?? "";
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return vm.datas?.count ?? 0;
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell();
        cell.textLabel?.text = vm.datas?[indexPath.section].items[indexPath.row].title ?? "";
        
        return cell;
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = vm.datas?[indexPath.section].items[indexPath.row];
        if let item = item  {
            if let segue = item.segue, segue != "" {
                self.performSegue(withIdentifier: segue,sender: nil);
            }else if let vc = item.vc {
                self.navigationController?.pushViewController(vc.init(), animated: true);
            }
        }
    }
    
}




private func g(style:UIBarButtonSystemItem)->UIImage?{
    switch style {
        
    case .done:
        
        break
        
    case .cancel:
        
        break
        
    case .edit:
        
        break
        
    case .save:
        
        break
        
    case .add: break;
        //return self.image(name: "<UIBarButtonSystemItem> add.png", leftCapWidth: 0, topCapHeight: 0)
        
    case .flexibleSpace:
        
        break
        
    case .fixedSpace:
        
        break
        
    case .compose:
        
        break
        
    case .reply:
        
        break
        
    case .action:
        
        break
        
    case .organize:
        
        break
        
    case .bookmarks:
        
        break
        
    case .search:
        
        break
        
    case .refresh:
        
        break
        
    case .stop:
        
        break
        
    case .camera:
        
        break
        
    case .trash:
        
        break
        
    case .play:
        
        break
        
    case .pause:
        
        break
        
    case .rewind:
        
        break
        
    case .fastForward:
        
        break
    default: break
    }
    
    return nil;
}
