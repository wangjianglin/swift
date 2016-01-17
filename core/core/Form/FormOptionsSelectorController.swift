//
//  FormOptionsSelectorController.swift
//  SwiftForms
//
//  Created by Miguel Ángel Ortuño Ortuño on 23/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

public class FormOptionsSelectorController: UITableViewController, FormSelector {

    /// MARK: FormSelector
    
    public var formCell: FormBaseCell!
    
    /// MARK: Init 
    
//    public override init() {
//        super.init(style: .Grouped)
//    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = formCell.rowDescriptor.title
    }
    
    /// MARK: UITableViewDataSource

    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return formCell.rowDescriptor.options.count
        return 0;
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseIdentifier = NSStringFromClass(self.dynamicType)
        
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: reuseIdentifier)
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
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if formCell.rowDescriptor.value == nil {
            formCell.rowDescriptor.value = []
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
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
