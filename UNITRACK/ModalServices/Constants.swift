//
//  Constants.swift
//  UNITRACK
//
//  Created by gitwebmobi1019 on 2018-01-15.
//  Copyright © 2018 gitwebmobi1019. All rights reserved.
//

import Foundation
import CoreBluetooth

let SERVICE_UUID = "E20A39F4-73F5-4BC4-A12F-17D1AD666661"
let CHARACTERISTIC_UUID = "08590F7E-DB05-467E-8757-72F6F66666D4"
let SERVICE_NAME = "Lecturer"
let NOTIFY_MTU = 20

let transferServiceUUID = CBUUID(string: SERVICE_UUID)
let transferCharacteristicUUID = CBUUID(string: CHARACTERISTIC_UUID)

var LECTURER_NAME = "Lecturer"

var STUDENT_NAME = "Student"
var STUDENT_ID = "Student ID"
var STUDENT_COMMENT = "Student comment"
