var data: Bool[] = []
data.append(false)
let iterations = 6

func printData() {
    for eachBool in data {
        if eachBool {
            print("1")
        } else {
            print("0")
        }
    }
    println()
}

for i in 0..iterations {
    var newSet: Bool[] = []
    for eachBool in data {
        newSet.append(!eachBool)
    }
    for eachBool in newSet {
        data.append(eachBool)
    }
    printData()
    println()
}