//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by 唐津 哲也 on 2021/05/14.
//

import UIKit
import CLImageEditor

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate {
    
    //「ライブラリ」ボタンの処理
    @IBAction func handleLibraryButton(_ sender: Any) {
        //photolibraryが有効なら
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //ImagePickerControllerインスタンスを作成
            let pickerController = UIImagePickerController()
            //デリゲート先をself、画像の取得先をフォトライブラリに設定
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            //modal viewで画像選択画面pickerController（ライブラリ）を表示
            self.present(pickerController, animated: true, completion: nil)
        }
        
    }
    //「カメラ」ボタンの処理
    @IBAction func handleCameraButton(_ sender: Any) {
        //cameraが有効なら
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //ImagePickerControllerインスタンスを作成
            let pickerController = UIImagePickerController()
            //デリゲート先をself、画像の取得先をカメラに設定
            pickerController.delegate = self
            pickerController.sourceType = .camera
            //modal viewで画像選択画面pickerControllerを表示(=カメラを起動)
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    //「キャンセル」ボタンの処理
    @IBAction func handleCancelButton(_ sender: Any) {
        //画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //imagePickerControllerDelegateのdelegateメソッド　画像を取得した際に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //取得した画像があれば
        if info[.originalImage] != nil {
            //取得した画像をUIImageインスタンスに変換
            let image = info[.originalImage] as! UIImage
            print("DEBUG_print: image=\(image) ")
            
            //--------CLImageEditorにimageを渡して、加工画面を起動---------
            //CLImageEditorインスタンスを作成
            let editor = CLImageEditor(image: image)!
            editor.delegate = self
            //modal View(fullScreen)で画像編集画面（先に定義したCLImageEditorインスタンス）を表示
            editor.modalPresentationStyle = .fullScreen
            picker.present(editor, animated: true, completion: nil)
        }
    }
    //imagePickerControllerDelegateのdelegateメソッド　キャンセルした時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //現在表示しているviewController（=imageSelectViewController）のmodal viewを閉じる
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //プロトコルCLImageEditorDelegateのメソッド 画像の加工が終わった時に呼ばれるメソッド
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        //投稿画面("Post")のviewControllerをpostViewControllerへダウンキャストし、インスタンスを定義
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        //postViewControllerへ取得した画像を送る
        postViewController.image = image!
        editor.present(postViewController, animated: true, completion: nil)
    }
    
    //プロトコルCLImageEditorDelegateのdelegate mmedhod CLImageEditorの編集がキャンセルされた時に呼ばれるメソッド
    func imageEditorDidCancel(_ editor: CLImageEditor!) {
        //imageSelectViewControllerのmodal viewを閉じてタブビューに戻る
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
