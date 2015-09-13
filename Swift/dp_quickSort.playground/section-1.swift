import Foundation

/*func input(text:String) -> String {
    print(text)
    var keyboard = NSFileHandle.fileHandleWithStandardInput()
    var inputData = keyboard.availableData
    return NSString(data: inputData, encoding:NSUTF8StringEncoding)
}*/

func quickSort(list: [Float]) -> [Float] {
    let listLength = count(list)
    if listLength <= 1 {
        return list
    } else if listLength == 2 {
        //swap if necessary
        if list[0] < list[1] {
            return [list[0],list[1]]
        } else {
            return [list[1],list[0]]
        }
    } else { //listLength >= 3
        //recursive call
        let pivot = list[0]
        var list_S: [Float] = []
        var list_G: [Float] = []
        for(var eachNum = 0; eachNum < listLength; ++eachNum) {
            if list[eachNum] < pivot {
                list_S.append(list[eachNum])
            } else {
                list_G.append(list[eachNum])
            }
        }
        let sorted_S = quickSort(list_S)
        let sorted_G = quickSort(list_G)
        let result = sorted_S + [pivot] + sorted_G
        return result
    }
}

let initialList:[Float] = [3.0,2.0,1.0,12.3,-2.4]
let sortedList = quickSort(initialList)
