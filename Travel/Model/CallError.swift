//
//  NetworkError.swift
//  Travel
//
//  Created by Genapi on 19/11/2021.
//

import Foundation

enum CallError {
    case invalidUrl(error: String)
    case returned(error: NSError)
    case invalidResponse(response: URLResponse)
    case invalidData(data: Data)
    case InvalideCode(code: Int)
}
