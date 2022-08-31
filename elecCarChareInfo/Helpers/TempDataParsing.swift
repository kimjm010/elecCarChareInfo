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
        guard let url = Bundle.main.url(forResource: "data", withExtension: "csv") else { return }
        
        guard let data = try? Data(contentsOf: url) else { return }
        
        guard let str = String(data: data, encoding: .utf8) else { return }
        
        let lines: [String] = str.components(separatedBy: "}")
        #if DEBUG
        print(lines)
        #endif
        
        for str in lines.dropFirst() {
            let values: [String] = str.components(separatedBy: ",")
            #if DEBUG
            print(values)
            #endif
        }
    }
}
