import Combine
import SwiftUI
import PlaygroundSupport

let 초당_값 = 1.0
let 수집_시간 = 4

let 소스_퍼블리셔 = PassthroughSubject<Date, Never>()
let 수집하는_퍼블리셔 = 소스_퍼블리셔
    .collect(
        .byTime(
            DispatchQueue.main,
            .seconds(수집_시간)
        )
    )
    .flatMap { dates in dates.publisher }

let 구독 = Timer
    .publish(every: 1.0 / 초당_값, on: RunLoop.main, in: .common)
    .autoconnect()
    .subscribe(소스_퍼블리셔)

let 소스_타임라인 = TimelineView(title: "Emitted values:")
let 수집_타임라인 = TimelineView(title: "Collected values (every \(수집_시간)s):")

//let view = VStack(spacing: 40) {
//    소스_타임라인
//    수집_타임라인
//}

//PlaygroundPage.current.liveView = UIHostingController(rootView: view.frame(width: 375, height: 600))

소스_퍼블리셔.displayEvents(in: 소스_타임라인)
수집하는_퍼블리셔.displayEvents(in: 수집_타임라인)

// -------

let 최대_수집_갯수 = 3

let 수집_퍼블리셔2 = 소스_퍼블리셔
    .collect(
        .byTimeOrCount(
            DispatchQueue.main,
            .seconds(수집_시간),
            최대_수집_갯수
        )
    )
    .flatMap { $0.publisher }

let 수집_타임라인2 = TimelineView(title: "Collected values (at most \(최대_수집_갯수) every \(수집_시간)s):")

let 뷰 = VStack(spacing: 40) {
    소스_타임라인
    수집_타임라인
    수집_타임라인2
}

PlaygroundPage.current.liveView = UIHostingController(rootView: 뷰.frame(width: 375, height: 600))

수집_퍼블리셔2.displayEvents(in: 수집_타임라인2)
