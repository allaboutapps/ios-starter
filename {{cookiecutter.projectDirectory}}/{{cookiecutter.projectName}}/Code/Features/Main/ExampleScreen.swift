import SwiftUI
import Toolbox

struct ExampleScreen: View {
    
    // MARK: Interface
    
    var onDismiss: (() -> Void)?
    
    // MARK: Private
    
    @State private var selectedColor: Color = .black
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    // MARK: Body
    
    var body: some View {
        VStack(spacing: Style.Padding.triple) {
            Text("Hello, from SwiftUI 👋!")
                .foregroundColor(selectedColor)
            
            Button(action: {
                onDismiss?()
            }, label: {
                Text("Dismiss!")
            })
            .padding(.horizontal, Style.Padding.double)
            .padding(.vertical, Style.Padding.single)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .onReceive(timer) { _ in
            changeColor()
        }
    }
    
    // MARK: Action
    
    private func changeColor() {
        let colors: [Color] = [.red, .blue, .green, .orange, .pink, .purple, .yellow]
        
        withAnimation {
            selectedColor = colors.randomElement() ?? .black
        }
    }
}

struct ExampleScreen_Previews: PreviewProvider {
    static var previews: some View {
        ExampleScreen()
    }
}
