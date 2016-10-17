//
//  TTCandidateSet.swift
//  Cyra
//
//  Created by Piotr on 27.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import Foundation

class TTCandidateSet: NSObject
{
	private var arrayCandidates = [TTCandidate]()
	var candidatesCount: Int
	{
		get
		{
			return arrayCandidates.count
		}
	}
	var currentShortlistedCandidates: Int
	{
		get
		{
			var count = 0
			for candidate in arrayCandidates
			{
				if candidate.shortlisted
				{
					count += 1
				}
			}
			
			return count
		}
	}
	
	var arrayCandidatesWithoutFeedback: [TTCandidate]
	{
		get
		{
			var candidates = [TTCandidate]()
			
			for candidate in arrayCandidates
			{
				if !candidate.feedbackSent
				{
					candidates.append(candidate)
				}
			}
			
			return candidates
		}
	}
	
	func setFeedbackSent()
	{
		for candidate in arrayCandidates
		{
			candidate.feedbackSent = true
		}
	}
	
	func atLeastOneFeedback() -> Bool
	{
		for candidate in arrayCandidates
		{
			if candidate.shortlisted || candidate.removed
			{
				return true
			}
		}
		
		return false
	}
	
	func addCandidate(newCandidate: TTCandidate)
	{
		arrayCandidates.append(newCandidate)
	}
	
	func candidateAtIndex(index: Int) -> TTCandidate?
	{
		if index >= 0 && index < arrayCandidates.count
		{
			return arrayCandidates[index]
		}
		
		return nil
	}
	
}
