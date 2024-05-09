# Lab 07 part 02
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
# python3 part02skel.py input.json output.json
"""
This code is based upon the documentation for
using Triple DES found on the PyCryptodome web pages.

https://pycryptodome.readthedocs.io/en/latest/src/cipher/des3.html

It has been modified for use in CprE/CybE 331.

You should never used Triple DES in a real world application.
There is a warning on the documentation page that suggests you
use AES instead.

We are only using Triple DES as part of the lab so you can
understand how it works.
"""


import sys
import json
from base64 import b64encode 
from base64 import b64decode 
from Crypto.Cipher import DES3    
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
        plaintext = bytes(inPlainText.get('plainText'),'utf-8')
       
        # Normally, the key would be generated and shared ahead
        # of time by 2 users.  However, you will be generating 
        # some random bytes to be used as a key.  
        # In this case we will be using 3 - 8 byte keys which will
        # provide us with a total of 24 bytes of key.  We also 
        # have to adjust the parity since the bits are ignored
        # in 3DES. 
        # While one would think there are 192 bits of key, there 
        # is a problem with that calculation.  The effective key size is
        # really 112 bits.  You will explain that discrepancy in 
        # your lab report. 
        key1 = bytearray(get_random_bytes(8))
        key2 = bytearray(get_random_bytes(8))
        key3 = bytearray(get_random_bytes(8))

        # You could extend the bytearrays, but I chose to 
        # concatenate them using the +
        tDesKey = key1 + key2 + key3

        tDesKey = DES3.adjust_key_parity(tDesKey)
        
        # You will use the DES3.new method 
        # In the block cipher mode we are using an iv
        # is stored in an 8 byte field.  
        #
        # Additionally, the actual messages that is sent is
        # the iv concatentated with the
        # ciphertext
        cipher = DES3.new(tDesKey, DES3.MODE_CFB) 
        cipherText = cipher.encrypt(plaintext)
        iv = cipher.iv
        msg = cipher.iv + cipherText
        
        # Writing the values out using base64 encoding
        iv = b64encode(cipher.iv).decode('utf-8')
        cipherText = b64encode(cipherText).decode('utf-8')
        msg = b64encode(msg).decode('utf-8')
        tDesKey = b64encode(tDesKey).decode('utf-8')
        key1 = b64encode(key1).decode('utf-8') 
        key2 = b64encode(key2).decode('utf-8') 
        key3 = b64encode(key3).decode('utf-8') 
        
        # Create the json object
        # You will be writing out the iv, the ciphertext, the tDesKey, the msg,
        # as well as the three initial keys you created randomly
        # You will be using the dictionary's key:value pair 
        # Reminder, you would never write the key out to a json file in a real 
        # world application.
        # TODO: json.dumps({'key1':value1,'key2':value2,'key3':value3})
        # 7 key:value pairs needed
        result = json.dumps({
            'iv': iv,
            'cipherText': cipherText,
            'tDesKey': tDesKey,
            'msg': msg,
            'key1': key1,
            'key2': key2,
            'key3': key3
        })

        print(result)

        writeOutJson(sys.argv[2],result)

    elif (action == 2):

        # Read in the json file.  There will be more key:value pairs than when
        # you read in the plaintext.
        inDecryptDets = readInJson(sys.argv[1])
        
        # TODO: keyneeded from json file.
        iv = b64decode(inDecryptDets['iv'])
        cipherText = b64decode(inDecryptDets['cipherText'])
        tDesKey = b64decode(inDecryptDets['tDesKey'])

        # Setup the 3DES cipher to use the key and the iv you just read in 
        # from the json file as well as the correct block cipher mode
        cipher = DES3.new(tDesKey, DES3.MODE_CFB, iv = iv)
        plainText = cipher.decrypt(cipherText)
        
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


