//
//  TTNavigationController.swift
//  Cyra
//
//  Created by Piotr on 18.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import UIKit

class TTNavigationController: UINavigationController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()

		navigationBar.barStyle = .Black
		navigationBar.translucent = false
		navigationBar.barTintColor = UIColor.cyraPink()
		navigationBar.tintColor = UIColor.whiteColor()
	}

}
