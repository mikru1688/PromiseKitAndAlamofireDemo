//
//  ViewController.swift
//  PromiseKitAndAlamofireDemo
//
//  Created by Frank.Chen on 2017/4/10.
//  Copyright © 2017年 Frank.Chen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PromiseKit

class ViewController: UIViewController {
    
    var userData: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // test promiseKit
        let account: String = "Frank" // 假設從畫面上取得使用者輸入的「帳號」
        let password: String = "12345" // 假設從畫面上取得使用者輸入的「密碼」
        
        // 2. 使用基礎的方式來定義非同步的執行任務
        self.checkAccountAndPassword(account, password: password).then { userId in
            // 若是帳號碼密驗證成功，則利用登入的使用者ID來取得其資料
            self.getUserDataWithUserName(userId: userId)
        } .then { userData -> Void in
            // 執行至該block表示已取得使用者的資料
            self.userData = userData
        } .always {
            if let userData = self.userData {
                // 若是有取得使用者資料則開始進行app的邏輯...
                print(userData)
            }
        } .catch { error in
            // Alamofire所拋出的錯誤
            print(error.localizedDescription)
        }
        
        // 3. 使用 when 來定義非同步的執行任務
//        let checkAccountAndPasswordApi: Promise<String> = self.checkAccountAndPassword(account, password: password) // 驗證帳號、密碼是否正確
//        let getUserDataWithUserNameApi: Promise<JSON> = self.getUserDataWithUserName(userId: "userId") // 利用userId取得使用者的資料
//        
//        when(fulfilled: checkAccountAndPasswordApi, getUserDataWithUserNameApi).then { (userId, jsonData) -> Void in
//            // 登入後的相關邏輯...
//        } .catch { error in
//            print(error)
//        }
        
        // 4. 使用 firstly block 來定義非同步的執行任務
//        firstly {
//            // 先執行某些事再執行檢查帳號、密碼是否正確
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true // 開啟電池旁邊的indicatior
//            return self.checkAccountAndPassword(account, password: password)
//        } .then { userId in
//            self.getUserDataWithUserName(userId: userId)
//        } .then { uesrData in
//            self.userData = uesrData
//        } .always {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false // 關閉電池旁邊的indicatior
//            if let userData = self.userData {
//                print(userData)
//            }
//        } .catch { error in
//            print(error)
//        }
        
        // 5. 演示實際在開發專案時會遇到的案例
//        self.checkAccountAndPassword(account, password: password).then { userId in
//            // 若是帳號碼密驗證成功，則利用登入的使用者ID來取得其資料
//        self.getUserDataWithUserName(userId: userId)
//        } .then { userData in
//            // 執行至該block表示已取得使用者的資料
//            self.userData = userData
//        } .always {
//            if let userData = self.userData {
//                // 若是有取得使用者資料則開始進行app的邏輯...
//                print(userData)
//            }
//        } .catch { error in
//            if error as? PromiseError != nil {
//                // 自定義錯誤
//                switch error as! PromiseError {
//                case .loginProblem:
//                    print("登入失敗...")
//                case .getDataProblem:
//                    print("取得資料失敗...")
//                }
//            } else {
//                // Alamofire所拋出的錯誤
//                print(error.localizedDescription)
//            }
//        }
    }
    
    // 驗證帳號、密碼是否正確
    func checkAccountAndPassword(_ account: String, password: String) -> Promise<String> {
        return Promise { fulfill, reject in
            Alamofire.request("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=e6831708-02b4-4ef8-98fa-4b4ce53459d9").responseJSON { response in
                if response.result.isSuccess {
                    // API 服務正常並成功接收到回傳結果
                    fulfill("userId")
                } else {
                    // 呼叫API失敗拋出Alamofire的錯誤
                    // 當呼叫reject閉包則會返回至catch的block
                    reject(response.result.error!)
                }
            }
        }
    }
    
    // 驗證帳號、密碼是否正確(5. 演示實際在開發專案時會遇到的案例)
//    func checkAccountAndPassword(_ account: String, password: String) -> Promise<String> {
//        return Promise { fulfill, reject in
//            Alamofire.request("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=e6831708-02b4-4ef8-98fa-4b4ce53459d9").responseJSON { response in
//                if response.result.isSuccess {
//                    // 服務正常並取得驗證的結果後開始執行以下邏輯判斷
//                    let json = JSON(data: response.data!)
//                    
//                    // 判斷是否驗證成功
//                    if json["isSuccess"].stringValue == "Y" {
//                        // 若驗證成功則將userId回傳
//                        fulfill(json["userId"].stringValue)
//                    } else {
//                        // 若驗證失敗則回傳自定義的錯誤
//                        reject(PromiseError.loginProblem)
//                    }
//                } else {
//                    // 呼叫API失敗拋出Alamofire的錯誤
//                    // 當呼叫reject閉包則會返回至catch的block
//                    reject(response.result.error!)
//                }
//            }
//        }
//    }
    
    // 利用userId取得使用者的資料
    func getUserDataWithUserName(userId: String) -> Promise<JSON> {
        return Promise { fulfill, reject in
            Alamofire.request("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=e6831708-02b4-4ef8-98fa-4b4ce53459d9").responseJSON { response in
                if response.result.isSuccess {
                    // API 服務正常並成功接收到回傳結果
                    fulfill(JSON(data: response.data!))
                } else {
                    // 呼叫API失敗拋出Alamofire的錯誤
                    // 當呼叫reject閉包則會返回至catch的block
                    reject(response.result.error!)
                }
            }
        }
    }
    
}

// 自定義錯誤
enum PromiseError: Error {
    case loginProblem // 驗證登入者資訊失敗
    case getDataProblem // 取得資料失敗
}


