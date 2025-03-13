//
//  BoxView.swift
//  Carely
//
//  Created by Daniele Fontana on 13/03/25.
//

import SwiftUI

struct BoxView: View {
    let icon: String
    let title: String
    let count: Int?
    let color: Color

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 228/255, green: 204/255, blue: 255/255),
                            Color(red: 200/255, green: 149/255, blue: 255/255)
                            
                        ]),
                        startPoint: .topTrailing,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.black)
                    Spacer()
                    if let count = count {
                        Text("\(count)")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                }

                Spacer()

                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .padding()
        }
        .frame(height: 130)
    }
}

struct BoxView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            BoxView(icon: "checkmark.seal", title: "Completed", count: 5, color: .green)
            BoxView(icon: "timer", title: "Scheduled", count: 0, color: .orange)
            BoxView(icon: "tray", title: "All", count: 10, color: .blue)
            BoxView(icon: "note.text", title: "Notes", count: nil, color: .purple)
        }
        .padding()
    }
}
