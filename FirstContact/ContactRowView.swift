//
//  ContactRowView.swift
//  FirstContact
//
//  Created by Bruce Gilmour on 2021-08-05.
//

import SwiftUI

struct ContactRowView: View {
    let contact: Contact

    var body: some View {
        HStack(alignment: .center) {
            contact.persistedImage
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.5, green: 0.5, blue: 0.5), lineWidth: 2)
                        .shadow(color: Color.gray, radius: 2)
                )
                .padding(.trailing, 4)

            VStack(alignment: .leading) {
                Text("\(contact.firstName) \(contact.lastName)")
                    .font(.title2)
                Text(contact.profession)
                    .font(.title3)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: contact.location != nil ? "location.fill" : "location.slash.fill")
                .foregroundColor(.purple)
        }
    }
}

struct ContactRowView_Previews: PreviewProvider {
    static var previews: some View {
        ContactRowView(contact: Contact.example1)
    }
}
