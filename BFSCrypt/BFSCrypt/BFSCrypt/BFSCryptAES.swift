//
//  BFSCryptAES.swift
//  BFSCrypt
//
//  Created by Bruno Fernandes on 25/05/15.
//  Copyright (c) 2015 BFS. All rights reserved.
//

import Foundation

enum CryptType : Int {
    case encrypt = 0, descrypt
}

public class BFSCryptAES: NSObject {
    
    let ENCRYPT_ALGORITHM  = kCCAlgorithmAES128
    let ENCRYPT_BLOCK_SIZE = kCCBlockSizeAES128
    let ENCRYPT_KEY_SIZE   = kCCKeySizeAES256
    
    // MARK: - Public Method
    public func encryptBase64String(message:String, key:String) -> String {
        
        var messageData:NSData = message.dataUsingEncoding(NSUTF8StringEncoding)!
        var keyData:NSData     = key.dataUsingEncoding(NSUTF8StringEncoding)!
        var data:NSData        = self.encryptData(typeCrypt: CryptType.encrypt , data: messageData, key: keyData, iv: nil)!
        
        if let result = data.base64EncodedStringWithOptions(.allZeros) as String? {
            
            return result
        }
        
        return ""
        
    }
    
    public func decryptBase64String(encrypt:String, key:String  ) -> String {
        
        var encryptData:NSData! = NSData(base64EncodedString: encrypt, options: .allZeros)!
        var keyData:NSData      = key.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let data = self.encryptData(typeCrypt: CryptType.descrypt , data: encryptData, key: keyData, iv: nil)
        
        if data != nil {
            let te = NSString(data: data!, encoding: NSUTF8StringEncoding)
            return te as! String
        }
        else{
            return ""
        }
    }
    
    
    // MARK: - Private Method
    private func encryptData(#typeCrypt:CryptType, data:NSData! ,key:NSData! ,iv:NSData?) -> NSData? {
        
        var result:NSData! = nil
        
        var cKey:CUnsignedChar = CUnsignedChar(ENCRYPT_KEY_SIZE)
        bzero(&cKey, sizeofValue(cKey))
        
        key.getBytes(&cKey, length: ENCRYPT_KEY_SIZE)
        
        var cIv:CChar = CChar(ENCRYPT_BLOCK_SIZE)
        bzero(&cIv, ENCRYPT_BLOCK_SIZE)
        
        if iv != nil {
            iv!.getBytes(&cIv, length: ENCRYPT_BLOCK_SIZE)
        }
        
        var bufferSize:size_t = data.length + ENCRYPT_BLOCK_SIZE
        var buffer = UnsafeMutablePointer<Void>.alloc(bufferSize)
        
        let dataLength    = data.length
        let dataBytes     = UnsafePointer<UInt8>(data.bytes)
        
        let keyLength              = size_t(ENCRYPT_KEY_SIZE)
        let operation: CCOperation = typeCrypt == .encrypt ? UInt32(kCCEncrypt) :UInt32(kCCDecrypt)
        let algoritm:  CCAlgorithm = UInt32(ENCRYPT_ALGORITHM)
        let options:   CCOptions   = UInt32(kCCModeECB)
        
        var encryptedSize :size_t = 0
        
        var cryptStatus = CCCrypt(operation,
            algoritm,
            options,
            &cKey,
            keyLength,
            &cIv,
            dataBytes,
            dataLength,
            buffer,
            bufferSize,
            &encryptedSize)
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            
            result = NSData(bytesNoCopy: buffer, length: encryptedSize)
            
        } else {
            free(buffer)
            
        }
        
        return result
    }
    
}


extension String {
    func encryptStringWithKey(key: String) -> String {
        
        var messageData:NSData = (self as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        var keyData:NSData     = key.dataUsingEncoding(NSUTF8StringEncoding)!
        var data:NSData        = messageData.encryptDataWithKey(typeCrypt: CryptType.encrypt , key: keyData, iv: nil)!
        
        if let result = data.base64EncodedStringWithOptions(.allZeros) as String? {
            return data.base64EncodedStringWithOptions(.allZeros)
        }
        
        return ""
        
    }
    
    func decryptStringWithKey(key: String) -> String {
        
        var encryptData:NSData = NSData(base64EncodedString: self, options: .allZeros)!
        var keyData:NSData     = key.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let data = encryptData.encryptDataWithKey(typeCrypt: CryptType.descrypt , key: keyData, iv: nil)
        
        if data != nil {
            let te = NSString(data: data!, encoding: NSUTF8StringEncoding)
            return te! as String
        }
        else{
            return ""
        }
    }
    
}

extension NSData {
    
    func encryptDataWithKey(#typeCrypt:CryptType ,key:NSData! ,iv:NSData?) -> NSData? {
        
        let ENCRYPT_ALGORITHM  = kCCAlgorithmAES128
        let ENCRYPT_BLOCK_SIZE = kCCBlockSizeAES128
        let ENCRYPT_KEY_SIZE   = kCCKeySizeAES256
        
        var result:NSData! = nil
        
        var cKey:CUnsignedChar = CUnsignedChar(ENCRYPT_KEY_SIZE)
        bzero(&cKey, sizeofValue(cKey))
        
        key.getBytes(&cKey, length: ENCRYPT_KEY_SIZE)
        
        var cIv:CChar = CChar(ENCRYPT_BLOCK_SIZE)
        bzero(&cIv, ENCRYPT_BLOCK_SIZE)
        
        if iv != nil {
            iv!.getBytes(&cIv, length: ENCRYPT_BLOCK_SIZE)
        }
        
        var bufferSize:size_t = self.length + ENCRYPT_BLOCK_SIZE
        var buffer = UnsafeMutablePointer<Void>.alloc(bufferSize)
        
        let dataLength    = self.length
        let dataBytes     = UnsafePointer<UInt8>(self.bytes)
        
        let keyLength              = size_t(ENCRYPT_KEY_SIZE)
        let operation: CCOperation = typeCrypt == .encrypt ? UInt32(kCCEncrypt) :UInt32(kCCDecrypt)
        let algoritm:  CCAlgorithm = UInt32(ENCRYPT_ALGORITHM)
        let options:   CCOptions   = UInt32(kCCModeECB)
        
        var encryptedSize :size_t = 0
        
        var cryptStatus = CCCrypt(operation,
            algoritm,
            options,
            &cKey,
            keyLength,
            &cIv,
            dataBytes,
            dataLength,
            buffer,
            bufferSize,
            &encryptedSize)
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            
            result = NSData(bytesNoCopy: buffer, length: encryptedSize)
            
        } else {
            free(buffer)
            
        }
        
        return result
        
    }
    
}

