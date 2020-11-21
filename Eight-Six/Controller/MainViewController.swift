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
    
    var cellCount: Int = 4
    
    private lazy var gallery: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16 * heightModifier
        layout.minimumInteritemSpacing = 16 * widthModifier
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
         cv.register(GalleryCell.self, forCellWithReuseIdentifier: "cell")
        
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .darkGray
        refresh.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        return refresh
    }()

    private var galleryDataSource: [UnsplashImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        
        //delegate setting
        gallery.delegate = self; gallery.dataSource = self
        
        //post notification to be notified when images load
        notificationCenter.addObserver(self, selector: #selector(imageHasLoaded), name: .thumbHasFinishedLoading, object: nil)
        
        
        //setup visual elements
        self.setUpUI()
        
        // retrieve images
        ImageRetriever.shared.getImages(count: 4, featured: false) { (image, count) in
            self.cellCount = count
            self.galleryDataSource.append(image)
            self.gallery.reloadData()
        } completion: { (success, error) in
            if success { print("successfully retrieved all images") }
            else { print(error?.rawValue as Any) }
        }


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
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

        self.navigationController?.navigationBar.topItem?.title = "Daily Photos"

        addSubviews()
        setConstraintsForSubviews()
        setUpMotion()
    }
    
    private func setUpMotion() {
        self.isMotionEnabled = true
        self.view.motionIdentifier = "bg"
    }
    
    private func addSubviews() {
        self.view.addSubview(gallery)
        gallery.refreshControl = refreshControl
    }
    
    private func setConstraintsForSubviews() {
        print(safeAreaTop)
        gallery.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24 * heightModifier)
            make.left.equalToSuperview().offset(24 * widthModifier)
            make.right.equalToSuperview().offset(-24 * widthModifier)
            make.bottom.equalToSuperview().offset(-safeAreaBottom)
        }
        
    }
    
    @objc private func imageHasLoaded() {
        self.gallery.reloadData()
        
    }
    
    //MARK: - Targets
    
    @objc private func refreshHandler() {
        galleryDataSource = []
        
        ImageRetriever.shared.getImages(count: cellCount, featured: true) { (image, count) in
            print(count)
            self.galleryDataSource.append(image)
            self.gallery.reloadData()
            self.gallery.refreshControl?.endRefreshing()
        }

    }
    
    @objc private func rightBarButtonItemPressed(_ sender: UIButton) {
        print("tap")
    }
    
    
    //MARK: - Deinit
    
    deinit {
        notificationCenter.removeObserver(self)
    }

}

//MARK: - Collectionview Methods

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
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
        errorCell.title.text = ""
        errorCell.heart.isHidden = true
        
        guard galleryDataSource.count != 0,
              galleryDataSource.count > indexPath.row
              else { return errorCell }
        
        cell.setContent(with: galleryDataSource[indexPath.row])
        if cell.imageContainer.image != nil { cell.loadingIndicator.stopAnimating() }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard galleryDataSource.count > indexPath.row, galleryDataSource.count != 0 else { return }
        
        let destination = ImagePreviewViewController()
        destination.galleryDataSource = self.galleryDataSource
        destination.image = galleryDataSource[indexPath.row]
        destination.index = indexPath.row
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? GalleryCell {
            selectedCell.imageContainer.motionIdentifier = "image"
        }

        self.navigationController?.pushViewController(destination, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.15) {
            self.gallery.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset((self.safeAreaTop + 24) * self.heightModifier)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard galleryDataSource.count > indexPath.row, galleryDataSource.count != 0 else { return }

        let imageToLoad = galleryDataSource[indexPath.row]

        guard imageToLoad.thumb == nil else { return }
        
        if let galleryCell = cell as? GalleryCell {
            
            imageToLoad.getImagefrom(imageToLoad.thumbSize) { (image) in
                imageToLoad.thumb = image
            }
            
            galleryCell.setContent(with: imageToLoad)
        }
        
    }
    


}
