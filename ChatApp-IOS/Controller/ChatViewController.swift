//
//  ChatViewController.swift
//  ChatApp-IOS
//
//  Created by TWBKG on 12/5/2562 BE.
//  Copyright © 2562 TWBKG. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ChatViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
  

    var messageArray: [Message] = [Message]()
    
    var currentUser : String? = ""

    @IBOutlet weak var heightcontraint: NSLayoutConstraint!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       currentUser = Auth.auth().currentUser?.email
        // Do any additional setup after loading the view.
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTextField.delegate = self
        
        let tabGesture = UIGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tabGesture)
        
        messageTableView.register(UINib(nibName: "OwnerViewCell", bundle: nil), forCellReuseIdentifier: "OwnerViewCell")
        messageTableView.register(UINib(nibName: "OtherUserViewCell", bundle: nil), forCellReuseIdentifier: "OtherUserViewCell")
        messageTableView.allowsMultipleSelection = true
        messageTableView.separatorStyle = .none
        
        configureTableViewCell()
        receiveData()
        
    }
    
    func configureTableViewCell(){
        
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 230.0
    }
    
    @objc func tableViewTapped() {
       textFieldIsEditing(isEditing: true)
    }
    
    func textFieldIsEditing(isEditing : Bool) {
        messageTextField.endEditing(isEditing)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            
            self.heightcontraint.constant = 350
            self.updateFocusIfNeeded()
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            
            self.heightcontraint.constant = 50
            self.updateFocusIfNeeded()
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func receiveData() {
        let database = Database.database().reference().child("ChatMessage").child("Message")
        database.observe(.childAdded) { (snapshot) in
            
            do {
               
                let msgValue = snapshot.value as! Dictionary<String, String>
                
                if msgValue["sender"] != nil && msgValue["messageBody"] != nil {
                    let sender = msgValue["sender"]!
                    let messageBody = msgValue["messageBody"]!
                    
                    let message = Message()
                    message.sender = sender
                    message.messageBody = messageBody
                    
                    self.messageArray.append(message)
                    self.configureTableViewCell()
                    self.messageTableView.reloadData()
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let msg = messageArray[indexPath.row]
        
        
        if msg.sender == currentUser {
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerViewCell", for: indexPath) as! OwnerViewCell
            
            cell.senderLabel.text = msg.sender
            cell.messageLabel.text = msg.messageBody
            cell.avartarImage.image = UIImage(named: "user")
            
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherUserViewCell", for: indexPath) as! OtherUserViewCell
            
            cell.senderLabel.text = msg.sender
            cell.messageLabel.text = msg.messageBody
            cell.avartarImageView.image = UIImage(named: "user")
            
            return cell
        }
        
    }
    

    @IBAction func onSendButtonPressed(_ sender: UIButton) {
        let countMessage = messageTextField.text?.count ?? 0
        
        if  countMessage == 0 {
            SVProgressHUD.showError(withStatus: "กรุณากรอกข้อความ")
        }
        else {
            
            if SVProgressHUD.isVisible() {
                SVProgressHUD.dismiss()
            }
        
            textFieldIsEditing(isEditing: true)
            
            messageTextField.isEnabled = false
            
            let db = Database.database().reference().child("ChatMessage").child("Message")
            
            let dictionary = ["sender" : currentUser, "messageBody" : messageTextField.text]
            
            db.childByAutoId().setValue(dictionary) { (error, dbRef) in
                
                if error !=  nil {
                    SVProgressHUD.showError(withStatus: "send message fail!")
                    self.messageTextField.isEnabled = true
                }
                else {
                    self.messageTextField.isEnabled = true
                    self.messageTextField.text = ""
                }
                
            }
        }
    }
    
   
    @IBAction func signOutPressed(_ sender: AnyObject) {
        print("signOut Pressecd")
        
        SVProgressHUD.show()
         navigationController?.popToRootViewController(animated: true)
        do {
            
            let signOutRespone = try Auth.auth().signOut()
            
            print("sign out respone is " , signOutRespone)
            
            SVProgressHUD.dismiss()
            
             navigationController?.popToRootViewController(animated: true)
            
            
        } catch {
            print("sign out error ", error)
            
            SVProgressHUD.showError(withStatus: "Sign out fail!")
        }
    }
}
