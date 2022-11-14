//
//  FavouritesViewController.swift
//  Nasa
//
//  Created by Saurav Satpathy on 13/11/22.
//

import Foundation
import UIKit

class FavouritesViewController: UIViewController {
    
    var viewModel = FavouritesViewModel()
    @IBOutlet weak var collectionView: UICollectionView!
    var showFavouritePod: ((PlanatoryPod)->Void)?
    override func viewDidLoad() {
        viewModel.getAstronomyPods { pods in
            self.collectionView.reloadData()
        } failed: { message in
            
        }

    }
    
    
    
    
}

extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.astronomyPods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouritePodCell", for: indexPath) as! FavouritePodCell
        cell.populateData(pod: viewModel.astronomyPods[indexPath.row])
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showFavouritePod?(viewModel.astronomyPods[indexPath.row].toPlanatoryPod())
        dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width * 0.33
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}
