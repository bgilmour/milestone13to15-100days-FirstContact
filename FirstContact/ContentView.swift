//
//  ContentView.swift
//  FirstContact
//
//  Created by Bruce Gilmour on 2021-08-04.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var contacts = Contacts()
    @State private var showingAddContact = false

    var body: some View {
        NavigationView {
            List(contacts.entries.sorted()) { contact in
                NavigationLink(destination: ContactView(contact: contact)) {
                    ContactRowView(contact: contact)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("FirstContact")
            .navigationBarItems(trailing: Button(action: {
                showingAddContact = true
            }) {
                Text("Add")
            })
            .sheet(isPresented: $showingAddContact) {
                AddContactView(contacts: contacts)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
