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
    @IBOutlet weak var commentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //セルに表示する内容を決める関数setPostData()を定義:PostDataクラスのインタンスが引数）
    func setPostData(_ postData: PostData) {
        //画像の表示
        //ダウンロード中を示すインジケータを設定（sd_imageIndicatorプロパティはFirebase_UIによるUIViewのextension）
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        //Storage上の画像の保存場所を取得
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        //print(imageRef)
        //imageViewの表示画像に、Storageから取得した画像を設定
        postImageView.sd_setImage(with: imageRef)
        
        //キャプションの表示「名前：キャプション」
        self.captionLabel.text = "\(postData.name!):\(postData.caption!)"
        
        //日時の表示
        self.dateLabel.text = ""
        //postData.dateのオプショナルバインディング
        if let date = postData.date {
            //DateFormatter()インスタンスを設定
            let formatter = DateFormatter()
            //日付表記の様式を[yyyy-MM-dd HH:mm]に設定
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            //日付表記の様式に基づいた文字列を取得->dateLabelへ表示
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        
        //「いいね」数の表示
        //postDataのlikesの要素数をカウント
        let likeNumber = postData.likes.count
        //その数をLikeLabelに表示
        likeLabel.text = "\(likeNumber)"
        
        //「いいね」ボタンの表示
        //自分が「いいね」を押していたら
        if postData.isLiked == true {
            //「いいね」ボタンをlike_exite(色付きハート)に設定
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        //自分がいいねを押していなければ
        } else {
            //「いいね」ボタンをlike_none(無色ハート)に設定
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        //
    
    }
    
}
