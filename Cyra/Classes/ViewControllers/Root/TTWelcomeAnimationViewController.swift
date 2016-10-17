//
//  TTWelcomeAnimationViewController.swift
//  Cyra
//
//  Created by Piotr on 29.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import UIKit

class TTWelcomeAnimationViewController: TTViewController,
UITableViewDelegate, UITableViewDataSource
{
	@IBOutlet var tableView: UITableView!
	var currentAnimation = 0
	var arrayMessages = [TTMessage]()

	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		tableView.bounces = false
		tableView.userInteractionEnabled = false
		tableView.separatorStyle = .None
		tableView.backgroundColor = UIColor.backgroundGray()
	}
	
	func animate()
	{
		if arrayMessages.count < allMessages().count
		{
		arrayMessages.append(allMessages()[currentAnimation])
			tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: currentAnimation, inSection: 0)],
			                                 withRowAnimation: UITableViewRowAnimation.Fade)
			currentAnimation += 1
			performSelector(#selector(TTWelcomeAnimationViewController.animate),
			                withObject: nil,
			                afterDelay: 2.5)
		}
	}
	
	func allMessages() -> [TTMessage]
	{
		return
			[
				TTMessage(text: "Hi, I'm Cyra, your smart Recruitment Assistant", type: .TextRecBo),
				TTMessage(text: "Tell me about the role you want by pressing \"Ready to Get Started\"", type: .TextRecBo),
				TTMessage(text: "I will ask you some basic questions about your recruitment requests", type: .TextRecBo),
				TTMessage(text: "and then I will come back to you with suitable candidates", type: .TextRecBo)
		]
	}
	
//MARK: UITableView datasource & delegate
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int
	{
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return arrayMessages.count
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
	{
		let message = arrayMessages[indexPath.row]
		let width = tableView.frame.size.width
		
		return TTChatRecBoTextCell.heightWithMessage(message, fittingWidth: width)
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let message = arrayMessages[indexPath.row]
		
		let cell = tableView.dequeueReusableCellWithIdentifier("kIdentifierCellChat1",
		                                                       forIndexPath: indexPath) as! TTChatRecBoTextCell
		
		cell.message = message
		cell.backgroundColor = UIColor.clearColor()
		cell.contentView.backgroundColor = UIColor.clearColor()
		
		return cell
	}
}
