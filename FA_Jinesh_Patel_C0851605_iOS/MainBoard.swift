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

        checkDataAndDisplay()
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
        switch sender.direction {
        case .right:
            let alert = UIAlertController(title: title, message: "Start new game?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Start again", style: .default, handler: { (_) in
                self.clearBoard()
                self.intNoughtsScore = 0
                self.intCrossesScore = 0
                self.lblXScore.text = "SCORE X : \(self.intCrossesScore)"
                self.lblOScore.text = "SCORE O : \(self.intNoughtsScore)"
                CoreDataHelper.instance.resetBoardFromDatabase()
            }))
            self.present(alert, animated: true)
        case .left:
            let alert = UIAlertController(title: title, message: "Start new game?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Start again", style: .default, handler: { (_) in
                self.clearBoard()
                self.intNoughtsScore = 0
                self.intCrossesScore = 0
                self.lblXScore.text = "SCORE X : \(self.intCrossesScore)"
                self.lblOScore.text = "SCORE O : \(self.intNoughtsScore)"
                CoreDataHelper.instance.resetBoardFromDatabase()
            }))
            self.present(alert, animated: true)
        default:
            break
        }
    }
    
    //MARK: - Custom methods
    
    func checkDataAndDisplay() {
        
        if CoreDataHelper.instance.totalDataCount() == 0
        {
            CoreDataHelper.instance.saveFirstTime(turn: "X")
        } else {
            CoreDataHelper.instance.syncDatabase()
            if appDelegate.arrData.count != 0  {
                let objGame = appDelegate.arrData[0] as! BoardOfGame
                lblDisplayTurn.text = objGame.firstMove ?? ""
                if let arrMoves = objGame.moves as? [String] {
                    
                    
                    intCrossesScore = Int(objGame.totalOfX)
                    intNoughtsScore = Int(objGame.totalOfO)
                    var currentMove = objGame.firstMove ?? "X"
                    for i in 0..<arrMoves.count {
                        let btnName = arrMoves[i]
                        if btnName == "a1" {
                            a1.setTitle(currentMove, for: .normal)
                        } else if btnName == "a2" {
                            a2.setTitle(currentMove, for: .normal)
                        } else if btnName == "a3" {
                            a3.setTitle(currentMove, for: .normal)
                        } else if btnName == "b1" {
                            b1.setTitle(currentMove, for: .normal)
                        } else if btnName == "b2" {
                            b2.setTitle(currentMove, for: .normal)
                        } else if btnName == "b3" {
                            b3.setTitle(currentMove, for: .normal)
                        } else if btnName == "c1" {
                            c1.setTitle(currentMove, for: .normal)
                        } else if btnName == "c2" {
                            c2.setTitle(currentMove, for: .normal)
                        } else if btnName == "c3" {
                            c3.setTitle(currentMove, for: .normal)
                        }
                        currentTurn = getNextMoveEnum(move: currentMove)
                        currentMove = getNextMove(move: currentMove)
                        lblDisplayTurn.text = currentMove
                    }
                }
                lblOScore.text = "Score O : " + String(Int(objGame.totalOfO))
                lblXScore.text = "Score X : " + String(Int(objGame.totalOfX))
            }
        }
    }
    
    
    private func getNextMove(move : String) -> String {
        if move == "X" {
            return "O"
        } else {
            return "X"
        }
    }
    
    private func getNextMoveEnum(move : String) ->  TURN {
        if move == "X" {
            return TURN.NOUGHT
        } else {
            return TURN.CROSS
        }
    }
    
    
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
    
    private func getMoveOfButton(index : Int) -> MoveOfButton {
        var move = MoveOfButton.a1
        if index == 1 {
            move = .a1
        } else if index == 2 {
            move = .a2
        } else if index == 3 {
            move = .a3
        } else if index == 4 {
            move = .b1
        } else if index == 5 {
            move = .b2
        } else if index == 6 {
            move = .b3
        } else if index == 7 {
            move = .c1
        } else if index == 8 {
            move = .c2
        } else if index == 9 {
            move = .c3
        }
        return move
    }
    
    private func showResultInAlert(title: String) {
        CoreDataHelper.instance.modifyCrossValue(count: intCrossesScore)
        CoreDataHelper.instance.modifyNoughtValue(count: intNoughtsScore)
        
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
        
        if currentTurn == .CROSS {
            CoreDataHelper.instance.changePlayer(move: "X")
        } else {
            CoreDataHelper.instance.changePlayer(move: "O")
        }
    }
    
    private func addToBoard(_ sender: UIButton) {
        if(sender.title(for: .normal) == nil) {
            var turn = ""
            if currentTurn == TURN.NOUGHT {
                sender.setTitle(strNought, for: .normal)
                currentTurn = TURN.CROSS
                lblDisplayTurn.text = strCross
                turn = "X"
            } else if currentTurn == TURN.CROSS {
                sender.setTitle(strCross, for: .normal)
                currentTurn = TURN.NOUGHT
                lblDisplayTurn.text = strNought
                turn = "O"
            }
            sender.isEnabled = false
            arrTags.append(sender.tag)
            
            var startTurn = ""
            if firstTurn == .CROSS {
                startTurn = "X"
            } else {
                startTurn = "O"
            }
            
            CoreDataHelper.instance.addBoard(move: getMoveOfButton(index: sender.tag), turn: turn,start: startTurn)
        }
    }
    
    func checkForUndo() {
        if let lastTag = arrTags.last {
            if lastTag == 1 {
                a1.setTitle(nil, for: .normal)
                a1.isEnabled = true
            } else if lastTag == 2 {
                a2.setTitle(nil, for: .normal)
                a2.isEnabled = true
            } else if lastTag == 3 {
                a3.setTitle(nil, for: .normal)
                a3.isEnabled = true
            } else if lastTag == 4 {
                b1.setTitle(nil, for: .normal)
                b1.isEnabled = true
            } else if lastTag == 5 {
                b2.setTitle(nil, for: .normal)
                b2.isEnabled = true
            } else if lastTag == 6 {
                b3.setTitle(nil, for: .normal)
                b3.isEnabled = true
            } else if lastTag == 7 {
                c1.setTitle(nil, for: .normal)
                c1.isEnabled = true
            } else if lastTag == 8 {
                c2.setTitle(nil, for: .normal)
                c2.isEnabled = true
            } else if lastTag == 9 {
                c3.setTitle(nil, for: .normal)
                c3.isEnabled = true
            }
            arrTags.removeLast()
        }
    }
    
    //MARK: - Motion code
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
    {
        if let _ = arrBoardButtons.last {
            if motion == .motionShake{
                
                print("Shake Gesture Recognized !!")
                
               checkForUndo()
                
                var turn = ""
                if(currentTurn == TURN.NOUGHT) {
                    currentTurn = TURN.CROSS
                    lblDisplayTurn.text = strCross
                    turn = "X"
                } else if(currentTurn == TURN.CROSS) {
                    currentTurn = TURN.NOUGHT
                    lblDisplayTurn.text = strNought
                    turn = "O"
                }
                CoreDataHelper.instance.removeRecentItem(turn: turn)
            }
        }
    }
    
}
