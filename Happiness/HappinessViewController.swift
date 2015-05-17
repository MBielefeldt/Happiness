//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Mads Bielefeldt on 17/05/15.
//  Copyright (c) 2015 GN ReSound. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController
{
    var happiness: Int = 50 { // 0 = very sad, 100 = ecstatic
        didSet {
            happiness = min(max(happiness, 0), 100);
            updateUI()
        }
    }

    func updateUI()
    {
        /* ... */
    }
}
