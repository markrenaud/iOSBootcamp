//
//  ZoomableView.swift
//  Created by Mark Renaud (2024).
//
    
import SwiftUI

struct ZoomableView<Content: View>: UIViewRepresentable {
    private let zoomableScrollView: ZoomableUIScrollView
    
    init(content: Content) {
        // Wrap our SwiftUI content in a UIKit UIView
        let uiView = UIHostingController(rootView: content).view ?? UIView()
        self.zoomableScrollView = ZoomableUIScrollView(content: uiView)
    }
        
    func makeUIView(context: Context) -> ZoomableUIScrollView {
        return zoomableScrollView
    }
    
    func updateUIView(_ uiView: ZoomableUIScrollView, context: Context) {
        // No updates required for the UIView
    }
}

class ZoomableUIScrollView: UIScrollView {
    private let content: UIView
    private let unscaledContentSize: CGSize
    private var firstLayout: Bool = true

    // MARK: - Setup
    
    init(content: UIView) {
        // Ensure that the content has a size even if it hasn't been laid out
        // yet by calling sizeToFit
        content.sizeToFit()
        self.content = content
        self.unscaledContentSize = content.frame.size
        
        // Initializes with .zero frame - layout will be managed by SwiftUI
        super.init(frame: .zero)

        // Additional scroll view set up
        prepareScrollView()
        prepareDoubleTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Calculate and set the minimum and maximum zoom scales for the content
    func calculateZoomLimits() {
        minimumZoomScale = min(scaleThatFits, 1.0)
        maximumZoomScale = max(scaleThatFits, 1.0)
    }
    
    /// Configure the scroll view properties and add the content view
    func prepareScrollView() {
        // configure content
        contentSize = content.frame.size
        addSubview(content)

        // set delegate to self
        // needed to implement `viewForZooming(in:)`
        delegate = self
    }
    
    /// Set up a double tap gesture recognizer to handle zooming and add to scroll view
    func prepareDoubleTap() {
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        addGestureRecognizer(doubleTapRecognizer)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Recalibrates zoom limits in case the scroll view frame has changed
        calculateZoomLimits()

        // Automatically scales to size that fits on the first layout pass
        if firstLayout {
            zoomScale = scaleThatFits
            firstLayout = false
        }

        // Ensures that the content is always centered in the scroll view
        recenter()
    }
    
    /// Calculates the scale that fits the content within the scroll view's frame
    var scaleThatFits: CGFloat {
        print(content.frame.size, contentSize)
        let contentAspectRatio = unscaledContentSize.width / unscaledContentSize.height
        let scrollViewAspectRatio = frame.width / frame.height
        
        if contentAspectRatio > scrollViewAspectRatio {
            // Scales so the width fits inside the frame
            return frame.width / unscaledContentSize.width
        } else {
            // Scales so the height fits inside the frame
            return frame.height / unscaledContentSize.height
        }
    }
    
    // MARK: - Gesture Responders
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // Adjusts zoom to fit inside the UIScrollView when double-tapped
        UIView.animate(withDuration: 0.5) {
            // if at minimum zoom scale, zoom to max
            // otherwise always zoom to min scale
            if self.zoomScale == self.minimumZoomScale {
                self.zoomScale = self.maximumZoomScale
            } else {
                self.zoomScale = self.scaleThatFits
            }
            self.recenter()
        }
    }

    // Recenters the content within the scroll view
    func recenter() {
        // Centers horizontally
        if content.frame.width < bounds.width {
            content.frame.origin.x = (bounds.width - content.frame.width) / 2
        } else {
            content.frame.origin.x = 0.0
        }
        
        // Centers vertically
        if content.frame.height < bounds.height {
            content.frame.origin.y = (bounds.height - content.frame.height) / 2
        } else {
            content.frame.origin.y = 0.0
        }
    }
}

// Extension to conform to UIScrollViewDelegate and provide the view for zooming
extension ZoomableUIScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return content
    }
}

#Preview {
    let sampleView = UIImageView(image: UIImage(named: "dachshund"))
    let image = Image("dachshund")
    return ZoomableView(content: image)
        .ignoresSafeArea(.all)
}
