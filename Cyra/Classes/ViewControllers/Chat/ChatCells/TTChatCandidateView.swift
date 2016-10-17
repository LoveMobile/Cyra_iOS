//
//  TTChatCandidateView.swift
//  Cyra
//
//  Created by Piotr on 04.08.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import UIKit
import AlamofireImage

class TTChatCandidateView: UIView
{
    @IBOutlet weak var backgroundView: UIView!
	@IBOutlet var labelName: UILabel!
	@IBOutlet var buttonCV: UIButton!
	@IBOutlet var viewLine: UIView!
	@IBOutlet var imageViewProfile: UIImageView!
	@IBOutlet var labelDescription: UILabel!
	@IBOutlet var imageViewArrow: UIImageView!
	@IBOutlet var buttonLike: UIButton!
	@IBOutlet var buttonDislike: UIButton!
	var tapHandler: TTChatCandidatesSetCellTap!
    var isLastCandidateViewInCarousel: Bool = false
    
	var candidate: TTCandidate!
	{
		didSet
		{
			labelName.text = "\(candidate.number). \(candidate.fullName)"
			labelDescription.text = candidate.personalStatement
			imageViewProfile.af_setImageWithURL(TTNetworkingEngine.imageURLWithCandidate(candidate))
			imageViewProfile.layer.cornerRadius = imageViewProfile.frame.size.height/2
			imageViewProfile.layer.masksToBounds = true
			
			let attributedButtonTitle = NSAttributedString(string: "More Info",
			                                               attributes:
				[
					NSUnderlineStyleAttributeName : 1,
					NSForegroundColorAttributeName : UIColor.cyraPink(),
				])
			buttonCV.setAttributedTitle(attributedButtonTitle, forState: .Normal)
		}
	}
	
	override func awakeFromNib()
	{
		super.awakeFromNib()
		
		layer.cornerRadius = 4
		layer.masksToBounds = true
	}
	
//MARK: Action handling
	
	@IBAction func onTapButtonLike()
	{
        tapHandler?(candidate: candidate, tapType: .Like, performSendFeedback: isLastCandidateViewInCarousel)
	}
	
	@IBAction func onTapButtonDislike()
	{
        tapHandler?(candidate: candidate, tapType: .Dislike, performSendFeedback: isLastCandidateViewInCarousel)
	}
	
	@IBAction func onTapButtonCV()
	{
        tapHandler?(candidate: candidate, tapType: .Candidate, performSendFeedback: false)
	}
	
}
