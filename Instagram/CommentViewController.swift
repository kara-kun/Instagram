//
//  CommentViewController.swift
//  Instagram
//
//  Created by 唐津 哲也 on 2021/05/20.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController {
    //var image: UIImage!
    var postRef: DocumentReference!
    //var postData:[PostData] = []
    
    //コメントを書き込む投稿の画像をプレビュー表示するためのImageView
    @IBOutlet weak var postImageView: UIImageView!
    //コメント書込欄TextViewを接続
    @IBOutlet weak var inputCommentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //-------受け取った画像をimageViewに表示-------
        //homeViewControllerから受け取ったimageRefを元に、Storage内から投稿先の画像データをゲット
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        //imageViewにゲットした画像を表示
        postImageView.sd_setImage(with: imageRef)
    }
    //コメント「投稿」ボタンの実装
    @IBAction func postComment(_ sender: Any) {
        //HUDで投稿処理中の表示を開始
        //SVProgressHUD.show()
        //コメント欄に入力されたコメントをゲットする。
        let comment = inputCommentTextView.text
        //コメントを書いた人＝現在ログインしているユーザーのdisplayNameをゲット
        let name = Auth.auth().currentUser?.displayName
        //辞書postDicに、Firestoreに書き込むデータを整理（名前／コメント／投稿日時）
        let postDic = [
            "name": name!,
            "comment": comment!,
            "date": FieldValue.serverTimestamp(),
        ] as [String: Any]
        //postDicをFirestoreに書き込む
        postRef.setData(postDic)
        //元の画面(HomeViewController)へ戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    //「キャンセル」ボタンの実装
    @IBAction func handleCancelButton(_ sender: Any) {
        //元の画面(HomeViewController)へ戻る
        self.dismiss(animated: true, completion: nil)
    }    
}
