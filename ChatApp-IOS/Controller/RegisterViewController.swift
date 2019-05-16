//
//  RegisterViewController.swift
//  ChatApp-IOS
//
//  Created by TWBKG on 12/5/2562 BE.
//  Copyright © 2562 TWBKG. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {
 
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var buttonRegister: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onRegisterButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        
       self.enableView(isEnable: false)
        
        if validateInput(text: emailTextField.text!) && validateInput(text: passwordTextField.text!) {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authenResult, error) in
                
                if error != nil {
                    print(error!)
                    SVProgressHUD.showError(withStatus: "Register fail!")
                    
                    self.enableView(isEnable: true)

                }
                else {
                    SVProgressHUD.dismiss()
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let targetViewController = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                    self.present(targetViewController, animated:true, completion:nil)
                }
                
            }
        }
        
        
    }
    
    func validateInput(text : String) -> Bool {
        if text.isEmpty {
            return false
        }
        else {
            return true
        }
    }
    
    func enableView(isEnable : Bool){
        buttonRegister.isEnabled = isEnable
        passwordTextField.isEnabled = isEnable
        emailTextField.isEnabled = isEnable
    }
    
}
