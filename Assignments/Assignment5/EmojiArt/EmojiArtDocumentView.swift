//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Brian Coleman on 2022-06-21.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    let defaultEmojiFontSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            palette
        }
    }
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.overlay(
                    OptionalImage(uiImage: document.backgroundImage)
                        .scaleEffect(zoomScale)
                        .position(convertFromEmojiCoordinates((0,0), in: geometry))
                )
                .gesture(doubleTapToZoom(in: geometry.size).exclusively(before: tapToDeSelect()))
                if document.backgroundImageFetchStatus == .fetching {
                    ProgressView().scaleEffect(2)
                } else {
                    ForEach(document.emojis) { emoji in
                        Text(emoji.text)
                            .font(.system(size: fontSize(for: emoji)))
                            .border(isSelected(emoji) ? Color.black : Color.clear)
                            .scaleEffect(zoomScale)
                            .position(position(for: emoji, in: geometry))
                            .gesture(tapToSelect(emoji).simultaneously(with: longPressToDelete(on: emoji)))
                    }
                }
            }
            .clipped()
            .onDrop(of: [.plainText, .url, .image], isTargeted: nil) { providers, location in
                return drop(providers: providers, at: location, in: geometry)
            }
            //.gesture(panGesture().simultaneously(with: zoomGesture()))
            .gesture(selectedEmojis.count == 0 ? panGesture().simultaneously(with: zoomGesture()) : nil)
            .gesture(selectedEmojis.count > 0 ? panGestureOfEmoji().simultaneously(with: zoomGestureOfEmoji()) : nil)
            .alert("Delete Emoji?", isPresented: $showDeleteAlert, presenting: deleteEmoji) { deleteEmoji in
                    deleteEmojiOnDemand(for: deleteEmoji)
            }
        }
    }
    
    // MARK: - Drag and Drop
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            document.setBackground(.url(url.imageURL))
        }
        if !found {
            found = providers.loadObjects(ofType: UIImage.self) { image in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    document.setBackground(.imageData(data))
                }
            }
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                if let emoji = string.first, emoji.isEmoji {
                    document.addEmoji(
                        String(emoji),
                        at: convertToEmojiCoordinates(location, in: geometry),
                        size: defaultEmojiFontSize / zoomScale
                    )
                }
            }
        }
        return found
    }
    
    // MARK: - Positioning/Sizing Emoji
    
    private func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }
    
    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(
            x: (location.x - panOffset.width - center.x) / zoomScale,
            y: (location.y - panOffset.height - center.y) / zoomScale
        )
        return (Int(location.x), Int(location.y))
    }
    
    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + CGFloat(location.x) * zoomScale + panOffset.width,
            y: center.y + CGFloat(location.y) * zoomScale + panOffset.height
        )
    }
    
    // MARK: - Zooming
    
    @State private var steadyStateZoomScale: CGFloat = 1
    @GestureState private var gestureZoomScale: CGFloat = 1
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                steadyStateZoomScale *= gestureScaleAtEnd
            }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0  {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
    // MARK: - Panning
    
    @State private var steadyStatePanOffset: CGSize = CGSize.zero
    @GestureState private var gesturePanOffset: CGSize = CGSize.zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, _ in
                gesturePanOffset = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                steadyStatePanOffset = steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale)
            }
    }
    
    // MARK: - Emoji panning
    
    @GestureState private var gesturePanOffsetOfEmoji: CGSize = CGSize.zero
    
    private func panGestureOfEmoji() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffsetOfEmoji) { latestDragGestureValue, gesturePanOffsetOfEmoji, _ in
                moveChosenEmojis(by: latestDragGestureValue.translation / zoomScale - gesturePanOffsetOfEmoji)
                gesturePanOffsetOfEmoji = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                moveChosenEmojis(by: (gesturePanOffsetOfEmoji / zoomScale))
            }
    }
    
    // MARK: - Emoji Zoom
        
    @GestureState private var gestureZoomScaleOfEmoji: CGFloat = 1
    
    private var zoomScaleOfEmoji: CGFloat {
        gestureZoomScaleOfEmoji
    }
    
    private func zoomGestureOfEmoji() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScaleOfEmoji) { latestGestureScale, gestureZoomScaleOfEmoji, _ in
                gestureZoomScaleOfEmoji = latestGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                scaleChosenEmojis(by: gestureScaleAtEnd)
            }
    }
    
    private func scaleChosenEmojis(by scale: CGFloat) {
        selectedEmojis.forEach { emoji in
            document.scaleEmoji(emoji, by: scale)
        }
    }
    
    private func moveChosenEmojis(by offset: CGSize) {
        selectedEmojis.forEach { emoji in
            document.moveEmoji(emoji, by: offset)
        }
    }
    
    // MARK: - Selecting/Deselect Emoji
    
    @State private var selectedEmojis: Set<EmojiArtModel.Emoji> = []
    
    private func tapToSelect(_ emoji: EmojiArtModel.Emoji) -> some Gesture {
        TapGesture()
            .onEnded {
                selectedEmojis.toggleMembership(of: emoji)
            }
    }
    
    private func tapToDeSelect() -> some Gesture {
        TapGesture()
            .onEnded {
                selectedEmojis.removeAll()
            }
    }
    
    private func isSelected(_ emoji: EmojiArtModel.Emoji) -> Bool {
        selectedEmojis.contains(where: {$0.id == emoji.id})
    }
    
    // MARK: - Delete Emoji

    @State private var showDeleteAlert = false
    @State private var deleteEmoji: EmojiArtModel.Emoji?
    
    private func longPressToDelete(on emoji: EmojiArtModel.Emoji) -> some Gesture {
        LongPressGesture(minimumDuration: 1.2)
            .onEnded { LongPressStateAtEnd in
                if LongPressStateAtEnd {
                    deleteEmoji = emoji
                    showDeleteAlert.toggle()
                } else {
                    deleteEmoji = nil
                }
            }
    }
    
    @available(iOS 15.0, *)
    private func deleteEmojiOnDemand(for emoji: EmojiArtModel.Emoji) -> some View {
        Button(role: .destructive) {
            if selectedEmojis.contains(emoji) { selectedEmojis.remove(emoji) }
            document.removeEmoji(emoji)
        } label: { Text("Yes") }
    }
    
    // MARK: - Palette
    
    var palette: some View {
        ScrollingEmojisView(emojis: testEmojis)
            .font(.system(size: defaultEmojiFontSize))
    }
    
    let testEmojis = "😀😷🦠💉👻👀🐶🌲🌎🌞🔥🍎⚽️🚗🚓🚲🛩🚁🚀🛸🏠⌚️🎁🗝🔐❤️⛔️❌❓✅⚠️🎶➕➖🏳️"
}

struct ScrollingEmojisView: View {
    let emojis: String

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag { NSItemProvider(object: emoji as NSString) }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}
