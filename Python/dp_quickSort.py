def quickSort(list):
    listLength = len(list)
    if listLength <= 1:
        return list
    elif listLength == 2:
        if list[0] < list[1]:
            return [list[0],list[1]]
        else:
            return [list[1],list[0]]
    else:
        pivot = list[0]
        list_S = []
        list_G = []
        for eachNum in range(1,listLength):
            if list[eachNum] < pivot:
                list_S.append(list[eachNum])
            else:
                list_G.append(list[eachNum])
        sorted_S = quickSort(list_S)
        sorted_G = quickSort(list_G)
        result = sorted_S + [pivot] + sorted_G
        return result

initialList = []
numOfElements = int(input("Enter the number of elements that you wish to sort: "))
for i in range(0,numOfElements):
    initialList.append(float(input()))

list = quickSort(initialList)

for i in range(0,numOfElements):
    print(list[i])
