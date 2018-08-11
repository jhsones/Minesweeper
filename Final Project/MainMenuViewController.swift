//
//  MainMenuViewController.swift
//  Final Project
//
//  Created by Joshua Sones on 4/17/17.
//  Copyright © 2017 Joshua Sones. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    var numRowsTextField: UITextField!
    var numMinesTextField: UITextField!
    var numRows: Int?
    var numMines: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Main Menu"
        view.backgroundColor = .white
        
        let numRowsLabel = UILabel(frame: CGRect(x: 30 +  15, y: 22 + 64, width: 120, height: 50))
        numRowsLabel.text = "Rows/Columns:"
        view.addSubview(numRowsLabel)
        
        numRowsTextField = UITextField(frame: CGRect(x: 30 +  140, y: 33 + 64, width: 35, height: 30))
        numRowsTextField.layer.cornerRadius = 5.0
        numRowsTextField.layer.borderColor = UIColor.lightGray.cgColor
        numRowsTextField.layer.borderWidth = 0.5
        numRowsTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        numRowsTextField.text = ""
        view.addSubview(numRowsTextField)
        
        let numMinesLabel = UILabel(frame: CGRect(x: 60 +  185, y: 22 + 64, width: 53, height: 50))
        numMinesLabel.text = "Mines:"
        view.addSubview(numMinesLabel)
        
        numMinesTextField = UITextField(frame: CGRect(x: 60 + 243, y: 33 + 64, width: 35, height: 30))
        numMinesTextField.layer.cornerRadius = 5.0
        numMinesTextField.layer.borderColor = UIColor.lightGray.cgColor
        numMinesTextField.layer.borderWidth = 0.5
        numMinesTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        numMinesTextField.text = ""
        view.addSubview(numMinesTextField)
        
        let startButton = UIButton(frame: CGRect(x: view.center.x, y: view.center.y + 64, width: 40, height: 20))
        startButton.center = view.center
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.blue, for: .normal)
        startButton.addTarget(self, action: #selector(showBoardViewControllerPush), for: .touchUpInside)
        view.addSubview(startButton)
    }
    
    func showBoardViewControllerPush() {
        let alert = UIAlertController(title: "UH OH!", message: "Enter a number of rows between 2 and 16 and a number of mines less than the number of rows squared", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.viewDidLoad() } ))
        numRows = Int (numRowsTextField.text!)
        numMines = Int (numMinesTextField.text!)
        if numRows != nil && numMines != nil {
            if numRows! < 17 && numRows! > 1 && numMines! <= numRows! * numRows! {
                let boardViewController = BoardViewController()
                boardViewController.mainMenuViewController = self
                navigationController?.pushViewController(boardViewController, animated: true)
            }
            else {
                numMinesTextField.text = ""
                numRowsTextField.text = ""
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            numMinesTextField.text = ""
            numRowsTextField.text = ""
            self.present(alert, animated: true, completion: nil)
        }
    }


}
