//
//  NewWindowListener.swift
//  Vuukle
//
//  Created by Narek Dallakyan on 22.05.22.
//

import Foundation

public class NewEventListener: ListenerManager {

    public var talkOfTheTownListener: ((URL?) -> Void)?
    public var whatsOnYourMindListener: ((URL?) -> Void)?
    public var onSignInButtonClicked: (() -> Void)?
}
