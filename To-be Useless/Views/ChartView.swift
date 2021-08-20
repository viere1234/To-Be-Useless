//
//  ChartView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/8/11.
//

import SwiftUI
import SwiftUICharts

struct ChartView: View {
    
    //@State var chartData: [Double] = [0, 5, 6, 2, 13, 4, 3, 6]
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title", legend: "Legendary") // legend is optional
                
                Spacer()
                
                MultiLineChartView(data: [([8,32,11,23,40,28], GradientColors.green), ([90,99,78,111,70,60,77], GradientColors.purple), ([34,56,72,38,43,100,50], GradientColors.orngPink)], title: "Title")


                Spacer()
            }
            
            LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title", legend: "Legendary") // legend is optional


        }
    }
}

#if DEBUG
struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
#endif
