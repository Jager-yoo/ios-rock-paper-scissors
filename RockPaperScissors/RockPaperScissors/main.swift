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
        case .win(.user):
            return Message.userWin
        case .win(.computer):
            return Message.computerWin
        }
    }
    
    case draw
    case win(Player)
}

enum Player: CustomStringConvertible {
    var description: String {
        switch self {
        case .user:
            return Message.userTurn
        case .computer:
            return Message.computerTurn
        }
    }
    
    case user
    case computer
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
        return .win(.user)
    } else {
        return .win(.computer)
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
        case .win(let player):
            print(player)
            try runMukChiBa(whoseTurn: player)
        }
    } catch GameError.invalidInput {
        print(GameError.invalidInput)
        runProgram()
    } catch {
        fatalError()
    }
}

func runMukChiBa(whoseTurn: Player) throws {
    switch whoseTurn {
    case .user:
        print(Message.menuUserTurn, terminator: "")
    case .computer:
        print(Message.menuComputerTurn, terminator: "")
    }
    
    do {
        guard let mukChiBaInput = try readMukChiBa() else {
            print(Message.exit)
            return
        }
        
        let gameResult = judgeGameResult(mukChiBaInput)
        
        switch gameResult {
        case .draw where whoseTurn == .user:
            print(Message.userFinalWin)
            print(Message.exit)
        case .draw where whoseTurn == .computer:
            print(Message.computerFinalWin)
            print(Message.exit)
        case .win(let player):
            print(gameResult)
            try runMukChiBa(whoseTurn: player)
        case .draw:
            fatalError()
        }
    } catch GameError.invalidInput {
        print(GameError.invalidInput)
        try runMukChiBa(whoseTurn: .computer)
    }
}

// MARK: - Program start
runProgram()
