
import UIKit

class VerificationViewController: RegistrationBaseController {

    @IBOutlet weak var resendCodeLabel: UILabel!
    @IBOutlet var codeCollection: [UILabel]!
    var code = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func setLayout() {
        let text = "Resend Code"
        
        resendCodeLabel.tappableLabels(string: text,
                                       tappableStrings: ["Resend Code"],
                                       textColor: UIColor(hex: "999999")!,
                                       font: UIFont(name: "Cocogoose-light", size: 18.0)!,
                                       isUnderLined: true)
        
        resendCodeLabel.addRangeGesture(stringRange: "Resend Code") {
            print("resend code clicked")
        }
    }
    
    @IBAction func keyPressed(_ sender: UIButton) {
        
        if sender.tag == -1 {
            if !code.isEmpty {
                code.removeLast()
                codeCollection[code.count].text = ""
            }
            
            return
        }
        
        if code.count == 4 { return }
        
        codeCollection[code.count].text = "\(sender.tag)"
        code.append(String(sender.tag))
        
        if code.count == 4 {
            let vc = TabViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
