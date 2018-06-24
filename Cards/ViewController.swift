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
    let navigationAnimator = NavigationAnimator()
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
        
        self.navigationController?.delegate = self
        self.navigationItem.title = "First"
    }
    
    func setupData() {
        self.data.append(CardData("Title 1", image: #imageLiteral(resourceName: "image1")))
        self.data.append(CardData("Title 2", image: #imageLiteral(resourceName: "image2")))
        self.data.append(CardData("Title 3", image: #imageLiteral(resourceName: "image3")))
        self.data.append(CardData("Title 4", image: #imageLiteral(resourceName: "image4")))
    }

    func requests() {
        let urlString1 = "https://api.reali.com/offers/getPlaceOfferScreenData"
        let url = URL(string: urlString1)!
        
        let dataDictionary = [
            "authToken": "57c67192-724f-4596-bca4-b416bff1de31",
            "listingId": "22d2df96-a4a9-48af-8604-5f20f33f5f50"
        ]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: dataDictionary, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dispatchGroup = DispatchGroup()
        for i in 1...10 {
            dispatchGroup.enter()
            Timer.scheduledTimer(withTimeInterval: Double(i * 3), repeats: false) { (_) in
                
                //            URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request) { (data, response, error) in
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    if let data = data, let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String,AnyObject> {
                        if let errorObject = dictionary!["errorObject"] {
                            print("\(i)\t: status \((response as! HTTPURLResponse).statusCode)\t error \(errorObject.debugDescription)")
                        } else {
                            print("\(i)\t: status \((response as! HTTPURLResponse).statusCode)")
                        }
                    } else {
                        print("\(i)\t: status \((response as? HTTPURLResponse)?.statusCode ?? -1)\t \(error?.localizedDescription ?? "nil")")
                    }
                    dispatchGroup.leave()
                    }.resume()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global(qos: .background)) {
            DispatchQueue.main.async {
                print("All Ended")
            }
        }
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
        cell.cardView.corners(true)
        return cell
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let cardView = self.selectedCardView {
            self.transition.originFrame = cardView.convert(cardView.bounds, to: self.view)
        }
        transition.presenting = true
//        self.transition.dismissCompletion = {
//            self.selectedCardView?.isHidden = false
//        }
        self.transition.originView = selectedCardView
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
            self.transition.cardData = self.data[indexPath.row]
            vc.transitioningDelegate = self
            vc.image = cardCell.cardView.imageView.image
            self.selectedCardView = cardCell.cardView

            self.present(vc, animated: true, completion: nil)
//            self.navigationController?.pushViewController(vc, animated: true)
        }
//        self.requests()
    }
}

extension ViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.navigationAnimator.operation = operation
        self.navigationAnimator.originalImageView = self.selectedCardView?.imageView
        self.navigationAnimator.originalFrame = self.selectedCardView?.imageView.convert(self.selectedCardView!.imageView.bounds, to: self.view).offsetBy(dx: 0, dy: -44)
        return self.navigationAnimator
    }
}

