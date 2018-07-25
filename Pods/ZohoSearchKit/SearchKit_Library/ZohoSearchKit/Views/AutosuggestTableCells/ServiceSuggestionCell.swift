//
//  ServiceSuggestionCell.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 12/03/18.
//

import UIKit

class ServiceSuggestionCell: UITableViewCell{
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
        flowLayout.scrollDirection = .horizontal
        self.collectionView.register(ServiceSuggestionCollectionViewCell.nib, forCellWithReuseIdentifier:ServiceSuggestionCollectionViewCell.identifier)
        
        //MARK: This has been added to make App compatible with iOS 9 and above. in 9, we need to do manual scroll and select.
        let selectedServiceIndexPath = IndexPath(row: SearchResultsViewModel.selected_service, section: 0)
        collectionView.scrollToItem(at: selectedServiceIndexPath, at: .init(rawValue: 0), animated: true)
        collectionView.selectItem(at: selectedServiceIndexPath, animated: true, scrollPosition: .init(rawValue: 0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
extension ServiceSuggestionCell :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 94)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SearchResultsViewModel.UserPrefOrder.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceSuggestionCollectionViewCell.identifier, for: indexPath) as? ServiceSuggestionCollectionViewCell else {
            fatalError("UICollectionViewCell should be or extend from TabBarCollectionViewCell")
        }
        
        cell.label.text = SearchResultsViewModel.UserPrefOrder[indexPath.row].itemInfo.title // Display Name
        
        if indexPath == collectionView.indexPathsForSelectedItems?.first // if current cell is in selected state
        {
            cell.label.textColor = SearchKitConstants.ColorConstants.SelectedServiceGradientBottomColor
            
            let img:UIImage = ServiceIconUtils.getServiceSelectedStateIcon(serviceName: SearchResultsViewModel.UserPrefOrder[indexPath.row].itemInfo.serviceName!)!
            let imageView = UIImageView.createCircularImageViewWithInsetForGradient(image: img, insetPadding: 10, imageViewWidth: 50, imageViewHeight: 50)
            
            //Setting gradient, will later export this code outside
            let colorTop =  SearchKitConstants.ColorConstants.SelectedServiceGradientTopColor.cgColor
            let colorBottom = SearchKitConstants.ColorConstants.SelectedServiceGradientBottomColor.cgColor
            
            let view = UIView(frame: imageView.frame)
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorBottom]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame = imageView.bounds
            gradientLayer.cornerRadius = (imageView.frame.width/2)
            view.layer.insertSublayer(gradientLayer, at: 0)
            cell.image.addSubview(view)
            //setting gradient ends
            
            //imageView.bringSubview(toFront: view)
            //first gradient view should be added then only the image view should be added otherwise service icon will not be visible
            cell.image.addSubview(imageView)
        }
        else // non-selected
        {
            cell.label.textColor = UIColor.darkGray
            let img:UIImage = ServiceIconUtils.getServiceIcon(serviceName: SearchResultsViewModel.UserPrefOrder[indexPath.row].itemInfo.serviceName!)!
            
            let imageView =  UIImageView.createCircularImageViewWithInset(image: img, bgColor: SearchKitConstants.ColorConstants.UnSelectedStateServiceBgColor, borderColor: SearchKitConstants.ColorConstants.UnSelectedStateServiceBorderColor, insetPadding: 8, imageViewWidth: 50, imageViewHeight: 50)
            
            //imageView.maskCircle(anyImage: img)
            cell.image.addSubview(imageView)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performUIUpdatesOnMain {
            SearchResultsViewModel.selected_service = indexPath.row
            self.collectionView.reloadData()
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init(rawValue: 0))
            let ViewController = self.getParentViewController() as! SearchQueryViewController
            ViewController.searchbar.awakeFromNib()
            
        }
        
        
}
}

