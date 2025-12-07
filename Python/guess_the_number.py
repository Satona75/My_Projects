import random
secretNumber = random.randint(1, 20)

print('I am thinking of a number between 1 and 20.')
for numOfGuesses in range (0,6):
    print('Take a guess.')
    yourGuess = int(input())

    if yourGuess < secretNumber:
        print('Your guess is too low')
    elif yourGuess > secretNumber:
        print('Your guess is too high')
    else:
        break
if yourGuess == secretNumber:
    print('Good job! You guessed my number in ' + str(numOfGuesses) + ' guesses!')
else:
    print('Never mind! Better luck next time. The secret number was ' + str(numOfGuesses))

