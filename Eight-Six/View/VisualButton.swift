//
//  VisualButton.swift
//  Eight-Six
//
//  Created by itay gervash on 13/11/2020.
//

import UIKit
import SnapKit

class VisualButton: CRButton {

    lazy var imageContainer: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    func addImageContainer() {
        self.addSubview(imageContainer)
        
        imageContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addImageContainer()
        
        self.setTitle(nil, for: .normal)
        self.setImage(nil, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
