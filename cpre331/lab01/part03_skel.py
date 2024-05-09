#Part 03

#This program will provide cryptanalysis on a Shift by N cipher using an exhaustive key search
#You can either hard code the ciphertext into the program (easy) or you can prompt for 
#a text file or character input from the command line.
#You will need a function called analyze that will read in the ciphertext and then conduct an 
#exhaustive key search that outputs its key (the N) and the answer in each trial)
#
#Example output:

#Testing shift by:  0
#qefpzixppfpsbovzlli

#Testing shift by:  1
#rfgqajyqqgqtcpwammj

#Testing shift by:  2
#sghrbkzrrhrudqxbnnk

#Look back at parts 01 and 02.  They provide clues on how to implement this.  

def analyze(ciphertext):
    #TODO:

    #26 for alphabet
    for shift in range(26):
        newText = ""
        for char in ciphertext:
            #chr for unicode, ord returns an integer value that is the unicode equivalent
            decrypt = chr(((ord(char) - ord('a') - shift) % 26) + ord('a'))

            newText += decrypt

        # prints all shift possiblies but of course not 26 because it would be the same
        print(f"Testing shift by: {shift}")
        print(newText)

#Main
def main():
    #TODO:  

    ciphertext = input("Enter a string to be encrypted/decrypted by a N value: ")
    
    analyze(ciphertext)

if __name__ == "__main__":
    main()

