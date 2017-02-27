//
//  TanouraViewController.swift
//  Tanoura
//
//  Created by NSMohamedElalfy on 12/3/16.
//  Copyright © 2016 NSMohamedElalfy. All rights reserved.
//

import UIKit
import CoreImage
import GLKit


public protocol TanouraViewControllerDelegate : class {
  
  func touchDidBegin(flag:Bool)
  func rendered(image:CIImage)
}

class TanouraViewController: UIViewController {
  
  open var rotateSpeed : CGFloat = -0.25
  open var radiusValue : CGFloat = 15
  
  open weak var delegate : TanouraViewControllerDelegate?
  
  fileprivate var imageAccumulator: CIImageAccumulator!
  fileprivate var sideLength: CGFloat!
  fileprivate var hue = CGFloat(0)
  
  fileprivate lazy var imageView: GLKView =
    {
      [unowned self] in
      
      let imageView = GLKView()
      
      imageView.context = self.eaglContext!
      imageView.delegate = self
      
      return imageView
      }()
  
  fileprivate let eaglContext = EAGLContext(api: .openGLES2)
  
  fileprivate lazy var ciContext: CIContext =
    {
      [unowned self] in
      
      return CIContext(eaglContext: self.eaglContext!,
                       options: [kCIContextWorkingColorSpace: NSNull()])
      }()
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.black
    
    sideLength = min(view.frame.width, view.frame.height)
    
    imageAccumulator = CIImageAccumulator(extent: CGRect(x: 0, y: 0, width: sideLength, height: sideLength),
                                          format: kCIFormatARGB8)
    
    let image = CIImage(color: CIColor(red: 0, green: 0, blue: 0))
      .cropping(to: CGRect(x: 0, y: 0, width: sideLength, height: sideLength))
    
    imageAccumulator.setImage(image)
    
    view.addSubview(imageView)
    
    let displayLink = CADisplayLink(target: self, selector: #selector(step))
    displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    
    delegate?.touchDidBegin(flag: false)
  }
  
  override func viewDidLayoutSubviews()
  {
    imageView.frame = CGRect(x: view.frame.midX - sideLength / 2,
                             y: view.frame.midY - sideLength / 2,
                             width: sideLength,
                             height: sideLength)
  }
  
  override var prefersStatusBarHidden : Bool
  {
    return true
  }
  
  @objc fileprivate func step()
  {
    imageView.setNeedsDisplay()
  }
  
  fileprivate var touchLocations: [CGPoint]?
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    guard let touch = touches.first else
    {
      return
    }
    
    delegate?.touchDidBegin(flag: true)
    
    touchLocations = [CGPoint(x: touch.location(in: imageView).x,
                              y: sideLength - touch.location(in: imageView).y)]
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    guard let touch = touches.first,
      let coalescedTouches = event?.coalescedTouches(for: touch)
      else
    {
      return
    }
    
    touchLocations = coalescedTouches.map
      {
        CGPoint(x: $0.location(in: imageView).x,
                y: sideLength - $0.location(in: imageView).y)
    }
    
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    delegate?.touchDidBegin(flag: false)
  }
  
  
}


extension TanouraViewController: GLKViewDelegate
{
  func glkView(_ view: GLKView, drawIn rect: CGRect)
  {
    let image = imageAccumulator.image()
      .applyingFilter("CIExposureAdjust", withInputParameters: [kCIInputEVKey: -0.0025])
    
    var tx = CGAffineTransform(translationX: sideLength / 2, y: sideLength / 2)
    tx = tx.rotated(by: rotateSpeed )
    tx = tx.translatedBy(x: -sideLength / 2, y: -sideLength / 2)
    
    var transformImage = CIFilter(name: "CIAffineTransform",
                                  withInputParameters: [kCIInputImageKey: image,
                                                        kCIInputTransformKey: NSValue(cgAffineTransform: tx)])!.outputImage!
    
    if let touchLocations = touchLocations
    {
      for touchLocation in touchLocations
      {
        let color = CIColor(color: UIColor(hue: hue.truncatingRemainder(dividingBy: 1.0), saturation: 1, brightness: 1, alpha: 1))
        hue += 0.01
        
        let gradient = CIFilter(name: "CIGaussianGradient",
                                withInputParameters: [
                                  kCIInputCenterKey: CIVector(cgPoint: touchLocation),
                                  kCIInputRadiusKey: radiusValue ,
                                  "inputColor0": color,
                                  "inputColor1": CIColor(red: 0, green: 0, blue: 0, alpha: 0)
          ])!.outputImage!
        
        transformImage = gradient.compositingOverImage(transformImage)
      }
      self.touchLocations = nil
    }
    
    let finalImage = transformImage
    
    imageAccumulator.setImage(finalImage)
    
    ciContext.draw(imageAccumulator.image(),
                   in: CGRect(x: 0, y: 0,
                              width: imageView.drawableWidth,
                              height: imageView.drawableHeight),
                   from: CGRect(x: 0, y: 0, width: sideLength, height: sideLength))
  }
}

