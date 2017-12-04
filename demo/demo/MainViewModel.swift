//
//  RACTableViewModel.swift
//  demo
//
//  Created by lin on 18/11/2016.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import LinUtil
import LinComm
import LinRac

public class MainViewModel : NSObject,ViewModel{
    public typealias ViewType = MainViewController;

    
    public dynamic var datas:[VMData]?;
    
    public func start(){
        genDatas();
    }
    
    public func refresh2(_ action: @escaping (Any!)->()){
        Queue.asynQueue {
            Thread.sleep(forTimeInterval: 3);
            //self.datas = ["one","two","three"];
            
            let e = HttpError.init(code: -34, message: "error.", cause: "", stackTrace: "");
            action(e);
        }
    }
    
    private let tables:[Any] = [
        ["RAC","bind","rac",RACViewController2.self],
        ["RAC","bind","",RACViewController2.self],
        ["RAC","camera","",CommodityDetialEditController.self],
        ["RAC","bind","rac",nil],
        ["RAC","bind","table",nil],
        ["Form","个人中心表格设置","tableVC",nil],
        ["Property","属性替换","property",nil]

    ];
    
    private func genDatas(){
        var tmpDatas = [VMData]();
        
        var data:VMData!;
        
        for item in self.tables {
            var items = item as! [Any];
            if data == nil || data.title != items[0] as! String{
                data = VMData();
                data.title = items[0] as! String;
                tmpDatas.append(data);
            }
            
            let itemData = VMDataItem();
            data.items.append(itemData);
            
            itemData.title = items[1] as! String;
            itemData.segue = items[2] as? String;
            itemData.vc = items[3] as? UIViewController.Type;
            
        }
        
        self.datas = tmpDatas;
    }
    
    public func refresh(_ action: @escaping (Any!)->()){
        Queue.asynQueue {
            Thread.sleep(forTimeInterval: 0.1);

            self.genDatas();
            action(nil);
        }
        
    }
}

public class VMData : NSObject{
    public var title = "";
    public var items = [VMDataItem]();
}

public class VMDataItem : NSObject{
    public var title = "";
    public var segue:String? = nil;
    public var vc:UIViewController.Type? = nil;
}
