//
//  RockPaperScissors - main.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
//

// MARK: - Enums
enum Message {
    static let menu = "가위(1), 바위(2), 보(3)! <종료 : 0> : "
    static let exit = "게임 종료"
    static let menuUserTurn = "[사용자 턴] 묵(1), 찌(2), 빠(3)! <종료 : 0> : "
    static let menuComputerTurn = "[컴퓨터 턴] 묵(1), 찌(2), 빠(3)! <종료 : 0> : "
    static let draw = "비겼습니다!"
    static let userWin = "이겼습니다!"
    static let computerWin = "졌습니다!"
    static let userFinalWin = "사용자의 승리!"
    static let computerFinalWin = "컴퓨터의 승리!"
    static let userTurn = "사용자의 턴입니다"
    static let computerTurn = "컴퓨터의 턴입니다"
}

enum GameResult: CustomStringConvertible {
    var description: String {
        switch self {
        case .draw:
            return Message.draw
        case .userWin:
            return Message.userWin
        case .computerWin:
            return Message.computerWin
        }
    }
    
    case draw
    case userWin
    case computerWin
}

enum WhoseTurn: CustomStringConvertible {
    var description: String {
        switch self {
        case .userTurn:
            return Message.userTurn
        case .computerTurn:
            return Message.computerTurn
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
        return .userWin
    } else {
        return .computerWin
    }
}

func runProgram() {
    print(Message.menu, terminator: "")
    
    do {
        guard let userHand = try readUserInput() else {
            print(Message.exit)
            return
        }
        
        let gameResult: GameResult = judgeGameResult(userHand)
        
        switch gameResult {
        case .draw:
            print(gameResult)
            runProgram()
        case .userWin:
            print(gameResult)
            try runMukChiBa(.userTurn)
        case .computerWin:
            print(gameResult)
            try runMukChiBa(.computerTurn)
        }
    } catch GameError.invalidInput {
        print(GameError.invalidInput)
        runProgram()
    } catch {
        fatalError()
    }
}

func runMukChiBa(_ whoseTurn: WhoseTurn) throws {
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
            print(Message.userFinalWin)
            print(Message.exit)
        case .draw where whoseTurn == .computerTurn:
            print(Message.computerFinalWin)
            print(Message.exit)
        case .userWin:
            print(WhoseTurn.userTurn)
            try runMukChiBa(.userTurn)
        case .computerWin:
            print(WhoseTurn.computerTurn)
            try runMukChiBa(.computerTurn)
        case .draw:
            fatalError()
        }
    } catch GameError.invalidInput {
        print(GameError.invalidInput)
        try runMukChiBa(.computerTurn)
    }
}

// MARK: - Program start
runProgram()
