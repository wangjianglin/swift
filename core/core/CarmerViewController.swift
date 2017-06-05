//
//  CarmerViewController.swift
//  LinCore
//
//  Created by Max on 2017/6/5.
//  Copyright © 2017年 lin. All rights reserved.
//

import UIKit

class CarmerViewController: UIViewController {

    
    let cancelButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = UIColor.white
        
        cancelButton.setTitle("取 消", for: .normal)
        cancelButton.frame = CGRect(x: CGFloat(0), y: CGFloat(view.bounds.size.height - 70), width: CGFloat(90), height: CGFloat(45))
        cancelButton.titleLabel?.font = UIFont(name: "STHeitiSC-Light", size: CGFloat(16.0))
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.setTitleColor(UIColor.gray, for: .normal)
        cancelButton.addTarget(self, action: #selector(CarmerViewController.back), for: .touchUpInside)
        view.addSubview(cancelButton)
    

    }
    

    func back() {
    
    
        dismiss(animated: true, completion: { _ in })
    
        
        
    
    }
    
    
}
