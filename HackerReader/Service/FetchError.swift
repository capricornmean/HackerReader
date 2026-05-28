//
//  FetchError.swift
//  HackerReader
//
//  Created by mai on 5/27/26.
//

enum FetchError: Error {
    case invalidURL
    case invalidResponse
    case responseError(Int)
}
