//
//  TempDataParsing.swift
//  elecCarChareInfo
//
//  Created by Chris Kim on 8/24/22.
//

import Foundation


// TODO: data.csv 파일 파싱해서 ChargeStation 모델에 바인딩 할 것
class Pasrse {
    func pasreList() {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else { return }
        
        guard let data = try? Data(contentsOf: url) else { return }
        
        guard let str = String(data: data, encoding: .utf8) else { return }
//        print(str.components(separatedBy: "}")[0], str.components(separatedBy: "}")[1])
        let lines: [String] = str.components(separatedBy: "}")
        
        for str in lines.dropFirst() {
            let values: [String] = str.components(separatedBy: ",")
            #if DEBUG
//            print(values)
            #endif
        }
    }
}
