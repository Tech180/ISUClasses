#Part 02 

#This program has a list of lists that will be searched.
#The program will prompt the user for a character and output
#the number of times the character appears in each of the lists.

#Frequency function:
#  There are two input variables used by this function: the name of
#  the list of lists and the character for which you are searching.
#  The function prints (not returns) the number of occurrences of 
#  that character in each of the lists.

def frequency(inputs, character):
     #TODO:

     #print(dict((i, inputs.count(i)) for i in character))

     #for i in inputs:
        #print (i[0])
        #for x in len(inputs[i]):
        #print (inputs.count('A'))
        #if (i == character):
        #    y = y + 1

     # Iterate through inputs
     for i in range(len(inputs)):
             # Count occurences of a character in the array
             count = inputs[i].count(character)

             # Print out that what number in the array it is and the number of occurences within that array
             print (f"Input [ {i} ] : {count}")

     
     #print ("Input [ 0 ] : " + str(y))


#Main
def main():
    #A list of lists
    inputs = [list("AOLSLAALYJJVVRPLZBHYABDPAOBSLAZAOBURBMVAOLYAOPUNZ"),
              list("ZCXNSMCPROCTYDGHCSUIRYTEBHHCJSMECWTQZCHDKRILLMSJS"),
              list("WSCVKAUSAUDJAUUEAOPLAHSMACDGHAUUSGABXHAGEHASGDARU")]

    charToCount = input("What character do you want to check?  ")

    # Checks for all occurences in inputs list
    # Also if lower case letter will make uppercase
    frequency(inputs, charToCount.upper())


if __name__ == "__main__":
    main()

