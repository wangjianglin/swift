//
//  WebViewController.swift
//  demo
//
//  Created by lin on 6/10/16.
//  Copyright © 2016 lin. All rights reserved.
//

import LinWeb

public class WebViewController : LinWebViewController{
    
    public override func viewDidLoad() {
        self.loadUrl("web/index.html")
    }
}
