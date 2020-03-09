//
//  ViewController.swift
//  BottomSheet
//
//  Created by Luan Orlando on 07/03/20.
//  Copyright © 2020 Luan Orlando. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func actionButton() {
        let vc = BottomSheetViewController()
        self.present(vc, animated: true)
    }
    
}

