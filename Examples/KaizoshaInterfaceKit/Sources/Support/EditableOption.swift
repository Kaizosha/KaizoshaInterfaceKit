import SwiftUI

struct EditableOption: Identifiable {
    let id: Int
    var title: String
    var tint: Color = .primary
    var foreground: Color = .primary
    var selectedForeground = Color(uiColor: .systemBackground)
}
