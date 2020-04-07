//
//  ViewController.swift
//  GenericRouter
//
//  Created by William Huang on 7/4/20.
//  Copyright © 2020 Whuangz. All rights reserved.
//

import UIKit
import Common

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let btn = UIButton()
        btn.setTitle("DEtail", for: .normal)
        btn.addTarget(self, action: #selector(openDetail), for: .touchUpInside)
        self.view.addSubview(btn)
        
        NSLayoutConstraint.activate([
            btn.widthAnchor.constraint(equalToConstant: 250),
            btn.heightAnchor.constraint(equalToConstant: 100),
            btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            btn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    @objc func openDetail(){
        DeepLinkNavigator.shared.navigate(to: .toDetailPage(1), from: self, completion: nil)
    }

}

