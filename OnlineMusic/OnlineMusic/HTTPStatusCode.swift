//
//  HTTPErrorCode.swift
//  OnlineMusic
//
//  Created by Neo Hsu on 2022/6/24.
//

import Foundation

extension URLSession {

    enum HTTPStatusCode:Int {
      case Success = 200
      case Unauthorized = 401
      case NoFound = 404
    }
    
}
