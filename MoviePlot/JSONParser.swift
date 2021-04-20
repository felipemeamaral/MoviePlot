//
//  JSONParser.swift
//  MoviePlot
//
//  Created by Felipe Amaral on 4/20/21.
//

import Foundation

class MyRequestController {
	func sendRequest() {
		let sessionConfig = URLSessionConfiguration.default
		let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
		guard var URL = URL(string: "https://api.themoviedb.org/3/trending/movie/day") else {return}
		let URLParams = ["api_key": "8f76ce0548481dcdb8f6db514afeb328"]
		URL = URL.appendingQueryParameters(URLParams)
		var request = URLRequest(url: URL)
		request.httpMethod = "GET"
		request.addValue("", forHTTPHeaderField: "Authorization")
		let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
			if (error == nil) {
				// Success
				let statusCode = (response as! HTTPURLResponse).statusCode
				print("URL Session Task Succeeded: HTTP \(statusCode)")
			}
			else {
				// Failure
				print("URL Session Task Failed: %@", error!.localizedDescription);
			}
		})
		task.resume()
		session.finishTasksAndInvalidate()
	}
}

protocol URLQueryParameterStringConvertible {
	var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
	var queryParameters: String {
		var parts: [String] = []
		for (key, value) in self {
			let part = String(format: "%@=%@",
												String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
												String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
			parts.append(part as String)
		}
		return parts.joined(separator: "&")
	}
}

extension URL {
	func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
		let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
		return URL(string: URLString)!
	}
}
