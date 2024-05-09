#Lab 02 Part01:

#This program will 
#  read in a ciphertext file, 
#  count the total number of characters, 
#  count the number of occurrences of each character in the ciphertext, 
#  calculate the percentages,
#  store the counts and percentages in a list of lists, 
#  print out the percentages in descending order,
#  print out possible solutions until a plaintext solution is found
#  You must show all the iterations you have completed in finding the plaintext


#readIn function: 
#  Reads a file ether character by character or line-by-line into a list.
#  There are benefits to each method.  You may chose which to use.
#  Returns a list of characters or lines
#  The choice will be up to you.
def readIn(filename):
    #TODO: Implement Here

    with open(filename, 'r') as file:
        content = file.read()
    
    return list(content) #return the list you generated 

#frequency function:
#  You have already written a function that counts the occurence of a 
#  specified character. This time instead of printing the counts,
#  you will be returning the number of occurences for the character.
def frequency(inputs, character):
    #TODO: Implement Here


    return inputs.count(character) #return the count of the character  

#substituteAlphabet function:
#  Using the character frequencies and information
#  you have gained from the digrams and trigrams
#  create the monoalphabetic substitution to solve
#  the plaintext message.
#  You may want to modify the list of lists that contains
#  your cipherCharsList or you may want to create a new list
#  of lists
# NOTE Does not use frequencies! Used only for testing...
#def substituteAlphabet(cipherText, frequencies):
def substituteAlphabet(cipherText):
    #TODO: Implement HERE

    # English
    alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

    #key = ''.join(frequencies)

    #frequencies = "VMBKFDELRPAXIQJZCSUNOYTWGH"

    # no duplicate letters
    # ## -> Stayed the same
    # V == C
    # M == T ##
    # B == U
    # K == N
    # F == S
    # D == O
    # E == Q
    # L == Z
    # R == W
    # P == K
    # A == H
    # X == D
    # I == A
    # Q == J
    # J == F
    # Z == R
    # C == M
    # S == I
    # U == P ##
    # N == V
    # O == B
    # Y == E
    # T == X
    # W == L
    # G == Y
    # H == G
   
    # Most Common English letters
    #key = "ETAOINSHRLDCUMWFGYPBVK"

    # Iterations
    # Most Common English letters in 26 letters
    # Shift 0
    #key = "EMBKFDELRPAXIQJZCSUNOYTWGH"

    # Words forming starting from a->c
    #key = "CTAOINSHRLDCUMWFGYPBVKETAO"

    # Changing T doesn't do anything
    #key = "CTAOINSHRLDCUMWFGYPBVKETAO"

    # Went all the way to U until words started appearing again
    #key = "CTUOINSHRLDCUMWFGYPBVKETAO"

    #key = "CTUOINSHRLDCUMWFGYPBVKETAO"
    #key = "CTUNSOQZWKHDAJFRMIPVBEXLYG"

    # Final Key
    key = "CTUNSOQZWKHDAJFRMIPVBEXLYG"

    # Empty PlainText String
    plainText = ""

    #changes out all characters for strings
    for character in cipherText:
        decrypt = key[alphabet.index(character)]
        plainText += decrypt


    print("\nKey:\n", key + "\t")
    print("\nPlaintext:\n", plainText)


#Main
def main():
    import string

    filename = 'cipherText.txt'

    #This is the list of lists you can use
    #Think of this as being read [row][column]
    #You can loop through the index [i][0] to 
    #pick a specific character, then you can write 
    #back to the index [i][1] for counts and 
    #index [i][2] for percentages
    cipherCharsList = [
         ['A', 0, 0],
         ['B', 0, 0],
         ['C', 0, 0],
         ['D', 0, 0],
         ['E', 0, 0],
         ['F', 0, 0],
         ['G', 0, 0],
         ['H', 0, 0],
         ['I', 0, 0],
         ['J', 0, 0],
         ['K', 0, 0],
         ['L', 0, 0],
         ['M', 0, 0],
         ['N', 0, 0],
         ['O', 0, 0],
         ['P', 0, 0],
         ['Q', 0, 0],
         ['R', 0, 0],
         ['S', 0, 0],
         ['T', 0, 0],
         ['U', 0, 0],
         ['V', 0, 0],
         ['W', 0, 0],
         ['X', 0, 0],
         ['Y', 0, 0],
         ['Z', 0, 0]
     ]
     
     
    #Call readIn function
    cipherText = readIn(filename)

    #Count characters in the list 
    #TODO: Implement Here
    #You can write a function if you prefer, but this is a pretty simple calculation 
    total = len(cipherText)


    #Count frequency of each character
    #TODO: Loop through the list of lists, use your frequency function, write back to your second column in your list of lists.   
    for characterInfo in cipherCharsList:
            character = characterInfo[0]
            count = frequency(cipherText, character)
            
            characterInfo[1] = count
            characterInfo[2] = ((count / total) * 100)
            
    #frequency(inputs, character)


    #Calculate the percentage for each letter in the ciphertext
    #TODO: Loop through the list of lists, calculate the percentage each (count of char/total char)*100, write back to your third column in your list of lists.   
    #Sort the list of lists based upon the percentages in descending order
    #TODO: Sort through the list of lists, print the character, count, percentage in descending order
    #HINT:  There is a method called .sort(), you can select which index to sort on and you can reverse the sort to achieve descending order.
    #Example is below       9.0310442144873		

    #myList.sort(key=lambda myList: myList[indextosorton],reverse=True)
    #print("Character ","\t", "Count ","\t", "Percentage","\n")

    cipherCharsList.sort(key=lambda x: x[2], reverse=True)

    print("Character ","\t", "Count ","\t", "Percentage","\n")
    
    for characterInfo in cipherCharsList:
        print(characterInfo[0], "\t\t", characterInfo[1], "\t\t", characterInfo[2])

    # Grab frequencies from list
    #frequencies = [char_info[0] for char_info in cipherCharsList]

    #substituteAlphabet(cipherText, frequencies)
    #Based upon the frequencies, digrams, trigrams try your substitution
    substituteAlphabet(cipherText)

if __name__ == "__main__":
    main()
