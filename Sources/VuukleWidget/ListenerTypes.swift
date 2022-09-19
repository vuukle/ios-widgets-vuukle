//
//  ListenerTypes.swift
//  Vuukle
//
//  Created by Narek Dallakyan on 19.05.22.
//

import Foundation

public enum VuukleExceptions: Error {
    case failedToLoadURL(URL?, Error)
    case didFailProvisionalNavigation(Error)
}

public enum SSOExceptions: Error {
    case emptyPublisherKeyPair(String)
    case authModelEncodingError(Error)
}
