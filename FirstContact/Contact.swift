//
//  Contact.swift
//  FirstContact
//
//  Created by Bruce Gilmour on 2021-08-04.
//

import SwiftUI

class Contacts: ObservableObject {
    @Published var entries = [Contact]() {
        didSet {
            let filename = FileManager.default.getDocumentsDirectory().appendingPathComponent("FirstContact")
            do {
                let data = try JSONEncoder().encode(entries)
                try data.write(to: filename, options: [.atomicWrite])
            } catch {
                print("Unable to save data: \(error.localizedDescription)")
            }
        }
    }

    init() {
        let filename = FileManager.default.getDocumentsDirectory().appendingPathComponent("FirstContact")

        do {
            let data = try Data(contentsOf: filename)
            entries = try JSONDecoder().decode([Contact].self, from: data)
        } catch {
            print("Unable to load saved data: \(error.localizedDescription)")
            entries = []
        }
    }
}

struct Contact: Identifiable {
    var id: UUID
    var firstName: String
    var lastName: String
    var profession: String
    var image: UUID

    var persistedImage: Image {
        let url = FileManager.default.getDocumentsDirectory().appendingPathComponent(image.uuidString)
        do {
            let data = try Data(contentsOf: url)
            if let uiImage = UIImage(data: data) {
                return Image(uiImage: uiImage)
            }
        } catch {
            // we should do something here but, for now, it can fall through to return the SF Symbol
        }
        return Image(systemName: "person")
    }
}

extension Contact: Codable {
    
}

extension Contact: Comparable {
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        if lhs.lastName < rhs.lastName {
            return true
        } else if lhs.lastName == rhs.lastName {
            return lhs.firstName < rhs.firstName
        }
        return false
    }
}

extension Contact {
    static let example1 = Contact(id: UUID(), firstName: "Taylor", lastName: "Swift", profession: "Singer", image: UUID())
    static let example2 = Contact(id: UUID(), firstName: "Billie", lastName: "Eilish", profession: "Singer", image: UUID())
    static let example3 = Contact(id: UUID(), firstName: "Bobby", lastName: "Swift", profession: "", image: UUID())
}
