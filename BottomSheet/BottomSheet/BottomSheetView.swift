//
//  BottomSheetView.swift
//  BottomSheet
//
//  Created by Luan Orlando on 07/03/20.
//  Copyright © 2020 Luan Orlando. All rights reserved.
//

import SnapKit

class BottomSheetView: UIView {
    
    private unowned let contentView: UIView
    private var initalHeight: CGFloat?
    
    private var topConstraint: Constraint?
    private var bottomConstraint: Constraint?
    private var heightConstraint: Constraint?
    
    init(frame: CGRect = .zero, contentView: UIView, initialBottomSheetHeight heigth: CGFloat? = nil) {
        self.contentView = contentView
        super.init(frame: frame)
        self.initalHeight = heigth
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var bottomSheetContainerView: UIView = {
        let view = UIView()
        return view
    }()
    // MARK: - Helpers
    
    private func initialHeight() -> CGFloat {
        guard let height = self.initalHeight else {
            let result = dynamicHeight()
            return result
        }
        
        return height
        
    }
    
    private func dynamicHeight() -> CGFloat {
        let screemHeight = UIScreen.main.bounds.height
        let contentHeight = self.contentView.bounds.height
        
        let defaultHeight = screemHeight / 2
        
        self.initalHeight = defaultHeight
        
        if contentHeight < defaultHeight && contentHeight != 0.0 {
            self.initalHeight = contentHeight
        }
        
        if let initialHeight = self.initalHeight {
            return initialHeight
        }
    
        return defaultHeight
    
    }
    
    func showBottomSheet() {
        self.bottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            
        }
        
    }
    
}

// MARK: - ViewCode

extension BottomSheetView {
    private func setup() {
        buildViewHierarchy()
        setupConstraints()
    }
    
    private func buildViewHierarchy() {
        bottomSheetContainerView.addSubview(contentView)
        self.addSubview(bottomSheetContainerView)
    }
    
    private func setupConstraints() {
        bottomSheetContainerView.snp.makeConstraints { (make) in
            topConstraint = make.top.greaterThanOrEqualToSuperview().offset(15).constraint
            make.left.right.equalToSuperview()
            let height = initialHeight()
            bottomConstraint = make.bottom.equalToSuperview().offset(height).constraint
            heightConstraint = make.height.equalTo(height).constraint
            
        }
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
}
