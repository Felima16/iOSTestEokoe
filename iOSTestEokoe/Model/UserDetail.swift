//
//  UserDetail.swift
//  iOSTestEokoe
//
//  Created by Fernanda de Lima on 11/09/2018.
//  Copyright © 2018 FeLima. All rights reserved.
//

import Foundation


struct UserDetail: Codable{
    var bio: Bio = Bio()
    var email:String = ""
    var location: Local = Local()
}

struct Local: Codable{
    var city:String = ""
}
