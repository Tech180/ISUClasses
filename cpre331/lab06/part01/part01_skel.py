# Lab 06 part 01
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
# python3 part01_skel.py input.json output.json
"""
This code is based upon the documentation for
using ChaCha20 found on the PyCryptodome web pages.

https://pycryptodome.readthedocs.io/en/v3.19.0/src/cipher/chacha20.html

It has been modified for use in CprE/CybE 331.

ChaCha20 is never used alone unless as PRNG.  In practice it would
be used with Poly1305 which would check for integrity.
As it is used here, only confidentiality is being accomplished. And,
by saving the key out in a plaintext file, that really isn't done
either.  
"""


import sys
import json
from base64 import b64encode 
from base64 import b64decode 
from Crypto.Cipher import ChaCha20
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
    action = int(input("Do you want to 1) encrypt or  2) decrypt?: "))

    if (action == 1):

        inPlainText = readInJson(sys.argv[1])

        # You will be working with bytes in this program
        # Here you will be reading from the dictionary named
        # inPlainText which was created when you readin the 
        # json file.  Use the key to call in the value from the
        # key:value pair in the dictionary.
        # .get() method is used to read what is stored in the value
        # and utf-8 is 8-bit unicode.
        # TODO: keyneeded from json file.
        plaintext = bytes(inPlainText.get('plainText'), 'utf-8')
       
        # Normally, the key would be generated and shared ahead
        # of time by 2 users.  However, you will be generating 
        # some random bytes to be used as a key.  You need 32 bytes
        # You will be writing the key out at the end of this action
        # so you can use it in part02.
        # TODO: Use get_random_bytes
        key = get_random_bytes(32)
                
        # You will use the ChaCha20.new method
        # You have generated a 32 byte key above.
        # By default a random number of 8 bytes is generated 
        # and stored in the nonce attribute.
        cipher = ChaCha20.new(key=key)
        cipherText = cipher.encrypt(plaintext)
        nonce = cipher.nonce
        
        # Writing the values out using base64 encoding
        nonce = b64encode(cipher.nonce).decode('utf-8')
        cipherText = b64encode(cipherText).decode('utf-8')
        key = b64encode(key).decode('utf-8')
        
        # Create the json object
        # You will be writing out the random number, the ciphertxt, and the key
        # using the dictionary's key:value pair 
        # Again, you would never write the key out to a json file in a real 
        # world application.
        # TODO: json.dumps({'key1':value1,'key2':value2,'key3':value3})
        result = json.dumps({
            'nonce': nonce,
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
        nonce = b64decode(inDecryptDets['nonce'])
        cipherText = b64decode(inDecryptDets['cipherText'])
        key = b64decode(inDecryptDets['key'])

        # Setup the ChaCha20 cipher to us the key and the nonce you just read in 
        # from the json file
        cipher = ChaCha20.new(key=key, nonce=nonce)
        plainText = cipher.decrypt(cipherText)
        plainText = plainText.decode('utf-8')

        # Dump the plaintext key:value to json file.
        # TODO: json.dumps({'key1':value1,'key2':value2,'key3':value3})
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


