//
//  BottomSheet.swift
//  BottomSheet
//
//  Created by Luan Orlando on 11/03/20.
//  Copyright © 2020 Luan Orlando. All rights reserved.
//

import UIKit

public class BottomSheet {
    static public func show(contentView: UIView, on viewController: UIViewController) {
        let bottomSheetViewController = BottomSheetViewController(contentView: contentView)
        viewController.present(bottomSheetViewController, animated: true)
        
    }
}
