import Combine
import SwiftUI
import PlaygroundSupport

let subject = PassthroughSubject<String, Never>()

let debounced = subject
    // 1초동안 온 중에 제일 나중것
    .debounce(for: .seconds(1.0), scheduler: DispatchQueue.main)
    // debounced를 여러번 구독할 건데, 매 구독자가 동일한 결과를 받을 수 있음을 보장받기 위한 처리
    // 13챕터 Resource Management에서 더 자세하게 배울 것.
    .share()

let subjectTimeline = TimelineView(title: "Emitted Values")
let debouncedTimeline = TimelineView(title: "Debounced Values")

let view = VStack(spacing: 100) {
    subjectTimeline
    debouncedTimeline
}

PlaygroundPage.current
    .setLiveView(
        view.frame(width: 375, height: 600)
    )

subject.displayEvents(in: subjectTimeline)
debounced.displayEvents(in: debouncedTimeline)

let subscription1 = subject
    .sink { string in
        print("+\(deltaTime)s: Subject emitted: \(string)")
    }

let subscription2 = debounced
    .sink { string in
        print("+\(deltaTime)s: Debounced emitted: \(string)")
    }

subject.feed(with: typingHelloWorld)

DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
    subject.send(completion: .finished)
}
