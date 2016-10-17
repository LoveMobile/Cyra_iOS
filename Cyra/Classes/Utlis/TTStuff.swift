//
//  TTStuff.swift
//  Cyra
//
//  Created by Piotr on 25.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import Foundation

typealias TTCompletion = () -> ()
typealias TTCompletionString = (string: String) -> ()
typealias TTRequestCompletion = (responseObject: AnyObject?, errorMessage: String?) -> ()

class TTStuff: NSObject
{
	class func handleErrorWithMessage(message: String)
	{
			
//			UIAlertView(title: "Error",
//			            message: message,
//			            delegate: nil,
//			            cancelButtonTitle: "OK").show()
	}
}
