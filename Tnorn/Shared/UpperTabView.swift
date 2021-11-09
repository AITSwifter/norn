//
//  UpperTabView.swift
//  Tnorn
//
//  Created by nissy on 2021/11/09.
//

import SwiftUI

struct UpperTabView: View {
    // ボタンのタップで状態を変える 親Viewに状態を伝えるため @Binding をつけておく
    @Binding var selection: TabType
    let geometrySize: CGSize
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack(spacing: .zero) {
                Button(action: {
                    self.selection = .timetable
                }, label: {
                    Text("時刻表")
                        .font(.headline)
                        
                })
                .frame(width: geometrySize.width / 2, height: 44.0)
                Button(action: {
                    self.selection = .mytimetable
                }, label: {
                    Text("プリセット")
                        .font(.headline)
                })
                .frame(width: geometrySize.width / 2, height: 44.0)
            }
            Rectangle()
                .frame(width: geometrySize.width / 2, height: 2.0)
                .offset(x: self.selection == .timetable ? .zero: geometrySize.width / 2, y: .zero)
        }
    }
}
