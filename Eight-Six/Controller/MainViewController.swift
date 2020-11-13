//
//  ViewController.swift
//  Eight-Six
//
//  Created by itay gervash on 12/11/2020.
//

import UIKit
import SnapKit
import Motion

class MainViewController: UIViewController {
    
    let notificationCenter = NotificationCenter.default
    
    private lazy var gallery: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16 * heightModifier
        layout.minimumInteritemSpacing = 16 * widthModifier
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
         cv.register(GalleryCell.self, forCellWithReuseIdentifier: "cell")
        
        cv.backgroundColor = .clear
        return cv
    }()

    private var galleryDataSource: [UnsplashImage]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate setting
        gallery.delegate = self; gallery.dataSource = self
        
        //post notification to be notified when images load
        notificationCenter.addObserver(self, selector: #selector(imageHasLoaded), name: .imageHasFinishedLoading, object: nil)
        
        // retrieve images
        ImageRetriever.shared.getImages(count: 4, featured: true) { (images) in
            self.galleryDataSource = images
            
            //setup visual elements
            self.setUpUI()
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for cell in gallery.visibleCells {
            if let galleryCell = cell as? GalleryCell {
                galleryCell.imageContainer.motionIdentifier = nil
            }
        }
    }
    
    //MARK: - UI Methods
    
    private func setUpUI() {
        
        self.title = "Daily Photos"
        addSubviews()
        setConstraintsForSubviews()
        setUpMotion()
    }
    
    private func setUpMotion() {
        self.isMotionEnabled = true
    }
    
    private func addSubviews() {
        self.view.addSubview(gallery)
    }
    
    private func setConstraintsForSubviews() {
        gallery.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(safeAreaTop + 36)
            make.left.equalToSuperview().offset(24 * widthModifier)
            make.right.equalToSuperview().offset(-24 * widthModifier)
            make.height.equalToSuperview().multipliedBy(0.95).offset(-(safeAreaTop + safeAreaBottom))
        }
        
    }
    
    @objc private func imageHasLoaded() {
        self.gallery.reloadData()
        
    }
    
    //Mark: - Deinit
    
    deinit {
        notificationCenter.removeObserver(self)
    }

}

//MARK: - Collectionview Methods

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return galleryDataSource?.count ?? 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 32) / 2
        let height = (collectionView.frame.height - 48) / 2
        let size = CGSize(width: width, height: height)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCell
        
        let errorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCell
        errorCell.backgroundColor = .darkGray
        errorCell.title.text = "Error"
        
        guard galleryDataSource != nil else { return errorCell }
        
        cell.setContent(with: galleryDataSource![indexPath.row])
        if cell.imageContainer.image != nil { cell.loadingIndicator.stopAnimating() }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = ImagePreviewViewController()
        destination.image = galleryDataSource?[indexPath.row]
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? GalleryCell {
            selectedCell.imageContainer.motionIdentifier = "image"
        }

        self.navigationController?.pushViewController(destination, animated: true)
    }


}
