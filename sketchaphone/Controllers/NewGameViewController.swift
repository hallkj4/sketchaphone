import UIKit

class NewGameViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.text = ""
        //TODO Default text
        //TODO can i unlock the textField?
        //todo pop the keyboard
    }
    
    @IBAction func createTouch(_ sender: UIBarButtonItem) {
        if (textField.text == nil || textField.text == "") {
            //TODO check for default text
            // TODO alert
            return
        }
        gamesManager.new(phrase: textField.text!)
        //TODO - loading animation
        //TODO can i lock the textField?
        dismiss(animated: true) //TODO put this in a callback
    }
    
    @IBAction func cancelTouch(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
