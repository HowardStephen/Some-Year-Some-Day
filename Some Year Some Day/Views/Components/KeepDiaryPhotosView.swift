import SwiftUI
import PhotosUI
import Photos

struct KeepDiaryPhotosView: View {
    @ObservedObject var vm: KeepDiaryViewModel
    @State private var images: [String: UIImage] = [:]

    var body: some View {
        VStack {
            if vm.context.photoIDs.isEmpty {
                Text("今日无照片")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 12)], spacing: 12) {
                        ForEach(vm.context.photoIDs, id: \.self) { id in
                            ZStack(alignment: .topTrailing) {
                                if let ui = images[id] {
                                    Image(uiImage: ui)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(8)
                                } else {
                                    Rectangle()
                                        .fill(Color(.systemGray5))
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(8)
                                }

                                Button(action: {
                                    // toggle selection: remove if present
                                    if let idx = vm.context.photoIDs.firstIndex(of: id) {
                                        vm.context.photoIDs.remove(at: idx)
                                        vm.photosSelected = !vm.context.photoIDs.isEmpty
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.white)
                                        .background(Circle().fill(Color.black.opacity(0.5)))
                                }
                                .padding(6)
                            }
                            .onAppear {
                                loadThumbnail(for: id)
                            }
                        }
                    }
                    .padding()
                }
            }

            Spacer()

            PhotosPicker(selection: Binding(get: { [] as [PhotosPickerItem] }, set: { _ in }), matching: .images, photoLibrary: .shared()) {
                Text("从相册选择")
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
                    .padding(.horizontal)
            }
            .onChange(of: /* no-op */ 0) { _ in }
            .padding(.bottom)
        }
        .navigationTitle("照片")
        .onAppear {
            // thumbnails will be loaded on appear
        }
    }

    private func loadThumbnail(for id: String) {
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
        guard let asset = assets.firstObject else { return }
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isSynchronous = false
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: options) { img, _ in
            if let img = img {
                images[id] = img
            }
        }
    }
}
