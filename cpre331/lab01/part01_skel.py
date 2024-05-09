#Part 01

#This program will prompt the user for a sentence.
#The program passes the sentence to a function named modify().
#The function modify() returns a string that shifts the characters
#in the sentence three characters to the right.


#Modify function:
#  Takes in a list and then
#  iterates through it shift the
#  characters three to the right
#  returns a string.
def modify(sentence):
    #TODO: Implement Here
    newsentence = ''

    for i in range(len(sentence)):
            # Shift position of new index, and wrapping around to a if needed
            newindex = (i + 3) % len(sentence)

            # Append character to the new index and to the modified sentence
            newsentence += sentence[newindex]

    # Return shifted sentence
    return(newsentence) 

#Main
def main():
    sentence = input("Write a sentence without spaces: ")
    
    #TODO: Implement Here
    print(modify(sentence))

if __name__ == "__main__":
    main()
