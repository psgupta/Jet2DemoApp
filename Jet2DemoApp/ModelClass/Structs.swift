//
//  Structs.swift
//  Jet2DemoApp
//
//  Created by Prasanna Gupta on 09/07/20.
//  Copyright © 2020 Prasanna Gupta. All rights reserved.
//

import Foundation

struct ArticleModel{
    var comments:String
    var likes:String
    var articleId:String
    var content:String
    var createdAt:String
    var mediaObject:MediaModel
    var userObject:UserModel
}

struct UserModel{
    var blogId:String
    var userId:String
    var about:String
    var avatar:String
    var city:String
    var designation:String
    var name:String
    var lastname:String
    var createdAt:String
}

struct MediaModel{
    var blogId:String
    var mediaId:String
    var createdAt:String
    var image:String
    var title:String
    var url:String
}
