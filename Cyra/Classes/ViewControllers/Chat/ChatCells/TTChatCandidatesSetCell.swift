//
//  TTChatCandidatesSetCell.swift
//  Cyra
//
//  Created by Piotr on 27.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import UIKit
import iCarousel

enum TTChatCandidatesSetCellTapType: Int
{
	case Candidate = 0
	case Like = 1
	case Dislike = 2
}

typealias TTChatCandidatesSetCellTap = (candidate: TTCandidate, tapType: TTChatCandidatesSetCellTapType, performSendFeedback: Bool) -> ()

let kMaxCandidatesToLoad = 36

class TTChatCandidatesSetCell: TTChatTableViewCell,
 iCarouselDataSource, iCarouselDelegate
{
	@IBOutlet var carousel: iCarousel!
	@IBOutlet var labelCandidatesCount: UILabel!

	var tapHandler: TTChatCandidatesSetCellTap!
	var loadMoreHandler: TTCompletion?
	var maxCandidatesHandler: TTCompletion?
    var isChannelArchive: Bool = false
	
	override var message: TTMessage!
	{
		didSet
		{
			if message is TTMessageCandidatesSet
			{
				candidatesSet = (message as! TTMessageCandidatesSet).candidatesSet
			}
		}
	}
	
	var candidatesSet = TTCandidateSet()
		{
		didSet
		{
			carousel.reloadData()
			
			if carousel.currentItemIndex > 0
			{
				if let candidate = candidatesSet.candidateAtIndex(carousel.currentItemIndex)
				{
					if candidate.feedbackSent
					{
						if candidatesSet.candidatesCount > carousel.currentItemIndex
						{
							carousel.scrollToItemAtIndex(carousel.currentItemIndex+1, animated: true)
						}
					}
				}
			}
		}
	}
	
	override class func heightWithMessage(message: TTMessage, fittingWidth: CGFloat) -> CGFloat
	{
		return 240
	}
	
	override func awakeFromNib()
	{
		super.awakeFromNib()
		
		carousel.type = .Linear
		carousel.backgroundColor = UIColor.clearColor()
		carousel.pagingEnabled = true
		labelCandidatesCount.textColor = UIColor.cyraPink()
		updateLabel()
	}
	
	func updateLabel()
	{
		labelCandidatesCount.text = "\(candidatesSet.currentShortlistedCandidates) candidate(s) selected."
	}
    
    func disableCandidateView(chatCandidatesView: TTChatCandidateView) -> TTChatCandidateView
    {
        chatCandidatesView.backgroundView.alpha = 0.5
        chatCandidatesView.labelName.alpha = 0.5
        chatCandidatesView.imageViewProfile.alpha = 0.5
        chatCandidatesView.labelDescription.alpha = 0.5
        chatCandidatesView.buttonLike.enabled = false
        chatCandidatesView.buttonDislike.enabled = false
        chatCandidatesView.buttonCV.enabled = true
        return chatCandidatesView
    }
	
//MARK: iCarousel datasource & delegate
	
	func numberOfItemsInCarousel(carousel: iCarousel) -> Int
	{
		return candidatesSet.candidatesCount
	}
	
	func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView
	{
		var chatCandidatesView: TTChatCandidateView
		
		if view == nil
		{
			chatCandidatesView = NSBundle.mainBundle().loadNibNamed("TTChatCandidateView", owner: self, options: nil).first! as! TTChatCandidateView
			
			chatCandidatesView.frame = CGRectMake(0,
			                                      0,
			                                      carouselItemWidth(carousel),
			                                      carousel.frame.size.height)
		}
		else
		{
			chatCandidatesView = view as! TTChatCandidateView
		}
		
		if let candidate = candidatesSet.candidateAtIndex(index)
		{
			candidate.seen = true
			chatCandidatesView.candidate = candidate
		
			if !(candidate.voted || candidate.feedbackSent)
			{
				chatCandidatesView.backgroundView.alpha = 1.0
                chatCandidatesView.labelName.alpha = 1.0
                chatCandidatesView.imageViewProfile.alpha = 1.0
                chatCandidatesView.labelDescription.alpha = 1.0
				chatCandidatesView.buttonLike.enabled = true
				chatCandidatesView.buttonDislike.enabled = true
                chatCandidatesView.buttonCV.enabled = true
                
                if index == candidatesSet.candidatesCount - 1
                {
                    chatCandidatesView.isLastCandidateViewInCarousel = true
                }
                
				chatCandidatesView.tapHandler = { candidate, tapType, performSendFeedback in

					if tapType != .Candidate
					{
						self.carousel.scrollToItemAtIndex(index+1, animated: true)
						
						if index+1 > self.candidatesSet.candidatesCount-1
						{
							if carousel.currentItemIndex >= kMaxCandidatesToLoad - 1
							{
								self.tapHandler(candidate: candidate, tapType: tapType, performSendFeedback: false)
                                self.maxCandidatesHandler?()
							}
							else
							{
                                self.tapHandler(candidate: candidate, tapType: tapType, performSendFeedback: performSendFeedback)
							}
						}
						
					}

                    self.tapHandler(candidate: candidate, tapType: tapType, performSendFeedback: false)
					self.updateLabel()
				}
			}
			else
			{
                disableCandidateView(chatCandidatesView)
                chatCandidatesView.tapHandler = { candidate, tapType, performSendFeedback in
                    self.tapHandler(candidate: candidate, tapType: tapType, performSendFeedback: false)
                }
			}
		}
        if isChannelArchive
        {
            disableCandidateView(chatCandidatesView)
            chatCandidatesView.tapHandler = { candidate, tapType, performSendFeedback in
                self.tapHandler(candidate: candidate, tapType: tapType, performSendFeedback: false)
            }
        }
        
		return chatCandidatesView
	}
	
	func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int)
	{
		if index == carousel.currentItemIndex
		{
			if let candidate = candidatesSet.candidateAtIndex(index)
			{
                tapHandler(candidate: candidate, tapType: .Candidate, performSendFeedback: false)
			}
		}
		else
		{
			carousel.scrollToItemAtIndex(index, animated: true)
		}
	}

	func carouselDidScroll(carousel: iCarousel)
	{
		if !isChannelArchive
        {
            if carousel.scrollOffset > CGFloat(candidatesSet.candidatesCount-1)
            {
                if carousel.currentItemIndex >= kMaxCandidatesToLoad - 1
                {
                    maxCandidatesHandler?()
                }
                else
                {
    //                print("End of Carousel")
                    loadMoreHandler?()
                }
            }
        }
	}
	
	func carouselItemWidth(carousel: iCarousel) -> CGFloat
	{
		return UIScreen.mainScreen().bounds.size.width - 60 - 16
	}
	
	func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
	{
		switch option
		{
		case .Spacing:	return value * 1.05
			
		default:
			break
		}
		
		return value
	}
	
}
