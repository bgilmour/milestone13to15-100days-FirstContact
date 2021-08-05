//
//  AddContactView.swift
//  FirstContact
//
//  Created by Bruce Gilmour on 2021-08-05.
//

import SwiftUI

struct AddContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var contacts: Contacts
    @State private var showingImagePicker = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var profession = ""

    var body: some View {
        GeometryReader { geo in
            NavigationView {
                Form {
                    Section {
                        ZStack {
                            Text("Select\nPhoto")
                                .frame(width: 80, height: 80, alignment: .center)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.secondary.opacity(0.25))
                                )
                                .padding([.top, .bottom])

                            HStack {
                                Spacer()
                                image?
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width * 0.75)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.black, lineWidth: 4)
                                            .shadow(color: Color.gray, radius: 4)
                                    )
                                    .padding([.top, .bottom])
                                Spacer()
                            }
                        }
                        .onTapGesture {
                            showingImagePicker = true
                        }
                    }

                    Section {
                        TextField("First name", text: $firstName)
                        TextField("Last name", text: $lastName)
                    }

                    Section {
                        TextField("Profession", text: $profession)
                    }
                }
                .navigationBarTitle("New Contact")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    },
                    trailing: Button("Save") {
                        let imageUUID = saveImage()
                        contacts.entries.append(Contact(id: UUID(), firstName: firstName, lastName: lastName, profession: profession, image: imageUUID))
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(isSaveDisabled())
                )
                .onAppear(perform: {
                    showingImagePicker = true
                })
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: $inputImage)
                }
            }
        }
    }

    func isSaveDisabled() -> Bool {
        if image == nil || firstName.isEmpty || lastName.isEmpty {
            return true
        }
        return false
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }

    func saveImage() -> UUID {
        let imageUUID = UUID()
        // save image to persistent storage
        if let jpegData = inputImage?.jpegData(compressionQuality: 0.8) {
            let url = FileManager.default.getDocumentsDirectory().appendingPathComponent(imageUUID.uuidString)
            try? jpegData.write(to: url, options: [.atomicWrite])
        }
        return imageUUID
    }
}


struct AddContactView_Previews: PreviewProvider {
    static var previews: some View {
        AddContactView(contacts: Contacts())
    }
}
