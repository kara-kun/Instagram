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
        
        // コメント入力欄inputCommentTextView:枠の色
        inputCommentTextView.layer.borderColor = UIColor.gray.cgColor
        
        // コメント入力欄inputCommentTextView: 枠の幅
        inputCommentTextView.layer.borderWidth = 1.0
        
        // コメント入力欄inputCommentTextView: 枠を角丸にする
        inputCommentTextView.layer.cornerRadius = 10.0
        inputCommentTextView.layer.masksToBounds = true
        
        //-------受け取った画像をimageViewに表示-------
        //homeViewControllerから受け取ったimageRefを元に、Storage内から投稿先の画像データをゲット
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        //imageViewにゲットした画像を表示
        postImageView.sd_setImage(with: imageRef)
    }
    //コメント「投稿」ボタンの実装
    @IBAction func postComment(_ sender: Any) {
        //HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        //コメント欄に入力されたコメントをゲットする。
        let commentText = inputCommentTextView.text
        //コメントを書いた人＝現在ログインしているユーザーのdisplayNameをゲット
        let commentName = Auth.auth().currentUser?.displayName
        //辞書postDicに、Firestoreに書き込むデータを整理（名前／コメント／投稿日時）
        let postDic = [
            "commentName": commentName!,
            "commentText": commentText!,
            //"commentDate": FieldValue.serverTimestamp()
        ] as [String: Any]
            print(postDic)
        
        //コメントの更新データを収める変数updateFieldを定義する
        var updateField: FieldValue
        //更新データをまとめた辞書(配列)postDicを、setData()で追加できるデータに変換
        updateField = FieldValue.arrayUnion([postDic])
        //Firestore上に配列commentに、updateFieldを書き込む（すでに配列「comment」がある場合は、merge追記する）
        postRef.setData(["comment": updateField], merge: true) {(error) in
            //ここからクロージャー。投稿時にエラーがあれば
            if error != nil {
                //HUDでエラー表示
                SVProgressHUD.showError(withStatus: "投稿にに失敗しました")
                print("DEBUD_print: \(error!)")
                //元の画面(HomeViewController)へ戻る
                self.dismiss(animated: true, completion: nil)
                return
            }
            //HUDで投稿完了を表示
            SVProgressHUD.showSuccess(withStatus: "コメントを投稿しました")
            //元の画面(HomeViewController)へ戻る
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //「キャンセル」ボタンの実装
    @IBAction func handleCancelButton(_ sender: Any) {
        //元の画面(HomeViewController)へ戻る
        self.dismiss(animated: true, completion: nil)
    }    
}
