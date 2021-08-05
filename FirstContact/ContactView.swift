//
//  ContactView.swift
//  FirstContact
//
//  Created by Bruce Gilmour on 2021-08-05.
//

import SwiftUI

struct ContactView: View {
    let contact: Contact

    var body: some View {
        GeometryReader { geo in
            NavigationView {
                VStack {
                    HStack {
                        Spacer()
                        contact.persistedImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.75)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(red: 0.5, green: 0.5, blue: 0.5), lineWidth: 4)
                                    .shadow(color: Color.gray, radius: 4)
                            )
                            .padding(.bottom)
                        Spacer()
                    }

                    Text("\(contact.firstName) \(contact.lastName)")
                        .font(.largeTitle)
                        .padding(.top)

                    if !contact.profession.isEmpty {
                        Text(contact.profession)
                            .font(.title)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView(contact: Contact.example1)
    }
}
