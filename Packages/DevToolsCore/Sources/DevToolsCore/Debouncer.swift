//
//  Debouncer.swift
//  
//
//  Created by Гавриил Михайлов on 10.04.2022.
//

import Foundation

public final class Debouncer {

    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?
    private weak var queue: DispatchQueue?

    public init(queue: DispatchQueue, delay: TimeInterval = 0.5) {
        self.queue = queue
        self.delay = delay
    }

    public func run(action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        if let workItem = workItem {
            queue?.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }

    public func cancel() {
        workItem?.cancel()
    }
}
