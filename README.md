# Some Year Some Day

Some Year Some Day is an open-source SwiftUI application that helps users reflect on their daily life by transforming personal data into structured diary entries.

## Overview

Some Year Some Day is designed to support daily reflection by turning fragmented personal data into a coherent narrative of one day.

The app allows users to select photos from their device and applies on-device AI analysis to infer emotional cues and contextual information from visual content. In addition, users can optionally integrate data from Apple Music, Apple Maps, and Apple Fitness to provide a richer understanding of their daily activities.

By combining visual memories with activity, location, and media data, the app aims to generate a daily summary that goes beyond traditional text-based journaling, supporting long-term reflection and personal memory recall.

## Platforms

- iOS 26+
- iPadOS 26+
- watchOS (planned)

## Architecture

- SwiftUI
- MVVM-style separation
- Shared core logic designed for multi-platform support

The project is structured to allow future expansion to watchOS and iPadOS while keeping core logic reusable and platform-agnostic.

## Requirements

- Xcode 26 or later
- iOS 26 SDK
- SwiftUI (iOS 26)

## Build & Run

1. Clone the repository
2. Open `Some Year Some Day.xcodeproj` in Xcode
3. Select an iOS simulator or a connected device
4. Build and run the app

Additional configuration steps may be required for optional data integrations (e.g. Apple Music, Maps, Fitness).
