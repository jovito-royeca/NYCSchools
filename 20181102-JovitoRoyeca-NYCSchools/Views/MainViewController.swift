//
//  MainViewController.swift
//  20181102-JovitoRoyeca-NYCSchools
//
//  Created by Jovito Royeca on 02/11/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import FontAwesome_swift

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // add tab icons
        guard let items = self.tabBar.items else {
            return
        }
        
        items[0].image = UIImage.fontAwesomeIcon(name: .map,
                                                 style: .solid,
                                                 textColor: UIColor.blue,
                                                 size: CGSize(width: 30, height: 30))
        items[1].image = UIImage.fontAwesomeIcon(name: .list,
                                                 style: .solid,
                                                 textColor: UIColor.blue,
                                                 size: CGSize(width: 30, height: 30))
    }


}

