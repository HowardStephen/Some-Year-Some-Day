import SwiftUI
import MapKit

struct KeepDiaryMapView: View {
    @ObservedObject var vm: KeepDiaryViewModel
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.00902), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @State private var annotations: [MKPointAnnotation] = []

    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: vm.context.locations) { loc in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)) {
                    VStack {
                        Image(systemName: "mappin")
                            .font(.title)
                            .foregroundColor(.red)
                        Text(loc.name ?? "")
                            .font(.caption2)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .frame(height: 300)

            Button(action: {
                // place a pin at current center
                let center = region.center
                let id = UUID().uuidString
                let ref = DiaryContext.LocationRef(id: id, name: "Pinned", latitude: center.latitude, longitude: center.longitude)
                vm.context.locations.append(ref)
                vm.locationsSelected = !vm.context.locations.isEmpty
            }) {
                Text("在此放置图钉")
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
                    .padding(.horizontal)
            }

            Spacer()
        }
        .navigationTitle("地图")
    }
}
