//
//  TTMessage.swift
//  Cyra
//
//  Created by Piotr on 22.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import Foundation

enum TTMessageType: Int
{
	case TextMe = 0
	case TextRecBo = 1
	case OptionsRecBo = 2
	case ActionRecBo = 3
	case CandidatesSet = 4
	case Button = 5
}

enum TTMessageDictionary: String
{
	case Action = "action"
	case API = "api"
	case Message1 = "msg1"
	case Message2 = "msg2"
	case Options = "options"
	case OptionFlag = "option_flag"
}

enum TTMessageAPI: String
{
	case None = ""
	case Match = "match"
	case Finalize = "finalize"
	case FeedbackResults = "get-feedback-results"
}

class TTMessage: NSObject
{
	var message1: String!
	var message2: String!
	var hasAction = false
	var hasOption = false
	var api = TTMessageAPI.None
	var type: TTMessageType = TTMessageType.TextMe
	var optionsDictionary = [String: AnyObject]()
	var dateCreation = NSDate()
	
	init(text: String, type: TTMessageType)
	{
		self.type = type
		self.message1 = text
		
		super.init()
	}
	
	init(message: TTMessage)
	{
		super.init()

		self.message1 = message.message1
		self.message2 = message.message2
		self.hasAction = message.hasAction
		self.api = message.api
		self.type = message.type
		self.optionsDictionary = message.optionsDictionary
		self.dateCreation = message.dateCreation
	}
	
	init(dictionary: [String: AnyObject])
	{
		super.init()
		
		self.type = .TextRecBo
		
		if let action = dictionary[TTMessageDictionary.Action.rawValue] as? Bool
		{
			self.hasAction = action
		}
		if let api = dictionary[TTMessageDictionary.API.rawValue] as? String
		{
			self.api = TTMessageAPI(rawValue: api)!
		}
		if let message = dictionary[TTMessageDictionary.Message1.rawValue] as? String
		{
			self.message1 = message
		}
		if let message = dictionary[TTMessageDictionary.Message2.rawValue] as? String
		{
			self.message2 = message
		}
		if let optionsDictionary = dictionary[TTMessageDictionary.Options.rawValue] as? [String: AnyObject]
		{
			self.optionsDictionary = optionsDictionary
		}
		if let option = dictionary[TTMessageDictionary.OptionFlag.rawValue] as? Int
		{
			self.hasOption = Bool(option)
		}
	}
	
	init(restoreCyraWithMessage: String)
	{
		super.init()
		self.type = .TextRecBo
		self.message1 = restoreCyraWithMessage
	}
	
	init(restoreUserWithMessage: String)
	{
		super.init()
		self.type = .TextMe
		self.message1 = restoreUserWithMessage
	}
	
	init(restoreButtonFinalize: Int)
	{
		super.init()
		self.type = .Button
//TODO: button message hardcoded
		self.message1 = "I am done"
	}
	
	init(restoreOptions: [String: AnyObject])
	{
		super.init()
		self.type = .OptionsRecBo
		self.optionsDictionary = restoreOptions
	}
	
	func splitMessage2() -> TTMessage?
	{
		if self.message2.characters.count > 0
		{
			let message = TTMessage(message: self)
			message.message1 = self.message2
			self.message2 = ""
			return message
		}
		
		return nil
	}
	
	func splitOptions() -> TTMessage?
	{
		if self.hasOption
		{
			let message = TTMessage(message: self)
			message.message1 = ""
			message.message2 = ""
			message.type = .OptionsRecBo
			return message
		}
		
		return nil
	}
	
	func splitAction() -> TTMessage?
	{
		if self.hasAction
		{
			let message = TTMessage(message: self)
			message.message1 = ""
			message.message2 = ""
			message.type = .ActionRecBo
			return message
		}
		
		return nil
	}
	
}
