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
    private unowned let gestureView: UIView
    
    private var initialHeight: CGFloat?
    private var currentOffSet: CGFloat?
    
    private var topConstraint: Constraint?
    private var bottomConstraint: Constraint?
    private var heightConstraint: Constraint?
    
    init(frame: CGRect = .zero, contentView: UIView, gestureView: UIView, initialBottomSheetHeight heigth: CGFloat? = nil) {
        self.contentView = contentView
        self.gestureView = gestureView
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
            return contentHeight
        }
        
        self.initialHeight = defaultHeight
        
        return defaultHeight
    
    }
    
    func offsetWhenPanGestureInitialized() -> CGFloat? {
        guard let height = heightConstraint?.layoutConstraints.first?.constant else { return nil }
        let offset = UIScreen.main.bounds.height - (height + gestureView.bounds.height)
        self.currentOffSet = offset
        
        return offset
    }
    
    func showBottomSheet() {
        self.bottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            
        }
        
    }
    
    func remakeConstraints(y position: CGFloat) {
        guard let offSet = offsetWhenPanGestureInitialized() else { return }
        heightConstraint?.update(priority: 200)
        gestureView.snp.remakeConstraints { (remake) in
            topConstraint = remake.top.equalToSuperview().offset(offSet).constraint
            remake.left.right.equalToSuperview()
            remake.height.equalTo(gestureView.bounds.height)
        }
        
        contentView.snp.remakeConstraints { (remake) in
            remake.top.equalTo(gestureView.snp.bottom)
            remake.left.right.bottom.equalToSuperview()
        }
        
    }
    
    func moveTopConstraintWith(y position: CGFloat) {
        guard let offset = currentOffSet else { return }
        let newOffset = offset + position
        
        currentOffSet = newOffset
        topConstraint?.update(offset: newOffset)
        
    }
    
}

// MARK: - ViewCode

extension BottomSheetView {
    private func setup() {
        buildViewHierarchy()
        setupConstraints()
    }
    
    private func buildViewHierarchy() {
        self.addSubview(contentView)
        self.addSubview(gestureView)
    }
    
    private func setupConstraints() {
        gestureView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(gestureView.bounds.height)
        }
        
        contentView.snp.makeConstraints { (make) in
            topConstraint = make.top.equalTo(gestureView.snp.bottom).constraint
            make.left.right.equalToSuperview()
            let height = getInitialHeight()
            bottomConstraint = make.bottom.equalToSuperview().offset(height + gestureView.bounds.height).constraint
            heightConstraint = make.height.equalTo(height).constraint
            
        }
    }
}
