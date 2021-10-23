//
//  UserRegisterValues.swift
//  Velance
//
//  Created by Kevin Kim on 2021/09/12.
//

import Foundation

struct UserRegisterValues {
    
    static var shared = UserRegisterValues()
    
    var userID: String = ""
    var userPassword: String = ""
    
    var veganType: Int = 4
    var height: Int = 150
    var weight: Int = 45
    var gender: Int = 0
    var reason: Int = 0
    
}
