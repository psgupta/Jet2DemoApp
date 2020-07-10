//
//   ArticleViewModel.swift
//  Jet2DemoApp
//
//  Created by Prasanna Gupta on 10/07/20.
//  Copyright © 2020 Prasanna Gupta. All rights reserved.
//

import Foundation

class ArticleViewModel{
    
    let strDisplayName:String?
    let strUserAvatar:String?
    let strUserDesignation:String?
    let strUserCreatedTime:String?
    
    let strArticleContent:String?
    let strArticleImage:String?
    let strLikes:String?
    let strComments:String?
    let strArticleCreatedTime:String?
    
    init(with article:ArticleModel) {
        
        let userObject = article.userObject as UserModel
        self.strDisplayName = userObject.name+" "+userObject.lastname
        self.strUserAvatar = userObject.avatar
        self.strUserDesignation = userObject.designation
        self.strUserCreatedTime = userObject.createdAt
        
        let mediaObject = article.mediaObject as MediaModel
        self.strArticleImage = mediaObject.image
        self.strArticleContent = article.content
        self.strLikes = article.likes
        self.strComments = article.comments
        
        let dateOfArticle = article.createdAt.toDate(format:kAppDateFormat)
        let dateComponentsFormatter = DateComponentsFormatter()
        let duration =  dateComponentsFormatter.difference(from: Date(), to: dateOfArticle)
        self.strArticleCreatedTime = duration
    }
}
