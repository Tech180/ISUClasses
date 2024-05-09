# Lab 08 part 02
# You will be using this code to encrypt and decrypt
# messages that have been stored in json files.
# Normally the key would never be written to a file
# since this is a symmetric key and it should be shared
# in some alternate channel.  However, for the purposes
# of this lab it will be in plaintext in a json file.
#
# You will also be using base64 encoding and decoding
# which is more like the keys you will see when we do
# RSA and DHE.
#
# To run the program the syntax is 
# python3 part02_skel.py input.json output.json
"""
This code is based upon the documentation for
using AES found on the PyCryptodome web pages.

https://pycryptodome.readthedocs.io/en/latest/src/examples.html
https://pycryptodome.readthedocs.io/en/latest/src/cipher/aes.html

It has been modified for use in CprE/CybE 331.

"""


import sys
import json
from base64 import b64encode 
from base64 import b64decode 
from Crypto.Cipher import AES    
from Crypto.Random import get_random_bytes

# readInJson function
# If a file is stored as json it can be
# read into a python dictionary using the .load() method
def readInJson(filename):
    with open(filename) as inFile:
        inData = json.load(inFile)
    inFile.close()
    return inData

# writeOutJson function
# A dictionary object can be converted to a json
# file using the .dump() method.   
def writeOutJson(filename,dump):
    with open (filename, 'w') as outFile:
        outFile.write(dump)
    outFile.close()
    return

#Main
def main():


    #Prompt for action
    action = int(input("Do you want to 1) encrypt or  2) decrypt?"))

    if (action == 1):

        inPlainText = readInJson(sys.argv[1])

        # You will be working with bytes in this program
        # Here you will be reading from the dictionary named
        # inPlainText which was created when you readin the 
        # json file.  Use the key to call in the value from the
        # key:value pair in the dictionary.
        # .get() method is used to read what is stored in the value
        # and utf-8 is 8-bit unicode.
        # TODO: keyneeded from json file.  This is the same as you have done
        # for 3DES and ChaCha20.
        plainText = inPlainText['plainText']
       
        # Normally, the key would be generated and shared ahead
        # of time by 2 users.  However, you will be generating 
        # some random bytes to be used as a key.  
        # In this case we will be using 16 bytes which is a 128
        # bit AES key.
        # Again, this is the similar to what you did in the previous lab
        # but with 16 bytes
        # TODO: Generate 16 bytes of random key
        key = get_random_bytes(16)
        
       
        # You will use the AES.new method 
        # and the GCM block cipher mode.  
        # You will get out the ciphertext and a tag that 
        # provides AEAD 
        cipher = AES.new(key, AES.MODE_GCM) 

        plainText = plainText.encode('utf-8')
        
        cipherText, tag = cipher.encrypt_and_digest(plainText)
        
        # Writing the values out using base64 encoding
        # cipher.nonce, tag, cipherText, and key
        # Again, look at your previous 3DES and ChaCha20 files
        # to see the syntax for base64encode and use 'utf-8'
        # TODO: Write out values using base64
        nonce = b64encode(cipher.nonce).decode('utf-8')
        tag = b64encode(tag).decode('utf-8')
        cipherText = b64encode(cipherText).decode('utf-8')
        key = b64encode(key).decode('utf-8') 
       
        # Create the json object
        # You will be writing out the nonce, the ciphertext, the key, and the tag.
        # You will be using the dictionary's key:value pair 
        # Reminder, you would never write the key out to a json file in a real 
        # world application.
        # TODO: json.dumps({'key1':value1,'key2':value2,'key3':value3})
        # 4 key:value pairs needed
        # Look at your previous 3DES and ChaCha20 programs if you need help here.
        result = json.dumps({
            'nonce': nonce,
            'tag': tag,
            'cipherText': cipherText,
            'key': key

        }) 

        print(result)
        
        writeOutJson(sys.argv[2],result)

    elif (action == 2):

        # Read in the json file.  There will be more key:value pairs than when
        # you read in the plaintext.
        inDecryptDets = readInJson(sys.argv[1])
        
        # TODO: keyneeded from json file.
        # If you need help look at your previous 3DES and ChaCha20 programs.
        nonce = b64decode(inDecryptDets['nonce'])
        cipherText = b64decode(inDecryptDets['cipherText'])
        tag = b64decode(inDecryptDets['tag'])
        key = b64decode(inDecryptDets['key'])
        

        # Setup the AES cipher to use the key, the cipherText, the nonce you just read in 
        # from the json file as well as the correct block cipher mode
        cipher = AES.new(key, AES.MODE_GCM, nonce)
        
        plainText = cipher.decrypt_and_verify(cipherText, tag)

        # Writing the plainText out using 'utf-8'
        # Your old programs will be helpful
        # TODO: Write out plainText in utf-8
        plainText = plainText.decode('utf-8')

        # Dump the plaintext key:value to json file.
        # TODO: json.dumps({'key1':value1,'key2':value2,'key3':value3})
        # 1 key:value pair needed
        result = json.dumps({
            'plainText': plainText
        }) 
 
        
        print(result)

        writeOutJson(sys.argv[2],result)


    else:
        print('You made a mistake','\n')


    return

if __name__ == "__main__":
    main()


