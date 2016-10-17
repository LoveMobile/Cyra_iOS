//
//  TTChannel.swift
//  Cyra
//
//  Created by Piotr on 13.08.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import UIKit

enum TTChannelStatus: Int
{
	case Unknown = -1
	case SeekingCandidates = 0
	case CandidateInterview = 1
}

enum TTChannelDictionary: String
{
	case Status = "status"
	case Status1 = "channel_status"
	case UID = "channel_id"
	case JobRole = "job_role"
	case RoleType = "role_type"
	
	case Candidates = "candidates"
	case CandidatesRemoved = "removed"
	case CandidatesShortlisted = "shortlisted"
	case Conversation = "conversation"
	
	case UserMessageRestore = "user_msg"
	case CyraMessage1Restore = "cyra_msg_1"
	case CyraMessage2Restore = "cyra_msg_2"
	case OptionFlag = "option_flag"
	case OptionsMessage = "options"
	case Slider = "slider_flag"
}

class TTChannel: NSObject
{
	var uid: NSNumber = 0
	var status: TTChannelStatus = .Unknown
	var arrayMessages = [TTMessage]()
	var candidatesSet = TTCandidateSet()
	var roleType = ""
	var statusString: String
	{
		get
		{
			switch status
			{
			case .Unknown: return ""
			case .SeekingCandidates: return "Seeking Candidates"
			case .CandidateInterview: return "Candidate Interview"
			}
		}
	}
	var statusColor: UIColor
	{
		get
		{
			switch status
			{
			case .Unknown: return UIColor.lightGrayColor()
			case .SeekingCandidates: return UIColor.cyraPink()
			case .CandidateInterview: return UIColor.lightGrayColor()
			}
		}
	}
	var jobRole = ""
	var arrayCandidatesShortlisted = [TTCandidate]()
	var arrayCandidatesRemoved = [TTCandidate]()
	
	init(dictionary: [String: AnyObject])
	{
		super.init()
		
		if let uid = dictionary[TTChannelDictionary.UID.rawValue] as? NSNumber
		{
			self.uid = uid
		}
		if let status = dictionary[TTChannelDictionary.Status.rawValue] as? Int
		{
			self.status = TTChannelStatus(rawValue: status)!
		}
		if let status1 = dictionary[TTChannelDictionary.Status1.rawValue] as? Int
		{
			self.status = TTChannelStatus(rawValue: status1)!
		}
		if let jobRole = dictionary[TTChannelDictionary.JobRole.rawValue] as? String
		{
			self.jobRole = jobRole
		}
		if let roleType = dictionary[TTChannelDictionary.RoleType.rawValue] as? String
		{
			self.roleType = roleType
		}
		
		addInitialMessage()
	}
	
	func restore(dictionary: [String: AnyObject])
	{
		if let candidates = dictionary[TTChannelDictionary.Candidates.rawValue] as? [String: AnyObject]
		{
			var counter = 0
			if let shortlisted = candidates[TTChannelDictionary.CandidatesShortlisted.rawValue] as? [[String: AnyObject]]
			{
				for dictionary in shortlisted
				{
					counter += 1
					let candidate = TTCandidate(dictionary: dictionary)
					candidate.seen = true
					candidate.feedbackSent = true
					candidate.shortlisted = true
					candidate.number = counter
					self.candidatesSet.addCandidate(candidate)
				}
			}
			if let removed = candidates[TTChannelDictionary.CandidatesRemoved.rawValue] as? [[String: AnyObject]]
			{
				for dictionary in removed
				{
					counter += 1
					let candidate = TTCandidate(dictionary: dictionary)
					candidate.seen = true
					candidate.feedbackSent = true
					candidate.removed = true
					candidate.number = counter
					self.candidatesSet.addCandidate(candidate)
				}
			}
		}
		
		if let conversation = dictionary[TTChannelDictionary.Conversation.rawValue] as? [[String: AnyObject]]
		{
			arrayMessages.removeAll()
//			addInitialMessage()
			
			for messageDictionary in conversation
			{
				if let userMessage = messageDictionary[TTChannelDictionary.UserMessageRestore.rawValue] as? String
				{
					if userMessage.characters.count > 0
					{
						arrayMessages.append(TTMessage(restoreUserWithMessage: userMessage))
					}
				}
				if let cyraMessage1 = messageDictionary[TTChannelDictionary.CyraMessage1Restore.rawValue] as? String
				{
					if cyraMessage1.characters.count > 0
					{
						arrayMessages.append(TTMessage(restoreCyraWithMessage: cyraMessage1))
					}
				}
				if let cyraMessage2 = messageDictionary[TTChannelDictionary.CyraMessage2Restore.rawValue] as? String
				{
					if cyraMessage2.characters.count > 0
					{
						arrayMessages.append(TTMessage(restoreCyraWithMessage: cyraMessage2))
					}
				}
				if let optionFlag = messageDictionary[TTChannelDictionary.OptionFlag.rawValue] as? Int
				{
					if optionFlag > 0
					{
						if let options = messageDictionary[TTChannelDictionary.OptionsMessage.rawValue] as? [String: AnyObject]
						{
							if options.values.count > 0
							{
								arrayMessages.append(TTMessage(restoreOptions: options))
							}
						}
					}
				}
				if let slider = messageDictionary[TTChannelDictionary.Slider.rawValue] as? Int
				{
					if slider > 0
					{
						let messageSlider = TTMessageCandidatesSet(candidatesSet: candidatesSet)
						arrayMessages.append(messageSlider)
						arrayMessages.append(TTMessage(restoreButtonFinalize: slider))
					}
				}
			}
		}
		
	}

	func addInitialMessage()
	{
//		var login = TTUser.mainUser().login
//		
//		let range = login!.rangeOfString("@")
//		
//		if range != nil
//		{
//			login = login!.substringToIndex(range!.startIndex)
//		}
//		
//		arrayMessages.append(TTMessage(text: "Hi \(login!).", type: .TextRecBo))
	}
}
