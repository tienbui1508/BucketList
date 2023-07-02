//
//  EditView.swift
//  BucketList
//
//  Created by Tien Bui on 30/6/2023.
//

import SwiftUI

struct EditView: View {
    @StateObject private var viewModel: ViewModel
    @Environment(\.dismiss) var dissmiss
    
    var onSAve: (Location) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            /*@START_MENU_TOKEN@*/Text(page.title)/*@END_MENU_TOKEN@*/
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    let newLocation = viewModel.createNewLocation()
                    onSAve(newLocation)
                    dissmiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlace()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
    
        self.onSAve = onSave
        _viewModel = StateObject(wrappedValue: ViewModel(location: location))
    }
    
    
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
