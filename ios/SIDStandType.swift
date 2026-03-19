//
//  SIDStandType.swift
//  reactsdk
//
//  Created by Валиева Анна Евгеньевна on 02.04.2024.
//

import SIDSDK

extension SIDStandType {
  init(fromString string: String) {
      switch string {
      case "psi_cloud":
        self = .psiCloud
      case "psi":
        self = .psi
      case "ift":
        self = .ift
      case "ift_cloud":
        self = .iftCloud
      default:
        self = .prom
    }
  }
}
