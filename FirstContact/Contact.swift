//
//  Contact.swift
//  FirstContact
//
//  Created by Bruce Gilmour on 2021-08-04.
//

import SwiftUI
import CoreLocation

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

struct Contact: Identifiable, Codable {
    var id: UUID
    var firstName: String
    var lastName: String
    var profession: String
    var image: UUID
    var location: CLLocationCoordinate2D?

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

    enum CodingKeys: CodingKey {
        case id, firstName, lastName, profession, image, latitude, longitude
    }

    init(id: UUID, firstName: String, lastName: String, profession: String, image: UUID, location: CLLocationCoordinate2D? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.profession = profession
        self.image = image
        self.location = location
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        profession = try container.decode(String.self, forKey: .profession)
        image = try container.decode(UUID.self, forKey: .image)

        if let latitude = try? container.decode(CLLocationDegrees.self, forKey: .latitude) {
            if let longitude = try? container.decode(CLLocationDegrees.self, forKey: .longitude) {
                location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(profession, forKey: .profession)
        try container.encode(image, forKey: .image)

        if let location = location {
            try container.encode(location.latitude, forKey: .latitude)
            try container.encode(location.longitude, forKey: .longitude)
        }
    }
}

extension Contact: Comparable {
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
    }

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
    static let example1 = Contact(id: UUID(), firstName: "Taylor", lastName: "Swift", profession: "Singer", image: UUID(), location: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13))
    static let example2 = Contact(id: UUID(), firstName: "Billie", lastName: "Eilish", profession: "Singer", image: UUID())
    static let example3 = Contact(id: UUID(), firstName: "Bobby", lastName: "Swift", profession: "", image: UUID())
}
