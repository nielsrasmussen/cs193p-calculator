//
//  ViewController.swift
//  Caluclator_2016
//
//  Created by Niels Rasmussen on 23.12.16.
//  Copyright © 2016 Niels Rasmussen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet private weak var history: UILabel!
    
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping && digit != "." || (digit == "."  && display.text!.range(of: ".") == nil) {
           display.text = display.text! + digit
        } else {
            if digit == "." && !userIsInTheMiddleOfTyping {
                display.text = "0."
            } else if digit != "."{
                display.text = digit
            }
        }
       
    userIsInTheMiddleOfTyping = true
        
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var historyValue: String {
        get {
            return history.text!
        }
        set {
            var value = newValue
            
            history.text = value
            
            if brain.isPartialResult {
            
                value += String("...")
             }
            else
            {
            value += String("=")
            }
        history.text = value
        }
    }
    
    
    
    private var brain = CalculatorBrain ()
    
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
            }
        
        if let mathmaticalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathmaticalSymbol)

        }
        
        displayValue = brain.result
        historyValue = brain.description
                
    }
    
}

