//
// Created by Le Xuan Quynh on 09/01/2023.
//

import Foundation

class Solution {
    // 1. away using recursion
    func fib1(_ n: Int) -> Int {
        if n == 0 { return 0 }
        if n == 1 { return 1 }
        return fib1(n - 1) + fib1(n - 2)
    }

    // 2. away using loop
    func fib2(_ n: Int) -> Int {
        if n == 0 { return 0 }
        if n == 1 { return 1 }
        var a = 0
        var b = 1
        for _ in 2...n {
            let c = a + b
            a = b
            b = c
        }
        return b
    }

    // 3. away using matrix
    func fib3(_ n: Int) -> Int {
           if n == 0 { return 0 }
            if n == 1 { return 1 }
            let matrix = [[1, 1], [1, 0]]
            var result = [[1, 1], [1, 0]]
            for _ in 2...n {
                result = multiply(matrix, result)
            }
            return result[0][0]
    }

    func multiply(_ matrix1: [[Int]], _ matrix2: [[Int]]) -> [[Int]] {
        let a = matrix1[0][0] * matrix2[0][0] + matrix1[0][1] * matrix2[1][0]
        let b = matrix1[0][0] * matrix2[0][1] + matrix1[0][1] * matrix2[1][1]
        let c = matrix1[1][0] * matrix2[0][0] + matrix1[1][1] * matrix2[1][0]
        let d = matrix1[1][0] * matrix2[0][1] + matrix1[1][1] * matrix2[1][1]
        return [[a, b], [c, d]]
    }


}
