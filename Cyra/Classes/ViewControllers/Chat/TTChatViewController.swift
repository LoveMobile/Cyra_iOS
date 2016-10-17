//
//  TTChatViewController.swift
//  Cyra
//
//  Created by Piotr on 18.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import UIKit
import Alamofire

let kMessageFinalize: String = "No"

class TTChatViewController: TTViewController,
 UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var viewBottomContainer: UIView!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var buttonSend: UIButton!
	@IBOutlet weak var constraintContainerBottom: NSLayoutConstraint!
	
	var messageInitial: String!
	var selectedCandidate: TTCandidate!
	var jobRole: String?
	var channel: TTChannel!
	var sendingFeedback = false
	var finalized = false
    var isCandidateSet = false
    var isNewChannelOrLastAsk = false
    var showActivityLoader = false
    var hideActivityLoader = true
    var performSendFeedback = false
    var isChannelArchive = false
    var eraseTwoLastMessagesWhenIsChannelArchive = true
    var indexCandidatesSetInArrayMessages: Int = 0
	
	override func viewDidLoad()
	{
		super.viewDidLoad()

		navigationController?.navigationBarHidden = false
		
		NSNotificationCenter.defaultCenter().addObserver(self,
		                                                 selector: #selector(TTChatViewController.keyboardDidAppear(_:)),
		                                                 name: UIKeyboardDidShowNotification,
		                                                 object: nil)
		
		NSNotificationCenter.defaultCenter().addObserver(self,
		                                                 selector: #selector(TTChatViewController.keyboardDidDisappear(_:)),
		                                                 name: UIKeyboardDidHideNotification,
		                                                 object: nil)
		
		buttonSend.setTitleColor(UIColor.cyraPink(), forState: .Normal)
		
		tableView.separatorStyle = .None
		tableView.allowsSelection = false
		tableView.backgroundColor = UIColor.clearColor()
		tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
		view.backgroundColor = UIColor.backgroundGray()

		if jobRole != nil
		{
			title = jobRole
            isNewChannelOrLastAsk = true
			TTNetworkingEngine.requestChannelCreate(jobRole!, completion: { (responseObject, errorMessage) in
				
				if responseObject is TTChannel
				{
					self.channel = (responseObject as! TTChannel)
					self.channelInitialize()
				}
				else
				{
					TTStuff.handleErrorWithMessage(errorMessage!)
				}
			})
		}
		else
		{
			title = channel.jobRole
            isNewChannelOrLastAsk = false
			channelInitialize()
		}
	}
	
	override func viewDidAppear(animated: Bool)
	{
		super.viewDidAppear(animated)
        hideActivityLoader = true
        if showActivityLoader
        {
            FPActivityLoader.addActivityLoader(self.view)
            showActivityLoader = false
        }
        
        NSLog("Channel: \(channel)")
        if channel != nil {
            if channel.arrayMessages.count != 0{
                for message in channel.arrayMessages
                {
                    if message.type == .CandidatesSet
                    {
                        isCandidateSet = true
                    }
                }
            }
        }

		reloadData()
        
        if isChannelArchive
        {
            viewBottomContainer.hidden = true
            
        }
	}
	
	func keyboardDidAppear(notification: NSNotification)
	{
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
		{
			UIView.animateWithDuration(UIApplication.sharedApplication().statusBarOrientationAnimationDuration)
			{
				self.constraintContainerBottom.constant = keyboardSize.height
				self.reloadData()
			}
		}
	}
	
	func keyboardDidDisappear(notification: NSNotification)
	{
		UIView.animateWithDuration(UIApplication.sharedApplication().statusBarOrientationAnimationDuration)
		{
			if self.constraintContainerBottom	!= nil
			{
				self.constraintContainerBottom.constant = 0
				self.reloadData()
			}
		}
	}
    
    func removeCandidatesWithoutActions()
    {
        for candidate in channel.candidatesSet.arrayCandidatesWithoutFeedback
        {
            if candidate.seen == true && candidate.shortlisted == false
            {
                candidate.removed = true
            }
        }
    }
    
    func removeLastMessagesAfterCandidateSet()
    {
        var temporaryIndex = 1
        print("Count messages: ", channel.arrayMessages.count)
        for message in channel.arrayMessages
        {
            temporaryIndex += 1
            if message.type == .CandidatesSet
            {
                indexCandidatesSetInArrayMessages = temporaryIndex
                print("Index CandidatesSet: ", indexCandidatesSetInArrayMessages)
            }
        }
        var amountMessageToRemove = channel.arrayMessages.count - indexCandidatesSetInArrayMessages
        print("Amount messages to remove: ", amountMessageToRemove)
        
        while amountMessageToRemove > 0
        {
            channel.arrayMessages.removeLast()
            amountMessageToRemove -= 1
        }
    }
	
//MARK: Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		if segue.identifier == TTSegueNames.ChatToCandidate.rawValue
		{
			if let vc = segue.destinationViewController as? TTWebViewViewController
			{
				vc.title = selectedCandidate.fullName
				vc.URLString = TTNetworkingEngine.CVURLWithCandidate(selectedCandidate).absoluteString
			}
		}
	}
	
//MARK: UITextField delegate
	
	func textFieldShouldReturn(textField: UITextField) -> Bool
	{
		onTapButtonSend()
		
		return true
	}
	
//MARK: UITableView datasource & delgate
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int
	{
			return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		if channel == nil
		{
			return 0
		}
        
        if isChannelArchive && isCandidateSet
        {
            removeLastMessagesAfterCandidateSet()
            return channel.arrayMessages.count
        }
        else
        {
            return channel.arrayMessages.count
        }
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
	{
		let message = channel.arrayMessages[indexPath.row]
		let width = tableView.frame.size.width
		
		switch message.type
		{
		case .TextMe:					return TTChatMeTextCell.heightWithMessage(message, fittingWidth: width)
		case .TextRecBo:			return TTChatRecBoTextCell.heightWithMessage(message, fittingWidth: width)
		case .OptionsRecBo:		return TTChatOptionsCell.heightWithMessage(message, fittingWidth: width)
		case .ActionRecBo:		return TTChatRecBoTextCell.heightWithMessage(message, fittingWidth: width)
		case .CandidatesSet:	return TTChatCandidatesSetCell.heightWithMessage(message, fittingWidth: width)
		case .Button:					return TTChatButtonCell.heightWithMessage(message, fittingWidth: width)
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let message = channel.arrayMessages[indexPath.row]
		
		let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierWithMessageType(message.type),
		                                                       forIndexPath: indexPath) as! TTChatTableViewCell
		
		cell.message = message
        
		cell.backgroundColor = UIColor.clearColor()
		
		switch message.type
		{
		case .TextMe:
            if isChannelArchive
            {
                
            }
			break
		case .TextRecBo:
			break
		case .ActionRecBo:
			break
		case .OptionsRecBo:
			(cell as! TTChatOptionsCell).tapOptionHandler = {
				string in
				self.textField.text = string
				
				let lastMessage = self.channel.arrayMessages.last
				if lastMessage!.type == .OptionsRecBo
				{
					self.channel.arrayMessages.popLast()
					self.reloadData()
				}
				
				self.onTapButtonSend()
			}
			break
		case .CandidatesSet:
            
			self.viewBottomContainer.hidden = true
            self.textField.resignFirstResponder()
			let candidatesSetCell = cell as! TTChatCandidatesSetCell
			candidatesSetCell.isChannelArchive = isChannelArchive
			candidatesSetCell.updateLabel()
			
			candidatesSetCell.maxCandidatesHandler = {
				self.performActionFinalizeConversation()
			}
			
			candidatesSetCell.loadMoreHandler = {
				
				if !self.finalized
				{
                    self.sendFeedback()
				}
			}
			
			candidatesSetCell.tapHandler = {candidate, tapType, performSendFeedback in
			
				switch tapType
				{
				case .Candidate:
					self.selectedCandidate = candidate
					self.performSegueWithIdentifier(TTSegueNames.ChatToCandidate.rawValue, sender: self)
					break
					
				case .Like:
					self.onTapLikeCandidate(candidate)
                    if performSendFeedback
                    {
                        self.removeCandidatesWithoutActions()
                        self.sendFeedback()
                    }
					break
					
				case .Dislike:
					self.onTapDislikeCandidate(candidate)
                    if performSendFeedback
                    {
                        self.removeCandidatesWithoutActions()
                        self.sendFeedback()
                    }
					break
				}
			}
			break
			
		case .Button:
			let buttonCell = cell as! TTChatButtonCell
			
            if isChannelArchive
            {
                buttonCell.button.hidden = true
            }
            
			buttonCell.tapHandler = { () in
                
				if !self.finalized
				{
					if self.channel.candidatesSet.atLeastOneFeedback()
					{
                        self.isNewChannelOrLastAsk = true
                        
                        self.sendMessage(kMessageFinalize)
						//self.performActionFinalizeConversation()
					}
					else
					{
						UIAlertView(title: "Missing feedback?",
												message: "Please give feedback on at least one candidate.",
												delegate: nil,
												cancelButtonTitle: "OK").show()
					}
				}
			}
			
			break
		}
		return cell
	}

//MARK: Action handling
	
	func onTapLikeCandidate(candidate: TTCandidate)
	{
		candidate.shortlisted = true
		candidate.removed = false
		reloadData()
	}
	
	func onTapDislikeCandidate(candidate: TTCandidate)
	{
		candidate.removed = true
		candidate.shortlisted = false
		reloadData()
	}
	
	@IBAction func onTapButtonSend()
	{
		if textField.text?.characters.count < 1
		{
			return
		}
		
		sendMessage(textField.text!)
		textField.text = ""
	}
	
//MARK: Networking
	
	func channelInitialize()
	{
		TTNetworkingEngine.requestChannelInitialize(channel.uid) { (responseObject, errorMessage) in
			
			if responseObject != nil
			{
				self.channel.restore(responseObject as! [String: AnyObject])
                if self.isNewChannelOrLastAsk
                {
                    self.sendMessage("start_session_hi")
                }
				self.reloadData()
			}
		}
	}
	
	func sendFeedback()
	{
		if sendingFeedback
		{
			return
		}
    
        removeCandidatesWithoutActions()
		sendingFeedback = true

        FPActivityLoader.addActivityLoader(self.view)
        
		TTNetworkingEngine.requestSendFeedback(channel!.uid,
		                                       candidates: channel.candidatesSet.arrayCandidatesWithoutFeedback)
        { (responseObject, errorMessage) in
			
			if responseObject is TTMessage
			{
				self.channel.candidatesSet.setFeedbackSent()
                let message = responseObject as! TTMessage
                print("Endpoint from API -> powinien byc get-feedback-result/: ", message.api)
                FPActivityLoader.hideActivityLoaderForView(self.view)
                //  TODO: change performActionGetFeedbackResults - change EndPoint from API send-feedback: api: String-> /
                self.performActionGetFeedbackResults()
				self.reloadData()
			}
			else
			{
				TTStuff.handleErrorWithMessage(errorMessage!)
			}
		}
	}
	
	func sendMessage(string: String)
	{
		if !isNewChannelOrLastAsk
        {
            channel.arrayMessages.append(TTMessage(text: string, type: .TextMe))
            reloadData()
            addCyraPlaceholder()
        }
        
        isNewChannelOrLastAsk = false
		TTNetworkingEngine.requestAsk(channel!.uid,
		                              message: string) { (responseObject, errorMessage) in
			
																		self.popCyraPlaceholder()
			
																		if let message = responseObject as? TTMessage
																		{
																			self.analyseMessage(message)
																			self.reloadData()
                                                                            if string == kMessageFinalize
                                                                            {
                                                                                self.performActionFinalizeConversation()
                                                                            }
                                                                            
																		}
																		else
																		{
																			TTStuff.handleErrorWithMessage(errorMessage!)
																		}
		}
        

	}

	func performAction(action: TTMessageAPI)
	{
		addCyraPlaceholder()
		
		switch action
		{
		case .None:
			break
		case .Match:
			performActionGetMatches()
			break
			
		case .Finalize:
			performActionFinalizeConversation()
			break
			
		case .FeedbackResults:
			performActionGetFeedbackResults()
			break
		}
	}
	
	func performActionGetFeedbackResults()
	{
        FPActivityLoader.addActivityLoader(self.view)
		TTNetworkingEngine.requestGetFeedbackResult(self.channel!.uid,
		                                            completion: { (responseObject, errorMessage) in
																									
																									
																									self.popCyraPlaceholder()
																									self.sendingFeedback = false
			
																									if responseObject != nil
																									{
																										if let candidates = (responseObject as! [String: AnyObject])["candidates"] as? [[String: AnyObject]]
																										{
																											for dictionary in candidates
																											{
																												let candidate = TTCandidate(dictionary: dictionary)
																												self.channel.candidatesSet.addCandidate(candidate)
																												candidate.number = self.channel.candidatesSet.candidatesCount
																											}
																											self.reloadData()
                                                                                                            FPActivityLoader.hideActivityLoaderForView(self.view)
																										}
																										else
																										{
																											TTStuff.handleErrorWithMessage(errorMessage!)
																										}
																									}
			})

	}
//	tutaj odpierdol koncowke!!!!!!!!
	func performActionFinalizeConversation()
	{
		if finalized
		{
			return
		}
		
		self.finalized = true
        
		TTNetworkingEngine.requestFinalize(channel!.uid,
		                                   completion: { (responseObject, errorMessage) in
		
																				self.popCyraPlaceholder()
																				self.channel.candidatesSet.setFeedbackSent()
																				self.popMessageOfType(.Button)
//																				self.popMessageOfType(.TextRecBo)

//																				self.channel.arrayMessages.append((TTMessage(restoreCyraWithMessage: "Thanks for using Cyra. We have sent you the shortlisted candidates by email and will be in touch to arrange interviews.")))
																				self.reloadData()
		})
	}
	
	func performActionGetMatches()
	{
		TTNetworkingEngine.requestMatch(channel!.uid,
		                                completion: { (responseObject, errorMessage) in
				
			self.popCyraPlaceholder()
			
			if let candidates = (responseObject as! [String: AnyObject])["candidates"] as? [[String: AnyObject]]
			{
				for dictionary in candidates
				{
					let candidate = TTCandidate(dictionary: dictionary)
					self.channel.candidatesSet.addCandidate(candidate)
					candidate.number = self.channel.candidatesSet.candidatesCount
				}
				
				self.channel.arrayMessages.append(TTMessageCandidatesSet(candidatesSet: self.channel.candidatesSet))
				self.channel.arrayMessages.append(TTMessage(text: "I am done", type: .Button))
				
				self.reloadData()
			}
			else
			{
			TTStuff.handleErrorWithMessage(errorMessage!)
            }
		})
	}
	
//MARK: Convinience methods
	
	func analyseMessage(message: TTMessage)
	{
		self.channel.arrayMessages.append(message)
		let message2 = message.splitMessage2()
        
		if message2 != nil
		{
			self.channel.arrayMessages.append(message2!)
		}
		let messageOptions = message.splitOptions()
        
		if messageOptions != nil
		{
			self.channel.arrayMessages.append(messageOptions!)
		}
		let messageAction = message.splitAction()
        
		if messageAction != nil
		{
			self.performAction(messageAction!.api)
		}
	}
	
	func cellIdentifierWithMessageType(messageType: TTMessageType) -> String
	{
		return "kIdentifierCellChat\(messageType.rawValue)"
	}
	
	func addCyraPlaceholder()
	{
		channel.arrayMessages.append(TTCyraPlaceholder())
		reloadData()
	}
	
	func reloadData()
	{
        if self.channel != nil{
            if self.channel.arrayMessages.count > 0
            {
                tableView.reloadData()
                performSelector(#selector(TTChatViewController.delayedScroll), withObject: nil, afterDelay: 0.3)
            }
        }

	}
	
	func delayedScroll()
	{
		let indexPath = NSIndexPath(forItem: self.channel.arrayMessages.count-1, inSection: 0)
		self.tableView.scrollToRowAtIndexPath(indexPath,
		                                      atScrollPosition: .Bottom,
		                                      animated: true)
        print("wywolany delayedScroll!")
        if hideActivityLoader
        {
        FPActivityLoader.hideActivityLoaderForView(self.view)
        hideActivityLoader = false
        }
	}
	
	func popCyraPlaceholder()
	{
		if self.channel.arrayMessages.last is TTCyraPlaceholder
		{
			self.channel.arrayMessages.popLast()
		}
		reloadData()
	}

	func popMessageOfType(type: TTMessageType)
	{
		let lastMessage = self.channel.arrayMessages.last!
		
		if lastMessage.type == type
		{
			self.channel.arrayMessages.popLast()
			reloadData()
		}
	}
}
