import Combine
import Foundation

// A subject you get values from
let subject = PassthroughSubject<Int, Never>()

let solution = subject
    .collect(.byTime(RunLoop.main, .seconds(0.5)))
// 이상하게 DispatchQueue로 돌리면 is가 아니고 i\ns 가 됨
//    .collect(.byTime(DispatchQueue.main, .seconds(0.5)))
    .map {
        String($0.map { Character(Unicode.Scalar($0)!)})
    }

let clap = subject
    .debounce(for: .seconds(0.9), scheduler: DispatchQueue.main)
    .map { _ in "👏" }

// Let's roll!
startFeeding(subject: subject)

let subecription = subject.sink { _ in }

let subscription1 = Publishers.Merge(solution, clap).sink {
    print($0)
}
