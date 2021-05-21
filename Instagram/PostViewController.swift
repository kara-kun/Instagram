//
//  PostViewController.swift
//  Instagram
//
//  Created by 唐津 哲也 on 2021/05/14.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    //imageSelectViewControllerから受け取った画像を入れる変数imageを定義
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    //「投稿」ボタンの処理
    @IBAction func handlePostButton(_ sender: Any) {
        //画像をJPEGに変換(圧縮率0.75)
        let imageData = image.jpegData(compressionQuality: 0.75)
        //投稿データの保存先を定義->Firestore Databeseへ
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        //投稿画像の保存先を定義->Storageへ
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        
        //-------------------投稿処理------------------
        //HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        //ここから、Storageに画像をアップロード
        //StorageMetadataのインスタンスを定義
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        //ここでFirestoreにアップロードしてる
        imageRef.putData(imageData!, metadata: metadata) {(metadata, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: "画像のアップロードに失敗しました")
                print(error!)
                //画像処理をキャンセルし、TabBar画面(もとのhome画面)に一気に戻る
                UIApplication.shared.windows.first{ $0 .isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            //画像をアップロードできたら、FireStoreに投稿データを保存
            //現在ログインしているユーサー名を取得
            let name = Auth.auth().currentUser?.displayName
            //辞書postDicに、Firestoreに書き込むデータを整理（名前／キャプション／投稿日時）
            let postDic = [
                "name": name!,
                "caption": self.textField.text!,
                "date": FieldValue.serverTimestamp(),
            ] as [String: Any]
            //Firestoreの保存場所postRefへ、postDicの内容を書込
            postRef.setData(postDic)
            //HUDで投稿完了を表示
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            //元の画面(TabBar)に戻る
            UIApplication.shared.windows.first{ $0 .isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    //「キャンセル」ボタンの処理
    @IBAction func handleCancelButton(_ sender: Any) {
        //加工画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //受け取った画像をimageViewに表示する
        imageView.image = image
    }
}
