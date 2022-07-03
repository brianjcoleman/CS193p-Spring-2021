//
//  PaletteManager.swift
//  EmojiArt
//
//  Created by Brian Coleman on 2022-06-28.
//

import SwiftUI

struct PaletteManager: View {
    @EnvironmentObject var store: PaletteStore
    
    // a Binding to a PresentationMode
    // which lets us dismiss() ourselves if we are isPresented
    @Environment(\.presentationMode) var presentationMode
    
    // we inject a Binding to this in the environment for the List and EditButton
    // using the \.editMode in EnvironmentValues
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.palettes) { palette in
                    // tapping on this row in the List will navigate to a PaletteEditor
                    // (not subscripting by the Identifiable)
                    // (see the subscript added to RangeReplaceableCollection in UtilityExtensiosn)
                    NavigationLink(destination: PaletteEditor(palette: $store.palettes[palette])) {
                        VStack(alignment: .leading) {
                            Text(palette.name)
                            Text(palette.emojis)
                        }
                        // tapping when NOT in editMode will follow the NavigationLink
                        // (that's why gesture is set to nil in that case)
                        .gesture(editMode == .active ? tap : nil)
                    }
                }
                // teach the ForEach how to delete items
                // at the indices in indexSet from its array
                .onDelete { indexSet in
                    store.palettes.remove(atOffsets: indexSet)
                }
                // teach the ForEach how to move items
                // at the indices in indexSet to a newOffset in its array
                .onMove { indexSet, newOffset in
                    store.palettes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .navigationTitle("Manage Palettes")
            .navigationBarTitleDisplayMode(.inline)
            .dismissable { presentationMode.wrappedValue.dismiss() }
            .toolbar { EditButton() }
            // see comment for editMode @State above
            .environment(\.editMode, $editMode)
        }
    }
    
    var tap: some Gesture {
        TapGesture().onEnded { }
    }
}

struct PaletteManager_Previews: PreviewProvider {
    static var previews: some View {
        PaletteManager()
            .previewDevice("iPhone 8")
            .environmentObject(PaletteStore(named: "Preview"))
            .preferredColorScheme(.light)
    }
}
