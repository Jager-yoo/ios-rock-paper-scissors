//
//  RockPaperScissors - main.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
//

// MARK: - Enums
enum Message {
    static let menu: String = "가위(1), 바위(2), 보(3)! <종료 : 0> : "
    static let exit: String = "게임 종료"
    static let menuUserTurn: String = "[사용자 턴] 묵(1), 찌(2), 빠(3)! <종료 : 0> : "
    static let menuComputerTurn: String = "[컴퓨터 턴] 묵(1), 찌(2), 빠(3)! <종료 : 0> : "
}

enum GameResult: CustomStringConvertible {
    var description: String {
        switch self {
        case .draw:
            return "비겼습니다!"
        case .win:
            return "이겼습니다!"
        case .lose:
            return "졌습니다!"
        }
    }
    
    case draw
    case win
    case lose
}

enum WhoseTurn: CustomStringConvertible {
    var description: String {
        switch self {
        case .userTurn:
            return "사용자의 턴입니다"
        case .computerTurn:
            return "컴퓨터의 턴입니다"
        }
    }
    
    case userTurn
    case computerTurn
}

enum GameError: Error, CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidInput:
            return "잘못된 입력입니다. 다시 시도해주세요."
        }
    }
    
    case invalidInput
}

enum ExpectedHand: String, CaseIterable, Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs == .paper, rhs == .scissors {
            return true
        }
        return lhs.rawValue < rhs.rawValue
    }
    
    case scissors = "1"
    case rock = "2"
    case paper = "3"
}

// MARK: - Functions
func readUserInput() throws -> ExpectedHand? {
    let input = readLine()
    
    switch input {
    case "0":
        return nil
    case .some(let input):
        if let userHand: ExpectedHand = ExpectedHand(rawValue: input) {
            return userHand
        }
        throw GameError.invalidInput
    case .none:
        throw GameError.invalidInput
    }
}

func readMukChiBa() throws -> ExpectedHand? {
    guard let input = try readUserInput() else {
        return nil
    }
    
    switch input {
    case .scissors:
        return .rock
    case .rock:
        return .scissors
    case .paper:
        return .paper
    }
}

func generateComputerHand() -> ExpectedHand? {
    return ExpectedHand.allCases.randomElement()
}

func judgeGameResult(_ input: ExpectedHand) -> GameResult {
    guard let computerHand: ExpectedHand = generateComputerHand() else {
        fatalError()
    }
    
    if computerHand == input {
        return .draw
    } else if computerHand < input {
        return .win
    } else {
        return .lose
    }
}

func runProgram() {
    print(Message.menu, terminator: "")
    do {
        let whoseTurn: WhoseTurn
        guard let userHand = try readUserInput() else {
            print(Message.exit)
            return
        }
        
        let gameResult: GameResult = judgeGameResult(userHand)
        
        switch gameResult {
        case .draw:
            print(gameResult)
            runProgram()
        case .win:
            whoseTurn = .userTurn
            print(gameResult)
        case .lose:
            whoseTurn = .computerTurn
            print(gameResult)
        }
        
    } catch GameError.invalidInput {
        print(GameError.invalidInput)
        runProgram()
    } catch {
        fatalError()
    }
}

func runMukChiBa(_ whoseTurn: WhoseTurn) {
    switch whoseTurn {
    case .userTurn:
        print(Message.menuUserTurn, terminator: "")
    case .computerTurn:
        print(Message.menuComputerTurn, terminator: "")
    }
    
    do {
        guard let mukChiBaInput = try readMukChiBa() else {
            print(Message.exit)
            return
        }
        
        let gameResult = judgeGameResult(mukChiBaInput)
        
        switch gameResult {
        case .draw where whoseTurn == .userTurn:
            print("사용자의 승리!")
        case .draw where whoseTurn == .computerTurn:
            print("컴퓨터의 승리!")
        case .win:
            runMukChiBa(.userTurn)
        case .lose:
            runMukChiBa(.computerTurn)
        case .draw:
            fatalError()
        }
        
    } catch GameError.invalidInput {
        print(GameError.invalidInput)
        runProgram()
    } catch {
        fatalError()
    }
}

// MARK: - Program start
runProgram()
