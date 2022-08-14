//
//  ChargeAnnotationView.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/14/22.
//

import Foundation
import MapKit


// 충전소 AnnotationView Class
class ChargeAnnotationView: MKAnnotationView {
    
    private let contentInsets = UIEdgeInsets(top: 10, left: 30, bottom: 20, right: 20)
    private let blurEffect = UIBlurEffect(style: .systemThickMaterial)
    
    private lazy var backgroundMaterial: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.spacing = 10
        
        return stackView
    }()
    
    private lazy var labelVibrancyView: UIVisualEffectView = {
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: .secondaryLabel)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.contentView.addSubview(self.label)
        
        return vibrancyView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.preferredMaxLayoutWidth = 90
        
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        return imageView
    }()
    
    private var imageHeightConstraint: NSLayoutConstraint?
    private var labelHeightConstraint: NSLayoutConstraint?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        addSubview(backgroundMaterial)
        
        backgroundMaterial.contentView.addSubview(stackView)
        
        backgroundMaterial.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundMaterial.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundMaterial.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundMaterial.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        stackView.leadingAnchor.constraint(equalTo: backgroundMaterial.leadingAnchor, constant: contentInsets.left).isActive = true
        stackView.topAnchor.constraint(equalTo: backgroundMaterial.topAnchor, constant: contentInsets.top).isActive = true
        
        imageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        labelVibrancyView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        labelVibrancyView.heightAnchor.constraint(equalTo: label.heightAnchor).isActive = true
        labelVibrancyView.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        labelVibrancyView.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = nil
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let _ = annotation as? ChargeAnnotation {
            imageView.image = UIImage(named: "chargeStn")
        }
        
        setNeedsLayout()
    }
}
