//
//  SegueCell.swift
//  LinCore
//
//  Created by lin on 12/25/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

public class FormSegueCell:FormBaseCell{
    let titleLabel = UILabel()
    let textField = UITextField()
    
    private var customConstraints: [AnyObject]!
    
    /// MARK: FormBaseCell
    
    override public func configure() {
        super.configure()
        accessoryType = .DisclosureIndicator
        selectionStyle = .None
        
        //self.titleLabel.text = self.rowDescriptor.title;
    }
    
    override public func update() {
        super.update()
        
        titleLabel.text = rowDescriptor.title
        //self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0);
    }

    public override class func formViewController(formViewController: FormViewController, didSelectRow: FormBaseCell) {
        let segue:FormSegueDescriptor = didSelectRow.rowDescriptor as! FormSegueDescriptor;
        formViewController.performSegueWithIdentifier(segue.segue, sender: nil);
    }
}
