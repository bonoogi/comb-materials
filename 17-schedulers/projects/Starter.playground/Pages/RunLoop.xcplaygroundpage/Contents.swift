import Combine
import SwiftUI
import PlaygroundSupport

var threadRecorder: ThreadRecorder? = nil

let source = Timer
  .publish(every: 1.0, on: .main, in: .common)
  .autoconnect()
  .scan(0) { (counter, _) in counter + 1 }

// ThreadRecorderView에서 클로져를 실행하기 떄문에 런루프의 currnet는 UI, 즉 메인 스레드가 된다.
let setupPublisher = { recorder in
    source
        .receive(on: DispatchQueue.global())
        .recordThread(using: recorder)
        .receive(on: RunLoop.current)
        .recordThread(using: recorder)
        .handleEvents(
            receiveSubscription: { _ in
                threadRecorder = recorder
            }
        )
        .eraseToAnyPublisher()
}

let view = ThreadRecorderView(title: "Using RunLoop", setup: setupPublisher)
PlaygroundPage.current.liveView = UIHostingController(rootView: view)

RunLoop.current.schedule(
    after: .init(Date(timeIntervalSinceNow: 4.5)),
    tolerance: .milliseconds(500)) {
        threadRecorder?.subscription?.cancel()
    }
