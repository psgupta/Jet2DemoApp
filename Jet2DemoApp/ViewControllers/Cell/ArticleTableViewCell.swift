//
//  ArticleTableViewCell.swift
//  Jet2DemoApp
//
//  Created by Prasanna Gupta on 09/07/20.
//  Copyright © 2020 Prasanna Gupta. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    //UIImageView
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var imgViewArticle: UIImageView!
    
    //UILabel
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserDesignation: UILabel!
    @IBOutlet weak var lblTimeStamp: UILabel!
    
    //UIView
    @IBOutlet weak var viewOfMediaFile: UIView!
    @IBOutlet weak var viewOfTitle: UIView!
    
    //UITextView
    @IBOutlet weak var txtViewTitle: UITextView!
    
    //UIButton
    @IBOutlet weak var btnLikes: UIButton!
    @IBOutlet weak var btnComments: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    fileprivate func displayNumber(_ number: Float, _ strNumberToDisplay: inout String, _ strNumber: String) {
        if number>1000{
            let roundOffValue = String(format: "%.1f", number/1000)
            strNumberToDisplay = "\(roundOffValue)K"
        }else{
            strNumberToDisplay = strNumber
        }
    }
    
    
    
    
    fileprivate func setUpArticleDetails(_ articleViewModalObj: ArticleViewModel, _ cell: ArticleTableViewCell) {
        //Article Details
        let displayImage = articleViewModalObj.strArticleImage ?? ""
        cell.viewOfMediaFile.isHidden = displayImage == "" ? true : false
        
        if let url = URL(string: displayImage){
            cell.imgViewArticle?.sd_setImage(with: url, completed: nil)
        }
        cell.txtViewTitle.text = articleViewModalObj.strArticleContent
        
        
        
        var likesToDisplay = ""
        let likes =  Float(articleViewModalObj.strLikes ?? "0") ?? 0
        displayNumber(likes, &likesToDisplay, (articleViewModalObj.strLikes ?? "0") )
        cell.btnLikes.setTitle(likesToDisplay+" Likes", for: .normal)
        
        
        
        var commentsToDisplay = ""
        let comments =  Float(articleViewModalObj.strComments ?? "0") ?? 0
        displayNumber(comments, &commentsToDisplay, (articleViewModalObj.strComments ?? "0"))
        cell.btnComments.setTitle(commentsToDisplay+" Comments", for: .normal)
        
        cell.lblTimeStamp.text = articleViewModalObj.strArticleCreatedTime?.replacingOccurrences(of: "-", with: "")
    }
    
    
    fileprivate func setUpUserDetails(_ articleViewModalObj: ArticleViewModel, _ cell: ArticleTableViewCell) {
        //User Details
        if let urlAvatar = URL(string: articleViewModalObj.strUserAvatar ?? ""){
            cell.imgViewUser?.sd_setImage(with: urlAvatar, completed: nil)
        }
        cell.lblUserName.text = articleViewModalObj.strDisplayName
        cell.lblUserDesignation.text = articleViewModalObj.strUserDesignation
    }
    
    
    func articleCellDidSet(_ articleViewModalObj: ArticleViewModel, _ cell: ArticleTableViewCell) {
        
        setUpUserDetails(articleViewModalObj, cell)
        
        setUpArticleDetails(articleViewModalObj, cell)
    }
    
}


