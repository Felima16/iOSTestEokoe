//
//  Users.swift
//  iOSTestEokoe
//
//  Created by Fernanda de Lima on 11/09/2018.
//  Copyright © 2018 FeLima. All rights reserved.
//

import Foundation

struct Users: Codable{
    var results:[User] = [User]()
}

struct User: Codable{
    var id:Int = 0
    var name:Name = Name()
    var bio:Bio = Bio()
    var picture:Pictures = Pictures()
}

struct Name: Codable {
    var first:String = ""
    var last:String = ""
}

struct Bio:Codable{
    var mini:String = ""
    var full:String?
}

struct Pictures: Codable{
    var large:String = ""
    var medium:String = ""
    var thumbnail:String = ""
}
