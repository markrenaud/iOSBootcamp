//
//  User.swift
//  Created by Mark Renaud (2023).
//

import Foundation

struct User: Codable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dob: AgedDate
    let registered: AgedDate
    let phone: String
    let cell: String
    let id: ID
    let picture: Picture
    let nat: String
}

extension User {
    struct Name: Codable {
        let title: String
        let first: String
        let last: String
    }
    
    struct Location: Codable {
        let street: Street
        let city: String
        let state: String
        let country: String
        let postcode: Int
        let coordinates: Coordinates
        let timezone: TimeZone
        
        struct Street: Codable {
            let number: Int
            let name: String
        }
        struct Coordinates: Codable {
            let latitude: String
            let longitude: String
        }
        struct TimeZone: Codable {
            let offset: String
            let description: String
        }
    }
    
    struct Login: Codable {
        let uuid: String
        let username: String
        let password: String
        let salt: String
        let md5: String
        let sha1: String
        let sha256: String
    }
    
    struct AgedDate: Codable {
        let date: Date
        /// The age (in years) from the `date` property to now.
        ///
        /// (Disregard the incoming JSON `age`, and calculate based of the difference
        /// between the current data and the user's date of birth - so it is always up-to-date)
        var age: Int {
            let cal = Calendar.current
            let dobComponents = cal.dateComponents([.year], from: date)
            let nowComponents = cal.dateComponents([.year], from: Date.now)
            
            return (nowComponents.year ?? -1) - (dobComponents.year ?? -1)
        }
        
        private static let dateFormatter: ISO8601DateFormatter = {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter
        }()
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let dateString = try container.decode(String.self, forKey: .date)
            self.date = AgedDate.dateFormatter.date(from: dateString) ?? Constants.DateReference.placeholder
            // ignore decoding the age, we will compute this directly from
            // the date of birth to ensure it is accurate.
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            let dateString = AgedDate.dateFormatter.string(from: date)
            try container.encode(dateString, forKey: .date)
            try container.encode(self.age, forKey: .age)
        }

        enum CodingKeys: CodingKey {
            case date
            case age
        }

    }
    
    // Make Hashable so can also use as a property for Identifiable
    struct ID: Codable, Hashable {
        let name: String
        let value: String
    }
    
    struct Picture: Codable {
        let large: String
        let medium: String
        let thumbnail: String
    }
}

extension User: Identifiable {}

extension User {
    static let paulina = UserResults.sample.users[0]
    
    var photoURL: URL? {
        URL(string: picture.large)
    }
}
