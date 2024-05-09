import random

# Generates a winning lottery number for today and tomorrow
def generateLottery(dateOfGeneration, timeInSeconds):
    # timeInSeconds = [0, 1, ..., 86400]
    # dateOfGeneration = MM/DD/YYYY
    lotteryNumbers = []

    # Add the date and the seconds to get the seed
    random.seed(int(dateOfGeneration.replace("/", "")) + timeInSeconds)

    # Generate lottery number for the current day
    randomNumbers = []
    for i in range(10):
        randomNumbers.append(str(random.randrange(0, 10)))
    lotteryNumbers.append('-'.join(randomNumbers))

    # Generate lottery number for the next day
    randomNumbers = []
    for i in range(10):
        randomNumbers.append(str(random.randrange(0, 10)))
    lotteryNumbers.append('-'.join(randomNumbers))


    #Return an array of two values
    #lotteryNumbers[0] = Today's lottery number
    # lotteryNumbers[1] = Tomorrow's lottery number

    return lotteryNumbers

def findTime(dateOfGeneration, winningNumber):
    for timeInSeconds in range(86400):
        lotteryNumbers = generateLottery(dateOfGeneration, timeInSeconds)
        if lotteryNumbers[0] == winningNumber:
            return timeInSeconds
    return None

def main():

    winningNumber = "5-4-3-1-2-9-1-4-2-5"
    #winningNumber = "7-8-9-9-3-6-8-3-5-8"
    dateOfGeneration = "11/11/2023"

    timeInSeconds = findTime(dateOfGeneration, winningNumber)

    if timeInSeconds is not None:
        print(f"Found matching timeInSeconds: {timeInSeconds}")
        
        # Calculate for the next day (even day)
        timeInSeconds += 86400
        numbers = generateLottery(dateOfGeneration, timeInSeconds)
        print("Winning Lottery Ticket for November 12th, 2023:", numbers[0])
        
    else:
        print("Matching timeInSeconds not found.")

if __name__ == '__main__':
    main()
