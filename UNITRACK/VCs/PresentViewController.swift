//
//  PresentViewController.swift
//  UNITRACK
//
//  Created by gitwebmobi1019 on 2018-01-23.
//  Copyright © 2018 gitwebmobi1019. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class PresentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }    

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
