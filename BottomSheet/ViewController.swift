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
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        label.backgroundColor = .green
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        view.addSubview(label)
        view.backgroundColor = .white
        
        BottomSheet.show(contentView: view, on: self)
        
//        let vc = BottomSheetViewController()
//        self.present(vc, animated: true)
    }
    
}

