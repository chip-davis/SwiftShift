import SwiftUI

struct InfoView: View {
    private var version: String? = nil
    
    init(hasPermissions: Bool = false) {
        self.version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    var body: some View {
        Group {
            VStack {
                HStack(alignment: .bottom) {
                    Text("⌘ Swift Shift").font(.headline)
                    if version != nil {
                        Text("v" + version!).font(.subheadline)
                    }
                }.padding(.bottom)
                
                Text("Made with 🩵 by")
                
                Button(action: {
                    guard let url = URL(string: "https://pablopunk.com") else {
                        print("Invalid URL")
                        return
                    }
                    NSWorkspace.shared.open(url)
                }, label: {
                    Text("Pablo Varela")
                }).buttonStyle(.link)
                
            }
            
            VStack {
                CheckUpdatesButton(label: "Check for updates").buttonStyle(.borderedProminent)
                Button(action: {
                    guard let url = URL(string: "https://github.com/pablopunk/SwiftShift") else {
                        print("Invalid URL")
                        return
                    }
                    NSWorkspace.shared.open(url)
                }, label: {
                    Image(systemName: "swift")
                    Text("Go to Open Source Project")
                })
            }
        }.padding()
            
            Divider()
            
            HStack {
                Button(action: {
                    NSApplication.shared.terminate(0)
                }, label: {
                    HStack {
                        Text("Quit")
                        Text("⌘+Q").foregroundStyle(.gray).font(.subheadline)
                    }
                })
                .keyboardShortcut("Q", modifiers: .command)
                
                Spacer()
            }.padding()
    }
}

#Preview {
    InfoView().frame(width: MAIN_WINDOW_WIDTH)
}