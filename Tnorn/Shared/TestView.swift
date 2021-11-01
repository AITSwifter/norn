//
//  TestView.swift
//  Tnorn
//
//  Created by nissy on 2021/10/20.
//

import SwiftUI

struct TestView: View {
    @State var showingTextField = false
    @State var text = ""
    
    var body: some View {
        return VStack {
            if showingTextField {
                TextField("入力してください", text: $text)
            }
            Button(action: { self.showingTextField.toggle() }) {
                Text ("Show")
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
