//
//  BoardViewController.swift
//  Final Project
//
//  Created by Joshua Sones on 4/17/17.
//  Copyright © 2017 Joshua Sones. All rights reserved.
//

import UIKit

class Square: UIButton {
    
    var col: Int // col index for this square
    var row: Int // rowumn index for this square
    var neighbors: [Square] = []
    var numNeighborMines = 0
    var isMine = false
    var isRevealed = false
    var isFlagged = false
    let width: CGFloat // width and height of this square
    let separator: CGFloat
    
    
    init(col: Int, row: Int, width: CGFloat, separator: CGFloat) {
        self.col = col
        self.row = row
        self.width = width
        self.separator = separator
        super.init(frame: CGRect(x: CGFloat(col) * (width + separator), y: CGFloat(row) * (width + separator) + 64, width: width, height: width))
        self.backgroundColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class Board {
    
    var numRows: Int // number of rowumns and cols in board
    var numMines: Int // number of mines on board
    var squares: [[Square]] = [] // 2D array of Squares with col and rowumn number
    var numSquaresRevealed: Int = 0
    
    
    init(numRows: Int, numMines: Int) {
        self.numRows = numRows
        self.numMines = numMines
        let viewController = UIViewController()
        for col in 0..<numRows {
            var squaresWithColAndRowNum: [Square] = []
            for row in 0..<numRows {
                let square = Square(col: col, row: row, width: (viewController.view.frame.width - CGFloat ((3 * (numRows-1)))) / CGFloat (numRows), separator: 3)
                squaresWithColAndRowNum.append(square)
            }
            squares.append(squaresWithColAndRowNum)
        }
    }
    
    func newGame() {
        
        clearBoard()
        addMines()
        for col in 0..<numRows {
            for row in 0..<numRows {
                setNeighbors(square: squares[col][row])
            }
        }
        setNumNeighborMines()
        
        
    }
    
    func clearBoard() {
        
        for col in 0..<numRows {
            for row in 0..<numRows {
                squares[col][row].isRevealed = false
                squares[col][row].isMine = false
                squares[col][row].neighbors = []
                squares[col][row].numNeighborMines = 0
            }
        }
    }
    
    func addMines() {
        
        var randomMineIndexesUsedSoFar: [Int] = []
        for _ in 0..<numMines {
            var newRandomMineIndex = Int(arc4random_uniform(UInt32(squares.count * squares.count)))
            while randomMineIndexesUsedSoFar.contains(newRandomMineIndex) {
                newRandomMineIndex = Int(arc4random_uniform(UInt32(squares.count * squares.count)))
            }
            randomMineIndexesUsedSoFar.append(newRandomMineIndex)
        }
        
        for index in 0..<randomMineIndexesUsedSoFar.count {
            squares[randomMineIndexesUsedSoFar[index] / numRows][randomMineIndexesUsedSoFar[index] % numRows].isMine = true
        }
    }


    func setNeighbors(square: Square) {
        var topLeftNeighborSquare: Square? = nil
        var topNeighborSquare: Square? = nil
        var topRightNeighborSquare: Square? = nil
        var leftNeighborSquare: Square? = nil
        var bottomLeftNeighborSquare: Square? = nil
        var bottomRightNeighborSquare: Square? = nil
        var rightNeighborSquare: Square? = nil
        var bottomNeighborSquare: Square? = nil
        

        // top left corner
        if square.col == 0 && square.row == 0 {
            rightNeighborSquare = squares[square.col+1][square.row]
            bottomRightNeighborSquare = squares[square.col+1][square.row+1]
            bottomNeighborSquare = squares[square.col][square.row+1]
        }
            
        // bottom left corner
        else if square.col == 0 && square.row == numRows - 1 {
            rightNeighborSquare = squares[square.col+1][square.row]
            topNeighborSquare = squares[square.col][square.row-1]
            topRightNeighborSquare = squares[square.col+1][square.row-1]
        }
            
        // top right corner
        else if square.col == numRows - 1 && square.row == 0 {
            bottomLeftNeighborSquare = squares[square.col-1][square.row+1]
            leftNeighborSquare = squares[square.col-1][square.row]
            bottomNeighborSquare = squares[square.col][square.row+1]
        }
            
        // bottom right corner
        else if square.col == numRows - 1 && square.row == numRows - 1 {
            topNeighborSquare = squares[square.col][square.row-1]
            leftNeighborSquare = squares[square.col-1][square.row]
            topLeftNeighborSquare = squares[square.col-1][square.row-1]
        }
            
        else if square.col == 0 {
            topNeighborSquare = squares[square.col][square.row-1]
            bottomNeighborSquare = squares[square.col][square.row+1]
            rightNeighborSquare = squares[square.col+1][square.row]
            bottomRightNeighborSquare = squares[square.col+1][square.row+1]
            topRightNeighborSquare = squares[square.col+1][square.row-1]
        }
            
        else if square.row == 0 {
            bottomNeighborSquare = squares[square.col][square.row+1]
            leftNeighborSquare = squares[square.col-1][square.row]
            rightNeighborSquare = squares[square.col+1][square.row]
            bottomRightNeighborSquare = squares[square.col+1][square.row+1]
            bottomLeftNeighborSquare = squares[square.col-1][square.row+1]
        }
            
        else if square.col == numRows - 1 {
            topNeighborSquare = squares[square.col][square.row-1]
            bottomNeighborSquare = squares[square.col][square.row+1]
            bottomLeftNeighborSquare = squares[square.col-1][square.row+1]
            leftNeighborSquare = squares[square.col-1][square.row]
            topLeftNeighborSquare = squares[square.col-1][square.row-1]
        }
        else if square.row == numRows - 1 {
            topNeighborSquare = squares[square.col][square.row-1]
            leftNeighborSquare = squares[square.col-1][square.row]
            topLeftNeighborSquare = squares[square.col-1][square.row-1]
            rightNeighborSquare = squares[square.col+1][square.row]
            topRightNeighborSquare = squares[square.col+1][square.row-1]
        }
            
        else {
            topNeighborSquare = squares[square.col][square.row-1]
            leftNeighborSquare = squares[square.col-1][square.row]
            topLeftNeighborSquare = squares[square.col-1][square.row-1]
            rightNeighborSquare = squares[square.col+1][square.row]
            topRightNeighborSquare = squares[square.col+1][square.row-1]
            bottomNeighborSquare = squares[square.col][square.row+1]
            bottomLeftNeighborSquare = squares[square.col-1][square.row+1]
            bottomRightNeighborSquare = squares[square.col+1][square.row+1]
        }
        
        if let unwrappedTopLeftNeighborSquare = topLeftNeighborSquare {
            square.neighbors.append(unwrappedTopLeftNeighborSquare) }
        
        if let unwrappedTopNeighborSquare = topNeighborSquare {
            square.neighbors.append(unwrappedTopNeighborSquare) }
        
        if let unwrappedTopRightNeighborSquare = topRightNeighborSquare {
                square.neighbors.append(unwrappedTopRightNeighborSquare) }
        
        if let unwrappedRightNeighborSquare = rightNeighborSquare {
            square.neighbors.append(unwrappedRightNeighborSquare) }
        
        if let unwrappedBottomRightNeighborSquare = bottomRightNeighborSquare {
                square.neighbors.append(unwrappedBottomRightNeighborSquare) }
        
        if let unwrappedBottomNeighborSquare = bottomNeighborSquare {
            square.neighbors.append(unwrappedBottomNeighborSquare) }
        
        if let unwrappedBottomLeftNeighborSquare = bottomLeftNeighborSquare {
            square.neighbors.append(unwrappedBottomLeftNeighborSquare) }
        
        if let unwrappedLeftNeighborSquare = leftNeighborSquare {
            square.neighbors.append(unwrappedLeftNeighborSquare) }
    }
    
    func setNumNeighborMines() {
        for col in 0..<numRows {
            for row in 0..<numRows {
                for neighbor in squares[col][row].neighbors {
                    if neighbor.isMine {
                        squares[col][row].numNeighborMines += 1
                    }
                }
            }
        }
    }
}


class SquareTapGestureRecognizer: UITapGestureRecognizer {
    var square = Square(col: 0, row: 0, width: 0, separator: 0)
}

class SquareLongPressGestureRecognizer: UILongPressGestureRecognizer {
    var square = Square(col: 0, row: 0, width: 0, separator: 0)
}

class BoardViewController: UIViewController {
    
    var mainMenuViewController: MainMenuViewController!
    var board: Board!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Minesweeper"
        view.backgroundColor = .white
        board = Board(numRows: mainMenuViewController.numRows!, numMines: mainMenuViewController.numMines!)
        board.newGame()
        for col in 0..<board.numRows {
            for row in 0..<board.numRows {
                let square = board.squares[col][row]
                let tapGesture = SquareTapGestureRecognizer(target: self, action: #selector(squareTapped))
                tapGesture.square = square
                let longPressGesture = SquareLongPressGestureRecognizer(target: self, action: #selector(squareLongPressed))
                longPressGesture.square = square
                square.addGestureRecognizer(tapGesture)
                square.addGestureRecognizer(longPressGesture)
                view.addSubview(square)
            }
        }
        
        let newGameBarButton = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(self.viewDidLoad))
        navigationItem.rightBarButtonItem = newGameBarButton
    }
    
    func squareTapped(sender: SquareTapGestureRecognizer) {
        let square = sender.square
        if square.isFlagged == false {
            square.isRevealed = true
            board.numSquaresRevealed += 1
            square.backgroundColor = .gray
            if square.isMine {
                square.setImage(#imageLiteral(resourceName: "mine"), for: .normal)
                let loserAlert = UIAlertController(title: "GAME OVER", message: "You hit a mine!", preferredStyle: .alert)
                loserAlert.addAction(UIAlertAction(title: "Main Menu", style: .default, handler: { action in
                    self.dismissViewControllerPop() }))
                loserAlert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { action in
                    self.viewDidLoad() }))
                self.present(loserAlert, animated: true, completion: nil)
            }
                
            else if square.numNeighborMines != 0 {
                square.setTitle(String (square.numNeighborMines), for: .normal)
            }
                
            else {
                for neighbor in square.neighbors {
                    if neighbor.isRevealed == false {
                        sender.square = neighbor
                        squareTapped(sender: sender)
                    }
                }
            }
            
            if board.numSquaresRevealed == board.numRows * board.numRows - board.numMines {
                let winnerAlert = UIAlertController(title: "WOOHOO!", message: "You found all the mines!", preferredStyle:. alert)
                winnerAlert.addAction(UIAlertAction(title: "Main Menu", style: .default, handler: { action in
                    self.dismissViewControllerPop() }))
                winnerAlert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { action in
                    self.viewDidLoad() }))
                self.present(winnerAlert, animated: true, completion: nil)
            }
        }
    }
    
    func squareLongPressed(sender: SquareLongPressGestureRecognizer) {
        let square = sender.square
        if square.isRevealed == false {
            if sender.state == .began {
                if square.isFlagged == false {
                    square.isFlagged = true
                    square.setImage(#imageLiteral(resourceName: "flag"), for: .normal)
                }
                else {
                    square.isFlagged = false
                    square.setImage(nil, for: .normal)
                }
            }
        }
    }
    
    func dismissViewControllerPop() {
        navigationController?.popViewController(animated: true)
    }
}
