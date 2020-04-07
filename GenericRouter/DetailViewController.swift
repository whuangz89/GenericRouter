//
//  DetailViewController.swift
//  GenericRouter
//
//  Created by William Huang on 7/4/20.
//  Copyright © 2020 Whuangz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    private var id: Int?
    private var slug: String?
    
    init(with id: Int? = nil, slug: String? = nil) {
        let bundle = Bundle(for: type(of: self))
        super.init(nibName: "DetailViewController", bundle: bundle)
        self.id = id
        self.slug = slug
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
