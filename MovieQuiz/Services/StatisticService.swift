//
//  StatisticService.swift
//  MovieQuiz
//

import Foundation

protocol StatisticService {
    //func store()
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
  
}

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    var totalAccuracy: Double {
        get {
            userDefaults.double(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue )
        }
    }
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }

    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    } 
    
    func store(correct count: Int, total amount: Int) {
        let newGame = GameRecord(
            correct: count,
            total: amount,
            date: Date())
        if newGame > bestGame {
            bestGame = newGame
        }
        
        
        let newGameAccuracy = Double(count) * 100 / Double(amount)
        totalAccuracy = (totalAccuracy * Double(gamesCount) + newGameAccuracy) / Double(gamesCount+1)
        gamesCount += 1
        print(newGameAccuracy)
        print(totalAccuracy)
        print(Double(gamesCount))
    }
}
