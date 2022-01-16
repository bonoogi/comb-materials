import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "output(in:)") {
    let publisher = ["A", "B", "C", "D", "E"].publisher
    publisher
        .print("publisher")
        .output(in: 1...3)
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print("Value in range: \($0)") })
        .store(in: &subscriptions)
}

example(of: "reduce") {
    let publisher = ["HEL", "LO", " ", "WORL", "D"].publisher
    publisher.print("Publisher")
        .reduce("", +)
        .sink { print("Reduced into: \($0)") }
        .store(in: &subscriptions)
}
