//
//  File.swift
//  metaoneSDKDemo
//
//  Created by Marius Šilenskis on 2023-08-22.
//

import Foundation
import metaoneSDK

public let defaultTheme = AppConfig.ColorsScheme()
public let lightTheme = defaultTheme
public let darkTheme = defaultTheme.withOverrides(overrides: [
    // App Background
    "background": "#18191E",

    // Primary
    "primary": "#0066FF",
    "primary80": "#0066FFCC",
    "primary60": "#0066FF99",
    "primary40": "#0066FF66",
    "primary20": "#417FF633",

    // Secondary
    "secondary": "#604EFF",
    "secondary80": "#604EFFCC",
    "secondary60": "#604EFF99",
    "secondary40": "#604EFF66",
    "secondary20": "#604EFF33",
    "secondary15": "#604EFF25",

    // Buttons
    "primaryButtonBg": "#386CF3",
    "primaryButtonBgDisabled": "#0066FF99",
    "primaryButtonText": "#FFFFFF",
    "secondaryButtonBg": "#417FF633",
    "secondaryButtonBgDisabled": "#417FF633",
    "secondaryButtonText": "#386CF3",

    // Error button
    "errorButtonBg": "#FFFFFF",
    "errorButtonText": "#D93F33",

    // Success, Warning, Error, Info
    "green": "#1BAC3F",
    "greenBg": "#B7E8C3",
    "yellow": "#DEA511",
    "yellowBg": "#F0E29A",
    "yellow15": "#DEA51126",
    "average": "#F7931A",
    "red": "#D93F33",
    "redBg": "#F5B9B5",
    "blue": "#386CF3",
    "blueBg": "#C6DAFF",

    // Black and white
    "alwaysWhite": "#FFFFFF",
    "alwaysBlack": "#101111",
    "white": "#34353C",
    "white20": "#34353C33",
    "white50": "#34353C80",
    "white80": "#34353CCC",
    "background20": "#18191E33",
    "blackrgb": "255, 255, 255",
    "black": "#FFFFFF",
    "black80": "#FFFFFFCC",
    "black60": "#FFFFFF99",
    "black40": "#FFFFFF66",
    "black20": "#FFFFFF33",
    "black15": "#FFFFFF26",
    "black10": "#FFFFFF1A",
    "black5": "#FFFFFF0D",

    // Specific UI components colors
    "pin": "#0066FF",
    // Transaction status dots
    "wireframes": "#BDC2CA",
    "wireframesLight": "#D8E0E5"
])

public func setTheme(theme: String) {
    UserDefaults.standard.set(theme, forKey: "MyDemoThemeName")
}

public func getTheme() -> String {
    return UserDefaults.standard.string(forKey: "MyDemoThemeName") ?? "light"
}
