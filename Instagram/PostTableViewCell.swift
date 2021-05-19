//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 唐津 哲也 on 2021/05/16.
//

import UIKit
import FirebaseUI

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPostData(_ postData: PostData) {
        //画像の表示
        //ダウンロード中を示すインジケータを設定
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        //Firebaseのstorage上の画像の保存場所とファイル名を取得
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        //print(imageRef)
        //imageViewにダウンロードした画像を表示
        postImageView.sd_setImage(with: imageRef)
        
        //キャプションの表示
        self.captionLabel.text = "\(postData.name!):\(postData.caption!)"
        
        //日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            //DateFormatterインスタンスを設定
            let formatter = DateFormatter()
            //日付表記の様式を設定
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            //日付表記の様式に基づいた文字列を取得->dateLabelへ表示
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        
        //「いいね」数の表示
        //postDataの配列likesの要素数をカウント
        let likeNumber = postData.likes.count
        //その数をLikeLabelに表示
        likeLabel.text = "\(likeNumber)"
        
        //「いいね」ボタンの表示
        if postData.isLiked == true {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        //
    
    }
    
}
