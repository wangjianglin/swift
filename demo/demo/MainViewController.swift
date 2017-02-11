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


public extension UIBarButtonItem{
    public convenience init(barButtonSystemItem systemItem: UIBarButtonSystemItem){
        self.init(barButtonSystemItem:systemItem, target: nil, action: nil);
        
//        UIImage
    }
}
public class MoreBarButtonItem : UIBarButtonItem{
    public override init(){
        super.init();
        self.target = self;
        self.action = "action:"
    }
    
//    override public var target: AnyObject?{
//        get{return nil;}
//        set{}
//    }
//    
//    override public var action: Selector?{
//        get{return nil;}
//        set{}
//    }
    
    public convenience init(image: UIImage?, style: UIBarButtonItemStyle){
        self.init();
        self.image = image;
        self.style = style;
//        super.init(image: image, style: style, target: self, action: Selector(("action")));
    }
    
    public convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItemStyle) {
        self.init();
        self.image = image;
        self.landscapeImagePhone = landscapeImagePhone;
        self.style = style;
    }
    
    public convenience init(title: String?, style: UIBarButtonItemStyle){
        self.init();
        self.title = title;
        self.style = style;
    }
    
//    public convenience init(barButtonSystemItem systemItem: UIBarButtonSystemItem, target: Any?, action: Selector?){
////        super.init(barButtonSystemItem: systemItem, target: nil, action: nil);
//    }
//    public init(barButtonSystemItem systemItem: UIBarButtonSystemItem){
//        super.init(barButtonSystemItem: systemItem, target: nil, action: nil);
////        self.init();
////        self.image = UIBarButtonItem.init(barButtonSystemItem: systemItem, target: nil, action: nil).image;
////        self.
////        super.init(barButtonSystemItem: systemItem, target: nil, action: nil);
//    }
    
    public convenience init(customView: UIView){
        self.init();
        self.customView = customView;
//        super.init(customView: customView);
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func action(sender:AnyObject){
        print("======================")
    }
}
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
        
        let refresh = MoreBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add);
        
        refresh.target = refresh;
        refresh.action = "action:"
//        let refresh = MoreBarButtonItem.init(title: "加载", style: UIBarButtonItemStyle.plain, target: nil, action: nil);
        
//        self.navigationController?.navigationItem.rightBarButtonItem = refresh;
        self.navigationItem.rightBarButtonItem = refresh;
        
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
