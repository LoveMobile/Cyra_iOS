//
//  TTChatTableViewCell.swift
//  Cyra
//
//  Created by Piotr on 22.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import UIKit

let kChatCellBubbleConstraintTop: CGFloat = 6
let kChatCellBubbleConstraintBottom: CGFloat = 6
let kChatCellBubbleConstraintLeft: CGFloat = 60
let kChatCellBubbleConstraintRight: CGFloat = 60
let kChatCellLabelConstraintTop: CGFloat = 6
let kChatCellLabelConstraintBottom: CGFloat = 6
let kChatCellLabelConstraintLeft: CGFloat = 15
let kChatCellLabelConstraintRight: CGFloat = 15

class TTChatTableViewCell: UITableViewCell
{
	var message: TTMessage!
	{
		didSet
		{
			
		}
	}
	
	class var labelFont: UIFont
	{
		get
		{
			return UIFont.systemFontOfSize(15)
		}
	}
	
	class func heightWithMessage(message: TTMessage, fittingWidth: CGFloat) -> CGFloat
	{
		return 100
	}
	
	override func awakeFromNib()
	{
		super.awakeFromNib()
		
		backgroundColor = UIColor.clearColor()
		contentView.backgroundColor = UIColor.clearColor()
	}
}
