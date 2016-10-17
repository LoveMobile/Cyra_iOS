//
//  TTChatButtonCell.swift
//  Cyra
//
//  Created by Piotr on 08.08.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import UIKit

class TTChatButtonCell: TTChatTableViewCell
{
	@IBOutlet weak var button: UIButton!
	var tapHandler: TTCompletion?
	
	override var message: TTMessage!
	{
		didSet
		{
			button.setTitle(message.message1, forState: .Normal)
		}
	}
	
	override func awakeFromNib()
	{
		super.awakeFromNib()
		
		button.tintColor = UIColor.cyraPink()
		button.setTitleColor(UIColor.cyraPink(), forState: .Normal)
		button.layer.borderColor = UIColor.cyraPink().CGColor
		button.layer.borderWidth = 1
		button.layer.cornerRadius = 4
		button.layer.masksToBounds = true
	}
	
	override 	class func heightWithMessage(message: TTMessage, fittingWidth: CGFloat) -> CGFloat
	{
		return 60
	}
	
//MARK: Action handling
	
	@IBAction func onTapButton()
	{
		tapHandler?()
	}
	
}
