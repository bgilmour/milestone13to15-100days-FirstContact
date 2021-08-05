//
//  FileManager-extension.swift
//  FirstContact
//
//  Created by Bruce Gilmour on 2021-08-05.
//

import Foundation

extension FileManager {
    func getDocumentsDirectory() -> URL {
        let paths = self.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
