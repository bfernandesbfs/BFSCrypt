//
//  ViewController.swift
//  BFSCrypt
//
//  Created by Bruno Fernandes on 25/05/15.
//  Copyright (c) 2015 BFS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var text:String = "Mensagem para ser cryptografada"
        var key :String = "palavraPasse"
        
        var crypt:BFSCryptAES = BFSCryptAES()
        var encrypted  = crypt.encryptBase64String(text, key: key)
        var descrypted = crypt.decryptBase64String(encrypted, key: key)
        println(encrypted)
        println(descrypted)
        
        //Usando Extension
        var encryptedExtension = text.encryptStringWithKey(key)
        var decryptedExtension = encryptedExtension.decryptStringWithKey(key)
        println(encryptedExtension)
        println(decryptedExtension)
        
    }
}

