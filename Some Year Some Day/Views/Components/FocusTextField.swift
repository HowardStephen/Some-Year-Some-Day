//
//  FocusTextField.swift
//  Some Year Some Day
//
//  Created by Henry Stephen on 2026/1/20.
//

import SwiftUI

// A small UIViewRepresentable to control first responder behavior for a TextField.
struct FocusTextField: UIViewRepresentable {
    @Binding var text: String
    var isFirstResponder: Bool
    var placeholder: String = "搜索"

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        init(text: Binding<String>) {
            _text = text
        }
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(text: $text) }

    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField(frame: .zero)
        tf.placeholder = placeholder
        tf.delegate = context.coordinator
        tf.returnKeyType = .search
        tf.borderStyle = .none
        tf.backgroundColor = .clear
        return tf
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        if isFirstResponder && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        } else if !isFirstResponder && uiView.isFirstResponder {
            uiView.resignFirstResponder()
        }
    }
}
