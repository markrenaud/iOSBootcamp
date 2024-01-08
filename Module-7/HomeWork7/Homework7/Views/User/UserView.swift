//
//  UserView.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct UserView: View {
    let user: User
    
    var body: some View {
        SimpleForm(sections: [
            // Personal details section
            SimpleFormSection(rows: [
                AsyncImageCard(
                    title: "\(user.name.first) \(user.name.last)",
                    subtitle: "\(user.dob.age) years old",
                    imageURL: user.photoURL
                )
            ]),
            
            // Geographical details section
            SimpleFormSection("Geographical Details", rows: [
                SimpleDestinationRow(label: "Location", detail: user.location.country, destination: userDetails),
                SimpleLabeledRow(label: "TimeZone", detail: user.location.timezone.description)
                
            ]),
            
            // Contact details section
            SimpleFormSection("Contact Details", rows: [
                SimpleLabeledRow(label: "Email", detail: user.email),
                SimpleLabeledRow(label: "Phone", detail: user.phone),
                SimpleLabeledRow(label: "Cell", detail: user.cell)

            ]),
            
            // User metadata section
            SimpleFormSection("User Metadata", rows: [
                SimpleLabeledRow(label: "Registered", detail: "\(user.registered.age) years ago"),
                SimpleDestinationRow(label: "Login", detail: user.login.username, destination: userLoginDetails)
            ])
            
        ])
    }
    
    var userDetails: some View {
        SimpleForm(sections: [
            SimpleFormSection(rows: [
                SimpleLabeledRow(label: "Street", detail: "\(user.location.street.number) \(user.location.street.name)"),
                SimpleLabeledRow(label: "City", detail: user.location.city),
                SimpleLabeledRow(label: "Country", detail: user.location.country),
                SimpleLabeledRow(label: "Postcode", detail: "\(user.location.postcode)"),
                MarkedMap(latitude: user.location.coordinates.latitude, longitude: user.location.coordinates.longitude)
            ])
        ])
    }
    
    var userLoginDetails: some View {
        SimpleForm(sections: [
            SimpleFormSection(rows: [
                SimpleLabeledRow(label: "Email", detail: user.email),
                SimpleLabeledRow(label: "Username", detail: user.login.username),
                SimpleLabeledRow(label: "UUID", detail: user.login.uuid)
            ])
        ])
    }
}

#Preview {
    NavigationStack {
        UserView(user: .paulina)
    }
}
