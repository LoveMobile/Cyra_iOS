//
//  TTEducation.swift
//  Cyra
//
//  Created by Piotr on 27.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import Foundation

enum TTEducationDictionary: String
{
	case DegreeGrade = "degreeGrade"
	case DateFinished = "finished_on"
	case GradeDescription = "grade_description"
	case InstitutionName = "institution_name"
	case QualificationType = "qualificationType"
	case DateStarted = "startedOn"
	case Subject = "subject"
}

class TTEducation: NSObject
{
	var degreeGrade: String = ""
	var dateFinished: NSDate = NSDate()
	var gradeDescription: String = ""
	var institutionName: String = ""
	var qualificationType: String = ""
	var dateStarted: NSDate = NSDate()
	var subject: String = ""
	
	init(dictionary: [String : AnyObject])
	{
		super.init()
		
		if let degree = dictionary[TTEducationDictionary.DegreeGrade.rawValue] as? String
		{
			self.degreeGrade = degree
		}
		if let dateFinished = dictionary[TTEducationDictionary.DateFinished.rawValue] as? String
		{
			self.dateFinished = NSDate.dateWithTimestamp(dateFinished)
		}
		if let gradeDescription = dictionary[TTEducationDictionary.GradeDescription.rawValue] as? String
		{
			self.gradeDescription = gradeDescription
		}
		if let institutionName = dictionary[TTEducationDictionary.InstitutionName.rawValue] as? String
		{
			self.institutionName = institutionName
		}
		if let qualificationType = dictionary[TTEducationDictionary.QualificationType.rawValue] as? String
		{
			self.qualificationType = qualificationType
		}
		if let startedOn = dictionary[TTEducationDictionary.DateStarted.rawValue] as? String
		{
			self.dateStarted = NSDate.dateWithTimestamp(startedOn)
		}
		if let subject = dictionary[TTEducationDictionary.Subject.rawValue] as? String
		{
			self.subject = subject
		}
		
	}
}
