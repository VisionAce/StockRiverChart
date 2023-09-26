//
//  ContentView.swift
//  StockRiverData
//
//  Created by 褚宣德 on 2023/9/24.
//

import SwiftUI
import Charts

struct ContentView: View {
    @State var selectedElement1: StockRiverData?
    @State var selectedElement2: StockRiverData?
    @State var selectedElement3: StockRiverData?
    @State var selectedElement4: StockRiverData?
    @State var selectedElement5: StockRiverData?
    @State var selectedElement6: StockRiverData?
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
        [StockSeries(type: "11.78倍 \(selectedElement1?.本益比股價基準Max ?? 0.0)", stockData: level1DataEntriess),
         StockSeries(type: "15.79倍 \(selectedElement2?.本益比股價基準Max ?? 0.0)", stockData: level2DataEntriess),
         StockSeries(type: "19.80倍 \(selectedElement3?.本益比股價基準Max ?? 0.0)", stockData: level3DataEntriess),
         StockSeries(type: "23.81倍 \(selectedElement4?.本益比股價基準Max ?? 0.0)", stockData: level4DataEntriess),
         StockSeries(type: "27.82倍 \(selectedElement5?.本益比股價基準Max ?? 0.0)", stockData: level5DataEntriess),
         StockSeries(type: "31.83倍 \(selectedElement6?.本益比股價基準Max ?? 0.0)", stockData: level6DataEntriess),
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
            Toggle(isShowedChart ? "收起河流圖" : "顯示河流圖", isOn: $isShowedChart.animation())
                .padding()
            
            if isShowedChart {
                Text("本益比")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.indigo)
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
                .opacity(0.8)
                // scan line
                .chartOverlay { proxy in
                    GeometryReader { geo in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(
                                SpatialTapGesture()
                                    .onEnded { value in
                                        let element = findElement1(location: value.location, proxy: proxy, geometry: geo)
                                        if selectedElement1?.yearMonth == element?.yearMonth {
                                            // If tapping the same element, clear the selection.
                                            selectedElement1 = nil
                                        } else {
                                            selectedElement1 = element
                                        }
                                    }
                                    .onEnded { value in
                                        let element2 = findElement2(location: value.location, proxy: proxy, geometry: geo)
                                        if selectedElement2?.yearMonth == element2?.yearMonth {
                                            // If tapping the same element, clear the selection.
                                            selectedElement2 = nil
                                        } else {
                                            selectedElement2 = element2
                                        }
                                    }
                                    .onEnded { value in
                                        let element3 = findElement3(location: value.location, proxy: proxy, geometry: geo)
                                        if selectedElement3?.yearMonth == element3?.yearMonth {
                                            // If tapping the same element, clear the selection.
                                            selectedElement3 = nil
                                        } else {
                                            selectedElement3 = element3
                                        }
                                    }
                                    .onEnded { value in
                                        let element4 = findElement4(location: value.location, proxy: proxy, geometry: geo)
                                        if selectedElement4?.yearMonth == element4?.yearMonth {
                                            // If tapping the same element, clear the selection.
                                            selectedElement4 = nil
                                        } else {
                                            selectedElement4 = element4
                                        }
                                    }
                                    .onEnded { value in
                                        let element5 = findElement5(location: value.location, proxy: proxy, geometry: geo)
                                        if selectedElement5?.yearMonth == element5?.yearMonth {
                                            // If tapping the same element, clear the selection.
                                            selectedElement5 = nil
                                        } else {
                                            selectedElement5 = element5
                                        }
                                    }
                                    .onEnded { value in
                                        let element6 = findElement6(location: value.location, proxy: proxy, geometry: geo)
                                        if selectedElement6?.yearMonth == element6?.yearMonth {
                                            // If tapping the same element, clear the selection.
                                            selectedElement6 = nil
                                        } else {
                                            selectedElement6 = element6
                                        }
                                    }
                                    .exclusively(
                                        before: DragGesture()
                                            .onChanged { value in
                                                selectedElement1 = findElement1(location: value.location, proxy: proxy, geometry: geo)
                                                
                                                selectedElement2 = findElement2(location: value.location, proxy: proxy, geometry: geo)
                                                
                                                selectedElement3 = findElement3(location: value.location, proxy: proxy, geometry: geo)
                                                
                                                selectedElement4 = findElement4(location: value.location, proxy: proxy, geometry: geo)
                                                
                                                selectedElement5 = findElement5(location: value.location, proxy: proxy, geometry: geo)
                                                
                                                selectedElement6 = findElement6(location: value.location, proxy: proxy, geometry: geo)
                                            }
                                        
                                        
                                    )
                            )
                    }
                }
                
                // draw scan line
                .chartBackground { proxy in
                    ZStack(alignment: .topLeading) {
                        GeometryReader { geo in
                            if let selectedElement1 = selectedElement1 {
                                let dateInterval = Calendar.current.dateInterval(of: .year, for: selectedElement1.yearMonth)!
                                let startPositionX = proxy.position(forX: dateInterval.start) ?? 0
                                let midStartPositionX = startPositionX + geo[proxy.plotFrame!].origin.x
                                let lineHeight = geo[proxy.plotFrame!].maxY
                                let boxWidth: CGFloat = 150
                                let boxOffset = max(0, min(geo.size.width - boxWidth, midStartPositionX - boxWidth / 2))
                                
                                Rectangle()
                                    .fill(.quaternary)
                                    .frame(width: 2, height: lineHeight)
                                    .position(x: midStartPositionX, y: lineHeight / 2)
                                
                                VStack(alignment: .leading) {
                                    Text("\(selectedElement1.yearMonth, format: .dateTime.year().month())")
                                        .font(.callout)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(width: boxWidth, alignment: .leading)
                                .background {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.background)
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.quaternary.opacity(0.7))
                                    }
                                    .padding([.leading, .trailing], -8)
                                    .padding([.top, .bottom], -4)
                                }
                                .offset(x: boxOffset)
                            }
                        }
                    }
                }
                .frame(height: 250)
                .padding()
                
                
                HStack {
                    Image( systemName: "circle.fill")
                        .foregroundStyle(.black)
                    Text("股價\(selectedElement1?.月平均收盤價 ?? 0.0, specifier: "%.2f")")
                        .foregroundStyle(.black)
                    Spacer()
                }

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
    
    func findElement1(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> StockRiverData? {
        let relativeXPosition = location.x - geometry[proxy.plotFrame!].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for dataIndex in level1DataEntriess.indices {
                let nthDataDistance = level1DataEntriess[dataIndex].yearMonth.distance(to: date)
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                    index = dataIndex
                }
            }
            if let index = index {
                return level1DataEntriess[index]
            }
            
        }
        return nil
    }
    
    func findElement2(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> StockRiverData? {
        let relativeXPosition = location.x - geometry[proxy.plotFrame!].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for dataIndex in level2DataEntriess.indices {
                let nthDataDistance = level2DataEntriess[dataIndex].yearMonth.distance(to: date)
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                    index = dataIndex
                }
            }
            if let index = index {
                return level2DataEntriess[index]
            }
            
        }
        return nil
    }
    
    func findElement3(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> StockRiverData? {
        let relativeXPosition = location.x - geometry[proxy.plotFrame!].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for dataIndex in level3DataEntriess.indices {
                let nthDataDistance = level3DataEntriess[dataIndex].yearMonth.distance(to: date)
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                    index = dataIndex
                }
            }
            if let index = index {
                return level3DataEntriess[index]
            }
            
        }
        return nil
    }
    
    func findElement4(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> StockRiverData? {
        let relativeXPosition = location.x - geometry[proxy.plotFrame!].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for dataIndex in level4DataEntriess.indices {
                let nthDataDistance = level4DataEntriess[dataIndex].yearMonth.distance(to: date)
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                    index = dataIndex
                }
            }
            if let index = index {
                return level4DataEntriess[index]
            }
            
        }
        return nil
    }
    
    func findElement5(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> StockRiverData? {
        let relativeXPosition = location.x - geometry[proxy.plotFrame!].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for dataIndex in level5DataEntriess.indices {
                let nthDataDistance = level5DataEntriess[dataIndex].yearMonth.distance(to: date)
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                    index = dataIndex
                }
            }
            if let index = index {
                return level5DataEntriess[index]
            }
            
        }
        return nil
    }
    
    func findElement6(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> StockRiverData? {
        let relativeXPosition = location.x - geometry[proxy.plotFrame!].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for dataIndex in level6DataEntriess.indices {
                let nthDataDistance = level6DataEntriess[dataIndex].yearMonth.distance(to: date)
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                    index = dataIndex
                }
            }
            if let index = index {
                return level6DataEntriess[index]
            }
            
        }
        return nil
    }
}



#Preview {
    ContentView()
}
