//
//  MainVC.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 14/6/25.
//

import UIKit

class MainVC: UIViewController, StoryboardInstantiable {
    static var storyboardName: StoryboardName {
        return .main
    }
    

    @IBOutlet weak var mobeBUtton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onTappedMoveButton(_ sender: Any) {
        
        guard let vc = ProductVC.instantiateSelf() else {
            print("No VC found")
            return }
        
        navigationController?.pushViewController(vc, animated: true)
    }
   
}
