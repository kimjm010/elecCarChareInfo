//
//  FCollectionReference.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/23/22.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case user
    case comment
    case marked
}

// MARK: - Firebase 내 최상위 폴더에 접근하는 메소드

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
