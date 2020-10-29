//
//  ContentView.swift
//  SwiftCodeRecord
//
//  Created by xiehongbiao on 2020/10/26.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var barConfig = SCRProgressBarConfig(trackTintColor: .orange, progressTintColor: .white)
    @ObservedObject private var circleConfig = SCRProgressCircleConfig(trackTintColor: .orange, progressTintColor: .white)
    @ObservedObject private var sectorConfig = SCRProgressSectorConfig(trackTintColor: .orange, progressTintColor: .white)
    
    var body: some View {
        VStack {
            SCRSView(SCRProgressView(state: .bottom)) { (view) in
                circleConfig.progressFrame = view.bounds
                view.setProgressConfig(circleConfig)
            }.frame(width: 200, height: 200, alignment: .center)
            Spacer().frame(width: 0, height: 20, alignment: .center)
            Text("调整进度: \(Int(circleConfig.progressValue * 100))%")
            Spacer().frame(width: 0, height: 20, alignment: .center)
            Slider(value: $circleConfig.progressValue, in: 0...1)
                .frame(width: 250, height: 10, alignment: .center)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

public class SCRProgressBarConfig: SCRProgressConfig, ObservableObject {
    public var trackTintColor: UIColor
    public var progressTintColor: UIColor
    @Published public var progressValue: CGFloat = 0
    public var progressFrame: CGRect = .zero
    public var progressShape: UIBezierPath {
        let frame = CGRect(x: 0, y: 0, width: progressFrame.width * progressValue, height: progressFrame.height)
        let barPath = UIBezierPath()
        barPath.move(to: CGPoint(x: 0, y: frame.height))
        barPath.addLine(to: CGPoint(x: frame.width, y: frame.height))
        barPath.addLine(to: CGPoint(x: frame.width, y: frame.height-5))
        barPath.addLine(to: CGPoint(x: 0, y: frame.height-5))
        barPath.close()
        return barPath
    }
    
    init(trackTintColor: UIColor, progressTintColor: UIColor) {
        self.trackTintColor = trackTintColor
        self.progressTintColor = progressTintColor
    }
}

public class SCRProgressCircleConfig: SCRProgressConfig, ObservableObject {
    public var trackTintColor: UIColor
    public var progressTintColor: UIColor
    @Published public var progressValue: CGFloat = 0
    public var progressFrame: CGRect = .zero
    public var progressShape: UIBezierPath {
        let origin = CGPoint(x: progressFrame.width/2, y: progressFrame.height/2)
        let radius = progressFrame.width/2
        let reset0 = (progressValue == 0)
        let startAngle = reset0  ? 0 : -CGFloat.pi/2
        let endAngle = (startAngle + progressValue * CGFloat.pi * 2)
        let path = UIBezierPath(arcCenter: origin, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        return path
    }
    
    init(trackTintColor: UIColor, progressTintColor: UIColor, progressValue: CGFloat = 0, progressFrame: CGRect = .zero) {
        self.trackTintColor = trackTintColor
        self.progressTintColor = progressTintColor
    }
}


public class SCRProgressSectorConfig: SCRProgressCircleConfig {
    public override var progressShape: UIBezierPath {
        let origin = CGPoint(x: progressFrame.width/2, y: progressFrame.height/2)
        let path = super.progressShape
        path.addLine(to: origin)
        return path
    }
}
