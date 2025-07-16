import Foundation
import SwiftUI

@Observable
class AppData {
    var child1 = Child1Data() // Nested observation - Highest level of redraw isolation constrainted to child
    var child2 = 0 // Raw observation - Will prompt shallow redraw of the parent
    var child3 = 0 // Another raw observation - Behave similarly to Child4
    // No child4, it is not dependent at all from this observation
}

@Observable
class Child1Data {
    var count = 0
}

struct Child3Data {
    var count = 0
}

struct ObservationDemo: View {
    @State var appData = AppData()

    var body: some View {
        let _ = Self._printChanges()
        VStack(spacing: 20) {
            ControlsView(appData: appData)

            Child1(data: appData.child1)
            Child2(count: appData.child2)
            Child3(count: appData.child3)
            Child4(viewModel: Child4ViewModel())
        }
        .padding()
        .debugMode()
    }
}

extension ObservationDemo: Equatable {
    static func == (lhs: ObservationDemo, rhs: ObservationDemo) -> Bool {
        return lhs.appData.child2 == rhs.appData.child2
    }
}

// MARK: - Controls View
struct ControlsView: View {
    var appData: AppData

    var body: some View {
        VStack(spacing: 20) {
            Text("Controls")
                .font(.headline)
            Button("Increment Child 1 Count") {
                appData.child1.count += 1
            }
            Button("Increment Child 2 Count") {
                appData.child2 += 1
            }
            Button("Increment Child 3 Count") {
                appData.child3 += 1
            }

        }
        .padding()
        .debugMode()
    }
}

struct Child1: View {
    var data: Child1Data

    var body: some View {
        Text("Child 1 - Count: \(data.count)")
            .padding(10)
            .debugMode()
    }
}

struct Child2: View {
    let count: Int

    let nonDiffable: () -> Int = { 0 }

    var body: some View {
        Text("Child 2 - Count: \(count)")
            .padding(10)
            .debugMode()
    }
}

struct Child3: View {
    let count: Int

    var body: some View {
        Text("Child 3 - Count: \(count)")
            .padding(10)
            .debugMode()
    }
}


struct Child4: View {
    struct GrandChild: View {
        let count: Int

        var body: some View {
            Text("Grand Child \(count)")
                .padding(10)
                .debugMode() // Observe that the nested view does not get recomputed
        }
    }
    // Adding a viewmodel like this breaks view diffing:
    // https://medium.com/airbnb-engineering/understanding-and-improving-swiftui-performance-37b77ac61896
    @State var viewModel: Child4ViewModel

    // Adding a primitive like this is fine for diffing
    @State var count: Int = 0

    init(viewModel: Child4ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text("Child 4 - Count: \(viewModel.count)")
                .padding(10)
            GrandChild(count: viewModel.grandChildCount)
            GrandChild(count: count)
        }
        .padding()
        .debugMode()
    }
}


@Observable
class Child4ViewModel {
    var count: Int = 0
    var grandChildCount: Int = 0
    private var timer: Timer?

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.count += 1
        }
    }

    deinit {
        timer?.invalidate()
    }
}

// An alternative to making the SwiftUI view itself equatable is making the viewmodel equatable.
//extension Child4ViewModel: Equatable {
//    static func == (lhs: Child4ViewModel, rhs: Child4ViewModel) -> Bool {
//        print("checking equatable child4vm")
//        return true
//    }
//}


// We can make the child equatable explicitly to bring back efficient view diffing. But lots of boilerplate
//extension Child4: Equatable {
//    static func == (lhs: Child4, rhs: Child4) -> Bool {
//        print("checking equatable child4")
//        return true
//    }
//}

#Preview {
    ObservationDemo()
}
