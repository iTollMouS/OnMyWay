//
//  GlobalFunctions.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 10/2/20.
//

import Foundation


func fileNameFrom(fileUrl: String) -> String {
    guard let name = (fileUrl.components(separatedBy: "%").last)?.components(separatedBy: "?").first else {return ""}
    return name
}
