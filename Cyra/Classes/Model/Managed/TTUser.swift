//
//  TTUser.swift
//  Cyra
//
//  Created by Piotr on 18.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import Foundation
import CoreData


class TTUser: TTEntity
{

	class func mainUser() -> TTUser
	{
		let moc = AppDelegate.moc()
		
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName("TTUser", inManagedObjectContext: moc)
		
		var arrayUsers: [TTUser]?
		do
		{
			arrayUsers = try moc.executeFetchRequest(fetchRequest) as? [TTUser]
		}
		catch
		{
			NSLog("failed to execute fetch request: \(error)")
		}
		
		var user: TTUser!
		if arrayUsers?.count < 1
		{
			user = NSEntityDescription.insertNewObjectForEntityForName("TTUser",
			                                                           inManagedObjectContext: moc) as! TTUser
			
			AppDelegate.saveContext()
		}
		else
		{
			user = arrayUsers?.last
		}
		
		return user
	}
	
	func isAuthenticated() -> Bool
	{
		if password != nil && login != nil
		{
			return password!.characters.count > 0 && login!.characters.count > 0
		}
		
		return false
	}
	
	func updateToken(token: TTToken)
	{
		if self.token != nil
		{
			AppDelegate.moc().deleteObject(self.token!)
			self.token = nil
		}
		
		self.token = token
	}
	
}
