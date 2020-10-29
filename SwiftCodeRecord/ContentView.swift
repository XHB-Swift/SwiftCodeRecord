//
//  ContentView.swift
//  SwiftCodeRecord
//
//  Created by xiehongbiao on 2020/10/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var barConfig = SCRProgressBarConfig(trackTintColor: .orange, progressTintColor: .white)
    @State private var circleConfig = SCRProgressCircleConfig(trackTintColor: .orange, progressTintColor: .white)
    @State private var sectorConfig = SCRProgressSectorConfig(trackTintColor: .orange, progressTintColor: .white)
    
    var body: some View {
        VStack {
            SCRProgressViewRepresentable(progressConfig: barConfig, progressViewType: .none)
                .frame(width: 100,
                       height: 100,
                       alignment: .center)
            Text("调整进度")
            Slider(value: $barConfig.progressValue, in: 0...1)
                .frame(width: 150, height: 10, alignment: .center)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

public class SCRProgressBarConfig: SCRProgressConfig {
    public var trackTintColor: UIColor
    public var progressTintColor: UIColor
    public var progressValue: CGFloat = 0
    public var progressFrame: CGRect = .zero
    public var progressShape: UIBezierPath {
        let frame = CGRect(x: 0, y: 0, width: progressFrame.width * progressValue, height: progressFrame.height)
        return UIBezierPath(roundedRect: frame, cornerRadius: frame.height/2)
    }
    
    init(trackTintColor: UIColor, progressTintColor: UIColor) {
        self.trackTintColor = trackTintColor
        self.progressTintColor = progressTintColor
    }
}

public class SCRProgressCircleConfig: SCRProgressConfig {
    public var trackTintColor: UIColor
    public var progressTintColor: UIColor
    public var progressValue: CGFloat = 0
    public var progressFrame: CGRect = .zero
    public var progressShape: UIBezierPath {
        let origin = CGPoint(x: progressFrame.width/2, y: progressFrame.height/2)
        let radius = progressFrame.width/2
        let reset0 = (progressValue == 0)
        let startAngle = reset0  ? 0 : CGFloat(-Double.pi/2)
        let endAngle = reset0 ? (CGFloat(Double.pi * 2)) : (startAngle + progressValue * CGFloat(Double.pi/2))
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
