//
//  MainBoard.swift
//  FA_Jinesh_Patel_C0851605_iOS
//
//  Created by Jinesh Patel on 29/05/22.
//

import UIKit

class MainBoard: UIViewController {
    
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
    @IBOutlet weak var lblDisplayTurn: UILabel!
    
    private var currentTurn = TURN.CROSS
    private var firstTurn = TURN.CROSS
    private var intNoughtsScore = 0
    private var intCrossesScore = 0
    
    private var strCross = "X"
    private var strNought = "O"
    private var arrTags : [Int] = []
    private var arrBoardButtons = [UIButton]()

    //MARK: - UIViewcontroller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpControls()
    }
    
    //MARK: - Button click events
    
    @IBAction func boardClickEvent(_ sender: UIButton) {
        addToBoard(sender)
        
        if isWin(strCross) {
            intCrossesScore += 1
            showResultInAlert(title: "Winner is Crosses!")
            lblXScore.text = "SCORE X : \(intCrossesScore)"
        }
        
        if isWin(strNought) {
            intNoughtsScore += 1
            showResultInAlert(title: "Win is Noughts!")
            lblOScore.text = "SCORE 0 : \(intNoughtsScore)"
        }
        
        if isFullBoardFilled() {
            showResultInAlert(title: "Draw")
        }
    }
    
    @IBAction func swipeGestureEven(_ sender: UISwipeGestureRecognizer) {
        
    }
    
    //MARK: - Custom methods
    
    private func setUpControls() {
        a1.tag = 1
        a2.tag = 2
        a3.tag = 3
        b1.tag = 4
        b2.tag = 5
        b3.tag = 6
        c1.tag = 7
        c2.tag = 8
        c3.tag = 9
        
        arrBoardButtons.append(a1)
        arrBoardButtons.append(a2)
        arrBoardButtons.append(a3)
        arrBoardButtons.append(b1)
        arrBoardButtons.append(b2)
        arrBoardButtons.append(b3)
        arrBoardButtons.append(c1)
        arrBoardButtons.append(c2)
        arrBoardButtons.append(c3)
    }
    
    private func isWin(_ s :String) -> Bool {
        if isSameSymbol(a1, s) && isSameSymbol(a2, s) && isSameSymbol(a3, s){
            return true
        }
        if isSameSymbol(b1, s) && isSameSymbol(b2, s) && isSameSymbol(b3, s) {
            return true
        }
        if isSameSymbol(a1, s) && isSameSymbol(b2, s) && isSameSymbol(c3, s) {
            return true
        }
        if isSameSymbol(a3, s) && isSameSymbol(b2, s) && isSameSymbol(c1, s) {
            return true
        }
        if isSameSymbol(c1, s) && isSameSymbol(c2, s) && isSameSymbol(c3, s) {
            return true
        }
        if isSameSymbol(a1, s) && isSameSymbol(b1, s) && isSameSymbol(c1, s) {
            return true
        }
        if isSameSymbol(a2, s) && isSameSymbol(b2, s) && isSameSymbol(c2, s) {
            return true
        }
        if isSameSymbol(a3, s) && isSameSymbol(b3, s) && isSameSymbol(c3, s) {
            return true
        }
        return false
    }
    
    private func isSameSymbol(_ button: UIButton, _ symbol: String) -> Bool {
        return button.title(for: .normal) == symbol
    }
    
    private func showResultInAlert(title: String) {
        let message = "\nNOUGHTS " + String(intNoughtsScore) + "\n\nCROSSES " + String(intCrossesScore)
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { (_) in
            self.clearBoard()
        }))
        self.present(ac, animated: true)
    }
    
    private func isFullBoardFilled() -> Bool {
        for button in arrBoardButtons {
            if button.title(for: .normal) == nil {
                return false
            }
        }
        return true
    }
    
    private func clearBoard() {
        for button in arrBoardButtons {
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        if firstTurn == TURN.NOUGHT {
            firstTurn = TURN.CROSS
            lblDisplayTurn.text = strCross
        } else if firstTurn == TURN.CROSS {
            firstTurn = TURN.NOUGHT
            lblDisplayTurn.text = strNought
        }
        currentTurn = firstTurn
    }
    
    private func addToBoard(_ sender: UIButton) {
        if(sender.title(for: .normal) == nil) {
            if currentTurn == TURN.NOUGHT {
                sender.setTitle(strNought, for: .normal)
                currentTurn = TURN.CROSS
                lblDisplayTurn.text = strCross
            
            } else if currentTurn == TURN.CROSS {
                sender.setTitle(strCross, for: .normal)
                currentTurn = TURN.NOUGHT
                lblDisplayTurn.text = strNought
            }
            sender.isEnabled = false
            arrTags.append(sender.tag)
        }
    }
    
}
