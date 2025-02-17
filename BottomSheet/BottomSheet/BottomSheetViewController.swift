//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Luan Orlando on 07/03/20.
//  Copyright © 2020 Luan Orlando. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    private let contentView: UIView
    
    init(contentView: UIView) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIComponnents
    
//    private lazy var contentView: UIView = {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: 0))
//
//        view.backgroundColor = .white
//        view.isUserInteractionEnabled = true
//
//        return view
//    }()
    
    private lazy var gestureView: UIView = {
        let gestureView = CustomGestureView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 35))
        
        gestureView.isUserInteractionEnabled = true
        gestureView.backgroundColor = contentView.backgroundColor
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        gestureView.addGestureRecognizer(panGesture)
        
        return gestureView
    }()
    
    private lazy var bottomSheetView: BottomSheetView = {
        contentView.clipsToBounds = true
        contentView.isUserInteractionEnabled = true
        let view = BottomSheetView(contentView: contentView, gestureView: gestureView)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.delegate = self
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
        let viewHeight = self.bottomSheetView.bounds.height
        
        let translation = panGesture.translation(in: view)
        let yPosition = viewHeight < 20 ?  gestureView.center.y + translation.y : gestureView.center.y
        
        gestureView.center = CGPoint(
            x: gestureView.center.x,
            y: yPosition)
        
        panGesture.setTranslation(CGPoint.zero, in: view)
        
        print("y", gestureView.center.y)
            
            switch panGesture.state {
            case .began:
                bottomSheetView.remakeConstraints(
                    y: translation.y)
            case .changed:
                bottomSheetView.moveTopConstraintWith(
                    y: translation.y)
            case .ended:
                bottomSheetView.setPosition()
            case .cancelled, .failed, .possible:
                break
            @unknown default:
                break
        }
            
    }
}

// MARK: - BottomSheetViewDelegate

extension BottomSheetViewController: BottomSheetViewDelegate {
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}
