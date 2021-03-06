//
//  TransactionDetail.swift
//  wallet
//
//  Created by Francisco Gindre on 4/14/20.
//  Copyright © 2020 Francisco Gindre. All rights reserved.
//

import Foundation
import SwiftUI

struct TransactionDetails: View {
    
    var model: DetailModel
    @State var isCopyAlertShown: Bool = false
    var status: String {
        
        switch model.status {
        case .paid(let success):
           return success ? "Outbound" : "Unsent"
        case .received:
            return "Inbound"
            }
    }
    
    func copyToClipBoard(_ content: String) {
        UIPasteboard.general.string = content
        logger.debug("content copied to clipboard")
        self.isCopyAlertShown = true
    }
    
    var body: some View {
        ZStack {
            ZcashBackground()
            ScrollView([.vertical], showsIndicators: false) {
                SendZecView(zatoshi: .constant(model.zecAmount.toZecAmount()))
                Text(status).foregroundColor(.white)
                    .font(.largeTitle)
                Spacer()
                VStack(alignment: .center, spacing: 20) {
                    DetailCell(title: "Tx Id:" , description: model.id, action: self.copyToClipBoard)
                    DetailCell(title: "Date:", description: model.date.description)
                    DetailCell(title: "Shielded:", description: model.shielded ? "🛡" : "❌")
                    DetailCell(title: "Memo:", description: model.memo ?? "No memo" , action: self.copyToClipBoard)
                    DetailCell(title: "Address:", description: model.zAddress ?? "", action: self.copyToClipBoard).opacity( model.zAddress != nil ? 1.0 : 0)
                    
                }
                Spacer()
            }.padding(.horizontal, 40)
            
        }.alert(isPresented: self.$isCopyAlertShown) {
            Alert(title: Text(""),
                  message: Text("Copied to clipboard!"),
                  dismissButton: .default(Text("OK"))
            )
        }
        .navigationBarTitle("Transaction Detail", displayMode: .inline)
        .navigationBarBackButtonHidden(false)
    }
}

struct DetailCell: View {
    var title: String
    var description: String
    var action: ((String) -> Void)?
    var body: some View {
        VStack {
            Text(title).foregroundColor(.zYellow)
                .font(.title)
            Text(description)
                .foregroundColor(.white)
        }
        .onTapGesture {
            self.action?(self.description)
        }
    }
}

struct TransactionDetails_Previews: PreviewProvider {
    static var previews: some View {
        
        return TransactionDetails(model:
            DetailModel(
                id: "bb031",
                zAddress: "Ztestsapling1ctuamfer5xjnnrdr3xdazenljx0mu0gutcf9u9e74tr2d3jwjnt0qllzxaplu54hgc2tyjdc2p6",
                date: Date(),
                zecAmount: -12.345,
                status: .paid(success: true),
                subtitle: "1 of 10 confirmations"
                
            )
        )
    }
}
