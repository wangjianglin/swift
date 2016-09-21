//
//  FormOptionsSelectorController.swift
//  SwiftForms
//
//  Created by Miguel Ángel Ortuño Ortuño on 23/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormOptionsSelectorController: UITableViewController, FormSelector {

    /// MARK: FormSelector
    
    open var formCell: FormBaseCell!
    
    /// MARK: Init 
    
//    public override init() {
//        super.init(style: .Grouped)
//    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = formCell.rowDescriptor.title
    }
    
    /// MARK: UITableViewDataSource

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return formCell.rowDescriptor.options.count
        return 0;
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = NSStringFromClass(type(of: self))
        
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        
//        let optionValue = formCell.rowDescriptor.options[indexPath.row]
//
//        cell?.textLabel?.text = formCell.rowDescriptor.titleForOptionValue(optionValue)
//        
//        if let selectedOptions = formCell.rowDescriptor.value as? [NSObject] {
//            if (find(selectedOptions, optionValue as NSObject) != nil) {
//                if formCell.rowDescriptor.cellAccessoryView == nil {
//                    cell?.accessoryType = .Checkmark
//                }
//                else {
//                    cell?.accessoryView = formCell.rowDescriptor.cellAccessoryView
//                }
//            }
//            else {
//                cell?.accessoryType = .None
//            }
//        }
        return cell!
    }
    
    /// MARK: UITableViewDelegate
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if formCell.rowDescriptor.value == nil {
            formCell.rowDescriptor.value = NSArray();
        }
        
//        if var selectedOptions = formCell.rowDescriptor.value as? [NSObject] {

//            let optionValue = formCell.rowDescriptor.options[indexPath.row]
//            
//            if let index = find(selectedOptions, optionValue) {
//                selectedOptions.removeAtIndex(index)
//                cell?.accessoryType = .None
//            }
//            else {
//                selectedOptions.append(optionValue)
//                if formCell.rowDescriptor.cellAccessoryView == nil {
//                    cell?.accessoryType = .Checkmark
//                }
//                else {
//                    cell?.accessoryView = formCell.rowDescriptor.cellAccessoryView
//                }
//            }
//            
//            formCell.rowDescriptor.value = selectedOptions
//            
//            formCell.update()
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
