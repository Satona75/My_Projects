import random
print('ROCK, PAPER, SCISSORS')

wins = 0
losses = 0
ties = 0

while True:
    print('Enter your move: (r)ock (p)aper (s)cissors or (q)uit')
    response = input()
    lower_response = response.lower()

    if lower_response == 'q':
        break

    if lower_response == 'r':
        player1 = 'ROCK'
        print('ROCK versus...')
    elif lower_response == 'p':
        player1 = 'PAPER'
        print('PAPER versus...')
    elif lower_response == 's':
        player1 = 'SCISSORS'
        print('SCISSORS versus...')

    gen = random.randint(0, 2)
    if gen == 0:
        game = 'ROCK'
        print('ROCK')
    elif gen == 1:
        game = 'PAPER'
        print('PAPER')
    elif gen == 2:
        game = 'SCISSORS'
        print('SCISSORS')

    if player1 == game:
        print('It is a tie!')
        ties = ties + 1
    elif (player1 == 'ROCK') and (game == 'PAPER'):
        print('You lose!')
        losses = losses + 1
    elif (player1 == 'ROCK') and (game == 'SCISSORS'):
        print('You win!')
        wins = wins + 1
    elif (player1 == 'PAPER') and (game == 'ROCK'):
        print('You win!')
        wins = wins + 1
    elif (player1 == 'PAPER') and (game == 'SCISSORS'):
        print('You lose!')
        losses = losses + 1
    elif (player1 == 'SCISSORS') and (game == 'PAPER'):
        print('You win!')
        wins = wins + 1
    elif (player1 == 'SCISSORS') and (game == 'ROCK'):
        print('You lose!')
        losses = losses + 1
    print(str(wins) + ' wins, ' + str(losses) + ' losses, ' + str(ties) + ' ties, ')




