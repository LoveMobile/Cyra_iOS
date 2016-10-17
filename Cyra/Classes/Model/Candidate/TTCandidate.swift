//
//  TTCandidate.swift
//  Cyra
//
//  Created by Piotr on 26.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import UIKit

enum TTCandidateDictionary: String
{
	case UID = "ID"
	case CVAddress = "cv_address"
	case EducationHistory = "education_history"
	case FirstName = "first_name"
	case HighestQualifications = "highest_qualifications"
	case Image = "image"
	case LastName = "last_name"
	case PersonalStatement = "personal_statement"
	case Skills = "skills"
	case WorkHistory = "work_history"
}

class TTCandidate: NSObject
{
	//model vars
	var uid: String = ""
	var CVAddress: String = "http://test.cyra.ai/download/21046923.txt"
	var educationHistory = [TTEducation]()
	var firstName: String = "firstName"
	var highestQualifications = ""
	var image = ""
	var lastName = "lastName"
	var personalStatement = ""
	var skills = [String]()
	var workHistory = [TTWork]()
	
	//temporary vars
	var seen = false
	var feedbackSent = false
	var shortlisted = false
		{
			didSet
			{
				voted = true
		}
	}
	var removed = false
		{
		didSet
		{
			voted = true
		}
	}
	var voted = false
	var number = 0
	
	var fullName: String
	{
		get
		{
			return "\(firstName) \(lastName)"
		}
	}
	
	init(dictionary: [String : AnyObject])
	{
		super.init()
		
		if let uid = dictionary[TTCandidateDictionary.UID.rawValue] as? String
		{
			self.uid = uid
		}
		if let cv = dictionary[TTCandidateDictionary.CVAddress.rawValue] as? String
		{
			self.CVAddress = cv
		}
		if let education = dictionary[TTCandidateDictionary.EducationHistory.rawValue] as? [[String: AnyObject]]
		{
			for dictionary in education
			{
				self.educationHistory.append(TTEducation(dictionary: dictionary))
			}
		}
		if let firstName = dictionary[TTCandidateDictionary.FirstName.rawValue] as? String
		{
			self.firstName = firstName
		}
		if let highestQualifications = dictionary[TTCandidateDictionary.HighestQualifications.rawValue] as? String
		{
			self.highestQualifications = highestQualifications
		}
		if let image = dictionary[TTCandidateDictionary.Image.rawValue] as? String
		{
			self.image = image
		}
		if let lastName = dictionary[TTCandidateDictionary.LastName.rawValue] as? String
		{
			self.lastName = lastName
		}
		if let personalStatement = dictionary[TTCandidateDictionary.PersonalStatement.rawValue] as? String
		{
			self.personalStatement = personalStatement
		}
		if let skills = dictionary[TTCandidateDictionary.Skills.rawValue] as? [String]
		{
			for skill in skills
			{
				self.skills.append(skill)
			}
		}
		if let workHistory = dictionary[TTCandidateDictionary.WorkHistory.rawValue] as? [[String: AnyObject]]
		{
			for dictionary in workHistory
			{
				self.workHistory.append(TTWork(dictionary: dictionary))
			}
		}
	}
	
}

