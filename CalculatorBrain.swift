//
//  CalculatorBrain.swift
//  Caluclator_2016
//
//  Created by Niels Rasmussen on 27.12.16.
//  Copyright © 2016 Niels Rasmussen. All rights reserved.
//

import Foundation

func factorial(operand: Double) -> Double {
    let zahl = Int(operand)
    if zahl == 1 || zahl == 0 {
            return Double(zahl)
        } else {
            return Double(zahl) * factorial(operand: Double(zahl-1))
        }
    }


class CalculatorBrain {
    
    private var accumulator = 0.0
    var description = ""
    var isPartialResult = true
    
    func setOperand (operand: Double) {
        accumulator = operand
        if isPartialResult {
          description += String(operand)
        } else {
            description = String(operand)
            isPartialResult = true
        }
    }
   
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "tan" : Operation.UnaryOperation(tan),
        "sin" : Operation.UnaryOperation(sin),
        "x!" : Operation.UnaryOperation({factorial(operand: $0)}),
        "±" : Operation.UnaryOperation({-$0}),
        "x²" : Operation.UnaryOperation({$0 * $0}),
        "x³" : Operation.UnaryOperation({pow($0, 3)}),
        "x⁻¹" : Operation.UnaryOperation({1/$0}),
        "×" :   Operation.BinaryOperation({$0 * $1}),
        "−" :   Operation.BinaryOperation({$0 - $1}),
        "÷" :   Operation.BinaryOperation({$0 / $1}),
        "+" :   Operation.BinaryOperation({$0 + $1}),
        "=" : Operation.Equals
    ]
    
    func performOperation (symbol: String){
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
                isPartialResult = false
                }
            
            
                description += symbol
            
        }
    }
    
    
    
    private func executePendingBinaryOperation (){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
   
    }
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double) -> Double)
        case Equals
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
