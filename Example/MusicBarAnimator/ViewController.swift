//
//  ViewController.swift
//  MusicBarAnimator
//
//  Created by raxcat on 03/11/2016.
//  Copyright (c) 2016 raxcat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSLocale.currentLocale().localeIdentifier)
        
//        print(NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode))
//        print(NSLocale.currentLocale().objectForKey(NSLocaleCountryCode))
//        print("\(NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode)!)-\(NSLocale.currentLocale().objectForKey(NSLocaleCountryCode)!)")
        
        print(NSLocale.preferredLanguages())
        
        
//        let ls = NSLocale.preferredLanguages()
        
//        print(NSLocale.preferredLanguages())
        
//        for id in ls {
//            
//            print("orig id:\(id) -> \n\(NSLocale.canonicalLanguageIdentifierFromString(id))\n \(NSLocale.windowsLocaleCodeFromLocaleIdentifier(id))")
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

