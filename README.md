# Milestone13to15 (FirstContact)

This is an implementation of the milestone challenge which was to create a simple contact app that would allow the user to select a photo, add a name (and a profession in this version), and display the saved contacts in a list. Selecting a contact from the list displays a detail view with a larger version of the photo than that displayed in the list. The contact data is persisted to the document directory as a JSON file. The selected photos are also persisted in the documents directory and use the UUID from the JSON source as their filename.

The milestone challenge follows on from projects 13 to 15 in the [100 Days Of SwiftUI](https://www.hackingwithswift.com/100/swiftui/) tutorial created by Paul Hudson ([@twostraws](https://github.com/twostraws)).

The next challenge was to allow location information to be added when a new contact is added. I made this optional and added an indicator to the row view on the main content screen to show whether location info was present or not. If present then a map view is displayed in the contact view with the map centred on the saved location and zoomed in to +/- 0.5 degrees of latitude and longitude.
