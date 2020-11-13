import UIKit
import SnapKit

class GalleryCell: UICollectionViewCell {
    
    lazy var imageContainer: UIImageView = {
       let view = UIImageView()
        view.backgroundColor = UIColor(red: 0.854, green: 0.886, blue: 0.929, alpha: 0.85)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 6 * heightModifier
        return view
    }()
    
    private lazy var detailContainer: UIView = {
        return UIView()
    }()
    
    private lazy var titleContainer: UIView = {
        return UIView()
    }()
    
    private lazy var likesContainer: UIView = {
        return UIView()
    }()

    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = FontTypes.shared.h3_medium
        label.minimumScaleFactor = 10 * heightModifier
        label.contentMode = .left
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    lazy var likes: UILabel = {
        let label = UILabel()
        label.font = FontTypes.shared.h3
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var heart: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "heart.fill")
        view.tintColor = .red
        return view
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .darkGray
        return indicator
    }()
    
    func addSubviews() {
        self.addSubview(imageContainer)
        self.addSubview(detailContainer)
        
        detailContainer.addSubview(titleContainer)
        detailContainer.addSubview(likesContainer)

        titleContainer.addSubview(title)
        
        likesContainer.addSubview(likes)
        likesContainer.addSubview(heart)
        
        self.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    func setConstraintsToSubviews() {
        imageContainer.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        detailContainer.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        titleContainer.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        
        likesContainer.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        
        title.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(8 * heightModifier)
            make.left.equalToSuperview().offset(16 * widthModifier)
            make.height.equalToSuperview().multipliedBy(0.75)
        }
        
        let likeOffset: CGFloat = likes.text?.count == nil ? 12 : (CGFloat(likes.text!.count) * 5.3)
        
        heart.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-8 * heightModifier)
            make.centerX.equalToSuperview().offset(likeOffset * heightModifier)
            make.height.equalTo(16 * heightModifier)
            make.width.equalTo(16 * heightModifier)
        }
        
        likes.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-8 * heightModifier)
            make.centerX.equalToSuperview().offset(-likeOffset * heightModifier)
            make.height.equalTo(heart.snp.height)
        }
        
        loadingIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(self.imageContainer.snp.center)
            make.height.equalTo(self.imageContainer.snp.height).multipliedBy(0.14)
            make.width.equalTo(self.imageContainer.snp.height).multipliedBy(0.14)
        }
        
    }
    
    func setContent(with image: UnsplashImage) {
        self.imageContainer.image = image.image
        self.title.text = image.title.capitalized
        self.likes.text = String(image.likes)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraintsToSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
}
