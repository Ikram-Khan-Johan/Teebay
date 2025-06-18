//
//  RentalDatePopVC.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 18/6/25.
//

import UIKit
import Toast_Swift

class RentalDatePopVC: UIViewController, StoryboardInstantiable {
    static var storyboardName: StoryboardName
    {
        return .purchase
    }

    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    var startDate: String = ""
    var endDate: String = ""
    var confirmRentalDateHandler: ((String, String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startDatePicker.addTarget(self, action: #selector(startDateChanged(_:)), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(endDateChanged(_:)), for: .valueChanged)
        startDate =   Date().toFullISO8601String()
        endDate =   Date().toFullISO8601String()
    }
    
    @objc func startDateChanged(_ sender: UIDatePicker) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
//            dateLabel.text = "Selected Date: \(formatter.string(from: sender.date))"
        startDate = sender.date.toFullISO8601String()
        print("Selected Date: \(startDate)")
        }

    @objc func endDateChanged(_ sender: UIDatePicker) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
//            dateLabel.text = "Selected Date: \(formatter.string(from: sender.date))"
        endDate = sender.date.toFullISO8601String()
        print("Selected Date: \(endDate)")
        }
    
    @IBAction func onTappedGoBackButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onTappedConfirmRentButton(_ sender: Any) {
        
        if startDate.isEmpty && endDate.isEmpty {
            self.view.makeToast("Please enter start and end date", duration: 2.0, position: .bottom)
            return
        } else if startDate.isEmpty {
            self.view.makeToast("Please enter start date", duration: 2.0, position: .bottom)
            return
        } else if endDate.isEmpty {
            self.view.makeToast("Please enter end date", duration: 2.0, position: .bottom)
            return
        }
        confirmRentalDateHandler?(startDate, endDate)
        self.dismiss(animated: true)
    }
    
}
