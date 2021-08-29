//
//  TextViewState.swift
//  
//
//  Created by Simon Støvring on 16/01/2021.
//

import Foundation

public final class TextViewState {
    let text: String
    let stringView: StringView
    let theme: Theme
    let lineManager: LineManager
    let languageMode: LanguageMode

    public private(set) var detectedIndentStrategy: DetectedIndentStrategy = .unknown

    public init(text: String, theme: Theme, language: TreeSitterLanguage? = nil) {
        self.text = text
        self.theme = theme
        self.stringView = StringView(string: NSMutableString(string: text))
        self.lineManager = LineManager(stringView: stringView)
        if let language = language {
            self.languageMode = TreeSitterLanguageMode(language: language, stringView: stringView, lineManager: lineManager)
        } else {
            self.languageMode = PlainTextLanguageMode()
        }
        prepare()
    }
}

private extension TextViewState {
    private func prepare() {
        let nsString = text as NSString
        lineManager.estimatedLineHeight = theme.font.lineHeight
        lineManager.rebuild(from: nsString)
        languageMode.parse(nsString)
        detectedIndentStrategy = languageMode.detectIndentStrategy()
    }
}
