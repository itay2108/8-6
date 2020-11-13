//
//  SecondViewController.swift
//  Eight-Six
//
//  Created by itay gervash on 13/11/2020.
//

import UIKit
import SnapKit

class SecondViewController: UIViewController {
    
    private lazy var segmentControl: UISegmentedControl = {
        
        let firstSegmentImage = UIImage(systemName: "textformat")
        let secondSegmentImage = UIImage(systemName: "command")
        let thirdSegmentImage = UIImage(systemName: "photo")
        
        let items = [firstSegmentImage, secondSegmentImage, thirdSegmentImage]
        
        let seg = UISegmentedControl(items: items as [Any])
        
        seg.selectedSegmentIndex = 0
        
        seg.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        return seg
    }()
    
    private lazy var container: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = 12 * heightModifier
        return view
    }()
    
    private lazy var subViewStackview: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .equalCentering
        sv.alignment = .center
        return sv
    }()
    
    private lazy var textfield1: CRTextField = {
        let field = CRTextField()
        field.backgroundColor = .white
        field.placeholder = "textField"
        field.isUserInteractionEnabled = false
        field.borderColor = .darkGray
        field.borderWidth = 1
        return field
    }()
    
    private lazy var textfield2: CRTextField = {
        let field = CRTextField()
        field.backgroundColor = .white
        field.placeholder = "textField"
        field.isUserInteractionEnabled = false
        field.borderColor = .darkGray
        field.borderWidth = 1
        return field
    }()
    
    private lazy var button1: CRButton = {
        let btn = CRButton()
        btn.backgroundColor = .white
        btn.setTitle("button 1", for: .normal)
        btn.roundedCorners = true
        btn.setTitleColor(.darkGray, for: .normal)
        btn.tintColor = .darkGray
        return btn
    }()
    
    private lazy var button2: CRButton = {
        let btn = CRButton()
        btn.backgroundColor = .white
        btn.setTitle("button 2", for: .normal)
        btn.setTitleColor(.darkGray, for: .normal)
        btn.roundedCorners = true
        btn.tintColor = .darkGray
        return btn
    }()
    
    private lazy var imageView1: UIImageView = {
       let view = UIImageView(image: UIImage(systemName: "photo.fill"))
        view.contentMode = .scaleAspectFit
        view.tintColor = .white
        return view
    }()
    
    private lazy var imageView2: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "photo"))
         view.contentMode = .scaleAspectFit
        view.tintColor = .white
         return view
    }()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    //MARK: - UI Methods
    
    private func setUpUI() {
        addSubviews()
        setConstraintsToSubviews()
    }
    
    private func addSubviews() {
        self.view.addSubview(segmentControl)
        self.view.addSubview(container)
        
        container.addSubview(subViewStackview)
        
        subViewStackview.addArrangedSubview(textfield1)
        subViewStackview.addArrangedSubview(textfield2)
    }
    
    private func setConstraintsToSubviews() {
        segmentControl.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(56 * heightModifier)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(56 * heightModifier)
        }
        
        container.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        subViewStackview.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
            make.width.equalToSuperview().multipliedBy(0.75)
        }
        
        textfield1.snp.makeConstraints { (make) in
            make.height.equalTo(48 * heightModifier)
            make.width.equalTo(UIScreen.main.bounds.width * 0.45)
        }
        
        textfield2.snp.makeConstraints { (make) in
            make.height.equalTo(48 * heightModifier)
            make.width.equalTo(UIScreen.main.bounds.width * 0.45)
        }
        
        button1.snp.makeConstraints { (make) in
            make.height.equalTo(48 * heightModifier)
            make.width.equalTo(UIScreen.main.bounds.width * 0.45)
        }
        
        button2.snp.makeConstraints { (make) in
            make.height.equalTo(48 * heightModifier)
            make.width.equalTo(UIScreen.main.bounds.width * 0.45)
        }
        
        imageView1.snp.makeConstraints { (make) in
            make.height.equalTo(UIScreen.main.bounds.height * 0.13)
            make.width.equalTo(UIScreen.main.bounds.width * 0.4)
        }
        
        imageView2.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width * 0.4)
            make.height.equalTo(UIScreen.main.bounds.height * 0.13)
        }
        
    }
    
    //MARK: - Targets

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        
        for view in subViewStackview.arrangedSubviews { view.removeFromSuperview() }
        
        switch sender.selectedSegmentIndex {
        case 1:

            container.backgroundColor = .systemBlue
            subViewStackview.addArrangedSubview(button1)
            subViewStackview.addArrangedSubview(button2)
        case 2:

            container.backgroundColor = .systemIndigo
            subViewStackview.addArrangedSubview(imageView1)
            subViewStackview.addArrangedSubview(imageView2)
        default:

            container.backgroundColor = .systemGreen
            subViewStackview.addArrangedSubview(textfield1)
            subViewStackview.addArrangedSubview(textfield2)
        }
    }
}
