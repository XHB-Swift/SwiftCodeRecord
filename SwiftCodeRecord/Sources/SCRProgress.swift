//
//  SCRProgress.swift
//  SwiftCodeRecord
//
//  Created by xiehongbiao on 2020/10/26.
//

import UIKit
import SwiftUI
import Combine

extension CGFloat {
    
    var isBetween0_1: Bool {
        return self <= 1 && self >= 0
    }
}

public protocol SCRProgressConfig {
    
    var trackTintColor: UIColor { get set }
    var progressTintColor: UIColor { get set }
    var progressValue: CGFloat { get set }
    var progressFrame: CGRect { get set }
    var progressShape: UIBezierPath { get }
    
}

public class SCRProgressView: UIView {
    
    private var progressLayer: CAShapeLayer?
    private var bottomLayer: CAShapeLayer?
    
    public enum SCRProgressMaskState {
        case none
        case mask
        case bottom
    }
    
    public var maskState = SCRProgressMaskState.none {
        didSet  {
            switch maskState {
            case .none:
                bottomLayer?.removeFromSuperlayer()
                self.layer.mask = nil
            case .mask:
                bottomLayer?.removeFromSuperlayer()
                self.layer.mask = bottomLayer
            case .bottom:
                self.layer.mask = nil
                self.layer.insertSublayer(bottomLayer!, at: 0)
            }
        }
    }
    
    public init(state: SCRProgressView.SCRProgressMaskState) {
        super.init(frame: .zero)
        setupLayers()
        self.maskState = state
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayers() {
        bottomLayer = CAShapeLayer()
        progressLayer = CAShapeLayer()
        self.layer.addSublayer(progressLayer!)
    }
    
    public func setProgressConfig(_ config: SCRProgressConfig) {
        if progressLayer?.frame == .zero {
            progressLayer?.frame = self.bounds
        }
        if bottomLayer != nil && bottomLayer?.frame == .zero {
            bottomLayer?.frame = self.bounds
        }
        if maskState != .none {
            if config.progressValue == 0 && bottomLayer?.path == nil {
                bottomLayer?.path = config.progressShape.cgPath
            }
        }
        progressLayer?.fillColor = config.trackTintColor.cgColor
        bottomLayer?.fillColor = config.progressTintColor.cgColor
        progressLayer?.path = config.progressShape.cgPath
        self.backgroundColor = config.progressTintColor
    }
}

struct SCRSView<V: UIView>: UIViewRepresentable {
    
    typealias UIViewType = V
    
    var makeView: () -> V
    var updater: (V, Context) -> Void
    
    init(_ makeView: @escaping @autoclosure () -> V,
         _ updater: @escaping (V, Context) -> Void) {
        self.makeView = makeView
        self.updater = updater
    }
    
    init(_ makeView: @escaping @autoclosure () -> V,
         _ updater: @escaping (V) -> Void) {
        self.makeView = makeView
        self.updater = { view , _ in updater(view) }
    }
    
    init(_ makeView: @escaping @autoclosure () -> V) {
        self.makeView = makeView
        self.updater = { _, _ in }
    }
    
    func makeUIView(context: Context) -> V {
        return self.makeView()
    }
    
    func updateUIView(_ uiView: V, context: Context) {
        self.updater(uiView, context)
    }
}
