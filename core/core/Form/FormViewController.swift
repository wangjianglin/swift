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
    @objc optional
    func formViewController(_ controller: FormViewController, didSelectRowDescriptor: FormRowDescriptor)
}

open class FormViewController : UITableViewController {

    /// MARK: Types

    
    /// MARK: Properties
    
    open var form: FormDescriptor!{
        didSet{
            self.tableView?.reloadData();
        }
    }
    
    open weak var delegate: FormViewControllerDelegate?
    
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        baseInit()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        baseInit()
    }
    
    fileprivate func baseInit() {
    }
    
    /// MARK: View life cycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.title = form.title
    }
    
    /// MARK: UITableViewDataSource
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return form.sections.count
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.sections[section].rows.count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowDescriptor = formRowDescriptorAtIndexPath(indexPath)
        
        let formBaseCellClass = rowDescriptor.formBaseCellClassFromRowDescriptor()
        
        let reuseIdentifier = NSStringFromClass(formBaseCellClass!)
        
        var cell: FormBaseCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? FormBaseCell
        if cell == nil {
            
            cell = formBaseCellClass?.init(style: rowDescriptor.cellStyle, reuseIdentifier: reuseIdentifier)
            cell?.configure()
        }
        
        cell?.rowDescriptor = rowDescriptor
        
        // apply cell custom design
//        for (keyPath, value) in [:] {
//            cell?.setValue(value, forKeyPath: keyPath)
//        }
        
        return cell!
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return form.sections[section].headerTitle
    }
    
    override open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return form.sections[section].footerTitle
    }
    
    /// MARK: UITableViewDelegate
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let rowDescriptor = formRowDescriptorAtIndexPath(indexPath)
        
        if let formBaseCellClass = rowDescriptor.formBaseCellClassFromRowDescriptor() {
            return formBaseCellClass.formRowCellHeight()
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let rowDescriptor = formRowDescriptorAtIndexPath(indexPath)
        
        if let selectedRow = tableView.cellForRow(at: indexPath) as? FormBaseCell {
            if let formBaseCellClass = rowDescriptor.formBaseCellClassFromRowDescriptor() {
                formBaseCellClass.formViewController(self, didSelectRow: selectedRow)
            }
        }
        
        delegate?.formViewController?(self, didSelectRowDescriptor: rowDescriptor)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// MARK: Private interface
    
    fileprivate class func isSelectionableRowDescriptor(_ rowType: FormRowType) -> Bool {
        switch( rowType ) {
        case .button, .booleanCheck, .picker, .date, .time, .dateAndTime:
            return true
        default:
            return false
        }
    }
    
    
    
    fileprivate func formRowDescriptorAtIndexPath(_ indexPath: IndexPath!) -> FormRowDescriptor {
        let section = form.sections[indexPath.section]
        let rowDescriptor = section.rows[indexPath.row]
        return rowDescriptor
    }
    
   
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
