import SwiftUI

struct SwiftUIView: View {
    @State private var textFieldEntry: String = ""
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ZStack {
  
                        if textFieldEntry.isEmpty {
                            Text("Reflect on your day..")
                                .padding(.all, 8)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .opacity(0.25)
                        }
                        
                        TextEditor(text: $textFieldEntry)
                            .opacity(textFieldEntry.isEmpty ? 0.40 : 1)
                        Text(textFieldEntry).opacity(0).padding(.all, 8)
                            


                    }
                    .listRowSeparator(.hidden)
                    
                    Label("Sant Josep de Sa Talaia", systemImage: "location.fill")
                        .foregroundColor(.secondary)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
            .navigationTitle("SwiftUI")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { print("Pressed") }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        print("Pressed")
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Create a tweet")
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
