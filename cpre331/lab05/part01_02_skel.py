# Lab 05  :

#This program will have two options to work with a LFSR cryptosystem 
#  1) Encrypt or Decrypt
#  2) Cryptanalysis
#  The simplest way to accommplish this is to reuse the functions
#
#  It is also easiest if you put filenames on the command line
#  For example: 
#         python3 part01_02.py input_file output_file
#  1) Encrypt - input_file == plaintext, output_file == ciphertext
#  2) Decrypt - input_file == ciphertext, output_file == plaintext
#  3) Cryptanalysis - input_file_1 == knownplaintext, input_file_2 == ciphertext, 
#     output_file == possiblekeystream
 

import sys
import binascii


#readIn function: 
#  Reads a file ether character by character or line by line into a list.
#  There are benefits to each method.  You may chose which to use.
#  Returns a list of characters or lines
#  The choice will be up to you.
#  For this implementation I chose to use character by character. 
def readIn(filename):
   with open(filename, 'r') as file:

          ciphertext = file.read().rstrip("\x00")
   return ciphertext #return the list you generated
 
 
#writeOut function:
#  Writes out a file
#  Can be used to save out the cipherText, the plainText, or the keyStream. 
def writeOut(filename, asciiText):
    file = open(filename, 'w')
    file.write(asciiText)
    file.close()


#cycle function:
#  The cycle function produces the new bit, 
#  shifts the registers to the right by one position,
#  and puts the new bit in the 4th bit position.
#
#  Two ways to do this are provided below.  
#  Pick the ONE cycle function you chose to use.
#  The first one uses bit shifting.
#  The second one selects a value at a specific index and then shifts the register array.
#
#  Either of these functions work for part01
#  You will need to modify the bits based upon your cryptanalysis for part02
#  As it is written it XORs the first bit and the last bit in the registers
#  You need to select different bits to create the correct xorValue
#  However, the shifting of the registers will not need to be modified.
def cycle2(registers):

     xorValue = 0
     
     #  TODO:  Modify which register position is needed for part02
     xorValue = ((registers & 1) ^(registers >> 3)) & 1
     #xorValue = ((registers & 3) ^(registers >> 4)) & 1
     
     #  Do not modify the line below.  The shifting works
     registers = (registers >> 1) | (xorValue << 3)
     
     return registers

#def cycle2(registers):
    #  TODO:  Modify the register indices for part02
#    xorValue = int(registers[3]) ^ int(registers[4])
    
    #  Do not modify the line below.  The shifting works
#    registers.pop(len(registers)-1)
#    registers.insert(0, str(xorValue))
#    return registers

def cycle(registers):

     #xorValue = 0
     
     #  TODO:  Modify which register position is needed for part02
     #xorValue = ((registers & 1) ^(registers >> 3)) & 1
     # part 2
     xorValue = ((registers & 1) ^(registers >> 1))
     
     #  Do not modify the line below.  The shifting works
     registers = (registers >> 1) | (xorValue << 3)
     
     return registers

 
 
#makeKeystream function:
#  Use the length of the plaintext in binary.
#  Create a keystream that is the same length.
#  The keystream is generated the 4th bit [3] in every cycle
#  of the registers.  
#  Don't forget that you must include bit 4 [3] of the 
#  seed value as the first bit in the keyStream.  
#  Depending upon how you implement this it may be useful to know
#  that you can get the last bit of the register by using &1 to the register
def makeKeystream(registers, length, number):
     #  TODO:  Use cycle(registers) here
     #  Potentially create a list to store the keyStream into

     keyStream = ""

     keyStream += str(registers & 1)

      # Generate the remaining bits of the keystream
     for i in range(length - 1):
        if(number == 1) :
           registers = cycle(registers) 
           
        else:
           print("here")
           registers = cycle2(registers) 

        keyStream += str(registers & 1)
           
        
     return keyStream[:length]


#XOR function:
#  Create a function that performs XOR
#  This function can be used to XOR the bits of 
#  plainText with keyStream (encrypt)
#  cipherText with keyStream (decrypt)
#  knownPlaintext with cipherText (cryptanalysis)
def XOR(bits, keyStream):
     #  TODO: Implement here 
     bitList = ""

     #print("bits: ")
     #print(bits)
     #print("keystream: ")
     #print(keyStream)
      
     for bit1, bit2 in zip(bits, keyStream):
             resultBit = int(bit1, 2) ^ int(bit2, 2)
             if(resultBit == 1):
               bitList += "1"
             
             else:
               bitList += "0"
             
     
     return bitList



#toBinary function:
#  Use to convert characters or a string to binary representation
#  Which you do depends upon how you read the file
def toBinary(inChars):
     #TODO:  Implement here

     binChars = []

     for char in inChars:
          binChars.append('{0:08b}'.format(ord(char)))

     return ''.join(binChars)

#Use to convert a binary or character string to ascii
def toAscii(bits):
     #TODO:  Implement here

     byte_list = []
     ascii_text = ""

     # Count the number of bits
     num_bits = len(bits)

     # Convert bits into bytes (8 bits per byte)
     for i in range(0, num_bits, 8):
          byte = bits[i : i + 8] 
          byte_str = ''.join(map(str, byte)) 
          byte_value = int(byte_str, 2) 
          byte_list.append(byte_value)

     # Decode bytes into ASCII characters
     for byte_value in byte_list:
          ascii_char = chr(byte_value)
          ascii_text += ascii_char

     return ascii_text


def main():
     #Prompt for action

     action = int(input("Do you want to 1) encrypt / decrypt or  2) conduct cryptanalysis?: "))


     if (action == 1):
          #check for two sys.arg[x]
          
          #Prompt for starting values: input()
          #Ex: 1001
          registers = (input("Enter starting values: "))
          
          #Readin file using sys.argv[1]
          inputText = readIn(sys.argv[1]) 

          #Convert text to binary
          inputBinary = toBinary(inputText)

          #Generate a keystream that is the length of our plaintext or ciphertext in bits
          keyStream = makeKeystream(int(registers, 2), len(inputBinary), 1)
          
          print("Plaintext Bits:\n")
          print(inputBinary)


          print("Keystream Bits:\n")
          print(keyStream)

          # Generate the ciphertext or plaintext by XORing the bits with the keyStream bits
          outputText = XOR(''.join(inputBinary), keyStream)

          # Part 1
          print("Ciphertext Bits:\n")
          print(''.join(outputText) + "\n")

          

          decryptedText = XOR(outputText, keyStream)
          
          print("Decrypted Ciphertext Bits:\n")
          print(''.join(decryptedText) + "\n")

          # Turn into ASCII
          asciiText = toAscii(decryptedText)
          print("ASCII Text:\n")
          print(asciiText)

          #binaryTest = "0100100001100101011011000110110001101111"
          #asciiTest = toAscii(binaryTest)
          #print(asciiTest)
          
          #Write file
          writeOut(sys.argv[2],asciiText)
          
          #Print ascii

     elif (action == 2):
          
        #check for three sys.arg[x]
        
        #Readin knownPlainText and cipherText
        knownPlainText = readIn(sys.argv[1])
        cipherText = readIn(sys.argv[2])

        print("Plaintext:\n")
        print(knownPlainText + "\n")

        print("Ciphertext:\n")
        print(cipherText + "\n")
        
        #Convert knownPlainText and cipherText to binary
        knownPlainTextBits = toBinary(knownPlainText)
        ciphertextBits = toBinary(cipherText)
        #ciphertextBits = [int(bit) for bit in ciphertextBits]

        # Print knownPlainTextBits
        print("Known Plaintext Bits:\n")
        print(knownPlainTextBits)
        
        # Print ciphertextBits
        print("Ciphertext Bits:\n")
        print(ciphertextBits)
        
        #Generate the possible keyStream by XORing the knownPlainText bits with the ciphertextBits
        suspectedKeystream = XOR(knownPlainTextBits, ciphertextBits)  
          
        # period = 15 (110001001101011)
        #degree = log_2(15 + 1) = 4

        period = 15

        print("Period:")
        print(period)
        
        degree = 4

        print("\nDegree:")
        print(degree)
        
        seed = int(''.join(map(str, suspectedKeystream[:degree])))

        #seed = suspectedKeystream[:degree]
        
        
        # 0   0   (1   1) -> 0
        # 0   0   0   1  -> 1
        # 1   0   0   0  -> 0
        # 0   1   0   0     0
        # 0   0   1   0     1
        # 1   0   0   1     1 
        # 1   1   0   0     0
        # 0   1   1   0     1
        # 1   0   1   1     0
        # 0   1   0   1     1
        # 1   0   1   0     1
        # 1   1   0   1     1
        #     1   1   0     1
        #         1   1     0
        #             1     0

        # seed = 1100

        # Base
        # 0   0   1   1
        # 0   0   0   1
        # 1   0   0   0
        # 0   1   0   0       


        print("\nSuspected Keystream:\n")
        #print(''.join(map(str, suspectedKeystream)), "\n")
        print(suspectedKeystream)

        #asciiText = toAscii(suspectedKeystream)

        #print("ASCII Text:\n")
        #print(asciiText)

        print("Seed:")
        print(seed)

        #keyStream = makeKeystream(seed, len(ciphertextBits), 2)

        #print("Ciphertext Length:")
        #print(len(ciphertextBits))
        #print("\n")

        #print("Keystream:")
        #print(''.join(map(str, keyStream)))

        #print("keystream")
        #print(keyStream)  
        
        #print("Possible Keystream:")
        #print(possibleKeyStream, "\n")
        
        #Write file containing possible keyStream
        #writeOut(sys.argv[3], asciiText)
        
        #You will need to determine which bits are XORed together in the function
        #using a Googlesheet or Excel spreadsheet.  For the lab there are only 2 taps being used.
        #Once you have the seed value, return to this program and run the encrypt/decrypt 
        #portion of the program using the discovered seed value.

     else:
        print("Something went wrong.")

if __name__=="__main__":
  main()

