import math

output = ""

def findFactors(input):
    for i in range(2,input):
        if(input%i==0):
            returned = i,int(input/i)
            global output
            output = output + str(returned[0]) + "," + str(returned[1]) + ","
            findFactors(returned[0])
            findFactors(returned[1])
            break

number = int(input("Whats the number? "))
findFactors(number)
print(output)

