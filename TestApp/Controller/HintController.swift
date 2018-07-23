//
//  HintController.swift
//  TestApp
//
//  Created by gHOST on 23/7/18.
//  Copyright © 2018 AlayaCare. All rights reserved.
//

import UIKit
import SwiftGifOrigin
class HintController: UIViewController {

    @IBOutlet weak var hintimage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
hintimage.image = UIImage.gif(name: "hintvideo")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true) {
          
        }
    }
    
}
