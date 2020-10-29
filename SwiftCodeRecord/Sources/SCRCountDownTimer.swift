//
//  SCRCountDownView.swift
//  SwiftCodeRecord
//
//  Created by xiehongbiao on 2020/10/26.
//

import UIKit

protocol SCRCountDownTimerDelegate {
    func timerDidCountdown(_ number: Int)
}

class SCRCountDownTimer {
    
    private var timer: DispatchSourceTimer
    public var totalCount: Int
    public var runningCount: Int
    public var delegate: SCRCountDownTimerDelegate?
    
    init(totalCount: Int) {
        self.totalCount = totalCount
        self.runningCount = totalCount
        let timerQueue = DispatchQueue(label: "org.timer.queue")
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: timerQueue)
        self.setupGCDTimer()
    }
    
    public func reset() {
        self.runningCount = self.totalCount
    }
    
    public func start() {
        self.timer.resume()
    }
    
    public func stop() {
        self.timer.suspend()
    }
    
    private func setupGCDTimer() {
        self.timer.schedule(deadline: .now(), repeating: 1, leeway: .milliseconds(0))
        self.timer.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                self?.decreaseIfNeeded()
            }
        }
    }
    
    private func decreaseIfNeeded() {
        if self.runningCount > 0 {
            self.runningCount -= 1
            self.delegate?.timerDidCountdown(self.runningCount)
        }else {
            self.stop()
        }
    }
}
