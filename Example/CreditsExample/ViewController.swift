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
        let frameworkBundle = Bundle(identifier: "com.credits")
        let storyboard = UIStoryboard(name: "Storyboard", bundle: frameworkBundle)
        let controller = storyboard.instantiateViewController(withIdentifier: "storyboard") as! CreditsViewController
        
        // TODO: See if this work can be encapsulated so that user can call a method and pass
        // Load plist file in an array
        let licensePath = Bundle.main.path(forResource: "licenses", ofType: "plist")
        let parser = LicenseParser(licensePath: licensePath!)
        controller.parser = parser
        
        // TODO: Embed CreditsViewController in a navigation controller within the framework.
        // TODO: User a segue to handle the above logic.
        let navigationController = UINavigationController(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // TODO: Provide example of custom HTML license body and content.
}
