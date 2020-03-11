//
//  BottomSheetView.swift
//  BottomSheet
//
//  Created by Luan Orlando on 07/03/20.
//  Copyright © 2020 Luan Orlando. All rights reserved.
//

import SnapKit

protocol BottomSheetViewDelegate: class {
    func dismissView()
}

enum BottomSheetStatus {
    case dismiss
    case initial
    case full
    case none
}

class BottomSheetView: UIView {
    
    private unowned let contentView: UIView
    private unowned let gestureView: UIView
    
    private var initialHeight: CGFloat?
    private var initialOffset: CGFloat?
    private var currentOffset: CGFloat?
    
    private var topConstraint: Constraint?
    private var bottomConstraint: Constraint?
    private var heightConstraint: Constraint?
    
    weak var delegate: BottomSheetViewDelegate?
    
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
    
    private func getState() -> BottomSheetStatus {
        let currentHeight = contentView.bounds.height
        guard let initialHeight = self.initialHeight else { return .none }
        let screemHeight = UIScreen.main.bounds.height
        let oneThirdOfScreem = screemHeight / 3
        
        var state: BottomSheetStatus
        
        switch currentHeight {
        case 0..<initialHeight / 2:
            state = .dismiss
        case initialHeight / 2..<oneThirdOfScreem * 2 :
            state = .initial
        default:
            state = .full
        }
        
        return state
    }
    
    func offsetWhenPanGestureInitialized() -> CGFloat? {
        guard let height = heightConstraint?.layoutConstraints.first?.constant else { return nil }
        let offset = UIScreen.main.bounds.height - (height + gestureView.bounds.height)
        self.currentOffset = offset
        
        return offset
    }
    
    func showBottomSheet() {
        self.bottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            
        }
    }
    
    func remakeConstraints(y position: CGFloat) {
        let state = getState()
        switch state {
        case .dismiss:
            break
        case .initial, .none:
            setInitialPosition()
        case .full:
            currentOffset = 0
        }
        
    }
    
    func moveTopConstraintWith(y position: CGFloat) {
        guard let offset = currentOffset else { return }
        let newOffset = offset + position
        
        currentOffset = newOffset
        if newOffset > 20 {
            topConstraint?.update(offset: newOffset)
        }
        
    }
    
    func setPosition() {
        let state = getState()
        
        switch state {
        case .dismiss:
            hideBottomSheet()
        case .initial, .none:
            setInitialPosition(withAnimation: true)
        case .full:
            setFullPosition()
            
        }
        
    }
    
}

// MARK: - ViewCode Initial

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

// MARK: set Positions

extension BottomSheetView {
    private func setInitialPosition(withAnimation isAnimation: Bool = false) {
        guard let offSet = offsetWhenPanGestureInitialized() else { return }
        let dispathGroup = DispatchGroup()
        dispathGroup.enter()
        heightConstraint?.update(priority: 200)
        gestureView.snp.remakeConstraints { (remake) in
            topConstraint = remake.top.equalToSuperview().offset(offSet).constraint
            remake.left.right.equalToSuperview()
            remake.height.equalTo(gestureView.bounds.height)
        }
        
        contentView.snp.remakeConstraints { (remake) in
            remake.top.equalTo(gestureView.snp.bottom)
            remake.left.right.bottom.equalToSuperview()
            dispathGroup.leave()
        }
        
        if isAnimation {
            dispathGroup.notify(queue: .main) {
                UIView.animate(withDuration: 0.3) {
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    private func hideBottomSheet() {
        let height = UIScreen.main.bounds.height
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        
        self.gestureView.snp.remakeConstraints { (remake) in
            remake.left.right.equalToSuperview()
            remake.height.equalTo(self.gestureView.bounds.height)
        }
        
        self.contentView.snp.remakeConstraints { (remake) in
            remake.top.equalTo(self.gestureView.snp.bottom)
            remake.left.right.equalToSuperview()
            remake.height.equalTo(self.contentView.bounds.height)
            remake.bottom.equalToSuperview().offset(height + self.gestureView.bounds.height)
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            UIView.animate(withDuration: 0.5, animations: {
                self.layoutIfNeeded()
            }) { (_) in
                self.delegate?.dismissView()
            }
        }
        
    }
    
    private func setFullPosition() {
        topConstraint?.update(offset: 19.0)
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
        })
    }
    
}
