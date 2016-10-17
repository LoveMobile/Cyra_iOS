//
//  TTChatOptionsCell.swift
//  Cyra
//
//  Created by Piotr on 25.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import UIKit

let kChatOptionsCellOptionHeight: CGFloat = 32

class TTChatOptionsCell: TTChatTableViewCell
{
	@IBOutlet weak var viewBubble: UIView!
	var tapOptionHandler: TTCompletionString?
	var arrayButtons = [UIButton]()
	
	override var message: TTMessage!
		{
		didSet
		{
			for button in arrayButtons
			{
				button.removeFromSuperview()
			}
			arrayButtons.removeAll()
			
			var index = 0
			for (key,option) in message.optionsDictionary
			{
				let button = UIButton(frame: CGRectMake(0,
					CGFloat(index) * kChatOptionsCellOptionHeight,
					viewBubble.frame.size.width,
					kChatOptionsCellOptionHeight))
				button.autoresizingMask = .FlexibleWidth
				button.setTitle(option as? String,
				                forState: .Normal)
				button.accessibilityHint = key
				button.backgroundColor = UIColor.clearColor()
				button.setTitleColor(UIColor.cyraPink(), forState: .Normal)
				button.titleLabel?.font = TTChatTableViewCell.labelFont
				button.addTarget(self,
				                 action: #selector(TTChatOptionsCell.onTapButtonOption(_:)),
				                 forControlEvents: .TouchUpInside)
				viewBubble.addSubview(button)
				
				let lineView = UIView(frame: CGRectMake(
					0,
					CGRectGetMaxY(button.frame),
					button.frame.size.width,
					1))
				lineView.autoresizingMask = button.autoresizingMask
				lineView.backgroundColor = UIColor.backgroundGray()
				viewBubble.addSubview(lineView)
				arrayButtons.append(button)
				index += 1
			}
		}
	}
	
	override func awakeFromNib()
	{
		super.awakeFromNib()
		
		viewBubble.backgroundColor = UIColor.whiteColor()
		viewBubble.layer.cornerRadius = 4
		viewBubble.layer.masksToBounds = true
	}
	
	override class func heightWithMessage(message: TTMessage, fittingWidth: CGFloat) -> CGFloat
	{
		let height: CGFloat = CGFloat(message.optionsDictionary.keys.count) * kChatOptionsCellOptionHeight
		
		let actualHeight = height + kChatCellBubbleConstraintBottom + kChatCellBubbleConstraintTop
		
		return actualHeight - 2
	}
	
//MARK: Action handling
	
	func onTapButtonOption(button: UIButton)
	{
		if let optionKey = button.accessibilityHint
		{
			if let option = message.optionsDictionary[optionKey]
			{
				tapOptionHandler?(string: option as! String)
			}
		}
	}
	
}
