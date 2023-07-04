//
//  DynamicBackgroundView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/1/23.
//

import SwiftUI

import SwiftUI

struct DynamicBackgroundView: View {
    private enum AnimationProperties {
        static let animationSpeed: Double = 4
        static let timerDuration: TimeInterval = 5
        static let blurRadius: CGFloat = 130
    }
    private func animateCircles() {
        withAnimation(.easeInOut(duration: AnimationProperties.animationSpeed)) {
            animator.animate()
        }
    }
    
    @State private var timer = Timer.publish(
        every: AnimationProperties.timerDuration,
        on: .main,
        in: .common).autoconnect()
    
    @ObservedObject private var animator = CircleAnimator(colors: GradientColors.all)
    
    
    
    var body: some View {
        VStack {
           
            ZStack {
               
                ForEach(animator.circles) { circle in
                    MovingCircle(originOffset: circle.position)
                            .foregroundColor(circle.color)
                }
            }
            .blur(radius: AnimationProperties.blurRadius)
            
            
            
            .background(GradientColors.backgroundColor)
            .onDisappear {
                timer.upstream.connect().cancel()
            }
            .onAppear {
                animateCircles()
                timer = Timer.publish(every: AnimationProperties.timerDuration, on: .main, in: .common).autoconnect()
            }
            .onReceive(timer) { _ in
                animateCircles()
            }
        }
        .ignoresSafeArea(.all)
        
       
    }
    
    private enum GradientColors {
        static var all: [Color] {
            [
                Color(#colorLiteral(red: 0.003799867816, green: 0.01174801588, blue: 0.07808648795, alpha: 1)),
                Color(#colorLiteral(red: 0.147772789, green: 0.08009552211, blue: 0.3809506595, alpha: 1)),
                Color(#colorLiteral(red: 0.5622407794, green: 0.4161503613, blue: 0.9545945525, alpha: 1)),
                Color(#colorLiteral(red: 0.7909697294, green: 0.7202591896, blue: 0.9798423648, alpha: 1)),
                Color(#colorLiteral(red: 0.7909697294, green: 0.7202591896, blue: 0.9798423648, alpha: 1)),
            ]
        }
        
        static var backgroundColor: Color {
            Color(#colorLiteral(
                red: 0.003799867816,
                green: 0.01174801588,
                blue: 0.07808648795,
                alpha: 1)
            )
        }
    }
    
    private struct MovingCircle: Shape {
        
        var originOffset: CGPoint
        
        var animatableData: CGPoint.AnimatableData {
            get {
                originOffset.animatableData
            }
            set {
                originOffset.animatableData = newValue
            }
        }
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            let adjustedX = rect.width * originOffset.x
            let adjustedY = rect.height * originOffset.y
            let smallestDimension = min(rect.width, rect.height)
            path.addArc(center: CGPoint(x: adjustedX, y: adjustedY), radius: smallestDimension/2, startAngle: .zero, endAngle: .degrees(360), clockwise: true)
            return path
        }
    }
    
    private class CircleAnimator: ObservableObject {
        class Circle: Identifiable {
            internal init(position: CGPoint, color: Color) {
                self.position = position
                self.color = color
            }
            var position: CGPoint
            let id = UUID().uuidString
            let color: Color
        }
        
        @Published private(set) var circles: [Circle] = []
        
        
        init(colors: [Color]) {
            circles = colors.map({ color in
                Circle(position: CircleAnimator.generateRandomPosition(), color: color)
            })
        }
        
        func animate() {
            objectWillChange.send()
            for circle in circles {
                circle.position = CircleAnimator.generateRandomPosition()
            }
        }
        
        static func generateRandomPosition() -> CGPoint {
            CGPoint(x: CGFloat.random(in: 0 ... 1), y: CGFloat.random(in: 0 ... 1))
        }
    }
}


struct DynamicBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicBackgroundView()
    }
}
