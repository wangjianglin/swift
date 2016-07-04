//
//  ScrollViewController.swift
//  LinCore
//
//  Created by lin on 6/29/16.
//  Copyright © 2016 lin. All rights reserved.
//

import UIKit

public class ScrollViewController : UIViewController{
    
    private var scrollView:ScrollView!;
    
    public override func loadView() {
        self.scrollView = ScrollView();
        self.scrollView.showsVerticalScrollIndicator = true;
        self.scrollView.showsHorizontalScrollIndicator = false;
        self.view = scrollView;
    }
    
    public override func viewDidLayoutSubviews() {
        
        var rect = scrollView.size();
        
        var navHeight:CGFloat = 0;
        if !UIApplication.sharedApplication().statusBarHidden {
            navHeight += 20;
        }
        if let height = self.navigationController?.navigationBar.bounds.height {
            navHeight += height;
        }
        if rect.height <= self.view.bounds.height - navHeight + 1 {
            rect.size.height = self.view.bounds.height - navHeight + 1;
        }
        
        rect.size.width = self.view.bounds.width;
        
        scrollView.contentSize = CGSizeMake(320, self.view.bounds.height - 63);
        
    }
    
    private class ScrollView : IOS7ScrollView{
        
        private var views = [UIView]();
        
        override func addSubview(view: UIView) {
            super.addSubview(view);
            views.append(view);
        }
        
        func size()-> CGRect {
            var rect:CGRect!;
            var scount = 0;
            if self.showsHorizontalScrollIndicator {
                scount += 2;
            }
            if self.showsVerticalScrollIndicator {
                scount += 2;
            }
            for n in 0 ..< self.views.count - scount {
                let view = self.views[n];
                let srect = view.convertRect(view.bounds, toView: self);
                
                if rect == nil {
                    rect = srect;
                }else{
                    rect = mergeRect(srect,rect2: rect);
                }
            }
            if rect == nil {
                return CGRectMake(0, 0, 0, 0);
            }
            return rect;
        }
        
        private func mergeRect(rect1:CGRect,rect2:CGRect)->CGRect{
            var result = CGRectMake(0, 0, 0, 0);
            result.origin.x = rect1.origin.x > rect2.origin.x ? rect2.origin.x : rect1.origin.x;
            
            result.origin.y = rect1.origin.y > rect2.origin.y ? rect2.origin.y : rect1.origin.y;
            
            var maxX = rect2.width + rect2.origin.x;
            if maxX < rect1.width + rect1.origin.x {
                maxX = rect1.width + rect1.origin.x
            }
            
            result.size.width = maxX - result.origin.x;
            
            var maxY = rect2.height + rect2.origin.y;
            if maxY < rect1.height + rect1.origin.y {
                maxY = rect1.height + rect1.origin.y
            }
            
            result.size.height = maxY - result.origin.y;
            
            return result;
        }
    }
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
