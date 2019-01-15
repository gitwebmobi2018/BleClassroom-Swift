//
//  RootNavigationController.swift
//  UNITRACK
//
//  Created by gitwebmobi1019 on 2018-01-12.
//  Copyright © 2018 gitwebmobi1019. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.tintColor = UIColor(red: 252.0/255.0, green: 71.0/255.0, blue: 7.0/255.0, alpha: 1)
    }

}
