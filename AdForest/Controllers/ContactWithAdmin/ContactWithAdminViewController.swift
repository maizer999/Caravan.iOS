//
//  ContactWithAdminViewController.swift
//  AdForest
//
//  Created by Charlie on 04/11/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import WebKit

class ContactWithAdminViewController: UIViewController {

    @IBOutlet weak var wkWebView: WKWebView!
    
    
    
    //MARK:-Properties
    

    var  pageUrl = ""
    var  pageTitle = ""
    
    
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = pageTitle
        let yourBackImage = UIImage(named: "backbutton")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.white


        let url = URL(string: pageUrl)
        var request = URLRequest(url: url!)
        request.setValue("body", forHTTPHeaderField: "Adforest-Shop-Request")
        if UserDefaults.standard.bool(forKey: "isSocial") {
            request.setValue("social", forHTTPHeaderField: "AdForest-Login-Type")
        }
        self.wkWebView.load(request)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

