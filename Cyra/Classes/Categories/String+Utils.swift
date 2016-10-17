//
//  String+Utils.swift
//  Actuna
//
//  Created by Piotr on 15.04.2016.
//  Copyright © 2016 ThemTomatoez. All rights reserved.
//

import UIKit

extension String
{
	func heightWithWidth(width: CGFloat, font: UIFont) -> CGFloat
	{
		let constraintRect = CGSize(width: width, height: CGFloat.max)
		
		let boundingBox = self.boundingRectWithSize(constraintRect,
		                                            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
		                                            attributes: [NSFontAttributeName: font],
		                                            context: nil)
		
		return boundingBox.height
	}

	func isValidEmail() -> Bool
	{
		let filter = false
		let filterString = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
		let laxString = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
		let emailRegex = filter ? filterString : laxString
		let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [emailRegex])
		return predicate.evaluateWithObject(self)
	}
	
}
