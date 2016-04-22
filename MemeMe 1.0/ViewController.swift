//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Phillip Crawford on 4/22/16.
//  Copyright © 2016 Phillip Crawford. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
}

