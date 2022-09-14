//
//  SSOAuthManage.swift
//  Vuukle
//
//  Created by Garnik Ghazaryan on 25.03.22.
//

import CryptoKit
import Foundation

class SSOAuthManager {

    var ssoExceptionsListener: ((SSOExceptions) -> Void)?

    private var publisherKeyPair: PublisherKeyPair

    private var token: String? {
        Utils.UserDefaultsManager.getValue(for: Constants.encodedTokenKey)
    }

    init(publisherKeyPair: PublisherKeyPair) {
        self.publisherKeyPair = publisherKeyPair
    }

    var isLoggedIn: Bool {
        guard let token = token else { return false }
        return !token.isEmpty
    }

    func login(email: String, username: String, completion: @escaping ((String) -> Void)) {
        do {
            try validatePublisherKeyPair()
            guard let signature = createSignature(email: email) else { return }
            let authModel = AuthModel(email: email, username: username, public_key: publisherKeyPair.publicKey, signature: signature)
            guard let encodedModel = encodeAuthModel(authModel: authModel) else { return }
            let encodedString = encodedModel.base64EncodedString()
            Utils.UserDefaultsManager.saveValue(string: encodedString, key: Constants.encodedTokenKey)
            completion(encodedString)
        } catch {
            ssoExceptionsListener?(.emptyPublisherKeyPair("Failed to get publisher key pair"))
        }
    }

    func logout() {
        Utils.UserDefaultsManager.saveValue(string: "", key: Constants.encodedTokenKey)
    }

    func makeAuthentifiableIfNeeded(url: URL) -> URL? {
        if let token = token, !token.isEmpty {
            return URL(string: url.absoluteString + "&sso=true&loginToken=\(token)")
        }
        return url
    }

    // MARK: - Private functions

    private func validatePublisherKeyPair() throws {
        if publisherKeyPair.privateKey.isEmpty {
            ssoExceptionsListener?(.emptyPublisherKeyPair("Error: Private key cannot be empty"))
            throw SSOExceptions.emptyPublisherKeyPair("Error: Private key cannot be empty")
        }

        if publisherKeyPair.publicKey.isEmpty {
            ssoExceptionsListener?(.emptyPublisherKeyPair("Error: Public key cannot be empty"))
            throw SSOExceptions.emptyPublisherKeyPair("Error: Public key cannot be empty")
        }
    }

    private func createSignature(email: String) -> String? {
        let inputString = email + "-" + publisherKeyPair.privateKey
        return SHA512Encode(stringToHash: inputString)?.uppercased()
    }

    private func SHA512Encode(stringToHash: String) -> String? {
        guard let hashableData = stringToHash.data(using: .utf8) else { return nil }
        return SHA512.hash(data: hashableData).hexStr
    }

    private func encodeAuthModel(authModel: AuthModel) -> Data? {
        let jsonEncoder = JSONEncoder()
        var encoded: Data? = nil
        do {
            encoded = try jsonEncoder.encode(authModel)
        } catch {
            ssoExceptionsListener?(.authModelEncodingError(error))
        }
        return encoded
    }
}

struct AuthModel: Codable {
    let email: String
    let username: String
    let public_key: String
    let signature: String
}

extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }

    var hexStr: String {
        bytes.map { String(format: "%02X", $0) }.joined()
    }
}
