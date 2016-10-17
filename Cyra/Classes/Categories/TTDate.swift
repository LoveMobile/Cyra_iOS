//
//  TTDate.swift
//  Cyra
//
//  Created by Piotr on 27.07.2016.
//  Copyright © 2016 TT. All rights reserved.
//

import Foundation

//"2014-01-01T00:00:00";
let kDefaultDateFormat = "yyyy-MM-dd'T'HH:mm:ss"

extension NSDate
{
	class func dateWithTimestamp(timestamp: String) -> NSDate
	{
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = kDefaultDateFormat
		
		return dateFormatter.dateFromString(timestamp)!
	}
	
}
