//
//  MoreBarButtonItem.swift
//  LinCore
//
//  Created by lin on 16/02/2017.
//  Copyright © 2017 lin. All rights reserved.
//

import Foundation


public extension UIBarButtonItem{
    public convenience init(barButtonSystemItem systemItem: UIBarButtonSystemItem){
        self.init(barButtonSystemItem:systemItem, target: nil, action: nil);
    }
}

public class MoreBarButtonCell : UITableViewCell{
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.initView();
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var _image: CacheImageView?;
    private var _titleView: UILabel?;
    
    fileprivate var item:UIBarButtonItem?{
        didSet{
            if let view = item?.customView {
                view.removeFromSuperview();
                self.contentView.addSubview(view);
                return;
            }
            self._image?.image = item?.image;
            self._titleView?.text = item?.title;
            self._titleView?.textColor = item?.tintColor;
        }
    }
    
    private func image(name:String,leftCapWidth:Int, topCapHeight:Int)->UIImage?{
        let frameworkBundle = Bundle.init(identifier: "org.chameleonproject.UIKit");
        let frameworkFile = frameworkBundle?.resourceURL?.appendingPathComponent(name);
        
        let image = UIImage.init(url: frameworkFile!);
        image?.stretchableImage(withLeftCapWidth:leftCapWidth , topCapHeight: topCapHeight);
        return image;
    }
    
    private func initView(){
        
        _image = CacheImageView();
        _image?.contentMode = UIViewContentMode.center;
        _image?.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(_image!);
        
        _titleView = UILabel();
        _titleView?.translatesAutoresizingMaskIntoConstraints = false;
        _titleView?.backgroundColor = UIColor.clear;
        _titleView?.textColor = item?.tintColor;
        _titleView?.font = UIFont.systemFont(ofSize: 16);
        
        self.addSubview(_titleView!);
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[image(>=20)]-(0)-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["image":_image!]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[title]-(0)-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["title":_titleView!]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[image(20)]-[title]-(3)-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["image":_image!,"title":_titleView!]))
        
    }
    
}
public class MoreBarButtonPopoverView : UITableView,UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate{
    
    fileprivate weak var pvc:UIViewController?;
    fileprivate var moreButton:MoreBarButtonItem!;
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "_more_bar_cell") as? MoreBarButtonCell;
        if cell == nil {
            cell = MoreBarButtonCell(style:UITableViewCellStyle.default, reuseIdentifier:"_more_bar_cell");
        }
        cell?.item = moreButton.buttons[indexPath.row];
        cell?.backgroundColor = moreButton.backgroundColor;
        return cell!;
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreButton.buttons.count;
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32;
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none;
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pvc?.dismiss(animated: true, completion: nil);
        if let target = moreButton.buttons[indexPath.row].target,
            let action = moreButton.buttons[indexPath.row].action {
            target.perform(action, with: moreButton.buttons[indexPath.row]);
        }
    }
    
}

public class PUIViewController : UIViewController{
    
    public override func viewWillAppear(_ animated: Bool) {
        self.view.superview?.layer.cornerRadius = 1;
    }
}
public class MoreBarButtonItem : UIBarButtonItem{
    
    public class func newButton()->MoreBarButtonItem{
        return MoreBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add);
    }
    
    
    private var setDelegate = false;
    public override init(){
        super.init();
        setDelegate = true;
        self.setDelegateAction {[weak self] (_) in
            self?.actionimpl();
        }
        setDelegate = false;
    }
    
    public var backgroundColor = UIColor.white;
    public var separatorColor = UIColor.clear;
    public weak var vc:UIViewController?;
    
    deinit {
        print("======= deinit ========");
    }
    
    override public var target: AnyObject?{
        get{
            return super.target;
        }
        set{
            if setDelegate {
                super.target = newValue;
            }
        }
    }
    
    override public var action: Selector?{
        get{
            return super.action;
        }
        set{
            if setDelegate {
                super.action = newValue;
            }
        }
    }
    
    public convenience init(image: UIImage?, style: UIBarButtonItemStyle){
        self.init();
        self.image = image;
        self.style = style;
    }
    
    public convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItemStyle) {
        self.init();
        self.image = image;
        self.landscapeImagePhone = landscapeImagePhone;
        self.style = style;
    }
    
    public convenience init(title: String?, style: UIBarButtonItemStyle){
        self.init();
        self.title = title;
        self.style = style;
    }
    
    public convenience init(customView: UIView){
        self.init();
        self.customView = customView;
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var buttons = [UIBarButtonItem]();
    
    public func add(button:UIBarButtonItem){
        buttons.append(button);
    }
    
    private func textWidth()->CGFloat{
        //        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
        let attrs = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 18)];
        var w:CGFloat = 90.0;
        for button in buttons {
            let bw = (button.title as NSString?)?.size(attributes: attrs).width ?? 0;
            if w < bw {
                w = bw;
            }
        }
        return w;
    }
    private func actionimpl(){
        
        let viewSize = CGSize.init(width: textWidth() + 30, height: CGFloat(32 * buttons.count))
        let pview = MoreBarButtonPopoverView();
        pview.frame = CGRect.init(x: -10, y: 0, width: viewSize.width+10, height: viewSize.height )
        pview.moreButton = self;
        pview.delegate = pview;
        pview.dataSource = pview;
        pview.isScrollEnabled = false;
        pview.backgroundColor = UIColor.clear;
        pview.separatorColor = separatorColor;
        if #available(iOS 9.0, *)  {
            pview.cellLayoutMarginsFollowReadableWidth = false
        }
        let pvc = PUIViewController();
        pvc.view.addSubview(pview);
        //        pvc.view.layer.cornerRadius = 0;
        pvc.modalPresentationStyle = .popover;
        //        pvc.view.backgroundColor = UIColor.blue;
        
        let popover:UIPopoverPresentationController = (pvc.popoverPresentationController)!;
        pvc.preferredContentSize = viewSize;
        popover.permittedArrowDirections = .up;
        popover.backgroundColor = backgroundColor;
        popover.barButtonItem = self;
        popover.delegate = pview;
        pview.pvc = pvc;
        
        vc?.present(pvc, animated: true, completion: nil);
        
    }
}



private func g(style:UIBarButtonSystemItem)->UIImage?{
    switch style {
        
    case .done:
        
        break
        
    case .cancel:
        
        break
        
    case .edit:
        
        break
        
    case .save:
        
        break
        
    case .add: break;
        //return self.image(name: "<UIBarButtonSystemItem> add.png", leftCapWidth: 0, topCapHeight: 0)
        
    case .flexibleSpace:
        
        break
        
    case .fixedSpace:
        
        break
        
    case .compose:
        
        break
        
    case .reply:
        
        break
        
    case .action:
        
        break
        
    case .organize:
        
        break
        
    case .bookmarks:
        
        break
        
    case .search:
        
        break
        
    case .refresh:
        
        break
        
    case .stop:
        
        break
        
    case .camera:
        
        break
        
    case .trash:
        
        break
        
    case .play:
        
        break
        
    case .pause:
        
        break
        
    case .rewind:
        
        break
        
    case .fastForward:
        
        break
    default: break
    }
    
    return nil;
}

