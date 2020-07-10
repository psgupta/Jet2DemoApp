//
//  Constant.swift
//  Jet2DemoApp
//
//  Created by Prasanna Gupta on 09/07/20.
//  Copyright © 2020 Prasanna Gupta. All rights reserved.
//

import Foundation


enum EntityTitle:String{
    case ArticleEntity = "Article",
    MediaEntity = "Media",
    UserEntity = "User"
}


let kMAXPAGELIMIT = 10
let strArticleAPIURL = "https://5e99a9b1bc561b0016af3540.mockapi.io/jet2/api/v1/blogs?page=1&limit=10"
let strArticleCellIdentifier = "articleCell"
