# Agent instructions — markmap

This repository is the **markmap** iOS app: a map-centric experience built with **SwiftUI** and **UIKit** (scene-based lifecycle via `SceneDelegate` and `AppDelegate`).

## Tech stack

- **Maps:** Mapbox (`MapView`, annotations, callouts, `LocationManager`)
- **Backend:** Firebase (Firestore, Storage, core SDK), `GoogleService-Info.plist` for configuration
- **Auth:** Google Sign-In (`GIDSignIn`, `LogInView`, `ProfileIcon`)
- **Images:** Kingfisher (SwiftUI) in gallery/list flows; camera capture under `Camera/`

## Layout (where to look)

| Area | Role |
|------|------|
| `ContentView.swift` | Main map shell, navigation, image state, Firestore reads for map pins |
| `MapView.swift`, `CustomAnnotation.swift`, `CustomCalloutView.swift` | Mapbox map and annotation UI |
| `LocationManager.swift` | Location + Mapbox-related location handling |
| `Database/DatabaseHandler.swift` | Firestore + Storage writes (e.g. image upload, metadata) |
| `Images/` | Gallery, single image, list, edit/upload flows |
| `Components/` | Shared UI (login, friends, profile) |
| `Camera/` | Capture pipeline |
| `Coordinators/` | UIKit navigation helpers |
| `markmapUITests/` | XCTest UI tests |

## Conventions for changes

- Match existing style: same imports, naming patterns, and mix of SwiftUI vs UIKit entry points already in the tree.
- Prefer small, focused edits; avoid drive-by refactors unrelated to the task.
- **Secrets:** Do not add new API keys or replace `GoogleService-Info.plist` with fake values in commits. Treat bundled Firebase/Google client IDs as sensitive in public forks.
- Firestore collections used in code include `images` and `users` (verify field names against `DatabaseHandler` and `ContentView` before assuming schema).

## Build and test

- Open the Xcode project or workspace for **markmap** (if present in your checkout), select an iOS simulator or device, then build and run.
- Run UI tests from the **markmapUITests** target when validating flows touched by automation.

If the `.xcodeproj` / `.xcworkspace` is not in this working tree, sync the full project from the upstream repository before building locally.
