import UIKit
import StoreKit

class SettingsViewController: LoadingViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var pushNotifButt: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        updateUi()
        loadUserData()
    }
    
    private func updateUi() {
        nameField.text = userManager.currentUser?.name
        if (userManager.pushEnabled) {
            pushNotifButt.setTitle("Push Notifications: On", for: .normal)
        }
        else {
            pushNotifButt.setTitle("Push Notifications: Off", for: .normal)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField == nameField) {
            return nameEditingDone()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == nameField) {
            return nameEditingDone()
        }
        return true
    }
    
    func nameEditingDone() -> Bool {
        if (nameField.text == nil || nameField.text == "") {
            alert("Name cannot be blank")
            return false
        }
        self.view.endEditing(true)
        if (networkOffline()) {
            alert("No network connection. Name could not be changed")
            return false
        }
        startLoading()
        userManager.set(name: nameField.text!, callback: {(error) in
            self.stopLoading()
            if let error = error {
                self.alert("Error setting name, please edit to try again: \(error.localizedDescription)")
            }
        })
        return true
    }
    
    @IBAction func pushNotifButtTouch() {
        if (userManager.pushEnabled) {
            confirm("Are you sure you want to disable push notifications for doodle game?", confirmedHandler: {
                self.startLoading()
                userManager.disablePushNotifications({ (err) in
                    DispatchQueue.main.async {
                        self.stopLoading()
                        if let err = err {
                            self.alert(err)
                            return
                        }
                        self.updateUi()
                    }
                })
            })
            return
        }
        userManager.enablePushNotifications { err in
            DispatchQueue.main.async {
                if let err = err {
                    self.alert(err)
                    return
                }
                self.updateUi()
            }
        }
    }
    
    @IBAction func signOutTouch() {
        confirm("Are you sure you want to sign out?", confirmedHandler: {
            self.startLoading()
            userManager.signOut({ error in
                DispatchQueue.main.async {
                    self.stopLoading()
                    if let error = error {
                        self.alert("Error signing you out: " + error)
                        return
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            })
        })
    }
    
    private func loadUserData() {
        if (!userManager.currentUserFetched()) {
            startLoading()
            userManager.fetchCurrentUser({ error in
                DispatchQueue.main.async {
                    self.stopLoading()
                    if let error = error {
                        self.alert(error)
                        return
                    }
                    self.updateUi()
                }
            })
        }
    }
}
