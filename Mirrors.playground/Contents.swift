
protocol DogBreed {
    typealias Level = Int
    
    var breedName: String { get set }
    var size: Level { get set }
    var health: Level { get set }
    var adaptability: Level { get set }
    var intelligence: Level { get set }
    var dogType: DogType { get set }
}

enum DogType: String {
    case companion = "companion"
    case sled = "sled dog"
}

class SiberianHusky: DogBreed {
    var breedName: String
    var size: Level
    var health: Level
    var adaptability: Level
    var intelligence: Level
    var dogType: DogType
    
    init() {
        self.breedName = "Husky"
        self.size = 3
        self.health = 4
        self.adaptability = 3
        self.intelligence = 3
        self.dogType = .sled
    }
}

let husky = SiberianHusky()
let huskyMirror = Mirror(reflecting: husky)

for case let (label?, value) in huskyMirror.children {
    print(label, value)
}

//prints:
//breedName Husky
//size 3
//health 4
//adaptability 3
//intelligence 3
//dogType sled


class Pomsky: SiberianHusky {
    override init() {
        super.init()
        self.breedName = "Pomsky"
        self.size = 2
        self.dogType = .companion
    }
}

extension Pomsky: CustomReflectable {
    var customMirror: Mirror {
        return Mirror(Pomsky.self, children: ["name": self.breedName , "size": self.size, "type" : self.dogType], displayStyle: .class, ancestorRepresentation: .generated)
    }
}

let pomsky = Pomsky()
let pomskyMirror = Mirror(reflecting: pomsky)
for case let (label?, value) in pomskyMirror.children {
    print(label, value)
}

//prints
//name Pomsky
//size 2
//type companion

pomskyMirror.displayStyle

class DogOwner {
    var name: String
    var dog: DogBreed
    
    init(name: String, dog: DogBreed) {
        self.name = name
        self.dog = dog
    }
}

let owner = DogOwner(name: "Pete", dog: husky)
let ownerMirror = Mirror(reflecting: owner)
print ("Pete owns a \(ownerMirror.descendant("dog", "breedName") ?? "some dog")")

//prints
//Pete owns a Husky

let children = ownerMirror.children
for child in children {
    if child.label == "dog" {
        let grandChildren = Mirror(reflecting: child.value).children
        Mirror(reflecting: child.value).children
        for grand in grandChildren {
            if grand.label == "breedName" {
                print("Pete owns a \(grand.value)")
            }
        }
    }
}

//prints
//Pete owns a Husky



