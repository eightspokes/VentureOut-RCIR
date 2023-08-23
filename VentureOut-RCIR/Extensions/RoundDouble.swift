//
//  RoundDouble.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/23/23.
//

import Foundation

extension Double {
    func roundDoubleToOneDecimal() -> String {
        return String(format: "%.0f", self)
    }
}
