//
//  TTWebViewViewController.swift
//  Cyra
//
//  Created by Piotr on 07.08.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import UIKit
import Alamofire

class TTWebViewViewController: TTViewController, UIWebViewDelegate
{
	@IBOutlet weak var webView: UIWebView!
	var URLString: String!
	var pathAbsolute: String?
	
	override func viewDidLoad()
	{
		super.viewDidLoad()

		webView.scalesPageToFit = true
		webView.delegate = self
		
		URLString.appendContentsOf("?access_token=\(TTUser.mainUser().token!.accessToken!)")
		
		Alamofire.request(.POST,
			NSURL(string: URLString)!,
			parameters:[:],
			encoding: .JSON,
			headers: [String : String]()).responseJSON {
				response in
				
				if response.data != nil
				{
					if let string = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
					{
						print(string)
					}
				}
				
				if response.data != nil
				{
					let suggestedName = response.response?.suggestedFilename ?? "file.pdf"
					
					var path = NSTemporaryDirectory()

					path.appendContentsOf(suggestedName)

					let success = NSFileManager.defaultManager().createFileAtPath(path,
						contents: response.data!,
						attributes: [:])
					
					if success
					{
						self.pathAbsolute = path
						self.performSelector(#selector(TTWebViewViewController.loadOnMainThread), withObject: nil, afterDelay: 0.5)
					}
					else
					{
						UIAlertView(title: "Failed to load candidate CV",
							message: nil,
							delegate: nil,
							cancelButtonTitle: "OK").show()
					}
				}
		}
		
	}
	
	func loadOnMainThread()
	{
		performSelectorOnMainThread(#selector(TTWebViewViewController.loadCV),
		                            withObject: nil,
		                            waitUntilDone: false)
	}
	
	func loadCV()
	{
		if self.pathAbsolute != nil
		{
			self.webView.loadRequest(NSURLRequest(URL: NSURL(string: self.pathAbsolute!)!))
		}
		else
		{
			UIAlertView(title: "Failed to load candidate CV",
			            message: nil,
			            delegate: nil,
			            cancelButtonTitle: "OK").show()
		}
	}

}
