//
//  TintTextField.swift
//  WombatTest
//
//  Created by Jonathan Go on 24.02.22.
//

import UIKit

// This subclass and extension is just for the clear button on the textfield.
class TintTextField: UITextField {

     var tintedClearImage: UIImage?

     override init(frame: CGRect) {
       super.init(frame: frame)
       self.setupTintColor()
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func setupTintColor() {
       self.borderStyle = UITextField.BorderStyle.roundedRect
       self.layer.cornerRadius = 8.0
       self.layer.masksToBounds = true
       self.layer.borderColor = self.tintColor.cgColor
       self.layer.borderWidth = 1.5
       self.backgroundColor = .clear
       self.textColor = self.tintColor
     }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.tintClearImage()
    }

    private func tintClearImage() {
        for view in subviews {
            if view is UIButton {
                let button = view as! UIButton
                if let image = button.image(for: .highlighted) {
                    if self.tintedClearImage == nil {
                        tintedClearImage = self.tintImage(image: image, color: self.tintColor)
                    }
                    button.setImage(self.tintedClearImage, for: .normal)
                    button.setImage(self.tintedClearImage, for: .highlighted)
                }
            }
        }
    }

    private func tintImage(image: UIImage, color: UIColor) -> UIImage {
        let size = image.size

        UIGraphicsBeginImageContextWithOptions(size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        image.draw(at: .zero, blendMode: CGBlendMode.normal, alpha: 1.0)

        context?.setFillColor(color.cgColor)
        context?.setBlendMode(CGBlendMode.sourceIn)
        context?.setAlpha(1.0)

        let rect = CGRect(x: CGPoint.zero.x, y: CGPoint.zero.y, width: image.size.width, height: image.size.height)
        UIGraphicsGetCurrentContext()?.fill(rect)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return tintedImage ?? UIImage()
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
            var rightViewRect = super.rightViewRect(forBounds: bounds)
            rightViewRect.origin.x -= 10;
            return rightViewRect
        }
 }


extension UITextField {
    func clearButtonWithImage(_ image: UIImage) {
        let clearButton = UIButton()
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(self.clear(sender:)), for: .touchUpInside)
        self.rightView = clearButton
        self.rightViewMode = .always
    }
    
    @objc func clear(sender: AnyObject) {
        self.text = ""
    }
}
