import SwiftUI
import ShortcutRecorder
import Sparkle

enum Tab {
    case settings, info
}

struct TabButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    let iconName: String
    
    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            Image(systemName: iconName)
                .frame(width: 40, height: 40)
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(selectedTab == tab ? .blue : .secondary)
    }
}

struct AppView: View {
    @State private var selectedTab: Tab = .settings
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            // Tab bar
            HStack {
                TabButton(tab: .settings, selectedTab: $selectedTab, iconName: "gear")
                TabButton(tab: .info, selectedTab: $selectedTab, iconName: "info.circle")
            }
            Button(action: {
                let apps = WindowManager.getAllWindows()
                SaveManager.save(apps: apps, category: "code")
                let newApps = SaveManager.load(category: "code")
                print(newApps)
            }) {
                Text("Get All Windows")
            }
            
            // Content area
            Group {
                switch selectedTab {
                case .settings:
                    SettingsView()
                case .info:
                    InfoView()
                }
            }
        }.frame(width: MAIN_WINDOW_WIDTH)
    }
}

// Preview
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
