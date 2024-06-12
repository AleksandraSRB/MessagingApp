//
//  ChatViewController.swift
//  MessagingApp
//
//  Created by Aleksandra Sobot on 27.5.24..
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var messageTextfield: UITextView!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
        setupKeyboardLayout()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
    }
    
    func setupUI() {
        
        navigationItem.hidesBackButton = true
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: K.BrandColor.brandLightPurple)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        title = K.appName
        navigationController?.navigationBar.tintColor = UIColor(named: K.BrandColor.brandLightPurple)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logOutPressed))
        navigationController?.navigationBar.barTintColor = .brandPurple
        messageTextfield.layer.cornerRadius = 10
    }
 
    
    func loadMessages() {
                                                                            // shows new messages every time instead of getDocument which retrives   messages only once
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { (QuerySnapshot, error) in
            // this line of code ensures that we don't copy messages. Before showing new messages, we are emptying an array of messages
            self.messages = []
            if let error = error {
                print("There was an error retriving data from Firestore: \(error)")
            } else {
                // This is code for retriving messages from Firestore
                if let snapshotDocuments = QuerySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                // populates cells by date created (newest messages are first)
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // This is where saving messages to Firestore is happening
    @IBAction func sendPressed(_ sender: UIButton) {
        guard let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email else {
            let error = NSError?.self
            fatalError("There was an issue saving data: \(error)")
        }
        if !messageBody.trimmingCharacters(in: .whitespaces).isEmpty {
            // we are saving each message with 3 parameters: sender, text and date created
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender, K.FStore.bodyField: messageBody, K.FStore.dateField: Date().timeIntervalSince1970])
            messageTextfield.text = ""
        } else {
            return
        }
    }

    
    @objc func logOutPressed() {
        let firebaseAuth = Auth.auth()
            do {
            try firebaseAuth.signOut()
                navigationController?.popToRootViewController(animated: true)
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
    }

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColor.brandLightPurple)
            cell.label.textColor = UIColor(named: K.BrandColor.brandPurple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColor.brandPurple)
            cell.label.textColor = UIColor(named: K.BrandColor.brandLightPurple)
        }
        
        return cell
    }
    
    @objc func setupKeyboardLayout() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
  
    
    @objc func keyboardWillShowNotification(notification: Notification) {
        let responderKeyboardType = UIResponder.keyboardFrameEndUserInfoKey
        guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[responderKeyboardType] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let bottomSpace = self.view.frame.height - (textFieldView.frame.height + textFieldView.frame.origin.y)
        
        let keyboardIsHidden = view.frame.origin.y == 0
        
        if keyboardIsHidden {
            self.view.frame.origin.y -= keyboardHeight - bottomSpace + 35
        }
    }

    @objc func keyboardWillHideNotification(notification: Notification) {
        let keyboardIsHidden = view.frame.origin.y == 0
        
        if !keyboardIsHidden {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
}






