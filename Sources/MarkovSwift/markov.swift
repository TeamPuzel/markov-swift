//
//  markov.swift
//
//  Created by TeamPuzel on 21/09/2022.
//
//  This file is part of markov-swift
//

/// A data type defining the structure of a markov table,
/// the input table is an array of `MarkovTable`.
public struct MarkovTable {
    
    /// The state of the markov chain.
    let content: [Character]
    
    /// Possible choices for the defined state.
    let choices: [Choice]
    
    /// The total probability used for random number generation,
    /// should be the same as the last `probability` in  `choices`.
    let totalProbability: UInt
    
    /// The structure of a possible choice.
    public struct Choice {
        
        /// A possible character to continue the sequence.
        let nextCharacter: Character
        
        /// The  cumulative probability of the character being chosen.
        let probability: UInt
    }
    
    /// Generates a chain and appends it to a given `String`.
    /// - Parameters:
    ///     - buffer: The `String` to append to.
    ///     - startString: The first **2** characters to start the chain with.
    ///     - table: The array of markov table to use for generation.
    ///     - length: the amount of characters to generate.
    public func appendMarkov(buffer: inout String, startString: String, table: [MarkovTable], length: Int) {
        
        var array:[Character] = [] ; array.reserveCapacity(Int(length))
        
        if startString.count != 2 {
            print("Error: bad start string, count must be 2")
            return
        }
        array.append(contentsOf: startString)
        
        
        var comparisonBuffer:[Character] = [] ; comparisonBuffer.reserveCapacity(2)
        while array.count < length {
            var safetyCheck:Int8 = 0
            let currentIndex = array.endIndex
            comparisonBuffer.append(array[currentIndex - 2])
            comparisonBuffer.append(array[currentIndex - 1])
            for entry in table {
                safetyCheck += 1
                if entry.content == comparisonBuffer {
                    let random:Int = .random(in: 1...Int(entry.totalProbability))
                    if let resultEntry = entry.choices.first(where: { $0.probability >= random}) {
                        array.append(resultEntry.nextCharacter)
                        comparisonBuffer.removeAll(keepingCapacity: true)
                        safetyCheck = 0
                    }
                }
            }
            if safetyCheck == table.count {
                array.append(contentsOf: startString)
                comparisonBuffer.removeAll(keepingCapacity: true)
                safetyCheck = 0
            }
        }
        buffer.append(contentsOf: array)
    }
    
    /// Generates a chain and returns it as a `String`.
    /// - Parameters:
    ///     - startString: The first **2** characters to start the chain with.
    ///     - table: The array of markov table to use for generation.
    ///     - length: the amount of characters to generate.
    public func returnMarkov(startString: String, table: [MarkovTable], length: Int) -> String {
        
        var array:[Character] = [] ; array.reserveCapacity(Int(length))
        
        if startString.count != 2 {
            print("Error: bad start string, count must be 2")
            return ""
        }
        array.append(contentsOf: startString)
        
        
        var comparisonBuffer:[Character] = [] ; comparisonBuffer.reserveCapacity(2)
        while array.count < length {
            var safetyCheck:Int8 = 0
            let currentIndex = array.endIndex
            comparisonBuffer.append(array[currentIndex - 2])
            comparisonBuffer.append(array[currentIndex - 1])
            for entry in table {
                safetyCheck += 1
                if entry.content == comparisonBuffer {
                    let random:Int = .random(in: 1...Int(entry.totalProbability))
                    if let resultEntry = entry.choices.first(where: { $0.probability >= random}) {
                        array.append(resultEntry.nextCharacter)
                        comparisonBuffer.removeAll(keepingCapacity: true)
                        safetyCheck = 0
                    }
                }
            }
            if safetyCheck == table.count {
                array.append(contentsOf: startString)
                comparisonBuffer.removeAll(keepingCapacity: true)
                safetyCheck = 0
            }
        }
        return String(array)
    }
}
