//
//  CustomView.swift
//  norn
//
//  Created by nissy on 2021/10/14.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    @Binding var iseditting: Bool
    @Binding var variable: String
    @State var text: String

    
    var body: some View{
        TextField("\(text)",text: $variable,
                  onEditingChanged: { begin in
                    /// 入力開始処理
                    if begin {
                        self.iseditting = true
                        // 編集フラグをオン
                        /// 入力終了処理
                    } else {
                        self.iseditting = false   // 編集フラグをオフ
                    }
                  })
            //入力中に枠を青く強調表示
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            // 編集フラグがONの時に枠に影を付ける
            .shadow(color: iseditting ? .blue : .clear, radius: 3)

    }
}
