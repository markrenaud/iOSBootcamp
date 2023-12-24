//
//  CategoryGrid.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct CategoryGrid: View {
    @Binding var tasks: [TaskItem]
    @Binding var selectedCategory: TaskCategory?
    
    var body: some View {
        let columns: [GridItem] = [
            GridItem(.adaptive(minimum: 120, maximum: 150))
        ]
        
        LazyVGrid(columns: columns) {
            ForEach(TaskCategory.allCases) { category in
                VStack {
                    Spacer()
                    Text(category.title)
                        .font(Constants.Font.gridTitle)
                    Spacer()
                    Text("\(tasks.count(of: category))")
                        .font(Constants.Font.gridCount)
                    Spacer()
                }
                .foregroundStyle(Constants.Color.gridText)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(1.0, contentMode: .fit)
                .background(category == selectedCategory ? Constants.Color.gridHighlightBackground : Constants.Color.gridBackground)
                .mask(RoundedRectangle(cornerRadius: 10))
                .onTapGesture { tapped(category) }
            }
        }
    }
    
    func tapped(_ category: TaskCategory) {
        withAnimation {
            if selectedCategory == category {
                selectedCategory = nil
            } else {
                selectedCategory = category
            }
        }
    }
}

#Preview {
    CategoryGrid(tasks: .constant(.sampleTasks), selectedCategory: .constant(.home))
        .padding()
}
