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
    
    var galleryDataSource: [UnsplashImage]?
    var image: UnsplashImage? {
        didSet {
            if image != nil {
                updateUI()
            }
        }
    }
    
    var index: Int = 0
    private var swipeStartPoint = CGPoint()
    
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
        view.roundCorners([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 6 * heightModifier)
        return view
    }()
    
    private lazy var imageTitle: UILabel = {
        let label = UILabel()
        label.text = image?.title
        label.font = FontTypes.shared.h2_medium
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var controls: UIStackView = {
       let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalCentering
        sv.alignment = .center
        return sv
    }()
    
    private lazy var previousButton: VisualButton = {
        let button = VisualButton()
        button.imageContainer.image = UIImage(systemName: "arrow.left.circle")
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(showPreviousImage), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: VisualButton = {
        let button = VisualButton()
        button.imageContainer.image = UIImage(systemName: "arrow.right.circle")
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(showNextImage), for: .touchUpInside)
        return button
    }()
    
    private lazy var swipeGR: UIPanGestureRecognizer = {
        let gr = UIPanGestureRecognizer()
        gr.minimumNumberOfTouches = 1
        gr.maximumNumberOfTouches = 1
        gr.addTarget(self, action: #selector(handleDownSwipe(_:)))
        return gr
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        image?.getImagefrom(image?.regularSize, completion: { (package) in
            guard package != nil else { return }
            self.image?.image = package!
        })
        

        //if image not loaded yet
        if image?.image == nil {
            notificationCenter.addObserver(self, selector: #selector(imageHasLoaded), name: .imageHasFinishedLoading, object: nil)
            loadingIndicator.startAnimating()
        }
        setUpUI()
        print(index)
    }
    
    //MARK: - UI Methods
    
    func setUpUI() {
        
        self.view.backgroundColor = UIColor(red: 0.854, green: 0.886, blue: 0.929, alpha: 0.85)
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        
        addSubviews()
        setConstraintsToSubviews()
        setUpMotion()
        
    }
    
    func setUpMotion() {
        self.isMotionEnabled = true
        self.view.backgroundColor = .white
        self.view.motionIdentifier = "bg"
    }
    
    func addSubviews() {
        
        self.view.addSubview(loadingIndicator)
        self.view.addSubview(imageContainer)
        
        self.view.addSubview(card)
        card.addSubview(controls)
        card.addSubview(imageTitle)
        
        controls.addArrangedSubview(previousButton)
        controls.addArrangedSubview(nextButton)
        
        self.view.addGestureRecognizer(swipeGR)
    }
    
    func setConstraintsToSubviews() {
        
        imageContainer.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            print(heightModifier)
            make.height.equalToSuperview().multipliedBy(0.875).offset(6 * heightModifier)
        }
        
        loadingIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(self.imageContainer.snp.center)
            make.height.equalTo(self.imageContainer.snp.height).multipliedBy(0.14)
            make.width.equalTo(self.imageContainer.snp.height).multipliedBy(0.14)
        }
        
        card.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()//.offset((UIScreen.main.bounds.height * 0.2) * heightModifier)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.125)
        }
        
        controls.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.height.equalTo(32 * heightModifier)
            make.width.equalTo(32 * heightModifier)
        }
        
        previousButton.snp.makeConstraints { (make) in
            make.height.equalTo(32 * heightModifier)
            make.width.equalTo(32 * heightModifier)
        }
        
        imageTitle.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(32 * heightModifier)
            make.width.equalTo(controls.snp.width).offset(-100 * widthModifier)
        }
    }
    
    func updateUI() {

        guard image != nil else { return }
        
        if image?.image == nil {
            notificationCenter.addObserver(self, selector: #selector(imageHasLoaded), name: .imageHasFinishedLoading, object: nil)
            loadingIndicator.startAnimating()
        }
        
        imageContainer.image = image?.image
        
        imageTitle.text = image!.title
    }
    
    //MARK: - Animate views
    
    //MARK: - Targets
    
    @objc private func showNextImage() {
        index += 1
        
        guard
            galleryDataSource != nil,
            let nextImage = galleryDataSource?[index % galleryDataSource!.count]
        else { return }
        
        self.image = nextImage
        
        nextImage.getImagefrom(nextImage.regularSize) { (package) in
            nextImage.image = package
        }
        
    }
    
    @objc private func showPreviousImage() {
        index -= 1
        
        guard
            galleryDataSource != nil,
            let previousImage = galleryDataSource?[index % galleryDataSource!.count]
        else { return }
        
        image = previousImage
        
        previousImage.getImagefrom(previousImage.regularSize) { (package) in
            previousImage.image = package
        }
    }
    
    @objc func handleDownSwipe(_ sender: UIPanGestureRecognizer) {
        
        if sender.state == .began {
            swipeStartPoint = sender.location(in: self.view)
        }
        
        let distanceY = sender.location(in: self.view).y - swipeStartPoint.y
        let distanceX = sender.location(in: self.view).x - swipeStartPoint.x

        if (sender.state == .ended && distanceY > distanceX && distanceY > 90) || distanceY > UIScreen.main.bounds.height / 5 {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    //MARK: - Handle image loaded notification
    
    @objc private func imageHasLoaded() {
        imageContainer.image = image?.image
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
        notificationCenter.removeObserver(self)
        
    }
    
    //MARK: - Deinit
    
    deinit {
        notificationCenter.removeObserver(self)
    }
}
