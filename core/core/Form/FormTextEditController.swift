//
//  FormTextEditController.swift
//  LinCore
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

open class FormTextEditController: UITableViewController{
    
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

//    internal var titel:String?;
    internal var value:String?{
        didSet{
            text.text = value;
        }
    }
    internal var textType:TextType = TextType.text{
        didSet{
            switch( textType ) {
            case .text:
                text.autocorrectionType = .default
                text.autocapitalizationType = .sentences
                text.keyboardType = .default
            case .name:
                text.autocorrectionType = .no
                text.autocapitalizationType = .words
                text.keyboardType = .default
            case .phone:
                text.keyboardType = .phonePad
            case .url:
                text.autocorrectionType = .no
                text.autocapitalizationType = .none
                text.keyboardType = .URL
            case .email:
                text.autocorrectionType = .no
                text.autocapitalizationType = .none
                text.keyboardType = .emailAddress
            case .password:
                text.autocorrectionType = .no
                text.autocapitalizationType = .none
                text.keyboardType = .asciiCapable
                text.isSecureTextEntry = true
            default:
                break
            }

        }
    }
    internal var valueChange:((_ value:String)->())?
    
    public init(){
        super.init(style: UITableViewStyle.grouped)
        print("ok.");
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!;
        
    }
    open override func viewDidLoad() {
        super.viewDidLoad();
        self.navigationItem.title = self.title;
        
        let ok:UIBarButtonItem = UIBarButtonItem();
        ok.title = "确定";
        ok.action = #selector(FormTextEditController.okClick(_:));
        ok.target = self;
        self.navigationItem.rightBarButtonItem = ok;
        
        let cancel:UIBarButtonItem = UIBarButtonItem();
        cancel.title = "取消";
        cancel.action = #selector(FormTextEditController.cancelClick(_:));
        cancel.target = self;
        
        self.navigationItem.leftBarButtonItem = cancel;
        //self.tableView.style = UITableViewStyle.Grouped;
        
        //self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        text.translatesAutoresizingMaskIntoConstraints = false;
        text.returnKeyType = UIReturnKeyType.done;
        text.addTarget(self, action: #selector(FormTextEditController.keyReturn(_:)), for: UIControlEvents.editingDidEndOnExit)
        cell.addSubview(text);
        cell.addConstraints([NSLayoutConstraint(item: text, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: text, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: text, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: text, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 34)]);
        
    }
    
    fileprivate func backValue(){
        self.navigationController?.popViewController(animated: true);
        if let valueChange = self.valueChange{
            valueChange(text.text!);
        }
    }
    
    @objc open func cancelClick(_:AnyObject){
        print("canecl click.");
        self.navigationController?.popViewController(animated: true);
    }
    
    @objc open func okClick(_:AnyObject){
        print("ok click.");
        backValue();
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1;
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    fileprivate var text:UITextField = UITextField();
    
    fileprivate var cell = UITableViewCell();
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        //text
        print("----------------");
        
        text.becomeFirstResponder();
        return cell;
    }
    
    @objc open func keyReturn(_:AnyObject){
        print("key return ok.");
        backValue();
    }
}

//public class FormTextEditCell:UITableViewCell{
//    
//}
