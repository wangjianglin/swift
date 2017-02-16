//
//  ScrollViewController.swift
//  LinCore
//
//  Created by lin on 6/29/16.
//  Copyright © 2016 lin. All rights reserved.
//

import UIKit

open class AutoScrollViewController : UIViewController{
    
    fileprivate var _scrollView:AutoScrollView!;
    
    open override func loadView() {
        //super.loadView();
        //        self.view.addSubview(self.view);
        let _view = SView();
        _view._scrollView.showsVerticalScrollIndicator = true;
        _view._scrollView.showsHorizontalScrollIndicator = false;
        _view.setView();
        
        _scrollView = _view._scrollView;
        
        //        _scrollView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleHeight.rawValue | UIViewAutoresizing.flexibleWidth.rawValue);
        
        
        //        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-3-[title]-4-|", options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:views));
        
        _view._scrollView.translatesAutoresizingMaskIntoConstraints = false;
        _view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[scroll]-(0)-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["scroll":_scrollView]));
        _view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[scroll]-(0)-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["scroll":_scrollView]));
        
        self.view = _view;
    }
    
    public var scrollView:AutoScrollView{
        return _scrollView;
    }
    
    class SView : UIView{
        fileprivate var _scrollView:AutoScrollView = AutoScrollView();
        fileprivate func setView(){
            super.addSubview(_scrollView);
        }
        override func addSubview(_ view: UIView) {
            _scrollView.addSubview(view);
        }
        
        override func bringSubview(toFront view: UIView) {
            _scrollView.bringSubview(toFront: view);
        }
        
        override func sendSubview(toBack view: UIView) {
            _scrollView.sendSubview(toBack: view);
        }
        
        override func layoutSubviews() {
            super.layoutSubviews();
            _scrollView.offset = CGSize(width:_scrollView.bounds.origin.x,height:_scrollView.bounds.origin.y);
        }
    }
    
    //    open override func viewDidLayoutSubviews() {
    //
    //        var rect = scrollView.size();
    //
    //        var navHeight:CGFloat = 0;
    //        if !UIApplication.shared.isStatusBarHidden {
    //            navHeight += 20;
    //        }
    //        if let height = self.navigationController?.navigationBar.bounds.height {
    //            navHeight += height;
    //        }
    //        if rect.height <= self.view.bounds.height - navHeight + 1 {
    //            rect.size.height = self.view.bounds.height - navHeight + 1;
    //        }
    //
    //        rect.size.width = self.view.bounds.width;
    //
    //        scrollView.contentSize = CGSize(width: 320, height: self.view.bounds.height - 63);
    //
    //    }
    
    //    fileprivate class ScrollView : IOS7ScrollView{
    //
    //        fileprivate var views = [UIView]();
    //
    //        override func addSubview(_ view: UIView) {
    //            super.addSubview(view);
    //            views.append(view);
    //        }
    //
    //        func size()-> CGRect {
    //            var rect:CGRect!;
    //            var scount = 0;
    //            if self.showsHorizontalScrollIndicator {
    //                scount += 2;
    //            }
    //            if self.showsVerticalScrollIndicator {
    //                scount += 2;
    //            }
    //            for n in 0 ..< self.views.count - scount {
    //                let view = self.views[n];
    //                let srect = view.convert(view.bounds, to: self);
    //
    //                if rect == nil {
    //                    rect = srect;
    //                }else{
    //                    rect = mergeRect(srect,rect2: rect);
    //                }
    //            }
    //            if rect == nil {
    //                return CGRect(x: 0, y: 0, width: 0, height: 0);
    //            }
    //            return rect;
    //        }
    //
    //        fileprivate func mergeRect(_ rect1:CGRect,rect2:CGRect)->CGRect{
    //            var result = CGRect(x: 0, y: 0, width: 0, height: 0);
    //            result.origin.x = rect1.origin.x > rect2.origin.x ? rect2.origin.x : rect1.origin.x;
    //
    //            result.origin.y = rect1.origin.y > rect2.origin.y ? rect2.origin.y : rect1.origin.y;
    //
    //            var maxX = rect2.width + rect2.origin.x;
    //            if maxX < rect1.width + rect1.origin.x {
    //                maxX = rect1.width + rect1.origin.x
    //            }
    //
    //            result.size.width = maxX - result.origin.x;
    //
    //            var maxY = rect2.height + rect2.origin.y;
    //            if maxY < rect1.height + rect1.origin.y {
    //                maxY = rect1.height + rect1.origin.y
    //            }
    //
    //            result.size.height = maxY - result.origin.y;
    //
    //            return result;
    //        }
    //    }
}
//public class ScrollViewController : UIViewController{
//
//    private var table:ScrollView!;
//
//    private var tableCell:UITableViewCell!;
//    private var tableCellView:UIView!;
//    private var dataSource:TableDataSource!;
//
//    public override func loadView(){
//
//        self.tableCell = UITableViewCell();
//        self.tableCellView = UIView(frame:CGRectMake(0, 0, 100, 100));
//
//        table = ScrollView();
//
//        table.view = self.tableCellView;
//
//        self.tableCellView.backgroundColor = UIColor.grayColor();
//        self.view = table;
//
//        table.estimatedRowHeight = 200;
//
//        table.rowHeight = UITableViewAutomaticDimension;
//
//
//
//        let views = ["view":self.tableCellView];
//
//        tableCell.contentView.addSubview(self.tableCellView);
//        self.tableCellView.translatesAutoresizingMaskIntoConstraints = false;
//
//        tableCell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view]-|", options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:views));
////
////
//        tableCell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view]-|", options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:views));
//
//
//        table.delegate = TableDelegate();
//        self.dataSource = TableDataSource(cell:tableCell);
//        table.dataSource = self.dataSource;
//    }
//
//
//    public override func viewDidLoad(){
////        super.viewDidLoad();
//////        table = UITableView();
////
////        self.tableCell = UITableViewCell();
////        self.tableCellView = UIView(frame:CGRectMake(0, 0, 100, 100));
////
////        table = UITableView(frame:self.view.frame);
////        table.autoresizingMask = UIViewAutoresizing.init(rawValue: UIViewAutoresizing.FlexibleHeight.rawValue | UIViewAutoresizing.FlexibleWidth.rawValue);
////
////        self.view.addSubview(table);
////
////
////        table.reloadData();
//    }
//
//    class TableDataSource: NSObject,UITableViewDataSource {
//
//        private var cell:UITableViewCell;
//        init(cell:UITableViewCell) {
//            self.cell = cell;
//        }
//
//        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//            return 1;
//        }
//
//        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
//
//
//            return cell;
//        }
//    }
//
//    class TableDelegate: NSObject, UITableViewDelegate {
////        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
////            return 100;
////        }
//    }
//
//    class ScrollView: UITableView {
//
//        private var view:UIView!
//
////        init(view:UIView){
////            self.view = view;
////            super.init(frame: CGRectMake(0, 0, 0, 0),);
////        }
////
////        required init?(coder aDecoder: NSCoder) {
////            fatalError("init(coder:) has not been implemented")
////        }
//
//        override func addSubview(view: UIView) {
//            self.view.addSubview(view);
//        }
//
//        override func bringSubviewToFront(view: UIView) {
//            self.view.bringSubviewToFront(view);
//        }
//
//        override func sendSubviewToBack(view: UIView) {
//            self.view.sendSubviewToBack(view);
//        }
//
//        override func addConstraint(constraint: NSLayoutConstraint) {
//            self.view.addConstraint(constraint);
//        }
//
//        override func addConstraints(constraints: [NSLayoutConstraint]) {
//            self.view.addConstraints(constraints);
//        }
//
//    }
//}
