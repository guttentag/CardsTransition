//
//  CardData.swift
//  Cards
//
//  Created by Eran Guttentag on 17/06/2018.
//  Copyright © 2018 Reali. All rights reserved.
//

import UIKit

struct CardData {
    let image: UIImage
    let title: String
    
    init(_ title: String, image: UIImage) {
        self.title = title
        self.image = image
    }
}
