//
//  ViewController.swift
//  SaveContact
//
//  Created by iOS on 16/02/23.
//

import UIKit
import Contacts

class ViewController: UIViewController {
    var store: CNContactStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        store = CNContactStore()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.checkContactsAccess()
        })
    }
    
    func saveContact(){
        do{
            let contact = CNMutableContact()
            contact.givenName = "iOS"
            contact.familyName = "Dev"
            contact.phoneNumbers = [CNLabeledValue(
                label:CNLabelPhoneNumberiPhone,
                value:CNPhoneNumber(stringValue:"9876543210"))]
            
            let saveRequest = CNSaveRequest()
            saveRequest.add(contact, toContainerWithIdentifier:nil)
            try store.execute(saveRequest)
            print("saved")
        }
        catch let error{
            print("error:\(error)")
        }
    }
    
    
    private func checkContactsAccess() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
            // Update our UI if the user has granted access to their Contacts
        case .authorized:
            saveContact()
            
            // Prompt the user for access to Contacts if there is no definitive answer
        case .notDetermined :
            self.requestContactsAccess()
            
            // Display a message if the user has denied or restricted access to Contacts
        case .denied,
                .restricted:
            let alert = UIAlertController(title: "Privacy Warning!",
                                          message: "Permission was not granted for Contacts.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func requestContactsAccess() {
        
        store.requestAccess(for: .contacts) {granted, error in
            if granted {
                DispatchQueue.main.async {
                    self.checkContactsAccess()
                }
            }
        }
    }
}
