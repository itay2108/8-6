//
//  ImagePreviewViewController.swift
//  Eight-Six
//
//  Created by itay gervash on 13/11/2020.
//

import UIKit
import Motion

class ImagePreviewViewController: UIViewController {
    
    var notificationCenter = NotificationCenter.default
    
    var image: UnsplashImage?
    
    private lazy var imageContainer: UIImageView = {
        let view = UIImageView(image: image?.image)
        view.contentMode = .scaleAspectFill
        view.motionIdentifier = "image"
        return view
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .darkGray
        return indicator
    }()
    
    private lazy var card: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.roundCorners([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 16)
        return view
    }()
    
    private lazy var cardHandle: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2
        return view
    }()
    
    private lazy var controls: UIStackView = {
       let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalCentering
        sv.alignment = .center
        return sv
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left.circle"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(showPreviousImage), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.right.circle"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(showNextImage), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        //if image not loaded yet
        if image?.image == nil {
            notificationCenter.addObserver(self, selector: #selector(imageHasLoaded), name: .imageHasFinishedLoading, object: nil)
            loadingIndicator.startAnimating()
        }
        setUpUI()
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UI Methods
    
    func setUpUI() {
        
        self.view.backgroundColor = UIColor(red: 0.854, green: 0.886, blue: 0.929, alpha: 0.85)
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        addSubviews()
        setConstraintsToSubviews()
        setUpMotion()
    }
    
    func setUpMotion() {
        self.isMotionEnabled = true
    }
    
    func addSubviews() {
        
        self.view.addSubview(loadingIndicator)
        self.view.addSubview(imageContainer)
        
        self.view.addSubview(card)
        card.addSubview(cardHandle)
        card.addSubview(controls)
        
        controls.addArrangedSubview(previousButton)
        controls.addArrangedSubview(nextButton)
        
    }
    
    func setConstraintsToSubviews() {
        
        imageContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(self.imageContainer.snp.center)
            make.height.equalTo(self.imageContainer.snp.height).multipliedBy(0.14)
            make.width.equalTo(self.imageContainer.snp.height).multipliedBy(0.14)
        }
        
        card.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2 * heightModifier)
        }
        
        cardHandle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(4 * heightModifier)
            make.width.equalTo(36 * heightModifier)
            make.top.equalTo(self.view.snp.bottom)
        }
        
        controls.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.height.equalTo(24 * heightModifier)
            make.width.equalTo(24 * widthModifier)
        }
        
        previousButton.snp.makeConstraints { (make) in
            make.height.equalTo(24 * heightModifier)
            make.width.equalTo(24 * widthModifier)
        }
    }
    
    //MARK: - Button targets
    
    @objc private func showNextImage() {
        
    }
    
    @objc private func showPreviousImage() {
        
    }
    
    //MARK: - Handle image loaded notification
    
    @objc private func imageHasLoaded() {
        imageContainer.image = image?.image
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }
    
    //MARK: - Deinit
    
    deinit {
        notificationCenter.removeObserver(self)
    }
}
