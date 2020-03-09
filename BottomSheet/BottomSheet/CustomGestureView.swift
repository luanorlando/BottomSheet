//
//  CustomGestureView.swift
//  BottomSheet
//
//  Created by Luan Orlando on 08/03/20.
//  Copyright © 2020 Luan Orlando. All rights reserved.
//

import SnapKit

class CustomGestureView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var riskView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 4
        return view
    }()
    
}

// MARK: - ViewCode

extension CustomGestureView {
    private func setup() {
        buildViewHierarchy()
        setupConstraints()
    }
    
    private func buildViewHierarchy() {
        self.addSubview(riskView)
    }
    
    private func setupConstraints() {
        riskView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(55)
            make.height.equalTo(8)
            make.centerX.equalToSuperview()
        }
    }
}
