//
//  ChargeStnAnnotationView.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/14/22.
//

import Foundation
import MapKit


/// MKAnnotatopmView Class
class ChargeStnAnnotationView: MKAnnotationView {
    
    // Annotation에 추가할 imageView
    lazy var imageView: UIImageView = {
        let imgView = UIImageView(frame: .zero)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        
        return imgView
    }()
    
    lazy var stackView: UIStackView = {
       let view = UIStackView(arrangedSubviews: [imageView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
        
        return view
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemBlue
        
        clusteringIdentifier = "charge"
        
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    
    /// 재사용되기 전 호출하여 준비 작업을 실행
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let _ = annotation as? ChargeStnAnnotation {
            imageView.image = UIImage(named: "chargeStn")
        }
        
        setNeedsLayout()
    }
    
}
