//
//  TabBarController.swift
//  Instagram
//
//  Created by 唐津 哲也 on 2021/05/14.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        //タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        //UITabBarControllerDelegateプロトコルのメソッドをこのクラスで実装
        self.delegate = self
        
    }
    
    //タブバー上のボタンがタップされた際に、タブの切り替えを行うかどうか（UITabBarControllerDelegateプロトコルのdelegateメソッド）
    //＊＊＊＊第2引数viewController:UIViewControllerに、タップされたボタンに応じたviewControllerインスタンスが入る＊＊＊＊
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //「投稿」ボタンが押された -> ImageSelectViewControllerが呼ばれた際は、
        if viewController is ImageSelectViewController {
            //「ImageSelect」IDが付与されたストーリーボートに対応するImageSelectViewControllerのインスタンス、imageSelectViewControllerを作成
            let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
            //modal viewで表示（タブ切替での表示はしない）
            present(imageSelectViewController, animated: true)
            return false
        } else {
            //タブ切替で表示する
            return true
        }
    }
    
    
}
