//
//  ContentView.swift
//  Some Year Some Day
//
//  Created by Henry Stephen on 2026/1/18.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    var calendar: Calendar = Calendar.current

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                TopBarView(
                    leftAction: { /* left */ },
                    rightAction: {
                        viewModel.startSearch()
                    },
                    title: "日记",
                    isSearching: viewModel.isSearching,
                    searchText: $viewModel.searchText,
                    onCancel: { viewModel.cancelSearch() }
                )
                .zIndex(2)

                // 主体内容可以在搜索时模糊
                VStack(spacing: 12) {
                    HStack {
                        Spacer()

                        WeekSelectorView(weekDays: viewModel.weekDays, selectedDate: viewModel.selectedDate, onSelect: { date in
                            viewModel.select(date: date)
                        }, calendar: viewModel.calendar)

                        // 右侧小面板与日历图标（点击会弹出日期选择器）
                        Rectangle()
                            .fill(Color(.systemGray4).opacity(0.25))
                            .frame(width: 1, height: 44)

                        Image(systemName: "calendar.day.timeline.right")
                            .font(.system(size: 20))
                            .foregroundColor(Color(.systemGray))
                            .background(Circle().fill(Color.clear))
                            .onTapGesture {
                                viewModel.openDatePicker(initial: nil)
                            }
                            .padding(.horizontal, 5)
                            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(UIColor.systemBackground).opacity(0.001)))
                            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color(.systemGray4).opacity(0.08), lineWidth: 0.5))
                            .padding(.trailing, 14)
                    }
                    .padding(.horizontal, 6)

                    Spacer()
                }
                .blur(radius: viewModel.isSearching ? 8 : 0)
                .disabled(viewModel.isSearching)
                .animation(.easeInOut, value: viewModel.isSearching)

                Spacer()
            }

            // dim overlay when searching
            if viewModel.isSearching {
                Color.white.opacity(0.6)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .zIndex(1)
                    .onTapGesture {
                        viewModel.cancelSearch()
                    }
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    LiquidGlassButton(systemName: "square.and.pencil", size: 54, isCircular: true, accent: Color.accentColor) {
                        // new diary
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 10)
                }
            }
        }
        // 日期选择弹窗（wheel 风格），选择后更新参考周与选中日期
        .sheet(isPresented: $viewModel.showDatePicker) {
            VStack(spacing: 16) {
                HStack {
                    // 左上角取消按钮（liquid glass 风格）
                    LiquidGlassButton(systemName: "xmark", size: 40, isCircular: true) {
                        // 取消筛选：只是关闭弹窗，不修改选中或参考日期
                        viewModel.showDatePicker = false
                    }
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.top, 20)

                // 将日期选择器的 locale 设置为中文（使月份显示为 1月/2月/...）
                DatePicker("", selection: $viewModel.pickerDate, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxHeight: 260)
                    .environment(\.locale, Locale(identifier: "zh_CN"))

                Button(action: {
                    viewModel.confirmDatePicker()
                }) {
                    Text("确定")
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(26)
                        .padding(.horizontal, 24)
                }

                Spacer()
            }
            .presentationDetents([.medium])
        }
        // Diary detail sheet
        .sheet(isPresented: $viewModel.showDiaryDetail) {
            VStack(spacing: 16) {
                HStack {
                    LiquidGlassButton(systemName: "xmark", size: 40, isCircular: true) {
                        viewModel.closeDiaryDetail()
                    }
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.leading, 20)

                if let diary = viewModel.selectedDiary {
                    DiaryCardView(model: diary)
                        .padding()

                    Text(diary.moodText ?? "")
                        .font(.body)
                        .padding(.horizontal, 20)

                    Text(DateFormatter.localizedString(from: diary.timestamp, dateStyle: .long, timeStyle: .short))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .presentationDetents([.medium])
        }
        .onAppear { viewModel.selectedDate = viewModel.today; viewModel.referenceDate = viewModel.today }
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel())
}
