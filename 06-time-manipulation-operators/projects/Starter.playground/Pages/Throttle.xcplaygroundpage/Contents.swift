import Combine
import SwiftUI
import PlaygroundSupport

let throttleDelay = 1.0

let subject = PassthroughSubject<String, Never>()

let throttled = subject
    // latest를 false로 주었기 때문에 주어진 시간동안 받은중 가장 첫 값을 emit합니다.
    .throttle(for: .seconds(throttleDelay), scheduler: DispatchQueue.main, latest: true)
    .share()

let subjectTimeline = TimelineView(title: "Emitted values")
let throttledTimeline = TimelineView(title: "Throttled values")

let view = VStack(spacing: 100) {
    subjectTimeline
    throttledTimeline
}

PlaygroundPage.current.setLiveView(view.frame(width: 375, height: 600))

subject.displayEvents(in: subjectTimeline)
throttled.displayEvents(in: throttledTimeline)

let subscription1 = subject.sink { string in
    print("+\(deltaTime)s: Subject Emitted: \(string)")
}
let subecription2 = throttled.sink { string in
    print("+\(deltaTime)s: Throttle EMitted: \(string)")
}

subject.feed(with: typingHelloWorld)
