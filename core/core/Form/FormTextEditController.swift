//
//  FormTextEditController.swift
//  LinCore
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

public class FormTextEditController: UITableViewController{
    
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

//    internal var titel:String?;
    internal var value:String?{
        didSet{
            text.text = value;
        }
    }
    internal var textType:TextType = TextType.Text{
        didSet{
            switch( textType ) {
            case .Text:
                text.autocorrectionType = .Default
                text.autocapitalizationType = .Sentences
                text.keyboardType = .Default
            case .Name:
                text.autocorrectionType = .No
                text.autocapitalizationType = .Words
                text.keyboardType = .Default
            case .Phone:
                text.keyboardType = .PhonePad
            case .URL:
                text.autocorrectionType = .No
                text.autocapitalizationType = .None
                text.keyboardType = .URL
            case .Email:
                text.autocorrectionType = .No
                text.autocapitalizationType = .None
                text.keyboardType = .EmailAddress
            case .Password:
                text.autocorrectionType = .No
                text.autocapitalizationType = .None
                text.keyboardType = .ASCIICapable
                text.secureTextEntry = true
            default:
                break
            }

        }
    }
    internal var valueChange:((value:String)->())?
    
    public init(){
        super.init(style: UITableViewStyle.Grouped)
        print("ok.");
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!;
        
    }
    public override func viewDidLoad() {
        super.viewDidLoad();
        self.navigationItem.title = self.title;
        
        let ok:UIBarButtonItem = UIBarButtonItem();
        ok.title = "确定";
        ok.action = "okClick:";
        ok.target = self;
        self.navigationItem.rightBarButtonItem = ok;
        
        let cancel:UIBarButtonItem = UIBarButtonItem();
        cancel.title = "取消";
        cancel.action = "cancelClick:";
        cancel.target = self;
        
        self.navigationItem.leftBarButtonItem = cancel;
        //self.tableView.style = UITableViewStyle.Grouped;
        
        //self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        text.translatesAutoresizingMaskIntoConstraints = false;
        text.returnKeyType = UIReturnKeyType.Done;
        text.addTarget(self, action: "keyReturn:", forControlEvents: UIControlEvents.EditingDidEndOnExit)
        cell.addSubview(text);
        cell.addConstraints([NSLayoutConstraint(item: text, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: text, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: text, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: text, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 34)]);
        
    }
    
    private func backValue(){
        self.navigationController?.popViewControllerAnimated(true);
        if let valueChange = self.valueChange{
            valueChange(value: text.text!);
        }
    }
    
    public func cancelClick(_:AnyObject){
        print("canecl click.");
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    public func okClick(_:AnyObject){
        print("ok click.");
        backValue();
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1;
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    private var text:UITextField = UITextField();
    
    private var cell = UITableViewCell();
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        //text
        print("----------------");
        
        text.becomeFirstResponder();
        return cell;
    }
    
    public func keyReturn(_:AnyObject){
        print("key return ok.");
        backValue();
    }
}

//public class FormTextEditCell:UITableViewCell{
//    
//}
