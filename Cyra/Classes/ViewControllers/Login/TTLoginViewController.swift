//
//  TTLoginViewController.swift
//  Cyra
//
//  Created by Piotr on 18.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI

class TTLoginViewController: TTViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate
{
	@IBOutlet weak var imageViewBackground: UIImageView!
//	@IBOutlet weak var segmentControl: UISegmentedControl!
	@IBOutlet weak var textFieldLogin: ACFloatingTextField!
	@IBOutlet weak var textFieldPassword: ACFloatingTextField!
	@IBOutlet weak var buttonLogin: UIButton!
	@IBOutlet weak var labelRegister: UILabel!
	@IBOutlet weak var buttonRegister: UIButton!
	@IBOutlet weak var buttonForgotPassword: UIButton!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()

		buttonRegister.buttonStylingSunken()
		buttonLogin.buttonStylingRaised()
		
		//textFieldLogin.text = "Sheenuchawla@yahoo.com"//"piotr.nietrzebka@risendot.com"//"star2redsky@yahoo.com"//
		textFieldLogin.setTextFieldPlaceholderText("Email")
		textFieldLogin.textColor = UIColor.whiteColor()
		textFieldLogin.placeHolderTextColor = UIColor.whiteColor()
		textFieldLogin.selectedPlaceHolderTextColor = UIColor.whiteColor()
		textFieldLogin.btmLineColor = UIColor.whiteColor()
		textFieldLogin.btmLineSelectionColor = UIColor.whiteColor()
		
		//textFieldPassword.text = "sulabh92"//"cyra_risen"//"p@wel"//
		textFieldPassword.setTextFieldPlaceholderText("Password")
		textFieldPassword.textColor = UIColor.whiteColor()
		textFieldPassword.placeHolderTextColor = UIColor.whiteColor()
		textFieldPassword.selectedPlaceHolderTextColor = UIColor.whiteColor()
		textFieldPassword.btmLineColor = UIColor.whiteColor()
		textFieldPassword.btmLineSelectionColor = UIColor.whiteColor()
		textFieldPassword.secureTextEntry = true
		
		buttonForgotPassword.buttonStylingPlain()
//TODO: temporary removed
		buttonForgotPassword.hidden = true
		
		view.backgroundColor = UIColor.cyraPink()
		
		finishesEditingOnTouch = true
	}
	
//MARK: Action handling
	
	@IBAction func onTapButtonForgotPassword()
	{
		
	}
	
	@IBAction func onTapButtonLogin()
	{
		if textFieldLogin.text?.characters.count < 1
		{
			UIAlertView(title: "Login cannot be empty",
			            message: nil,
			            delegate: nil,
			            cancelButtonTitle: "OK").show()
			return
		}
		if textFieldPassword.text?.characters.count < 1
		{
			UIAlertView(title: "Password cannot be empty",
			            message: nil,
			            delegate: nil,
			            cancelButtonTitle: "OK").show()
			return
		}
		
		TTNetworkingEngine.requestLogin(textFieldLogin.text!,
		                                password: textFieldPassword.text!) { (object, errorMessage) in
																			
																			if errorMessage == nil
																			{
																				TTUser.mainUser().login = self.textFieldLogin.text!
																				TTUser.mainUser().password = self.textFieldPassword.text!
																				AppDelegate.saveContext()
																				self.performSegueWithIdentifier(TTSegueNames.RootToLoginUnwind.rawValue,
																				                                sender: self)
																			}
																			else
																			{
																				UIAlertView(title: "Something went wrong...",
																				            message: nil,
																				            delegate: nil,
																				            cancelButtonTitle: "OK").show()
																			}
		}
	}
	
	@IBAction func onTapButtonRegister()
	{
		let mailComposerVC = MFMailComposeViewController()
		mailComposerVC.mailComposeDelegate = self
		
		mailComposerVC.setToRecipients(["hello@cyra.ai"])
		mailComposerVC.setSubject("Interested in Cyra")
		mailComposerVC.setMessageBody("Hi\n\nI am interested in Cyra. Please get in touch.\n\nRegards", isHTML: false)
		
		if MFMailComposeViewController.canSendMail()
		{
			self.presentViewController(mailComposerVC, animated: true, completion: nil)
		}
		else
		{
			let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
			sendMailErrorAlert.show()
		}
	}

	@IBAction func onValueChangedSegmentControl()
	{
		
	}
	
//MARK: UITextField delegate
	
	func textFieldShouldReturn(textField: UITextField) -> Bool
	{
		if textField == textFieldLogin
		{
			textFieldPassword.becomeFirstResponder()
		}
		
		return true
	}

	func textFieldDidBeginEditing(textField: UITextField)
	{
		(textField as! ACFloatingTextField).textFieldDidBeginEditing()
	}
	
	func textFieldDidEndEditing(textField: UITextField)
	{
		(textField as! ACFloatingTextField).textFieldDidEndEditing()
	}
	
// MARK: MFMailComposeViewControllerDelegate Method
	func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
	{
		if result == MFMailComposeResultSent
		{
			UIAlertView(title: "Email sent!", message: "Thank you for your interest. We will get back to you shortly.", delegate: nil, cancelButtonTitle: "OK").show()
		}
		
		controller.dismissViewControllerAnimated(true, completion: nil)
	}
	
}
