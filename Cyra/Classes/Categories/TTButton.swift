//
//  TTButton.swift
//  Cyra
//
//  Created by Piotr on 18.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import UIKit

extension UIButton
{
	func buttonStylingSunken()
	{
		titleLabel?.font = UIFont.boldSystemFontOfSize(17)
		setTitleColor(UIColor.whiteColor(), forState: .Normal)
		backgroundColor = UIColor.cyraPink()
		layer.cornerRadius = 2
		layer.masksToBounds = true
		layer.borderWidth = 1
		layer.borderColor = UIColor.whiteColor().CGColor
	}
	
	func buttonStylingRaised()
	{
		titleLabel?.font = UIFont.boldSystemFontOfSize(17)
		setTitleColor(UIColor.cyraPink(), forState: .Normal)
		backgroundColor = UIColor.whiteColor()
		layer.cornerRadius = 2
		layer.masksToBounds = true
	}
	
	func buttonStylingPlain()
	{
		titleLabel?.font = UIFont.boldSystemFontOfSize(15)
		setTitleColor(UIColor.whiteColor(), forState: .Normal)
		backgroundColor = UIColor.clearColor()
	}
	
}
