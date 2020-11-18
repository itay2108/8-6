//
//  LoopViewController.swift
//  Eight-Six
//
//  Created by itay gervash on 17/11/2020.
//

import UIKit
import SnapKit

class SecondViewController: UIViewController {
    
    let notificationCenter = NotificationCenter.default
    
    private lazy var verticalStackView: UIStackView = {
       let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.distribution = .fill
        return sv
    }()
    
    private lazy var topHorizontalStackView: UIStackView = {
       let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .bottom
        sv.distribution = .equalSpacing
        return sv
    }()
    
    private lazy var bottomHorizontalStackView: UIStackView = {
       let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .top
        sv.distribution = .equalSpacing
        return sv
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpUI()
    }
    
    private func setUpUI() {
       addSubviews()
       setConstraintsToSubviews()
        layoutImages(count: 4)
    }
    
    private func addSubviews() {
        self.view.addSubview(verticalStackView)
        
        self.verticalStackView.addArrangedSubview(topHorizontalStackView)
        self.verticalStackView.addArrangedSubview(bottomHorizontalStackView)
        

    }
    
    private func setConstraintsToSubviews() {
        
        verticalStackView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.center.equalToSuperview()
        }
        
        topHorizontalStackView.snp.makeConstraints { (make) in
            make.height.equalTo(verticalStackView).multipliedBy(0.4)
            make.width.equalTo(verticalStackView)
        }
        
        bottomHorizontalStackView.snp.makeConstraints { (make) in
            make.height.equalTo(verticalStackView).multipliedBy(0.4)
            make.width.equalTo(verticalStackView)
        }
        
    }

    
    func layoutImages(count: Int) {
                    
        for i in 1...count {
            
            var randomImage = UIImage()
            
            ImageRetriever.shared.getImages(count: 1, featured: true) { (result, _) in
                
                result.getImagefrom(result.thumbSize) { (thumb) in
                    
                    if let safeThumb = thumb {
                        randomImage = safeThumb
                    }
                    
                    let container = UIView()
                    
                    let label = UILabel()
                    label.font = FontTypes.shared.h3_demiBold
                    label.text = result.title
                    label.textAlignment = .center
                    
                    let imageView = self.createImageView(image: randomImage)
                    
                    container.addSubview(imageView)
                    container.addSubview(label)
                    
                    if i * 2 <= count {
                        self.topHorizontalStackView.addArrangedSubview(container)
                    } else {
                        self.bottomHorizontalStackView.addArrangedSubview(container)
                    }
                    
                    container.snp.makeConstraints { (make) in
                        make.height.equalToSuperview().multipliedBy(0.66)
                        make.width.equalToSuperview().multipliedBy(0.4)
                    }
                    
                    imageView.snp.makeConstraints { (make) in
                        make.top.equalToSuperview()
                        make.left.equalToSuperview()
                        make.right.equalToSuperview()
                        make.height.equalToSuperview().multipliedBy(0.8)
                    }
                    
                    label.snp.makeConstraints { (make) in
                        make.centerX.equalToSuperview()
                        make.width.equalToSuperview()
                        make.height.equalTo(label.font.pointSize + 2)
                        make.bottom.equalToSuperview()
                    }
                }
            }
        }
        
    }
    
    func createImageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        return imageView
    }
    
    

}
