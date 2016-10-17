//
//  TTMessageCandidatesSet.swift
//  Cyra
//
//  Created by Piotr on 27.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import Foundation

class TTMessageCandidatesSet: TTMessage
{
	var candidatesSet: TTCandidateSet
	
	init(candidatesSet: TTCandidateSet)
	{
		self.candidatesSet = candidatesSet
		
		super.init(text: "", type: .CandidatesSet)
	}
	
}
