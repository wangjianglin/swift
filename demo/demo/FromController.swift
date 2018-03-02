
//
//  FromController.swift
//  demo
//
//  Created by 钟亮 on 2017/6/5.
//  Copyright © 2017年 lin. All rights reserved.
//

import UIKit
import CessCore
import CessComm
import CessRac
import ReactiveCocoa
import ReactiveSwift

public class FromController: FormViewController,FormViewControllerDelegate ,BaseView{
    
    private lazy var vm:FromViewModel = {
        var _vm = FromViewModel()
        _vm.view = self
        return _vm
    }()
    
    var countRow:FormRowDescriptor = FormRowDescriptor(title: "", name: "")
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self

        self.loadForm()
        
    }
    
    private func loadForm(){
        let cellBackgroundColor = UIColor(red: 0xf8/255.0, green: 0xfd/255.0, blue: 0xf7/255.0, alpha: 0.98)
        
        let form = FormDescriptor()
        form.title = "form"
        
        var row:FormRowDescriptor = FormRowDescriptor(title: "", name: "")
        
        let section1 = FormSectionDescriptor()
        row = FormSegueDescriptor(title:"线下支付", imageName:"我的订单icon", segue:"test")
        row.backgroundColor = cellBackgroundColor
        section1.addRow(row)
        
        
        row = FormSegueDescriptor(title:"关于翡翠吧吧", imageName:"关于icon", segue:"test")
        row.backgroundColor = cellBackgroundColor
        
        section1.addRow(row)
        
        
        let section2 = FormSectionDescriptor()
        
        countRow = FormSegueDescriptor(title:"设置", imageName:"设置icon", segue:"test")
        
        //row.value = ""
        countRow.reactive.value <~ vm.bind.property(keyPath: "count")
        
        countRow.backgroundColor = cellBackgroundColor
        section2.addRow(countRow)
        
        let section3 = FormSectionDescriptor()
        row = FormSegueDescriptor(title:"听话", imageName:"听话icon", segue:"test")
        row.backgroundColor = cellBackgroundColor
        section3.addRow(row)
        
        
        row = FormGeneralRowDescriptor(title:"分享时带视频链接", name:"", rowType:FormRowType.booleanSwitch, value:0 as NSNumber)
        row.backgroundColor = cellBackgroundColor
        row.enabled = true
        row.valueChange = {(newValue:Any? , oldValue:Any? ) in
            //按钮操作后的响应
        }
        section3.addRow(row)
        
        row = FormGeneralRowDescriptor(title:"分享时带视频链接", imageName:"听话icon", name:"", rowType:FormRowType.booleanSwitch, value:0 as NSNumber)
        row.backgroundColor = cellBackgroundColor
        row.enabled = true
        row.valueChange = {(newValue:Any? , oldValue:Any? ) in
            //按钮操作后的响应
        }
        section3.addRow(row)
        
        form.sections = [section1, section2, section3]
        
        
        
        self.form = form
        
        self.vm.testCount()
    }
    
}
