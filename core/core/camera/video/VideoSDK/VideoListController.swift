//
//  VideoListController.swift
//  VideoSDK
//
//  Created by devjia on 2017/11/9.
//  Copyright © 2017年 devjia. All rights reserved.
//

import UIKit
import Photos

fileprivate let reuseIdentifier = "VideoCell"
final class VideoListController: UIViewController {

    var collectionView: UICollectionView!
    var flowLayout: UICollectionViewFlowLayout!
    var fetchResult: PHFetchResult<PHAsset>?
    var thumbnailSize = CGSize.zero
    let imageManager = PHCachingImageManager()
    var previousPreheatRect = CGRect.zero
    var maxInterVal:Double = 15.0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        requestAccessPhotos()
    }
    deinit {
        resetCachedAssets()
    }

    convenience init(_ interVal:Double){
        self.init()
        self.maxInterVal = interVal
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func closeAction() {
        if let picker = navigationController as? VideoPickerController {
            picker.pickerDelegate?.videoPickerControllerDidCancel(picker)
        }
        dismiss(animated: true, completion: nil)
    }
}

// UI
extension VideoListController {
    func setupUI() {
        title = "选择"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(closeAction))
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
//        let closeImage = UIImage(named: "close", in: Bundle(for: VideoListController.self), compatibleWith: nil)
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (ScreenSize.width - 3) / 4, height: (ScreenSize.width - 3) / 4)
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
  
    
    
}

//data
extension VideoListController {
    
    func requestAccessPhotos() {
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.loadData()
            }
        }
    }
    
    func loadData() {
        thumbnailSize = CGSize(width: ScreenSize.width / 4 * 2, height: ScreenSize.width / 4 * 2)
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssets(with: .video, options: PHFetchOptions())
        imageManager.allowsCachingHighQualityImages = false
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.updateCachedAssets()
        }
    }
    
    func requestVideoWithIndexPath(_ indexPath: IndexPath) {
        
    }
}

//缓存
extension VideoListController {
    
    fileprivate func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    
    fileprivate func updateCachedAssets() {
        guard isViewLoaded && view.window != nil else { return }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > view.bounds.height / 3 else { return }
        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
        if fetchResult != nil {
            let addedAssets = addedRects
                .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
                .map { indexPath in fetchResult!.object(at: indexPath.item) }
            let removedAssets = removedRects
                .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
                .map { indexPath in fetchResult!.object(at: indexPath.item) }
            imageManager.startCachingImages(for: addedAssets,
                                                targetSize: thumbnailSize,
                                                contentMode: .aspectFill,
                                                options: nil)
            imageManager.stopCachingImages(for: removedAssets,
                                           targetSize: thumbnailSize,
                                           contentMode: .aspectFill,
                                           options: nil)
        }
        previousPreheatRect = preheatRect
    }
    
    fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                 width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                 width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                   width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                   width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
}

//UICollectionViewDelegate
extension VideoListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let asset = fetchResult?.object(at: indexPath.item) else { return }
      let spliceController =   VideoSpliceController.init(asset: asset, time: self.maxInterVal)
        navigationController?.pushViewController(spliceController, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCachedAssets()
    }
}

//UICollectionViewDataSource
extension VideoListController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VideoCell
        if let asset = fetchResult?.object(at: indexPath.item) {
            cell.label.text = timeString(seconds: asset.duration)
            cell.representedAssetIdentifier = asset.localIdentifier
            imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { (image, info) in
                if cell.representedAssetIdentifier == asset.localIdentifier && image != nil {
                    cell.imageView.image = image
                }
            })
        }
        return cell
    }
    
    func timeString(seconds: TimeInterval) -> String{
        let n = Int(seconds)
        let h = n / 3600
        let m = n % 3600 / 60
        let s = n % 60
        if s >= 3600 {
            return NSString(format: "%d:%02d:%02d", h, m ,s) as String
        }else {
            return NSString(format: "%d:%02d", m ,s) as String
        }
    }
}

fileprivate extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}

