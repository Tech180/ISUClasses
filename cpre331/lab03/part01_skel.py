#Lab 03 :

#This program will 
#  conduct a trigram analysis on the ciphertext
#  find the starting indices for each of the most common trigrams
#  calculate the distance between the starting index of each common trigram
#  determine the common factors of the differences to determine the key length
#  break the cipher into X (key length value) number of shift-by-n ciphers
#  perform monoalphabetic frequency analysis for each of the X shift-by-n ciphers
#  identify the potential key 
#  use the key to decrypt the ciphertext into plaintext

#  You must print all the iterations you have completed in finding the plaintext


#readIn function: 
#  Reads a file ether character by character or line-by-line into a list.
#  There are benefits to each method.  You may chose which to use.
#  Returns a list of characters or lines
#  The choice will be up to you.
def readIn(filename):
    with open(filename, 'r') as file:
        ciphertext = file.read()
    return ciphertext

#trigramAnalysis function:
#  Counts the occurrences of each trigram
def trigramAnalysis(ciphertext):
    #  Store each repeated value in trigramList and the number of times it occurs in occurrenceList
    #  Store the starting position in triPost and the distances between trigrams in differences
    #  You may rewrite this as a list of lists if you prefer

    occurrenceList = []
    trigramList = []
    triPos = []
    differences = []

    #  TODO: Implement Here
    #  Search for trigrams
    #  If there is a suplicate trigram, increment its occurrence value 
    #  If we find a new trigram append it to the list
    #  Print the 5 trigrams that occurred most frequently, the positions, and the differences.

    # Loop through the ciphertext to count trigrams
    for i in range(len(ciphertext) - 2):
    
        trigram = ciphertext[i : i + 3]

        # Check if the trigram is already in list 
        if trigram in trigramList:
            # Count and position
            occurrenceList[trigramList.index(trigram)] += 1
            triPos[trigramList.index(trigram)].append(i)
            
        else:
            # Add trigram to list and add count and position
            trigramList.append(trigram)
            occurrenceList.append(1)
            triPos.append([i])

    # Sort trigrams by frequency and print the top 5
    sortTrigrams = sorted(zip(trigramList, occurrenceList), key=lambda x: x[1], reverse=True)[:5]

    common = []
    
    for trigram, count in sortTrigrams:
        common.append(trigram.lower())
    
    print(f"The five most common trigrams are: {common} \n")

    # Print positions
    for trigram, count in sortTrigrams:
        positions = triPos[trigramList.index(trigram)]
        print(f"The starting indexes of '{trigram.lower()}' are: {positions}")

    print("\n")

    # Print differences between positions for common trigrams
    for trigram, count in sortTrigrams:
        positions = triPos[trigramList.index(trigram)]

        differences = []
        
        for i in range(len(positions) - 1):
            difference = positions[i + 1] - positions[i]
            differences.append(difference)
        
        print(f"The differences each index of '{trigram.lower()}': {differences}")


    #print(trigram info and indices)

    #  The five most common trigrams are: ['qay', 'buw', 'khm', 'gzv', 'tpr']
    #  The starting indexes of ‘qay’ are: 17, 332, 482, 777, 807, 1057  (Fixed this line to print all the indexes)
    #  The starting indexes of ‘buw’ are: 322, 452, 462, 772, 907, 1052  (Fixed this line to print all the indexes)
    #  The starting indexes of ‘khm’ are: 5, 125, 680, 810, 985  (Fixed this line to print all the indexes)
    #  The starting indexes of ‘gzv’ are: 103, 373, 433, 573, 933  (Fixed this line to print all the indexes)
    #  The starting indexes of ‘tpr’ are: 181, 276, 731, 856, 1011  (Fixed this line to print all the indexes)



#splitIntoXCiphers function:
#  Splits the ciphertext into X number of shift-by-N ciphers
def splitIntoXCiphers(keyLength, ciphertext):
    # Create an empty list to hold the sublists
    xCiphers = []


    #TODO: Implement Here
    #  Split the ciphertext into X shift-by-N ciphers by looping through the list and creating X
    #    new lists, one for each shift-by-N cipher
    
    for i in range(keyLength):
        xCiphers.append([])

    #  For each of those shift-by-N ciphers conduct a frequency analysis
    for i in range(len(ciphertext)):
        char = ciphertext[i]
        index = i % keyLength
        xCiphers[index].append(char)

    # Print each of the X ciphers
    # Print each of the X ciphers and perform frequency analysis
    for i in range(keyLength):
        print(f"\n/////////  Cipher {i}   /////////")
        cipher = ''.join(xCiphers[i])
        print(cipher)
        
        #  For each of those shift-by-N ciphers conduct a frequency analysis
        count = [0] * 26
        for cipherChar in cipher:
            if cipherChar.isalpha():
                index = ord(cipherChar.lower()) - ord('a')
                count[index] += 1
        
        print(f"\n/////////  Frequency Analysis on Cipher {i}   /////////")
        print(count)
        
        # Sort char_count by frequency in descending order
        sortChars = []
        for i in range(len(count)):
            sortChars.append((i, count[i]))
        
        sortChars = sorted(sortChars, key=lambda x: x[1], reverse=True)

        # Most Common Characters
        common = []
        for index, count in sortChars:
            if count > 0:
                common.append(chr(index + ord('a')))
            if len(common) == 3:
                break
        
        print("The three most common characters are: ", common)
        
        
        print("Most common ciphertext characters: ", common)
                
        
    return xCiphers

    
    #print(each of the X ciphers)

    #/////////  Cipher 0   /////////
    #zklykyjrcjfvkvzvzkvkxvcewkrrufjrzgfexrzwfufnfzvvlkjjiprxvfxkcuvwfikkyvfvuuvvjzzebvkyeeyvuizerpivewdztefkkrxjjdivvgfvezkvjzvyuzekvzebkrnfkjzreddfmzjrfrrrjzukjmupyzkwlfrfirilvyyluitvfjiuetvvjzzcyeeiskznwzjrfrrrjzukjmu

    #/////////  Cipher 1   /////////
    #hhmoothrypfqcrosnwtyhmiglhrtewstselatynimftorelsroiariitfuoaoraruehhudrceosrdncnetoegeawoynisgesgoetoywidthukaosouvsgsowdnftosgictnetgamhnntdeouebtiwfgtomohwehbethoinktawotsianmmovisaoaasrdnceesiilhnnrbtiwfgtomohwe

    #/////////  Cipher 2   /////////
    #mmaqvjmaemacwavkompnbwbammaouiiqblltppovmwbzivwpvunggbbpwqvsbiewbaqivuuwdqaiwiiiaqlbadlqowbobzaaqzaiuqbuwabzqvzttammmmkpmazmnbbdwaiiwuggmwoizvztztpvvzwiumbqmzcwaqmzbvmboiupvvblmwcmjbqenqaiwiiazlvkmmaqqtpvvzwiumbqmz

    #/////////  Cipher 3   /////////
    #nqravhubuebvanfbvyvygbjepfghreybbnzbrbgqberqagqrrrguofvregargtnzuaagqrbhrogvjstgbzbujrgyfhuuubgyafbecxuhjenrywvvlngegrhnrvvaguurztgyqrsbeggurbrqqrrfvvaxrguaaueljaelfnnbzllrbtneaeyeyuaaeogvjsvfnbnnfeqaprrfvvaxrguaau

    #/////////  Cipher 4   /////////
    #jjuyylwfakewnlzefnjazfawllzalvnfhfsfohgkdyfkuealvsgmgofjqkssgeqqwgysjfjdjdzffjgsewlawjzvulwlwodgygdqsfskzaksaskcetzwacjlhvywzastwgsgjsjmwzzmvjuwgkjvfufwlgwywsjksywgyldvwxgjllzwgwvvwwkaadzffjtlaoxaksgsskjvfufwlgwyws

    
    #print(the most common ciphertext characters for each cipher)
    #(The index of these values correspond to the index in the alphabet.)
    #/////////  Frequency Analysis on Cipher 0   /////////
    #[0, 2, 4, 4, 15, 18, 2, 0, 10, 18, 21, 5, 3, 3, 0, 3, 0, 20, 1, 3, 13, 26, 6, 5, 10, 23]
    #['v', 'z', 'k'] (Most common ciphertext characters)

    #/////////  Frequency Analysis on Cipher 1   /////////
    #[12, 3, 5, 6, 18, 6, 9, 14, 15, 0, 2, 4, 8, 14, 25, 1, 1, 12, 15, 21, 6, 2, 10, 0, 5, 0]
    #['o', 't', 'e'] (Most common ciphertext characters)

    #/////////  Frequency Analysis on Cipher 2   /////////
    #[21, 21, 3, 3, 3, 0, 4, 0, 19, 2, 3, 6, 25, 4, 7, 9, 17, 0, 1, 6, 10, 17, 18, 0, 0, 15]
    #['m', 'a', 'b'] (Most common ciphertext characters)

    #/////////  Frequency Analysis on Cipher 3   /////////
    #[19, 19, 1, 0, 16, 10, 21, 6, 0, 6, 0, 5, 0, 13, 3, 2, 9, 26, 3, 4, 17, 16, 1, 3, 9, 5]
    #['r', 'g', 'a'] (Most common ciphertext characters)

    #/////////  Frequency Analysis on Cipher 4   /////////
    #[14, 0, 2, 7, 6, 18, 17, 3, 0, 18, 12, 16, 3, 3, 4, 0, 4, 0, 19, 3, 6, 10, 25, 2, 10, 12]
    #['w', 's', 'f'] (Most common ciphertext characters)


#frequency function:
#  You have already written a function that counts the occurrence of a 
#  specified character.  You will probably want to write this into a list
#def frequency(inputs, character):
    #TODO: Implement Here -- you already have the basis of this function.
#    count = 0
#    for char in inputs:
#        if char.lower() == character:
#            count += 1
#    return count

#shiftChars function:
#  Based upon the output you received from the frequency analysis on each of the X shift-by-N ciphers
#    you will shift each of the X ciphers
def shiftChars(char, likelyChar, xCiphers):

    # Potential keys
    keyList = []

    # Loop through each cipher
    for cipher in xCiphers:
        count = [0] * 26
        
        for cipherChar in cipher:
            # Check if letter
            if cipherChar.isalpha():
                # Index of decrypted character
                index = ord(cipherChar.lower()) - ord(char)
                
                if index < 0:
                    index += 26

                # Update Frequency count
                decryptChar = chr(index + ord('a'))
                
                count[ord(decryptChar) - ord('a')] += 1

    # Store sorted character frequencies
    sortChars = []
    
    for index in range(len(count)):
        sortChars.append((index, count[index]))

    # Sort characters
    sortChars.sort(key=lambda x: x[1], reverse=True)

    common = []

    # Extract characters from list and add to common frequency list
    for index, count in sortChars:
        common.append(chr(index + ord('a')))

    key = common[0]
    keyList.append(key)

    decryptText = ''

    # Loop through each character in the cipher text for decryption
    for cipherChar in cipher:
    
        if cipherChar.isalpha():
        
            index = ord(cipherChar.lower()) - ord(key)
            
            if index < 0:
                index += 26
                
            decryptChar = chr(index + ord('a'))
            
            decryptText += decryptChar
        else:
            decryptText += cipherChar

    print(f"/////////  Cipher {xCiphers.index(cipher)} Potential Key Values   /////////")
    print(f"\nMost frequently occurring ciphertext characters from left to right:")
    print(common)
    print(f"\nMost likely {xCiphers.index(cipher) + 1} character(s) in the keyword: ['{key}']\n")

    return keyList

    #/////////  Cipher 0 Potential Key Values   /////////
    #['v', 'z', 'k'] (Most frequently occurring ciphertext characters from left to right)
    #['r'] (Most likely first character in the keyword)

    #/////////  Cipher 1 Potential Key Values   /////////
    #['o', 't', 'e'] (Most frequently occurring  ciphertext characters from left to right)
    #['k'] (Most likely second character in the keyword)

    #/////////  Cipher 2 Potential Key Values   /////////
    #['m', 'a', 'b'] (Most frequently occurring ciphertext characters from left to right)
    #['i'] (Most likely third character in the keyword)

    #/////////  Cipher 3 Potential Key Values   /////////
    #['r', 'g', 'a'] (Most frequently occurring ciphertext characters from left to right)
    #['n'] (Most likely fourth character in the keyword)

    #/////////  Cipher 4 Potential Key Values   /////////
    #['w', 's', 'f'] (Most frequently occurring ciphertext characters from left to right)
    #['s'] (Most likely fifth character in the keyword)



    #  use key to print plaintext solution
    #  may need to iterate which can be done manually, but all printed versions must be included
    #  in lab report
    #print(plaintextList)    
    #   /////////  Plaintext using the key:  rkins /////////
    #i x e a r t x e d r u c s e c h e i n g t e n i g h j b u t s x e h e a h s o n l o w h i s f e r s o v s o m e g u i e t s o n v e h s a t i e n s h e i c o m i d g i n t m e l v e j h i r t o f l i g x t t h e c o o n l y t w i n w s r e f b e c t t x e s t a h s t h a j g u i d u m e t o m a r d s i a l v a j i o n i i t o p p u d a n o b d m a n q l o n g j h e w a o h o p i d g t o f y n d s o c e o l d v o r g o j t e n w e r d s o h a n c i u n t m e b o d i e i h e t u h n e d t e m e a s y f t o s q y h u r h y b o y y t s w a y t i n g j h e r e v o r y o k i t s g e n n a t q k e a l e t t o d h a g m e q w a y f h o m y o k t h e r u s n o t x i n g t x a t a h k n d r e t m e n o h m o r e s o u l d u v e r d e i b l e i s t h e h a i n s t o w n i d a f r i s a g o n d a t a k u s o m e j i m e t e d o t h u t h i n w s w e n u v e r h q d t h e m i l d d e g s c r o o u t i d t h e n y g h t a i t h e y w r o w r u s t l e i s l o n w i n g f e r s o m u s o l i j a r y c e m p a n o i k n o m t h a t y m u s t t o w h a j s r i g x t a s s k r e a s a i l i m q n j a r e r i s e i l i k e e l y m p k s a b o l e t h e i e r e n w e t i i i e e k t e c u r e m h a t s t e e p i d s i d e v r i g h j e n e d e f t h i i t h i n w t h a t y v e b e s o m e i j s g o n d a t a k u a l o t j o d r a w m e a w q y f r o c y o u t x e r e s d o t h i d g t h a j a h u n t r e d m u n o r m e r e c o k l d e v u r d o i r l e s s j h e r a y n s d o m n i n a v r i c a w o n n a j a k e s e m e t i c e t o d e t h e t x i n g s m e n e v u r h a d x u r r y r o y s h u s w a i j i n g t x e r e f e r y o u y t s g o d n a t a a e a l o j t o d r q g m e a m a y f r e m y o u j h e r e i n o t h y n g t h q t a h u d d r e d c e n o r c o r e c e u l d e l e r d o y b l e s i t h e r q i n s d e w n i n q f r i c q i b l e i s t h e h a i n s t o w n i d a f r i s a i b l u s s t h u r a i n i d o w n y n a f r y c a i b b e s s t x e r a i d s d o w d i n a f h i c a i r l e s s j h e r a y n s d o m n i n a v r i c a w o n n a j a k e s e m e t i c e t o d e t h e t x i n g s m e n e v u r h a d

    #/////////  Plaintext using the key:   rpins /////////
    #i s e a r t s e d r u x s e c h z i n g t z n i g h e b u t s s e h e a c s o n l j w h i s a e r s o q s o m e b u i e t n o n v e c s a t i z n s h e d c o m i y g i n t h e l v e e h i r t j f l i g s t t h e x o o n l t t w i n r s r e f w e c t t s e s t a c s t h a e g u i d p m e t o h a r d s d a l v a e i o n i d t o p p p d a n o w d m a n l l o n g e h e w a j h o p i y g t o f t n d s o x e o l d q o r g o e t e n w z r d s o c a n c i p n t m e w o d i e d h e t u c n e d t z m e a s t f t o s l y h u r c y b o y t t s w a t t i n g e h e r e q o r y o f i t s g z n n a t l k e a l z t t o d c a g m e l w a y f c o m y o f t h e r p s n o t s i n g t s a t a h f n d r e o m e n o c m o r e n o u l d p v e r d z i b l e d s t h e c a i n s o o w n i y a f r i n a g o n y a t a k p s o m e e i m e t z d o t h p t h i n r s w e n p v e r h l d t h e h i l d d z g s c r j o u t i y t h e n t g h t a d t h e y r r o w r p s t l e d s l o n r i n g f z r s o m p s o l i e a r y c z m p a n j i k n o h t h a t t m u s t o o w h a e s r i g s t a s s f r e a s v i l i m l n j a r z r i s e d l i k e z l y m p f s a b o g e t h e d e r e n r e t i i d e e k t z c u r e h h a t s o e e p i y s i d e q r i g h e e n e d z f t h i d t h i n r t h a t t v e b e n o m e i e s g o n y a t a k p a l o t e o d r a r m e a w l y f r o x y o u t s e r e s y o t h i y g t h a e a h u n o r e d m p n o r m z r e c o f l d e v p r d o i m l e s s e h e r a t n s d o h n i n a q r i c a r o n n a e a k e s z m e t i x e t o d z t h e t s i n g s h e n e v p r h a d s u r r y m o y s h p s w a i e i n g t s e r e f z r y o u t t s g o y n a t a v e a l o e t o d r l g m e a h a y f r z m y o u e h e r e d n o t h t n g t h l t a h u y d r e d x e n o r x o r e c z u l d e g e r d o t b l e s d t h e r l i n s d z w n i n l f r i c l i b l e d s t h e c a i n s o o w n i y a f r i n a i b l p s s t h p r a i n d d o w n t n a f r t c a i b w e s s t s e r a i y s d o w y i n a f c i c a i m l e s s e h e r a t n s d o h n i n a q r i c a r o n n a e a k e s z m e t i x e t o d z t h e t s i n g s h e n e v p r h a d


    #/////////  Plaintext w/ key:  rains /////////
    #i h e a r t h e d r u m s e c h o i n g t o n i g h t b u t s h e h e a r s o n l y w h i s p e r s o f s o m e q u i e t c o n v e r s a t i o n s h e s c o m i n g i n t w e l v e t h i r t y f l i g h t t h e m o o n l i t w i n g s r e f l e c t t h e s t a r s t h a t g u i d e m e t o w a r d s s a l v a t i o n i s t o p p e d a n o l d m a n a l o n g t h e w a y h o p i n g t o f i n d s o m e o l d f o r g o t t e n w o r d s o r a n c i e n t m e l o d i e s h e t u r n e d t o m e a s i f t o s a y h u r r y b o y i t s w a i t i n g t h e r e f o r y o u i t s g o n n a t a k e a l o t t o d r a g m e a w a y f r o m y o u t h e r e s n o t h i n g t h a t a h u n d r e d m e n o r m o r e c o u l d e v e r d o i b l e s s t h e r a i n s d o w n i n a f r i c a g o n n a t a k e s o m e t i m e t o d o t h e t h i n g s w e n e v e r h a d t h e w i l d d o g s c r y o u t i n t h e n i g h t a s t h e y g r o w r e s t l e s s l o n g i n g f o r s o m e s o l i t a r y c o m p a n y i k n o w t h a t i m u s t d o w h a t s r i g h t a s s u r e a s k i l i m a n j a r o r i s e s l i k e o l y m p u s a b o v e t h e s e r e n g e t i i s e e k t o c u r e w h a t s d e e p i n s i d e f r i g h t e n e d o f t h i s t h i n g t h a t i v e b e c o m e i t s g o n n a t a k e a l o t t o d r a g m e a w a y f r o m y o u t h e r e s n o t h i n g t h a t a h u n d r e d m e n o r m o r e c o u l d e v e r d o i b l e s s t h e r a i n s d o w n i n a f r i c a g o n n a t a k e s o m e t i m e t o d o t h e t h i n g s w e n e v e r h a d h u r r y b o y s h e s w a i t i n g t h e r e f o r y o u i t s g o n n a t a k e a l o t t o d r a g m e a w a y f r o m y o u t h e r e s n o t h i n g t h a t a h u n d r e d m e n o r m o r e c o u l d e v e r d o i b l e s s t h e r a i n s d o w n i n a f r i c a i b l e s s t h e r a i n s d o w n i n a f r i c a i b l e s s t h e r a i n s d o w n i n a f r i c a i b l e s s t h e r a i n s d o w n i n a f r i c a i b l e s s t h e r a i n s d o w n i n a f r i c a g o n n a t a k e s o m e t i m e t o d o t h e t h i n g s w e n e v e r h a d




#Main function
def main():

    filename = 'cipherText.txt'  # Replace with the actual filename

    # Read file
    ciphertext = readIn(filename)

    print("For the TA's -> to get the plaintext its 5 and lqlgt (translates to idina)\n")

    # trigram analysis on ciphertext
    trigramAnalysis(ciphertext)

    keyLength = int(input("\nWhat do you think the key length is?: "))
    #Split the ciphertext
    ciphers = splitIntoXCiphers(keyLength, ciphertext)

    alphabet = 'abcdefghijklmnopqrstuvwxyz'
    # Store decryption keys
    key = []

    # Loop through characters that could be in keyword
    for i in range(keyLength):
        char = input(f"\nEnter character {i} (likely to be in the keyword): ")
        key.append(shiftChars(char, alphabet, ciphers)[0])
    # key found
    #input = lqlgt
    #potential_key = ["i", "d", "i", "n", "a"]

    #print(f"\nPotential Key: {''.join(potential_key)}")

    print(f"/////////  Plaintext using the key: {''.join(key)} /////////\n")

    # Decrypt the ciphertext using the potential key
    decryptText = ''
    keyLength = len(key)
    
    for i in range(len(ciphertext)):
        char = ciphertext[i]
        if char.isalpha():
            index = ord(char.lower()) - ord(key[i % keyLength])
            if index < 0:
                index += 26
            decryptChar = chr(index + ord('a'))
            decryptText += decryptChar
        else:
            decryptText += char

    print(decryptText)

    #print(potentialKeys)


if __name__=="__main__":
   main()
