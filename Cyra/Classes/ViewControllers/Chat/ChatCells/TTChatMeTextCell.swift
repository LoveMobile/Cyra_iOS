//
//  TTChatMeTextCell.swift
//  Cyra
//
//  Created by Piotr on 22.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import UIKit

class TTChatMeTextCell: TTChatTableViewCell
{
	@IBOutlet weak var viewBubble: UIView!
	@IBOutlet weak var labelText: UILabel!
	@IBOutlet weak var imageViewPip: UIImageView!
	@IBOutlet weak var imageViewProfile: UIImageView!
	
	override var message: TTMessage!
	{
		didSet
		{
			labelText.text = message.message1
		}
	}
	
	override func awakeFromNib()
	{
		super.awakeFromNib()
		
		viewBubble.backgroundColor = UIColor.cyraPink()
		viewBubble.layer.cornerRadius = 4
		viewBubble.layer.masksToBounds = true
		
		labelText.backgroundColor = UIColor.clearColor()
		labelText.font = TTChatTableViewCell.labelFont
		labelText.textColor = UIColor.whiteColor()
		
		imageViewProfile.image = UIImage(named: "profileMe")
		imageViewProfile.layer.cornerRadius = imageViewProfile.frame.size.height / 2
		imageViewProfile.layer.masksToBounds = true

		imageViewPip.image = imageViewPip.image?.imageWithRenderingMode(.AlwaysTemplate)
		imageViewPip.tintColor = UIColor.cyraPink()
	}
	
	override class func heightWithMessage(message: TTMessage, fittingWidth: CGFloat) -> CGFloat
	{
		let actualWidth = fittingWidth - kChatCellBubbleConstraintLeft - kChatCellBubbleConstraintRight - kChatCellLabelConstraintLeft - kChatCellLabelConstraintRight// - 16
		
		let height = message.message1.heightWithWidth(actualWidth, font: labelFont)
		
		let actualHeight = height + kChatCellBubbleConstraintTop + kChatCellBubbleConstraintBottom + kChatCellLabelConstraintTop + kChatCellLabelConstraintBottom + 10
		
		return actualHeight
	}
	
}
