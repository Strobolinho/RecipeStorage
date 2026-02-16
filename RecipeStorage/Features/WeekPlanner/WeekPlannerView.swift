import SwiftUI
import SwiftData

struct WeekPlannerView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MealPlanEntry.day) private var mealplanEntries: [MealPlanEntry]
    @Query(sort: \GroceryListEntry.name) private var groceryEntries: [GroceryListEntry]

    @StateObject private var viewModel = WeekPlannerViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Text(viewModel.weekdayTitle(for: viewModel.date))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.brandPrimary)
                    .padding(.top, -50)

                TabView(selection: $viewModel.selectedIndex) {
                    ForEach(viewModel.dates.indices, id: \.self) { index in
                        DayPlannerPageView(
                            date: viewModel.dates[index],
                            entries: mealplanEntries,
                            isEditing: $viewModel.isEditing
                        )
                        .tag(index)
                        .padding(.top, 4)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onAppear {
                    viewModel.syncInitialDateWithSelectedIndex()
                }
                .onChange(of: viewModel.selectedIndex) { _, newValue in
                    viewModel.didSwipe(to: newValue)
                }
                .onChange(of: viewModel.date) { _, newValue in
                    if let idx = viewModel.targetIndexForDateChange(newValue) {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                            viewModel.selectedIndex = idx
                        }
                    }
                }
            }
            .toolbar {
                WeekPlannerToolbar(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showEntriesSheet) {
                MealPlanEntriesView()
            }
        }
    }
}

#Preview {
    WeekPlannerView()
}
