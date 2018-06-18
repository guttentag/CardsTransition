//
//  CardView.swift
//  Cards
//
//  Created by Eran Guttentag on 17/06/2018.
//  Copyright © 2018 Reali. All rights reserved.
//

import UIKit

class CardView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleView: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    
}

private extension CardView {
    func commonInit() {
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.contentView)
        
        self.contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.backgroundColor = UIColor.clear
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.7
        
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
    }
}
