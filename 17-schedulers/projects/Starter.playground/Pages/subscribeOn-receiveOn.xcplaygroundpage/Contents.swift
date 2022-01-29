import Foundation
import Combine

let computationPublisher = Publishers.ExpensiveComputation(duration: 3)

let queue = DispatchQueue(label: "serial queue")
let mapQueue = DispatchQueue(label: "map queue")

let currentThread = Thread.current.number
print("Start computation publisher on thread \(currentThread)")

let subscription = computationPublisher
    .subscribe(on: queue)
    .receive(on: mapQueue)
    .map { value -> String in
        let thread = Thread.current.number
        print("Map on thread \(thread): \(value)")
        return "\(value) HAHA!"
    }
    .receive(on: DispatchQueue.main)
    .sink { value in
        let thread = Thread.current.number
        print("Received computation result on thread \(thread): \(value)")
    }
