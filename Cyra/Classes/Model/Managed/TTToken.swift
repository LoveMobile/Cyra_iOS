//
//  TTToken.swift
//  
//
//  Created by Piotr on 01.08.2016.
//
//

import Foundation
import CoreData

enum TTTokenDictionary: String
{
	case AccessToken = "access_token"
	case ExpiresIn = "expires_in"
	case Scope = "scope"
	case TokenType = "token_type"
}

class TTToken: TTEntity
{

	class func fromDictionary(dictionary: [String: AnyObject]) -> TTToken
	{
		let moc = AppDelegate.moc()

		let token = NSEntityDescription.insertNewObjectForEntityForName("TTToken",
		                                                                inManagedObjectContext: moc) as! TTToken

		if let accessToken = dictionary[TTTokenDictionary.AccessToken.rawValue] as? String
		{
			token.accessToken = accessToken
		}
		if let expiresIn = dictionary[TTTokenDictionary.AccessToken.rawValue] as? Int
		{
			token.expiresIn = expiresIn
			token.expiresAt = NSDate(timeIntervalSinceNow: Double(token.expiresIn!))
		}
		if let scope = dictionary[TTTokenDictionary.AccessToken.rawValue] as? String
		{
			token.scope = scope
		}
		if let type = dictionary[TTTokenDictionary.AccessToken.rawValue] as? String
		{
			token.type = type
		}
		
		return token
	}
	
}
