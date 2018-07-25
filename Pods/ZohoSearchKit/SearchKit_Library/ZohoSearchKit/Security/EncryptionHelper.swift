//
//  EncryptionHelper.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 28/06/18.
//

import Foundation
import CryptoSwift

class EncryptionHelper {
    
    //later these keys will be secured, may be we can generate key using keychain and store in keychain
    fileprivate static let key = "SearchSDKBreakMe" //Must be of 16 chars in case of 128 bit encryption
    fileprivate static let iv = "eMkaerBKDShcraeS" //this also must be of 16 chars
    
    static func encrypt(_ string: String) -> String {
        var ciphertext = string
        do {
            let aes = try AES(key: key, iv: iv) // aes128
            let data = string.data(using: String.Encoding.utf8)
            let encrypted = try aes.encrypt(data!.bytes)
            let encryptedData = Data(encrypted)
            ciphertext = encryptedData.base64EncodedString()
        } catch {
            print("I failed")
        }
        
        return ciphertext
    }
    
    static func decrypt(_ string: String) -> String {
        var plaintext = string
        do {
            if let data = Data(base64Encoded: string) {
                let aes = try AES(key: key, iv: iv) // aes128
                let decrypted = try aes.decrypt([UInt8](data))
                let decryptedData = Data(decrypted)
                //return decrypted text or the same text
                plaintext = String(bytes: decryptedData.bytes, encoding: .utf8) ?? string
            }
        } catch { }
        
        return plaintext
    }
}
