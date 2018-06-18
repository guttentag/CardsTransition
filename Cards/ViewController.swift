//
//  ViewController.swift
//  Cards
//
//  Created by Eran Guttentag on 17/06/2018.
//  Copyright © 2018 Reali. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    let transition = Animator()
    var data = [CardData]()
    let layout = UICollectionViewFlowLayout()
    var selectedCardView: CardView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setupData()
        
        self.collectionView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.layout.itemSize = CGSize(width: 350, height: 350)
        self.collectionView.collectionViewLayout = self.layout
        self.collectionView.reloadData()
        
    }
    
    func setupData() {
        self.data.append(CardData("Title 1", image: #imageLiteral(resourceName: "image1")))
        self.data.append(CardData("Title 2", image: #imageLiteral(resourceName: "image2")))
        self.data.append(CardData("Title 3", image: #imageLiteral(resourceName: "image3")))
        self.data.append(CardData("Title 4", image: #imageLiteral(resourceName: "image4")))
    }

}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CardCollectionViewCell
        cell.cardView.imageView.image = item.image
        cell.cardView.titleView.text = item.title
        return cell
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let cardView = self.selectedCardView {
            self.transition.originFrame = cardView.convert(cardView.bounds, to: self.view)
        }
        transition.presenting = true
        self.transition.dismissCompletion = {
            self.selectedCardView?.isHidden = false
        }
//        self.transition.originView = selectedCardView
        self.selectedCardView?.isHidden = true
        return self.transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transition.presenting = false
        return self.transition
    }
}


extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if
            let cell = collectionView.cellForItem(at: indexPath),
            let cardCell = cell as? CardCollectionViewCell,
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Details") as? DetinationViewController
        {
            vc.transitioningDelegate = self
            vc.image = cardCell.cardView.imageView.image
            self.selectedCardView = cardCell.cardView
            
            self.present(vc, animated: true, completion: nil)
        }
    }
}
