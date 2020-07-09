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

}
