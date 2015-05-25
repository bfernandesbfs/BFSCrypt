# BFSCrypt
Criptografia usando AES128 com suporte a AES256 

<h3>Configuração</h3> 
Crie um "Header File" e adicione <code>#import &lt;CommonCrypto/CommonCrypto.h&gt;</code><br/>
Arraste para seu projeto <code>BFSCryptAES.swift</code> 
<h3>Como usar</h3> 

Encrypt

        var text:String = "Mensagem para ser cryptografada"
        var key :String = "palavraPasse"
        
        var crypt:BFSCryptAES = BFSCryptAES()
        var encrypted  = crypt.encryptBase64String(text, key: key)
Decrypt

        var descrypted = crypt.decryptBase64String(encrypted, key: key)

Usando Extension

        var encryptedExtension = text.encryptStringWithKey(key)
        var decryptedExtension = encryptedComExtesion.decryptStringWithKey(key)
        println(encryptedExtension)
        println(encryptedExtension)
