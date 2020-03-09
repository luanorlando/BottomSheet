//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Luan Orlando on 07/03/20.
//  Copyright © 2020 Luan Orlando. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIComponnents
    
    private lazy var contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: 200))
        
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var gestureView: UIView = {
        let gestureView = CustomGestureView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 35))
        gestureView.isUserInteractionEnabled = true
        gestureView.backgroundColor = .white
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        gestureView.addGestureRecognizer(panGesture)
        return gestureView
    }()
    
    private lazy var containerView: UIView = {
        let fullHeight = contentView.bounds.height != 0 ? contentView.bounds.height + gestureView.bounds.height : 0
        
        let view = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: contentView.bounds.width,
            height: fullHeight))
        
        view.backgroundColor = contentView.backgroundColor
        
        view.addSubview(gestureView)
        view.addSubview(contentView)
        
        gestureView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(35)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(gestureView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var bottomSheetView: BottomSheetView = {
        let view = BottomSheetView(contentView: containerView)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    
    // MARK: - Life cicle
    
    override func loadView() {
        super.loadView()
        self.view = bottomSheetView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bottomSheetView.showBottomSheet()
        
    }
    
    // MARK: - Actions
    @objc private func handlePanGesture(panGesture: UIPanGestureRecognizer) {
    //        heightConstraint?.isActive = false
            print("oi")
//            let translation = panGesture.translation(in: gestureView)
//            gestureView.center = CGPoint(x: 0, y: gestureView.center.y + translation.y)
//            panGesture.setTranslation(CGPoint.zero, in: self)
            
//            print("y", translation.y)
//            print("x", translation.x)
            
            switch panGesture.state {
            case .possible:
                break
            case .began:
                break
            case .changed:
                break
            case .ended:
                print("será???")
            case .cancelled:
                break
            case .failed:
                break
            @unknown default:
                break
            }
            
    //        gestureView.center = CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
    //        sender.setTranslation(CGPoint.zero, in: self.view)
            
        }
}
