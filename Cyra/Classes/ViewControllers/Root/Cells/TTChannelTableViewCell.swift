//
//  TTChannelTableViewCell.swift
//  Cyra
//
//  Created by Piotr on 14.08.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import UIKit

class TTChannelTableViewCell: UITableViewCell
{
	@IBOutlet weak var labelJobRole: UILabel!
	@IBOutlet weak var labelStatus: UILabel!
	@IBOutlet weak var labelLastMessage: UILabel!
	@IBOutlet weak var labelDate: UILabel!
	@IBOutlet weak var imageViewStatus: UIImageView!
	
	var channel: TTChannel!
	{
		didSet
		{
			self.labelJobRole.text = channel.jobRole
			self.labelStatus.text = "Status: " + channel.statusString
			self.labelLastMessage.text = "Looks like Tuesday and Wednesday next week suit you. Could you..."
			self.labelDate.text = "2d"
			imageViewStatus.tintColor = channel.statusColor
		}
	}
	
	override func awakeFromNib()
	{
		super.awakeFromNib()
		
		labelJobRole.textColor = UIColor.cyraPink()
		labelJobRole.font = UIFont.systemFontOfSize(17)
		labelStatus.font = UIFont.systemFontOfSize(15)
		labelLastMessage.textColor = UIColor.lightGrayColor()
		labelLastMessage.font = UIFont.systemFontOfSize(15)
		imageViewStatus.image = imageViewStatus.image?.imageWithRenderingMode(.AlwaysTemplate)

//TODO: temporary removed
		labelDate.hidden = true
		labelLastMessage.hidden = true
	}
	
}
