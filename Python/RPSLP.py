from random import randint
import time
import sys

beats = [2,21,10,4,43,32,25,41,13,30]
defeat_speech = {2:"Rock crushes scissors",4:"Rock crushes lizard",10:"Paper covers rock",13:"Paper disproves spock",
                 21:"Scissors cuts paper",25:"Scissors decapitate lizard",30:"Spock vaporizes rock",
                 32:"Spock smashed scissors",41:"Lizard eats paper",43:"Lizard poisons spock"}
options = ["rock","paper","scissors","spock","lizard"]
plays = [0,0,0,0,0]
user_wins = 0
comp_wins = 0
draws = 0
exit = False
rounds_played = 0

def calculatedComp():
    
    #find what the player plays most frequently
    most_common = 0
    commons = []
    for i in range(len(plays)):
        if(plays[i]>most_common):
            most_common = plays[i]
            commons = []
            commons.append(i)
        elif(plays[i]==most_common):
            commons.append(i)

    #find moves that will win against them
    winning_choices = []
    for i in range(len(commons)): #for all most common user options
        for j in range(len(beats)): #for 'x beats y' combinations
            if(beats[j]<10): #if single digit
                if(commons[i]==beats[j]):
                    winning_choices.append(0)
            else: #if double digit
                if(commons[i] == int(str(beats[j])[1])):
                    winning_choices.append(int(str(beats[j])[0]))

    #remove potential ties
    for i in range(len(commons)):
        winning_choices_num = len(winning_choices)
        j = 0
        while(j<winning_choices_num):
            if(commons[i]==winning_choices[j]):
                winning_choices.remove(winning_choices[j])
                winning_choices_num = winning_choices_num - 1
            j = j + 1

    if(len(winning_choices)>0):
        return winning_choices[randint(0,len(winning_choices)-1)]
    else:
        return randint(0,4)

def run(comp_move):
    #input
    comp_num = comp_move
    
    print("*****")
    print("type exit to exit")
    user_plays = input("Player Picks: ").lower()
    if(user_plays=="exit"):
        return 0
    print("Computer Picks: "+options[comp_num])
    print()

    #conversion to numerical representation of moves, using array 'options'
    user_num = -1
    for i in range(0,5):
        if(user_plays==options[i]):
            user_num = i
    plays[user_num] = plays[user_num] + 1

    #error checking
    if(user_num==-1):
        print("That's not right! You've ruined the game!")
        print("We need to restart now!")
        return 0

    #find winner
    beatsValue_userFirst = int(str(user_num)+str(comp_num))
    beatsValue_compFirst = int(str(comp_num)+str(user_num))
    user_won = False
    comp_won = False
    for i in range(len(beats)):
        if(beats[i]==beatsValue_userFirst):
            user_won=True
        if(beats[i]==beatsValue_compFirst):
            comp_won=True

    #output
    ouput_message = ""
    for i,v in enumerate(defeat_speech):
        if(v==beatsValue_userFirst or v==beatsValue_compFirst):
            output_message = defeat_speech[v]
    if(user_won):
        print(output_message + ". You Win!")
        global user_wins
        user_wins = user_wins + 1
        return 1
    elif(comp_won):
        print(output_message+". Computer Wins!")
        global comp_wins
        comp_wins = comp_wins + 1
        return 2
    else:
        print("Draw!")
        global draws
        draws = draws + 1
        return 3   

#main loop
while(not exit):
    if(rounds_played<5):
        comp_move = randint(0,4)
    else:
        comp_move = calculatedComp()
    game = run(comp_move)
    if(game==0):
        exit=True
    else:
        rounds_played = rounds_played + 1
        
print("")
print("You won "+str(user_wins)+" times which is "+str(round((user_wins/rounds_played)*100,2))+"%")
print("I won "+str(comp_wins)+" times which is "+str(round((comp_wins/rounds_played)*100,2))+"%")
print("We drew "+str(draws)+" times which is "+str(round((draws/rounds_played)*100,2))+"%")
