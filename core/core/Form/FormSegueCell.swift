//
//  SegueCell.swift
//  LinCore
//
//  Created by lin on 12/25/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

open class FormSegueCell:FormBaseCell{
    let titleLabel = UILabel()
    let textField = UITextField()
    
    fileprivate var customConstraints: [AnyObject]!
    
    /// MARK: FormBaseCell
    
    override open func configure() {
        super.configure()
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        
        //self.titleLabel.text = self.rowDescriptor.title;
    }
    
    override open func update() {
        super.update()
        
        titleLabel.text = rowDescriptor.title
//        imgView.image = UIImage(named:rowDescriptor.imageName)
    }

    open override class func formViewController(_ formViewController: FormViewController, didSelectRow: FormBaseCell) {
        let segue:FormSegueDescriptor = didSelectRow.rowDescriptor as! FormSegueDescriptor;
        formViewController.performSegue(withIdentifier: segue.segue, sender: nil);
    }
}
