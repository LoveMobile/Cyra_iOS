//
//  TTRootViewController.swift
//  Cyra
//
//  Created by Piotr on 18.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import UIKit
import Alamofire

enum TTChannelsType: Int
{
	case Current = 0
	case Archived = 1
}

class TTRootViewController: TTViewController, UITextFieldDelegate,
	UITableViewDelegate, UITableViewDataSource
{
	@IBOutlet weak var viewContainer: UIView!
	@IBOutlet weak var segmentControl: UISegmentedControl!
	@IBOutlet weak var buttonGetStarted: UIButton!
	@IBOutlet weak var barButtonItemLogout: UIBarButtonItem!
	@IBOutlet weak var tableView: UITableView!
	var arrayChannelsArchived = [TTChannel]()
	var arrayChannelsCurrent = [TTChannel]()
	weak var textFieldJobRole: UITextField?
	var jobRole: String = ""
	weak var welcomeAnimationViewController: TTWelcomeAnimationViewController!
	var type: TTChannelsType
	{
		get
		{
			return TTChannelsType(rawValue: segmentControl.selectedSegmentIndex)!
		}
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()

		let imageView = UIImageView(frame: CGRectMake(0, 0, 100, navigationController!.navigationBar.frame.size.height/2))
		imageView.image = UIImage(named: "logoNavBar")
		imageView.contentMode = .ScaleAspectFit
		navigationItem.titleView = imageView
		
		view.backgroundColor = UIColor.backgroundGray()
		
		buttonGetStarted.buttonStylingSunken()
		
		segmentControl.tintColor = UIColor.whiteColor()
		segmentControl.backgroundColor = UIColor.cyraPink()
		segmentControl.setTitleTextAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(17.0)], forState: .Normal)
		viewContainer.backgroundColor = UIColor.cyraPink()
		
		tableView.alpha = 0.0
		hideTutorial(false)
		
		if !TTUser.mainUser().isAuthenticated()
		{
			performSegueWithIdentifier(TTSegueNames.RootToLogin.rawValue, sender: self)
		}
		
	}

	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		
		TTNetworkingEngine.requestToken { (responseObject, errorMessage) in
			
			if TTUser.mainUser().isAuthenticated()
			{
					TTNetworkingEngine.requestLogin(TTUser.mainUser().login!,
						password: TTUser.mainUser().password!) { (object, errorMessage) in
								
								TTNetworkingEngine.requestInitializeProfile { (responseObject, errorMessage) in
									
									self.getCurrentChannels()
								}
				}
				
			}
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		if segue.identifier == TTSegueNames.RootToChatCreate.rawValue
		{
			if let vc = segue.destinationViewController as? TTChatViewController
			{
				vc.jobRole = jobRole
				jobRole = ""
			}
		}
		else
			if segue.identifier == TTSegueNames.RootToChatInitialize.rawValue
			{
				if let vc = segue.destinationViewController as? TTChatViewController
				{
					if let channel = sender as? TTChannel
					{
						vc.channel = channel
                        vc.showActivityLoader = true //segmentControl.selectedSegmentIndex == 0
                        vc.isChannelArchive = type == .Archived ? true: false

					}
				}
			}
			else
				if segue.identifier == TTSegueNames.RootToTutorial.rawValue
				{
					if let vc = segue.destinationViewController as? TTWelcomeAnimationViewController
					{
						welcomeAnimationViewController = vc
					}
				}
	}
	
	override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
	{
		if identifier == TTSegueNames.RootToChatCreate.rawValue
		{
			if jobRole.characters.count < 1
			{
				return false
			}
		}
		
		return true
	}
	
	func showTutorial()
	{
		self.buttonGetStarted.alpha = 1.0
		self.welcomeAnimationViewController.view.alpha = 1.0
		self.tableView.alpha = 0.0
	}
	
	func hideTutorial(animated: Bool)
	{
		if animated
		{
			UIView.animateWithDuration(1.0,
																 delay: 0.0,
																 usingSpringWithDamping: 0.22,
																 initialSpringVelocity: 0.44,
																 options: UIViewAnimationOptions.CurveEaseInOut,
																 animations:
				{
					self.buttonGetStarted.alpha = 0.0
					self.welcomeAnimationViewController.view.alpha = 0.0
					self.tableView.alpha = 1.0
				})
			{ (completed) in
					
			}
		}
		else
		{
			self.buttonGetStarted.alpha = 0.0
			self.welcomeAnimationViewController.view.alpha = 0.0
			self.tableView.alpha = 1.0
		}
	}
	
//MARK: Networking
	
	func getCurrentChannels()
	{
		TTNetworkingEngine.requestChannelGetCurrent { (responseObject, errorMessage) in
			
			if responseObject is [TTChannel]
			{
				self.arrayChannelsCurrent.removeAll()
				//TODO: channels order is reversed
				self.arrayChannelsCurrent.appendContentsOf( (responseObject as! [TTChannel]).reverse() )
				self.tableView.reloadData()
			}
		}
	}
	
	func getArchivedChannels()
	{
		TTNetworkingEngine.requestChannelGetArchived { (responseObject, errorMessage) in
			
			if responseObject is [TTChannel]
			{
				self.arrayChannelsArchived.removeAll()
				//TODO: channels order is reversed
				self.arrayChannelsArchived.appendContentsOf( (responseObject as! [TTChannel]).reverse() )
				self.tableView.reloadData()
			}
		}
	}
	
//MARK: Action Handling
	
	@IBAction func unwindSegueStartChat(segue: UIStoryboardSegue)
	{
		
	}
	
	@IBAction func unwindSegueLogin(segue: UIStoryboardSegue)
	{
		let activityLoader = FPActivityLoader.addActivityLoader(self.view)
		
		TTNetworkingEngine.requestChannelGetArchived { (responseObject, errorMessage) in
			
			if responseObject is [TTChannel]
			{
				self.arrayChannelsArchived.removeAll()
				//TODO: channels order is reversed
				self.arrayChannelsArchived.appendContentsOf( (responseObject as! [TTChannel]).reverse() )
				self.tableView.reloadData()
			}
			
			TTNetworkingEngine.requestChannelGetCurrent { (responseObject, errorMessage) in

				activityLoader.removeFromSuperview()
				
				if responseObject is [TTChannel]
				{
					self.arrayChannelsCurrent.removeAll()
					//TODO: channels order is reversed
					self.arrayChannelsCurrent.appendContentsOf( (responseObject as! [TTChannel]).reverse() )
					self.tableView.reloadData()
				}
				
				if self.arrayChannelsCurrent.count < 1 && self.arrayChannelsArchived.count < 1
				{
					self.showTutorial()
					self.welcomeAnimationViewController.animate()
				}
				else
				{
					self.hideTutorial(true)
				}
			}
		}
	}
	
	@IBAction func onTapButtonGetStarted()
	{
		let alertController = UIAlertController(title: "Enter your channel's name",
		                                        message: "",
		                                        preferredStyle: UIAlertControllerStyle.Alert)
		
		alertController.addTextFieldWithConfigurationHandler { (textField) in
			
			textField.delegate = self
			textField.tintColor = UIColor.cyraPink()
		}
		
		alertController.addAction(UIAlertAction(title: "Ok",
			style: UIAlertActionStyle.Default,
			handler: { (alertAction) in
				
				if self.jobRole.characters.count < 1
				{
					UIAlertView(title: "Missing channel name!",
						message: "The channel name cannot be empty.",
						delegate: nil,
						cancelButtonTitle: "OK").show()
				}
				else
				{
					self.performSegueWithIdentifier(TTSegueNames.RootToChatCreate.rawValue, sender: self)
				}
		}))
		
		alertController.addAction(UIAlertAction(title: "Cancel",
			style: UIAlertActionStyle.Cancel,
			handler: { (alertAction) in
				
		}))
		
		alertController.view.tintColor = UIColor.cyraPink()
		
		presentViewController(alertController, animated: true) { 
			
		}
	}

	@IBAction func onValueChangedSegmentControl()
	{
		if TTChannelsType(rawValue: segmentControl.selectedSegmentIndex)! == .Current
		{
			getCurrentChannels()
		}
		else
		{
			getArchivedChannels()
		}
	}
	
	@IBAction func onTapButtonLogout()
	{
		TTNetworkingEngine.requestLogout { (responseObject, errorMessage) in
			
			TTUser.mainUser().login = ""
			TTUser.mainUser().password = ""
			AppDelegate.saveContext()
			self.showTutorial()
			self.performSegueWithIdentifier(TTSegueNames.RootToLogin.rawValue, sender: nil)
		}
	}

//MARK: UITextField delegate
	
	func textFieldDidEndEditing(textField: UITextField)
	{
		jobRole = textField.text!
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool
	{
		textField.resignFirstResponder()
		
		return true
	}

//MARK: UITableView delegate & datasource
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int
	{
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return type == .Current ? arrayChannelsCurrent.count : arrayChannelsArchived.count
	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
	{
		return 80.0
//		return 120.0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCellWithIdentifier(TTCellnames.RootCandidateCell.rawValue,
		                                                       forIndexPath: indexPath) as! TTChannelTableViewCell
		
		let arrayChannels = type == .Current ? arrayChannelsCurrent : arrayChannelsArchived
		
		if arrayChannels.count > indexPath.row
		{
			cell.channel = arrayChannels[indexPath.row]
		}
		
		return cell
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		let arrayChannels = type == .Current ? arrayChannelsCurrent : arrayChannelsArchived
		
		performSegueWithIdentifier(TTSegueNames.RootToChatInitialize.rawValue,
		                           sender: arrayChannels[indexPath.row])
	}
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let archive = UITableViewRowAction(style: .Normal, title: "Archive") { (action, indexPath) in
            
            let currentChannel = self.arrayChannelsCurrent[indexPath.row]
                        TTNetworkingEngine.requestChannelArchive(currentChannel.uid) { (responseObject, errorMessage) in
                            
                            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
                            self.getCurrentChannels()
            }
        }
        archive.backgroundColor = UIColor.lightGrayColor()
        return [archive]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return type == .Current ? true : false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
    }
}