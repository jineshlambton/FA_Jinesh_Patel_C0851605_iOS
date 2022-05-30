//
//  MainBoard.swift
//  FA_Jinesh_Patel_C0851605_iOS
//
//  Created by Jinesh Patel on 29/05/22.
//

import UIKit

class MainBoard: UIViewController {
    
    @IBOutlet weak var lblDisplayTurn: UILabel!
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    @IBOutlet weak var lblXScore: UILabel!
    @IBOutlet weak var lblOScore: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func boardClickEvent(_ sender: UIButton) {
        
    }
    
    @IBAction func swipeGestureEven(_ sender: UISwipeGestureRecognizer) {
        
    }
    
}
