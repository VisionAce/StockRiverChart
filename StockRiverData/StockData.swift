//
//  StockData.swift
//  StockRiverData
//
//  Created by 褚宣德 on 2023/9/24.
//

import Foundation

struct StockRiverData: Identifiable, Equatable {
        
    let yearMonth: Int
    
    // population is in million
    let 本益比股價基準: Double
    let 月平均收盤價 : Double
    
    var id: Int { yearMonth }
    
    static var level1Example: [StockRiverData] {
    
        [StockRiverData(yearMonth: 202309, 本益比股價基準: 438.57, 月平均收盤價: 540),
         StockRiverData(yearMonth: 202308, 本益比股價基準: 438.57, 月平均收盤價: 549.82),
         StockRiverData(yearMonth: 201708, 本益比股價基準: 214.59, 月平均收盤價: 214.59)]
    }
    
    static var level2Example: [StockRiverData] {
        [StockRiverData(yearMonth: 202309, 本益比股價基準: 587.86 - 438.57, 月平均收盤價: 540),
         StockRiverData(yearMonth: 202308, 本益比股價基準: 587.86 - 438.57, 月平均收盤價: 549.82),
         StockRiverData(yearMonth: 201708, 本益比股價基準: 257.75 - 214.59, 月平均收盤價: 214.59)]
    }
    
    static var level3Example: [StockRiverData] {
        [StockRiverData(yearMonth: 202309, 本益比股價基準: 737.15 - 587.86, 月平均收盤價: 540),
         StockRiverData(yearMonth: 202308, 本益比股價基準: 737.15 - 587.86, 月平均收盤價: 549.82),
         StockRiverData(yearMonth: 201708, 本益比股價基準: 301.04 - 257.75, 月平均收盤價: 214.59)]
    }
    static var level4Example: [StockRiverData] {
        [StockRiverData(yearMonth: 202309, 本益比股價基準: 886.45 - 737.15, 月平均收盤價: 540),
         StockRiverData(yearMonth: 202308, 本益比股價基準: 886.45 - 737.15, 月平均收盤價: 549.82),
         StockRiverData(yearMonth: 201708, 本益比股價基準: 344.20 - 301.04, 月平均收盤價: 214.59)]
    }
    static var level5Example: [StockRiverData] {
        [StockRiverData(yearMonth: 202309, 本益比股價基準: 1035.74 - 886.45, 月平均收盤價: 540),
         StockRiverData(yearMonth: 202308, 本益比股價基準: 1035.74 - 886.45, 月平均收盤價: 549.82),
         StockRiverData(yearMonth: 201708, 本益比股價基準: 387.50 - 344.20, 月平均收盤價: 214.59)]
    }
    static var level6Example: [StockRiverData] {
        [StockRiverData(yearMonth: 202309, 本益比股價基準: 1185.03 - 1035.74, 月平均收盤價: 540),
         StockRiverData(yearMonth: 202308, 本益比股價基準: 1185.03 - 1035.74, 月平均收盤價: 549.82),
         StockRiverData(yearMonth: 201708, 本益比股價基準: 430.66 - 387.50, 月平均收盤價: 214.59)]
    }
}

struct StockSeries: Identifiable {
    let type: String
    let stockData: [StockRiverData]
    var id: String { type }
}

enum Constants {
    static let nStockAPiKey = "https://api.nstock.tw/v2/per-river/interview?stock_id=2330"
}
var stock:Stock?
var responseText = ""



// MARK: - Stock
struct Stock: Codable {
    let data: [Datum]
    
    enum CodingKeys: CodingKey {
        case data
    }
    
}

// MARK: - Datum
struct Datum: Codable {
    let 股票代號, 股票名稱: String
    let 本益比基準, 本淨比基準: [String]
    let 河流圖資料: [河流圖資料]
    let 目前本益比, 目前本淨比, 同業本益比中位數, 同業本淨比中位數: String
    let 本益比股價評估, 本淨比股價評估, 平均本益比, 平均本淨比: String
    let 本益成長比: String
}

// MARK: - 河流圖資料
struct 河流圖資料: Codable {

    let 年月, 月平均收盤價, 近四季Eps, 月近四季本益比: String
    let 本益比股價基準: [String]
    let 近一季Bps, 月近一季本淨比: String
    let 本淨比股價基準: [String]
    let 平均本益比, 平均本淨比: String
    let 近3年年複合成長: String?

    enum CodingKeys: String, CodingKey {
  
        case 年月, 月平均收盤價
        case 近四季Eps = "近四季EPS"
        case 月近四季本益比, 本益比股價基準
        case 近一季Bps = "近一季BPS"
        case 月近一季本淨比, 本淨比股價基準, 平均本益比, 平均本淨比, 近3年年複合成長
    }
}



