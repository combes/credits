//
//  ViewController.swift
//  CreditsExample
//
//  Created by Christopher Combes on 1/21/17.
//  Copyright © 2017 Christopher Combes. All rights reserved.
//

import UIKit
import Credits

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showCreditsTapped(_ sender: Any) {

        // Load plist file in an array for the parser to use
        let licensePath = Bundle.main.path(forResource: "licenses", ofType: "plist")
        // Create a new license parser
        let parser = LicenseParser(licensePath: licensePath!)
        // Create a new Credits view controller
        let controller = CreditsViewController.creditsViewController(parser: parser!)
        // Override the title for localization
        controller.title = NSLocalizedString("Third Party Notices", comment: "")
        // Create a navigation controller to show credits inside of
        let navigationController = UINavigationController(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
}
