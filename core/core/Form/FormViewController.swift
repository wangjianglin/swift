//
//  FormViewController.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuño on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

@objc
public protocol FormViewControllerDelegate: NSObjectProtocol {
    optional
    func formViewController(controller: FormViewController, didSelectRowDescriptor: FormRowDescriptor)
}

public class FormViewController : UITableViewController {

    /// MARK: Types

    
    /// MARK: Properties
    
    public var form: FormDescriptor!
    
    public weak var delegate: FormViewControllerDelegate?
    
    /// MARK: Init
    
//    override convenience init() {
//        self.init(style: .Grouped)
//    }
    
    convenience init(form: FormDescriptor) {
        self.init()
        self.form = form
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        baseInit()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        baseInit()
    }
    
    private func baseInit() {
    }
    
    /// MARK: View life cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.title = form.title
    }
    
    /// MARK: UITableViewDataSource
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return form.sections.count
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.sections[section].rows.count
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let rowDescriptor = formRowDescriptorAtIndexPath(indexPath)
        
        let formBaseCellClass = rowDescriptor.formBaseCellClassFromRowDescriptor()
        
        let reuseIdentifier = NSStringFromClass(formBaseCellClass)
        
        var cell: FormBaseCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? FormBaseCell
        if cell == nil {
            
            cell = formBaseCellClass.init(style: rowDescriptor.cellStyle, reuseIdentifier: reuseIdentifier)
            cell?.configure()
        }
        
        cell?.rowDescriptor = rowDescriptor
        
        // apply cell custom design
//        for (keyPath, value) in [:] {
//            cell?.setValue(value, forKeyPath: keyPath)
//        }
        
        return cell!
    }
    
    override public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return form.sections[section].headerTitle
    }
    
    override public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return form.sections[section].footerTitle
    }
    
    /// MARK: UITableViewDelegate
    
    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let rowDescriptor = formRowDescriptorAtIndexPath(indexPath)
        
        if let formBaseCellClass = rowDescriptor.formBaseCellClassFromRowDescriptor() {
            return formBaseCellClass.formRowCellHeight()
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let rowDescriptor = formRowDescriptorAtIndexPath(indexPath)
        
        if let selectedRow = tableView.cellForRowAtIndexPath(indexPath) as? FormBaseCell {
            if let formBaseCellClass = rowDescriptor.formBaseCellClassFromRowDescriptor() {
                formBaseCellClass.formViewController(self, didSelectRow: selectedRow)
            }
        }
        
        delegate?.formViewController!(self, didSelectRowDescriptor: rowDescriptor)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    /// MARK: Private interface
    
    private class func isSelectionableRowDescriptor(rowType: FormRowType) -> Bool {
        switch( rowType ) {
        case .Button, .BooleanCheck, .Picker, .Date, .Time, .DateAndTime:
            return true
        default:
            return false
        }
    }
    
    
    
    private func formRowDescriptorAtIndexPath(indexPath: NSIndexPath!) -> FormRowDescriptor {
        let section = form.sections[indexPath.section]
        let rowDescriptor = section.rows[indexPath.row]
        return rowDescriptor
    }
    
   
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
