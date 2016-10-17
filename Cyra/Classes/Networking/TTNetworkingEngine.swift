//
//  TTNetworkingEngine.swift
//  Cyra
//
//  Created by Piotr on 18.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import Foundation
import Alamofire

enum TTRootURL: String
{
	case TestRecBo = "http://test.recbo.co"
	case TestCyra = "http://test.cyra.ai"
}

enum TTAPIEndpoint: String
{
	case Token = "/o/token/"
	
	case CompanySignup = "company-signup/"
	case CompanyLogin = "company-login/"
	case CompanyLogout = "company-logout/"
	
	case ProfileInitialize = "initialize-profile/"
	
	case ChannelCreate = "create-channel/"
	case ChannelArchive = "archive-channel/"
	case ChannelGetArchived = "get-archived-channels/"
	case ChannelGetCurrent = "get-current-channels/"
	
	case Ask = "ask/"
	case Match = "match/"
	case InitializeChannel = "initialize-channel/"
	case Finalize = "finalize/"
	case SendFeedback = "send-feedback/"
	case GetFeedbackResult = "get-feedback-result/"
}

enum TTRequestKey: String
{
	case Login = "email"
	case Password = "password"
	
	case JobRole = "job_role"
	
	case Message = "msg"
	
	case GrantType = "grant_type"
	case ClientID = "client_id"
	case ClientSecret = "client_secret"
	
	case Feedback = "feedback"
	case Result = "result"
	case IDs = "IDs"
	
	case ChannelUID = "channel_id"
}

enum TTResponseKey: String
{
	case Status = "status"
	case Message = "message"
	
	case Channels = "channels"
}

enum TTOAuth: String
{
	case GrantType = "client_credentials"
	case ClientID = "cb7qBQmwz4kNzn2oRwKorUvRQti5es90HY3AtPh0"//"NdUIRJu0SbAIK9O4p1JifQ95FXs1cOxwzFRUdkTg"
	case ClientSecret = "6I34u41JkuaqjDTEEkjw0oxx0c8fpimcdZ1anY3hjV101kbB2ZjSEV9jdVNcORN9Bnn6Dns9kZqExTg3zji0p9EnnawEL0cT7WgyhENVjbDByGDFBnpCe4gdEKKh2WtC"//"G8H377TsjUERV9lB5LaIiHQ7M9DUJqTCVyYDz5lt6wjycx8UtOSqRUv2kKYYRAwndmAmxsifSm34c6xCDmrhbf24I3LoSXscxtpvTpgn6Fs9t3ZDmODkENZqx0kuRsvc"
}

class TTNetworkingEngine: NSObject
{
	class func setupNetworkingEngine()
	{

	}
	
	class func URLWithEndpoint(endpoint: TTAPIEndpoint) -> NSURL
	{
		let useOAuth = true
		
		if useOAuth
		{
			var URLString: String!
			
			if endpoint == .Token
			{
				URLString = URLRoot().URLByAppendingPathComponent(endpoint.rawValue).absoluteString
			}
			else
			{
				URLString = URLRoot().URLByAppendingPathComponent("api").URLByAppendingPathComponent(endpoint.rawValue).absoluteString
			}
			
			if endpoint != .Token
			{
				if TTUser.mainUser().token != nil
				{
					if TTUser.mainUser().token?.accessToken != nil
					{
						URLString.appendContentsOf("?access_token=\(TTUser.mainUser().token!.accessToken!)")
					}
				}
			}
			return NSURL(string: URLString)!
		}
		else
		{
			return URLRoot().URLByAppendingPathComponent(endpoint.rawValue)
		}
	}
    
    class func URLWithEndpointFromSendfeedback(endpoint: String) -> NSURL
    {
        var URLString: String!
      
        URLString = URLRoot().URLByAppendingPathComponent("api").URLByAppendingPathComponent(endpoint).absoluteString
        
           if TTUser.mainUser().token != nil
           {
               if TTUser.mainUser().token?.accessToken != nil
               {
                    URLString.appendContentsOf("?access_token=\(TTUser.mainUser().token!.accessToken!)")
               }
            }
        return NSURL(string: URLString)!
    }
	
	class func URLRoot() -> NSURL
	{
		return NSURL(string: TTRootURL.TestCyra.rawValue)!
	}
	
	class func requestToken(completion: TTRequestCompletion)
	{
		let parameters = [
			TTRequestKey.GrantType.rawValue : TTOAuth.GrantType.rawValue,
			TTRequestKey.ClientID.rawValue : TTOAuth.ClientID.rawValue,
			TTRequestKey.ClientSecret.rawValue : TTOAuth.ClientSecret.rawValue
		]
		
		Alamofire.request(.POST,
			TTNetworkingEngine.URLWithEndpoint(.Token),
			parameters: parameters,
			encoding: .URL,
			headers: [String : String]()).responseJSON {
				response in
				
				if let JSON = response.result.value as? [String: AnyObject]
				{
					print("i haz token:\n",JSON)
					TTUser.mainUser().updateToken(TTToken.fromDictionary(JSON))
					completion(responseObject: nil, errorMessage: nil)
				}
				else
				{
					handleErrorResponse(response, completion: completion)
				}
		}
	}
	
	class func requestLogin(login: String, password: String, completion: TTRequestCompletion)
	{
		Alamofire.request(.POST,
			TTNetworkingEngine.URLWithEndpoint(.CompanyLogin),
			parameters:
			[
				TTRequestKey.Login.rawValue : login,
				TTRequestKey.Password.rawValue : password,
			],
			encoding: .JSON,
			headers: [String : String]()).responseJSON {
				response in
				
				if let JSON = response.result.value as? [String: AnyObject]
				{
					if let status = JSON[TTResponseKey.Status.rawValue] as? Int
					{
						if status == 0
						{
							completion(responseObject: nil, errorMessage: JSON[TTResponseKey.Message.rawValue] as? String)
							return
						}
					}
					
					completion(responseObject: JSON, errorMessage: nil)
				}
				else
				{
					handleErrorResponse(response, completion: completion)
				}
		}
	}
	
	class func requestAsk(channelUID: NSNumber, message: String, completion: TTRequestCompletion)
	{
		Alamofire.request(.POST,
			TTNetworkingEngine.URLWithEndpoint(.Ask),
			parameters:
			[
				TTRequestKey.Message.rawValue : message,
				TTRequestKey.ChannelUID.rawValue : channelUID,
			],
			encoding: .JSON,
			headers: [String : String]()).responseJSON {
				response in
				
				if let JSON = response.result.value
				{
                    print("Obiekt odpowiedzi po wysłaniu pytania: ", JSON.description)
					let message = TTMessage(dictionary: JSON as! [String : AnyObject])
				
					completion(responseObject: message, errorMessage: nil)
				}
				else
				{
					handleErrorResponse(response, completion: completion)
				}
		}
	}
	
	class func requestChannelInitialize(channelUID: NSNumber, completion: TTRequestCompletion)
	{
		Alamofire.request(.POST,
			TTNetworkingEngine.URLWithEndpoint(.InitializeChannel),
			parameters:
			[
				TTRequestKey.ChannelUID.rawValue : channelUID
			],
			encoding: .JSON,
			headers: [String : String]()).responseJSON {
				response in
				
				if let JSON = response.result.value
				{
					completion(responseObject: JSON, errorMessage: nil)
                    print("Initalize channel: ", JSON.description)
				}
				else
				{
					handleErrorResponse(response, completion: completion)
				}
		}
	}
	
	class func requestFinalize(channelUID: NSNumber, completion: TTRequestCompletion)
	{
		Alamofire.request(.POST,
			TTNetworkingEngine.URLWithEndpoint(.Finalize),
			parameters:
			[
				TTRequestKey.ChannelUID.rawValue : channelUID
			],
			encoding: .JSON,
			headers: [String : String]()).responseJSON {
				response in
				
				if let JSON = response.result.value
				{
                    print("From finalize conversation: ", JSON.description)
					if let status = JSON[TTResponseKey.Status.rawValue] as? Int
					{
						if status == 1
						{
							completion(responseObject: nil, errorMessage: nil)
							return
						}
					}
				}
				
				handleErrorResponse(response, completion: completion)
		}
	}
	
	class func requestLogout(completion: TTRequestCompletion)
	{
		Alamofire.request(.POST,
			TTNetworkingEngine.URLWithEndpoint(.CompanyLogout),
			parameters:	[:],
			encoding: .JSON,
			headers: [String : String]()).responseJSON {
				response in
				
					completion(responseObject: nil, errorMessage: nil)
		}
	}
	
	class func requestMatch(channelUID: NSNumber, completion: TTRequestCompletion)
	{
		Alamofire.request(.POST,
			TTNetworkingEngine.URLWithEndpoint(.Match),
			parameters:
			[
				TTRequestKey.ChannelUID.rawValue : channelUID
			],
			encoding: .JSON,
			headers: [String : String]()).responseJSON {
				response in
				
				if let JSON = response.result.value
				{
					completion(responseObject: JSON, errorMessage: nil)
				}
				else
				{
					handleErrorResponse(response, completion: completion)
				}
		}
	}
	
	class func requestSendFeedback(channelUID: NSNumber, candidates: [TTCandidate],completion: TTRequestCompletion)
	{
		var arrayCandidateIDs = [String]()
		var arrayStatus = [Int]()

		for candidate in candidates
		{
			if candidate.shortlisted || candidate.removed
			{
				arrayCandidateIDs.append(candidate.uid)
                
                if candidate.shortlisted
                {
                    arrayStatus.append(Int(candidate.shortlisted))
                }
                else
                {
                    let candidateIsRemoved: Int = -1
                    arrayStatus.append(candidateIsRemoved)
                }
			}
		}
        print("Candidate ID to send: ", arrayCandidateIDs.description)
        print("Candidate status to send: ", arrayStatus.description)
//    Temporary code:
//        print("Original API: ", TTNetworkingEngine.URLWithEndpoint(.SendFeedback))
//        print("Api from API", TTNetworkingEngine.URLWithEndpointFromSendfeedback("get-feedback-result/"))
		
		Alamofire.request(.POST,
			TTNetworkingEngine.URLWithEndpoint(.SendFeedback),
			parameters:
			[
				TTRequestKey.ChannelUID.rawValue : channelUID,
				TTRequestKey.Feedback.rawValue :
					[
						TTRequestKey.IDs.rawValue : arrayCandidateIDs,
						TTRequestKey.Result.rawValue : arrayStatus,
					]
			],
			encoding: .JSON,
			headers: [String : String]()).responseJSON {
				response in
				
				if let JSON = response.result.value
				{
                    print("From /send-feedback: ", JSON.description)
					let message = TTMessage(dictionary: JSON as! [String : AnyObject])
						
					completion(responseObject: message, errorMessage: nil)
				}
				else
				{
					handleErrorResponse(response, completion: completion)
				}
		}
	}
	
	class func requestGetFeedbackResult(channelUID: NSNumber, completion: TTRequestCompletion)
	{
		Alamofire.request(.POST,
			TTNetworkingEngine.URLWithEndpoint(.GetFeedbackResult),
			parameters:
			[
				TTRequestKey.ChannelUID.rawValue : channelUID,
			],
			encoding: .JSON,
			headers: [String : String]()).responseJSON {
				response in
				
				if let JSON = response.result.value
				{
					completion(responseObject: JSON, errorMessage: nil)
				}
				else
				{
					handleErrorResponse(response, completion: completion)
				}
		}
	}
	
	class func requestInitializeProfile(completion: TTRequestCompletion)
	{
		Alamofire.request(.POST,
			TTNetworkingEngine.URLWithEndpoint(.ProfileInitialize),
			parameters:[:],
			encoding: .JSON,
			headers: [String : String]()).responseJSON {
				response in
				
				if let JSON = response.result.value
				{
					completion(responseObject: JSON, errorMessage: nil)
				}
				else
				{
					handleErrorResponse(response, completion: completion)
				}
		}
	}
	
	class func requestChannelGetCurrent(completion: TTRequestCompletion)
	{
		Alamofire.request(.POST,
			TTNetworkingEngine.URLWithEndpoint(.ChannelGetCurrent),
			parameters:[:],
			encoding: .JSON,
			headers: [String : String]()).responseJSON {
				response in
				
				if let JSON = response.result.value
				{
					if let arrayDicionaryChannels = JSON[TTResponseKey.Channels.rawValue] as? [[String: AnyObject]]
					{
						var arrayChannels = [TTChannel]()
						for dictionaryChannel in arrayDicionaryChannels
						{
							arrayChannels.append(TTChannel(dictionary: dictionaryChannel))
						}
						completion(responseObject: arrayChannels, errorMessage: nil)
					}
				}
				else
				{
					handleErrorResponse(response, completion: completion)
				}
		}
	}

	class func requestChannelGetArchived(completion: TTRequestCompletion)
	{
		Alamofire.request(.POST,
			TTNetworkingEngine.URLWithEndpoint(.ChannelGetArchived),
			parameters:[:],
			encoding: .JSON,
			headers: [String : String]()).responseJSON {
				response in
				
				if let JSON = response.result.value
				{
					if let arrayDicionaryChannels = JSON[TTResponseKey.Channels.rawValue] as? [[String: AnyObject]]
					{
						var arrayChannels = [TTChannel]()
						for dictionaryChannel in arrayDicionaryChannels
						{
							arrayChannels.append(TTChannel(dictionary: dictionaryChannel))
						}
						completion(responseObject: arrayChannels, errorMessage: nil)
					}
				}
				else
				{
					handleErrorResponse(response, completion: completion)
				}
		}
	}

	class func requestChannelCreate(role: String, completion: TTRequestCompletion)
	{
		Alamofire.request(.POST,
			TTNetworkingEngine.URLWithEndpoint(.ChannelCreate),
			parameters:
			[
				TTRequestKey.JobRole.rawValue : role
			],
			encoding: .JSON,
			headers: [String : String]()).responseJSON {
				response in
				
				if let JSON = response.result.value
				{
					let channel = TTChannel(dictionary: JSON as! [String : AnyObject])
					
					completion(responseObject: channel, errorMessage: nil)
				}
				else
				{
					handleErrorResponse(response, completion: completion)
				}
		}
	}
    
    class func requestChannelArchive(channelUID: NSNumber, completion: TTRequestCompletion)
    {
        Alamofire.request(.POST,
            TTNetworkingEngine.URLWithEndpoint(.ChannelArchive),
            parameters:
            [
                TTRequestKey.ChannelUID.rawValue : channelUID
            ],
            encoding: .JSON,
            headers: [String : String]()).responseJSON {
                response in
                
                if let JSON = response.result.value
                {
                    completion(responseObject: JSON, errorMessage: nil)
                }
                else
                {
                    handleErrorResponse(response, completion: completion)
                }
        }
    }
	
	class func handleErrorResponse(response: Response<AnyObject, NSError>, completion: TTRequestCompletion)
	{
		if let JSON = response.result.value
		{
			if let responseMessage = JSON[TTResponseKey.Message.rawValue] as? String
			{
				completion(responseObject: nil, errorMessage: responseMessage)
				return
			}
		}
		
		if response.data!.length > 0
		{
			if let string = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
			{
				var message = response.request?.URL?.absoluteString
				message?.appendContentsOf("\(message)\n\n\(string)")
				completion(responseObject: nil, errorMessage: string as String)
			}
		}
		
		completion(responseObject: nil, errorMessage: response.debugDescription)
		
		print(response.debugDescription)
	}
	
	class func imageURLWithCandidate(candidate: TTCandidate) -> NSURL
	{
		let path = candidate.image.stringByReplacingOccurrencesOfString("..", withString: "")
		
		let url = URLRoot().URLByAppendingPathComponent(path)
		
		return url
	}
	
	class func CVURLWithCandidate(candidate: TTCandidate) -> NSURL
	{
		let path = candidate.CVAddress.stringByReplacingOccurrencesOfString("/download/", withString: "/api/download/")
		
		return NSURL(string: path)!
	}
	
}
