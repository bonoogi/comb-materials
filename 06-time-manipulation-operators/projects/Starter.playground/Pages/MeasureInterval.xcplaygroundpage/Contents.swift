import Combine
import SwiftUI
import PlaygroundSupport

let subject = PassthroughSubject<String, Never>()

let measureSubject = subject.measureInterval(using: DispatchQueue.main)

let measureSubject2 = subject.measureInterval(using: RunLoop.main)

let subjectTimeline = TimelineView(title: "Emitted Values")
let measureTimeline = TimelineView(title: "Measured Values")

let view = VStack(spacing: 100) {
    subjectTimeline
    measureTimeline
}

PlaygroundPage.current.setLiveView(view.frame(width: 375, height: 600))

subject.displayEvents(in: subjectTimeline)
measureSubject.displayEvents(in: measureTimeline)

let subscription1 = subject.sink {
    print("+\(deltaTime)s: Subject emitted: \($0)")
}

let subscription2 = measureSubject.sink {
    print("+\(deltaTime)s: Measure emitted: \(Double($0.magnitude) / 1_000_000_000.0)")
}

let subecription3 = measureSubject2.sink {
    print("+\(deltaTime)s: Measure emitted: \($0)")
}

subject.feed(with: typingHelloWorld)
