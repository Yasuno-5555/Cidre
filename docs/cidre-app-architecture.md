# Cidre.app Architecture

## Overview
- **SwiftUI View hierarchy**: Uses standard SwiftUI `NavigationView` and custom Views (`SidebarView`, `DashboardView`, `InstallView`, etc.).
- **MVVM VM architecture**: Uses ViewModels (`AppViewModel`, `DashboardViewModel`, etc.) to hold and update State.
- **Repository Locator**: Automatically finds local `Cidre` paths.
- **Mock Mode**: Loads mock fixtures when offline or on unverified platforms.
