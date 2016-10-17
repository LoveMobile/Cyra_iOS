//
//  TTWork.swift
//  Cyra
//
//  Created by Piotr on 27.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import Foundation

enum TTWorkDictionary: String
{
	case CompanyName = "companyName"
	case DateFinished = "dateFrom"
	case DateStarted = "dateTo"
	case JobDescription = "jobDescription"
	case JobTitle = "jobTitle"
}

class TTWork: NSObject
{
	var companyName: String = ""
	var dateFinished = NSDate()
	var dateStarted = NSDate()
	var jobDescription: String = ""
	var jobTitle: String = ""
	
	init(dictionary: [String: AnyObject])
	{
		if let companyName = dictionary[TTWorkDictionary.CompanyName.rawValue] as? String
		{
			self.companyName = companyName
		}
		if let jobDescription = dictionary[TTWorkDictionary.JobTitle.rawValue] as? String
		{
			self.jobDescription = jobDescription
		}
		if let jobTitle = dictionary[TTWorkDictionary.JobDescription.rawValue] as? String
		{
			self.jobTitle = jobTitle
		}
		if let startedOn = dictionary[TTWorkDictionary.DateStarted.rawValue] as? String
		{
			self.dateStarted = NSDate.dateWithTimestamp(startedOn)
		}
		if let finishedOn = dictionary[TTWorkDictionary.DateFinished.rawValue] as? String
		{
			self.dateFinished = NSDate.dateWithTimestamp(finishedOn)
		}
	}
	
}
