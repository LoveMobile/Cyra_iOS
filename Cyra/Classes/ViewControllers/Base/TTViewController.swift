//
//  TTViewController.swift
//  Cyra
//
//  Created by Piotr on 18.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import UIKit

class TTViewController: UIViewController
{
	var finishesEditingOnTouch = false
	
	override func viewDidLoad()
	{
		super.viewDidLoad()

		view.backgroundColor = UIColor.backgroundGray()
		
		if navigationController != nil
		{
			if navigationController?.viewControllers.count > 1
			{
				navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btnBack"),
				                                                   style: UIBarButtonItemStyle.Plain,
				                                                   target: self,
				                                                   action: #selector(TTViewController.customPop))
			}
		}
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
	{
		super.touchesBegan(touches, withEvent: event)
		
		if finishesEditingOnTouch
		{
			view.endEditing(true)
		}
	}

//MARK: Action handling
	
	func customPop()
	{
		navigationController?.popViewControllerAnimated(true)
	}
	
}
