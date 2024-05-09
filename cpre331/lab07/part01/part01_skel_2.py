# Lab 07 part 01
# You will be creating a Baby
# Fiestel cipher.  It will have a 4 bit key
# and work with only 4 bits of data. It will run for 3 
# rounds.  You will not be implementing a block
# cipher mode.
#
# The s-box lookup table is provided for you.
#
# 
import copy

# sBox function
# The sBox lookup table is implemented for you 
# as a list.  You pass the key and half the inputBits 
# into the table and the s-box value is returned.
# This should not be modified.  It is intended to function
# correctly for you.  
def sBox(keyBits, rightHalf):
    key = int(keyBits, 2)
    index = int(rightHalf, 2)
    sBox = [[0]*4]*16
    sBox[0] = [0, 2, 2, 3]
    sBox[1] = [2, 3, 0, 0]
    sBox[2] = [1, 2, 0, 0]
    sBox[3] = [3, 0, 1, 3]
    sBox[4] = [2, 0, 3, 1]
    sBox[5] = [1, 3, 2, 2]
    sBox[6] = [3, 1, 3, 2]
    sBox[7] = [0, 1, 2, 1]
    sBox[8] = [3, 1, 0, 2]
    sBox[9] = [1, 0, 1, 3]
    sBox[10] = [0, 3, 3, 0]
    sBox[11] = [1, 2, 3, 1]
    sBox[12] = [2, 3, 1, 2]
    sBox[13] = [3, 1, 0, 0]
    sBox[14] = [0, 0, 2, 1]
    sBox[15] = [2, 2, 1, 3]
    
    return sBox[key][index]
    
    
# ---  Functions for encoding ---


# encode function
# The main encoding function for the Fiestel cipher
# You will pass in the inputBits and the keyBits.
# You will run for 3 rounds.
# You will print the values in each round.
# You will NOT want to increment the keyBits on the last round
def encode(inputBits, keyBits):
    # TODO:  Call the encodeRoundFunction and the encodeRotateKey function
    # Loop through encodeRoundFunction 3 times, but only rotate the key twice
    # Also print the round and the inputBits here

    # Goes through encodeRoundFunction 3 times printing each round
    
    inputBits = encodeRoundFunction(inputBits, keyBits)
    #inputBits = encodeRoundFunction(inputBits, encodeRotateKey(keyBits)) 
    print(f"Round 0 - Input Bits: {inputBits}")

    #print("encode keybits: " + keyBits)

    #inputBits = encodeRoundFunction(inputBits, keyBits)
    inputBits = encodeRoundFunction(inputBits, encodeRotateKey(keyBits))    
    print(f"Round 1 - Input Bits: {inputBits}")

    #print("encode keybits: " + keyBits)

    inputBits = encodeRoundFunction(inputBits, keyBits)
    #inputBits = encodeRoundFunction(inputBits, encodeRotateKey(keyBits))
    print(f"Round 2 - Input Bits: {inputBits}")

    #print("encode keybits: " + keyBits)

    return inputBits, keyBits

# encodeRoundFunction function
# Split the four bits into 2 halves
# a left half and a right half
def encodeRoundFunction(inputBits, keyBits):

    #print("inputBits: " + inputBits)
    leftHalf = inputBits[:2]
    rightHalf = inputBits[2:]
    
    # TODO:  Call the sBox function using the parameters of keyBits and the current rightHalf
    # This will get you the value from the sBox lookup table
    # Set the leftHalf to the current rightHalf
    # Set the rightHalf to (the current leftHalf XOR'ed with the output from the sBox function)
    # You will have problems with the output dropping the leading zeros.  A quick fix you can use is below.
    
    #if (rightHalf == "0"):
    #    rightHalf = "00"
    #elif (rightHalf == "1"):
    #    rightHalf = "01"

    sBoxOutput = sBox(keyBits, rightHalf)

    ogLeft = leftHalf
    ogRight = rightHalf

    #print("leftHalf: " + leftHalf)
    #print("rightHalf: " + rightHalf)
    
    #leftHalf = rightHalf
    leftHalf = ogRight
    
    rightHalf = format(int(ogLeft, 2) ^ sBoxOutput, '02b')

    #print("encode round keybits: " + keyBits)

    #rightHalf = format(int(leftHalf, 2) ^ sBoxOutput, '02b')
    # Join the two halfs back together and return
    inputBits = leftHalf + rightHalf
    
    return inputBits

# encodeRotateKey function
# This function is used to shift the key left.
# The first bit becomes the last bit.
# An easy way to do this is to use a list and treat it like an array
# You may want to create a temporary copy of the list and shift the bits in the array.
def encodeRotateKey(keyBits):
    key = list(keyBits)
    #TODO: Shift the key left.  The first bit becomes the last bit.
    key = key[1:] + key[:1]
    
    key = "".join(key)
    
    return key

   
def main():
    inputBits = input("4-bit input to encode: ")
    keyBits = input("4-bit key: ")
    
    print("\nEncode:\n")
    encode(inputBits, keyBits)


if __name__ == '__main__':
    main()
