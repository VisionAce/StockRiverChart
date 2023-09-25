//
//  ContentView.swift
//  StockRiverData
//
//  Created by 褚宣德 on 2023/9/24.
//

import SwiftUI
import Charts

struct ContentView: View {
    @State private var stock: Stock?
    @State private var riverDate: Date?
    @State private var years = [Date]()
    @State private var pERatios = [[String]]()
    @State private var pBRatios = [[String]]()
    @State private var averagePrice = [String]()
    @State private var level1DataEntriess = [StockRiverData]()
    @State private var level2DataEntriess = [StockRiverData]()
    @State private var level3DataEntriess = [StockRiverData]()
    @State private var level4DataEntriess = [StockRiverData]()
    @State private var level5DataEntriess = [StockRiverData]()
    @State private var level6DataEntriess = [StockRiverData]()
    @State private var isShowedChart  = false
    @State private var riverDataCount = 0
    @State private var level1DataEntriessMin = [String]()
    
    struct StockSeries: Identifiable {
        let type: String
        let stockData: [StockRiverData]
        var id: String { type }
    }
    
    var data: [StockSeries] {
        [StockSeries(type: "11.78倍", stockData: level1DataEntriess),
         StockSeries(type: "15.79倍", stockData: level2DataEntriess),
         StockSeries(type: "19.80倍", stockData: level3DataEntriess),
         StockSeries(type: "23.81倍", stockData: level4DataEntriess),
         StockSeries(type: "27.82倍", stockData: level5DataEntriess),
         StockSeries(type: "31.83倍", stockData: level6DataEntriess),
        ]
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(stock?.data.first?.股票名稱 ?? "")")
                Text("\(stock?.data.first?.股票代號 ?? "")")
               
            }
            .font(.title)
            .foregroundStyle(.brown)
            Text("河流圖資料筆數：\(riverDataCount)")
            Button("顯示河流圖") {
                isShowedChart = true
            }
            
            if isShowedChart {
                
                Chart(data, id: \.type) { dataSeries in
                    ForEach(dataSeries.stockData) { data in
                        AreaMark(x: .value("year", data.yearMonth), yStart: .value("本益比股價基準", data.本益比股價基準Min), yEnd: .value("本益比股價基準", data.本益比股價基準Max))
                        
                        LineMark(x: .value("year", data.yearMonth), y: .value("股價", data.月平均收盤價))
                            .foregroundStyle(.black)
                        
                    }
                    .foregroundStyle(by: .value("River type", dataSeries.type))
                    
                    
                } // Chart
                .chartXScale(domain: years[73]...years[0])
                .aspectRatio(1, contentMode: .fit)
                .chartScrollableAxes(.horizontal)
                .padding()
            }
            
        }
        .onAppear {
            if let url = URL(string:Constants.nStockAPiKey) {
                Task {
                    do {
                        let(data, _) = try await URLSession.shared.data(from: url)
                        let decoder = JSONDecoder()
                        let stockData =  try decoder.decode(Stock.self, from: data)
                        
                        stock = stockData

                        if let stockName = stock?.data.first?.股票名稱 {
                                print(stockName)
                        }
                        
                        for i in 0...73 {
                            if let stockPrice = stock?.data.first?.河流圖資料[i].月平均收盤價 {
                                averagePrice.append(stockPrice)
                            }
                        }
                        print("月平均收盤價: \(averagePrice)\n\n\n")
                        
                    
                        for i in 0...73 {
                            if let stockRiver = stock?.data.first?.河流圖資料[i].本益比股價基準 {
                                pERatios.append(stockRiver)
                            }
                        }
                        
                        print("本益比股價基準: \(pERatios)\n\n\n")
                        
                        for i in 0...73 {
                            if let stockRiverlevel1Min = stock?.data.first?.河流圖資料[i].本益比股價基準[0] {
                                let result = Double(stockRiverlevel1Min)! - 20
                                let resultString = String(result)
                                level1DataEntriessMin.append(resultString)
                            }
                        }
                        
                        
                        if let stockCount = stock?.data.first?.河流圖資料.count {
                            print("河流圖資料筆數： \(stockCount)\n\n\n")
                            riverDataCount = stockCount
                        }
                        
                        for i in 0...73 {
                            if let stockRiver2 = stock?.data.first?.河流圖資料[i].本淨比股價基準 {
                                pBRatios.append(stockRiver2)
                            }
                        }
                        
                        print("本淨比股價基準: \(pBRatios)\n\n\n")
                        
                        for i in 0...73 {
                            if let stockYear = stock?.data.first?.河流圖資料[i].年月 {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyyMM"
                                riverDate = dateFormatter.date(from: stockYear)
                                years.append(riverDate!)
                            }
                          
                        }
                        print("時間：\(years)\n\n\n")
                    
                        
                        let level1DataEntries = stride(from: 0, to: 74, by: 1).map { i in
                            StockRiverData(yearMonth: years[i], 本益比股價基準Max: Double(stock!.data.first!.河流圖資料[i].本益比股價基準[0])!, 本益比股價基準Min: Double(level1DataEntriessMin[i])!, 月平均收盤價: Double(averagePrice[i])!)
                        }
                        level1DataEntriess = level1DataEntries
                        print("\(level1DataEntries)\n\n\n")
                        
                        let level2DataEntries = stride(from: 0, to: 74, by: 1).map { i in
                            StockRiverData(yearMonth: years[i], 本益比股價基準Max:Double(stock!.data.first!.河流圖資料[i].本益比股價基準[1])!, 本益比股價基準Min: Double(stock!.data.first!.河流圖資料[i].本益比股價基準[0])!, 月平均收盤價: Double(averagePrice[i])!)
                        }
                        level2DataEntriess = level2DataEntries
                        print("\(level2DataEntries)\n\n\n")
                        
                        let level3DataEntries = stride(from: 0, to: 74, by: 1).map { i in
                            StockRiverData(yearMonth: years[i],本益比股價基準Max: Double(stock!.data.first!.河流圖資料[i].本益比股價基準[2])!, 本益比股價基準Min: Double(stock!.data.first!.河流圖資料[i].本益比股價基準[1])!, 月平均收盤價: Double(averagePrice[i])!)
                        }
                        level3DataEntriess = level3DataEntries
                        print("\(level3DataEntries)\n\n\n")
                        
                        let level4DataEntries = stride(from: 0, to: 74, by: 1).map { i in
                            StockRiverData(yearMonth: years[i],本益比股價基準Max: Double(stock!.data.first!.河流圖資料[i].本益比股價基準[3])!, 本益比股價基準Min: Double(stock!.data.first!.河流圖資料[i].本益比股價基準[2])!, 月平均收盤價: Double(averagePrice[i])!)
                        }
                        level4DataEntriess = level4DataEntries
                        print("\(level4DataEntries)\n\n\n")
                        
                        let level5DataEntries = stride(from: 0, to: 74, by: 1).map { i in
                            StockRiverData(yearMonth: years[i],本益比股價基準Max:Double(stock!.data.first!.河流圖資料[i].本益比股價基準[4])!,  本益比股價基準Min: Double(stock!.data.first!.河流圖資料[i].本益比股價基準[3])!, 月平均收盤價: Double(averagePrice[i])!)
                        }
                        level5DataEntriess = level5DataEntries
                        print("\(level5DataEntries)\n\n\n")
                        
                        let level6DataEntries = stride(from: 0, to: 74, by: 1).map { i in
                            StockRiverData(yearMonth: years[i], 本益比股價基準Max: Double(stock!.data.first!.河流圖資料[i].本益比股價基準[5])!, 本益比股價基準Min: Double(stock!.data.first!.河流圖資料[i].本益比股價基準[4])!,月平均收盤價: Double(averagePrice[i])!)
                        }
                        level6DataEntriess = level6DataEntries
                        print("\(level6DataEntries)")
                    
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
