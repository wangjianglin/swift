//
//  VideoPickerController.swift
//  VideoSDK
//
//  Created by devjia on 2017/11/9.
//  Copyright © 2017年 devjia. All rights reserved.
//

import UIKit

public class VideoPickerController: UINavigationController {

    public weak var pickerDelegate: VideoPickerControllerDelegate?
    
    public convenience init() {
        self.init(rootViewController: VideoListController())
        navigationBar.barTintColor = .white
        navigationBar.tintColor = .black
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

public protocol VideoPickerControllerDelegate: NSObjectProtocol {
    func videoPickerControllerDidCancel(_ controller: VideoPickerController)
    func videoPickerController(_ controller: VideoPickerController, didPickVideoAt url: URL)
}
