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
    private var initialHeight: CGFloat?
    private var initialPosition: CGFloat = 17.0
    private var currentHeight: CGFloat = 0

    private var topConstraint: Constraint?
    private var bottomConstraint: Constraint?
    private var heightConstraint: Constraint?
    
    init(frame: CGRect = .zero, contentView: UIView, initialBottomSheetHeight heigth: CGFloat? = nil) {
        self.contentView = contentView
        super.init(frame: frame)
        self.initialHeight = heigth
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var bottomSheetContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    // MARK: - Helpers
    
    private func getInitialHeight() -> CGFloat {
        guard let height = self.initialHeight else {
            let result = dynamicHeight()
            return result
        }
        
        return height
        
    }
    
    private func dynamicHeight() -> CGFloat {
        let screemHeight = UIScreen.main.bounds.height
        let contentHeight = self.contentView.bounds.height
        
        let defaultHeight = screemHeight / 2
        
        if contentHeight < defaultHeight && contentHeight != 0.0 {
            self.initialHeight = contentHeight
            currentHeight = contentHeight
            return contentHeight
        }
        
        self.initialHeight = defaultHeight
        currentHeight = defaultHeight
        
        return defaultHeight
    
    }
    
    func showBottomSheet() {
        self.bottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            
        }
        
    }
    
    func remakeConstraints(y position: CGFloat) {
//        initialPosition = position
//        currentHeight = initialHeight ?? 0
    }
    
    func moveTopConstraintWith(y position: CGFloat) {
        
//        update(height: position)
        
        if position < initialPosition {
            currentHeight += 1.0
            update(height: currentHeight)
            print("Menor")
            return
        }

        if position > initialPosition {
            currentHeight -= 1
            update(height: currentHeight)
            print("Maior")
            return
        }
        
        if position == initialPosition {
            return
        }

//        guard let height = initialHeight else { return }
//        currentHeight = height
//        print("igual")
//        update(height: height)
        
    }
    
    private func update(height: CGFloat) {
        bottomSheetContainerView.snp.updateConstraints { (update) in
            update.height.equalTo(height)
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
            topConstraint = make.top.greaterThanOrEqualToSuperview().offset(40).constraint
            make.left.right.equalToSuperview()
            let height = getInitialHeight()
            bottomConstraint = make.bottom.equalToSuperview().offset(height).constraint
            heightConstraint = make.height.equalTo(height).constraint
        }
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
}
