# Lab 08 part 01
# This skeleton code implements Baby Rijndael
# as developed by an ISU graduate student and
# Dr. Cliff Bergman in the ISU Math Department.
# Dr. Bergman is now retired.
#
# You will only be changing the plaintext and 
# the roundkeys.  The roundkeys will come from 
# the table provided in the lab instructions.
#
# You will need to print the labels for each step
# and will use both the print() function and the
# print2DArray() function.  



#Takes in an array of hex characters
def subByte(arr):
    origin = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f']
    substitute = ['a', '4', '3', 'b', '8', 'e', '2', 'c', '5', '7', '6', 'f', '0', '1', '9', 'd']
    subByteArray = []
    for i in range(len(arr)):
        subByteArray.append(substitute[origin.index(arr[i])])
    print2DArray(subByteArray)
    return subByteArray

#Takes in an array of hex characters
def shiftRows(arr):
    print('shiftRow')
    print2DArray([arr[0], arr[3], arr[2], arr[1]])
    return [arr[0], arr[3], arr[2], arr[1]]

#Takes in an array of hex characters
def mixColumn(arr):
    arr = hexToBits(arr)
    h00 = int(arr[0][0])
    h01 = int(arr[0][1])
    h02 = int(arr[0][2])
    h03 = int(arr[0][3])

    h10 = int(arr[1][0])
    h11 = int(arr[1][1])
    h12 = int(arr[1][2])
    h13 = int(arr[1][3])

    h20 = int(arr[2][0])
    h21 = int(arr[2][1])
    h22 = int(arr[2][2])
    h23 = int(arr[2][3])

    h30 = int(arr[3][0])
    h31 = int(arr[3][1])
    h32 = int(arr[3][2])
    h33 = int(arr[3][3])


    nh00 = ((h00 * 1) + (h01 *  0) + (h02 *  1)  + (h03 * 0) + (h10 * 0) + (h11 *  0) + (h12 *  1) + (h13 *  1) ) % 2
    nh01 = ((h00 * 1) + (h01 *  1) + (h02 *  0)  + (h03 * 1) + (h10 * 0) + (h11 *  0) + (h12 *  0) + (h13 *  1) ) % 2
    nh02 = ((h00 * 1) + (h01 *  1) + (h02 *  1)  + (h03 * 0) + (h10 * 1) + (h11 *  0) + (h12 *  0) + (h13 *  0) ) % 2
    nh03 = ((h00 * 0) + (h01 *  1) + (h02 *  0)  + (h03 * 1) + (h10 * 0) + (h11 *  1) + (h12 *  1) + (h13 *  1) ) % 2
    nh10 = ((h00 * 0) + (h01 *  0) + (h02 *  1)  + (h03 * 1) + (h10 * 1) + (h11 *  0) + (h12 *  1) + (h13 *  0) ) % 2
    nh11 = ((h00 * 0) + (h01 *  0) + (h02 *  0)  + (h03 * 1) + (h10 * 1) + (h11 *  1) + (h12 *  0) + (h13 *  1) ) % 2
    nh12 = ((h00 * 1) + (h01 *  0) + (h02 *  0)  + (h03 * 0) + (h10 * 1) + (h11 *  1) + (h12 *  1) + (h13 *  0) ) % 2
    nh13 = ((h00 * 0) + (h01 *  1) + (h02 *  1)  + (h03 * 1) + (h10 * 0) + (h11 *  1) + (h12 *  0) + (h13 *  1) ) % 2
    nh20 = ((h20 * 1) + (h21 *  0) + (h22 *  1)  + (h23 * 0) + (h30 * 0) + (h31 *  0) + (h32 *  1) + (h33 *  1) ) % 2
    nh21 = ((h20 * 1) + (h21 *  1) + (h22 *  0)  + (h23 * 1) + (h30 * 0) + (h31 *  0) + (h32 *  0) + (h33 *  1) ) % 2
    nh22 = ((h20 * 1) + (h21 *  1) + (h22 *  1)  + (h23 * 0) + (h30 * 1) + (h31 *  0) + (h32 *  0) + (h33 *  0) ) % 2
    nh23 = ((h20 * 0) + (h21 *  1) + (h22 *  0)  + (h23 * 1) + (h30 * 0) + (h31 *  1) + (h32 *  1) + (h33 *  1) ) % 2
    nh30 = ((h20 * 0) + (h21 *  0) + (h22 *  1)  + (h23 * 1) + (h30 * 1) + (h31 *  0) + (h32 *  1) + (h33 *  0) ) % 2
    nh31 = ((h20 * 0) + (h21 *  0) + (h22 *  0)  + (h23 * 1) + (h30 * 1) + (h31 *  1) + (h32 *  0) + (h33 *  1) ) % 2
    nh32 = ((h20 * 1) + (h21 *  0) + (h22 *  0)  + (h23 * 0) + (h30 * 1) + (h31 *  1) + (h32 *  1) + (h33 *  0) ) % 2
    nh33 = ((h20 * 0) + (h21 *  1) + (h22 *  1)  + (h23 * 1) + (h30 * 0) + (h31 *  1) + (h32 *  0) + (h33 *  1) ) % 2
    
    A = str(nh00) + str(nh01) + str(nh02) + str(nh03)
    C = str(nh10) + str(nh11) + str(nh12) + str(nh13)
    B = str(nh20) + str(nh21) + str(nh22) + str(nh23)
    D = str(nh30) + str(nh31) + str(nh32) + str(nh33)

    return bitsToHex([A, C, B, D])

#Takes an array of hex ['a', '2', ...] 
#and returns an array of bits ['1010', '0010', ...]  
def hexToBits(arr):
    hex = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f']
    bits = ['0000', '0001', '0010', '0011', '0100', '0101', '0110', '0111', '1000', '1001', '1010', '1011', '1100', '1101', '1110', '1111']
    bitArray = []
    for i in range(len(arr)):
        bitArray.append(bits[hex.index(arr[i])])
    return bitArray

#Takes an array of bits ['1010', '0010', ...]
#and returns an array of hex ['a', '2', ...] 
def bitsToHex(arr):
    hex = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f']
    bits = ['0000', '0001', '0010', '0011', '0100', '0101', '0110', '0111', '1000', '1001', '1010', '1011', '1100', '1101', '1110', '1111']
    hexArray = []
    for i in range(len(arr)):
        hexArray.append(hex[bits.index(arr[i])])
    return hexArray

#Prints out the array in a 2x2 matrix
def print2DArray(array):
    print(array[0], array[2])
    print(array[1], array[3])
    print()

#XOR bits
def xor(a, b):
  if (a == b):
    return "0"
  else:
    return "1"

#XOR two arrays of hex characters
def XOR(arr1, arr2, counter):
    arr1 = hexToBits(arr1)
    arr2 = hexToBits(arr2)
    xorArray = []
    #For each element in the array (4)
    for i in range(4):
        xorElement = ""
        bitsA = arr1[i]  #1111
        bitsB = arr2[i]  #1010
        #For each bit in the element 
        for x in range(4):
            xorElement = xorElement + xor(bitsA[x], bitsB[x])
        xorArray.append(xorElement)
    if counter < 4:
        print('start')
    else:
        print('ciphertext')
    print2DArray(bitsToHex(xorArray))
    return bitsToHex(xorArray)

def main():
    #TODO: Starting (Change this value)
    #input = ['2', 'c', 'a', '5']
    input = ['3', '7', '2', 'c']

    #Round1
    #TODO: the second argument should be the 
    #provide round key as a list
    #for example ['6', 'b', '5', 'd']
    round_key1 = ['6', 'b', '5', 'd']
    
    print("plaintext")
    print2DArray(input)

    print("roundKey 1")
    print2DArray(round_key1)
    
    start1 = XOR(input, round_key1, 0)
    
    print("subByte 1")
    subbyte1 = subByte(start1)
    
    shiftrow1 = shiftRows(subbyte1)

    print("mixColumn 1")
    mixcolumn1 = mixColumn(shiftrow1)
    print2DArray(mixcolumn1)

    #Round2
    #TODO: the second argument should be the 
    #provide round key as a list
    #for example ['6', 'b', '5', 'd']
    round_key2 = ['6', '5', '3', '8']
    
    print("roundKey 2")
    print2DArray(round_key2)
        
    start2 = XOR(mixcolumn1, round_key2, 1)
    
    print("subByte 2")
    subbyte2 = subByte(start2)
    
    shiftrow2 = shiftRows(subbyte2)
    
    print("mixColumn 2")
    mixcolumn2 = mixColumn(shiftrow2)
    print2DArray(mixcolumn2)

    
    #Round3
    #TODO: the second argument should be the 
    #provide round key as a list
    #for example ['6', 'b', '5', 'd']
    round_key3 = ['1', 'e', '2', '6']
    print("roundKey 3")
    print2DArray(round_key3)
    
    start3 = XOR(mixcolumn2, round_key3, 2)

    print("subByte 3")
    subbyte3 = subByte(start3)

    shiftrow3 = shiftRows(subbyte3)

    print("mixColumn 3")
    mixcolumn3 = mixColumn(shiftrow3)
    print2DArray(mixcolumn3)

    #Round4
    #TODO: the second argument should be the 
    #provide round key as a list
    #for example ['6', 'b', '5', 'd']
    round_key4 = ['7', 'd', '5', 'b']
    
    print("roundKey 4")
    print2DArray(round_key4)
    
    start4 = XOR(mixcolumn3, round_key4, 3)

    print("subByte 4")
    subbyte4 = subByte(start4)

    shiftrow4 = shiftRows(subbyte4)
    
    
    #TODO: the second argument should be the 
    #provide round key as a list
    #for example ['6', 'b', '5', 'd']
    round_key5 = ['0', '3', '5', '8']
    
    print("roundKey 5")
    print2DArray(round_key5)
    
    XOR(shiftrow4, round_key5, 4)

if __name__ == '__main__':
    main()

