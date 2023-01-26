//
//  ExpandableParagraph.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/26/23.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self,
                                value: geometry.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}
    
struct ExpandableParagraph: View {
    @State private var expandedSize: CGSize = .zero
    @State private var limitedSize: CGSize = .zero
    @State private var needsExpandRow = false
    @State private var isExpanded = false
    
    let text: String
    let lineLimit: Int?
    var body: some View {
        VStack {
            HStack {
                if isExpanded {
                    labelView()
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    labelView()
                        .lineLimit(lineLimit)
                        .readSize { size in
                            limitedSize = size
                            updateNeedsExpandable(expandable: limitedSize != expandedSize)
                        }
                        .background(
                            labelView()
                                .fixedSize(horizontal: false, vertical: true)
                                .hidden()
                                .readSize { size in
                                    expandedSize = size
                                    updateNeedsExpandable(expandable: limitedSize != expandedSize)
                                }
                        )
                }
            }
            .padding(.horizontal, Device.isIpad ? 24.0 : 16.0)
            .padding(.top, Device.isIpad ? 12.0 : 8.0)
            if needsExpandRow {
                HStack {
                    Spacer()
                    ExpandCollapseButton(isExpanded: isExpanded) {
                        withAnimation {
                            isExpanded = !isExpanded
                        }
                    }
                    .transition(.scale(scale: 1.0))
                }
                .padding(.horizontal, Device.isIpad ? 12.0 : 8.0)
            }
            Spacer()
                .frame(height: Device.isIpad ? 12.0 : 8.0)
        }
        .box(backgroundColor: Color("theme2_yale"),
                 strokeColor: Color("theme1_saffron"),
                 cornerRadius: 12.0,
                 strokeWidth: Device.isIpad ? 2.0 : 1.0)
        .clipShape(RoundedRectangle(cornerRadius: 12.0))
        .padding(.horizontal, Device.isIpad ? 12.0 : 8.0)
    }
    
    private func labelView() -> some View {
        Text(text)
            .font(.system(size: Device.isIpad ? 22.0 : 16.0))
            .foregroundColor(Color("theme2_banana"))
            .transition(.slide.combined(with: .opacity))
    }
    
    private func updateNeedsExpandable(expandable: Bool) {
        DispatchQueue.main.async {
            needsExpandRow = expandable
        }
    }
}

struct ExpandableParagraph_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ExpandableParagraph(text: "Hello hello, what is up today. This is a sentence which is a long sentence. It continues on for quite a while. Words just keep coming and coming. Words on words, letters on letters. They flow and flow. Like diarrhea from the buffalo. Continuous words.",
                                lineLimit: 3)
            ExpandableParagraph(text: "Hello hello",
                                lineLimit: 3)
        }
    }
}
