# Parents Map

Parents Map is a community-driven iOS app that helps parents quickly find family-friendly places nearby.

Whether you're looking for a parents room, playground, café with high chairs, baby change facility, shaded park, bench or another useful amenity, Parents Map brings them together in one simple map.

Unlike traditional map apps, Parents Map focuses on information that matters specifically to parents and carers. Every location can be improved by the community through ratings, photos, comments and suggested edits, allowing the database to become more useful over time.

---

# Features

## 🗺️ Interactive Map

- Native Apple MapKit integration
- Smooth animated camera movement
- Custom category pins
- Automatic pin clustering
- Current location support
- Place Preview Cards
- Full Place Detail screens

---

## 🔍 Search

- Full-screen search experience
- Instant search results
- Search by:
  - Place name
  - Suburb
  - Address
  - Category
  - Amenities / Tags
- Automatically zooms the map to selected results

---

## 🎛 Filters

Current filters include:

- Place Type
- Distance
- Sort

Designed so additional filters can easily be added later.

---

## ❤️ Saved Places

Users can:

- Save favourite places
- Remove saved places
- Access favourites from their account

---

## ➕ Community Contributions

Users can:

- Submit new locations
- Suggest edits
- Improve existing information

Future updates will include:

- Photo uploads
- Reviews
- Ratings
- Community moderation

---

# Technology

## Frontend

- Swift
- SwiftUI
- MapKit

## Backend

Supabase

- PostgreSQL
- Authentication
- Storage
- Row Level Security (RLS)

## Development

- Xcode 16+
- iOS 18+
- Git
- GitHub

---

# Architecture

Parents Map follows a lightweight MVVM-inspired architecture.

```
SwiftUI Views
        │
        ▼
Shared Services
        │
        ▼
Supabase Backend
```

Views are intentionally lightweight.

Business logic, networking and persistence live inside shared services wherever possible.

More detail is available in **ARCHITECTURE.md**.

---

# Current Features

## Authentication

- Email sign up
- Login
- Logout
- Session persistence

## Map

- Interactive map
- Category pins
- Live filtering
- Camera animations
- Place selection

## Search

- Dedicated SearchView
- Live filtering
- Search callback to MapView
- Animated camera focus

## Places

- Preview Card
- Full Detail Screen
- Opening hours
- Contact details
- Directions
- Amenities
- Saved places

## User Contributions

- Multi-step place submission flow
- Manual location picker
- Category-specific amenities
- Supabase submission

---

# Project Structure

```
ParentsMap

├── Views
│   ├── Authentication
│   ├── Map
│   ├── Search
│   ├── Place Detail
│   ├── Submit Place
│   ├── Saved
│   └── Components
│
├── Services
│   ├── MapService
│   ├── SavedPlacesService
│   ├── AuthViewModel
│   └── LocationManager
│
├── Models
│
├── Utilities
│
├── Assets
│
└── Fonts
```

The project is organised by feature rather than by screen wherever practical.

---

# Running the Project

## Requirements

- macOS
- Xcode 16+
- iOS 18 SDK
- Supabase project
- Apple ID

---

## Setup

1. Clone the repository.

2. Open:

```
ParentsMap.xcodeproj
```

3. Verify the Supabase URL and anon key.

4. Select an iPhone or Simulator.

5. Press:

```
⌘R
```

Xcode will build, install and launch the application.

---

# Development Notes

Some important implementation details:

- Uses native MapKit rather than Google Maps.
- Google Maps directions are used when installed, otherwise Apple Maps opens automatically.
- Uses Quicksand as the primary font.
- Uses Poppins only for secondary metadata.
- Uses an 8pt spacing grid throughout the UI.
- Uses frosted glass materials where appropriate to match Apple's design language.

---

# Current Status

### ✅ Completed

- Authentication
- Interactive map
- Search
- Place Preview Card
- Place Detail screen
- Saved Places
- Submit Place flow
- Filtering
- Supabase backend

### 🚧 In Progress

- Photo uploads
- Reviews
- Admin moderation
- List View

### 📋 Planned

- Notifications
- Offline improvements
- Better onboarding
- Additional search enhancements

---

# Documentation

Project documentation is split across several files.

| File | Purpose |
|------|----------|
| `ARCHITECTURE.md` | Technical architecture and data flow |
| `AI_GUIDE.md` | Instructions and conventions for AI-assisted development |
| `CURRENT_STATE.md` | Snapshot of current project progress |
| `TODO.md` | Development roadmap |
| `CHANGELOG.md` | Version history |

---

# Philosophy

Parents Map aims to feel like a native Apple application rather than a traditional directory.

The design philosophy prioritises:

- Speed over complexity
- Clear hierarchy
- Smooth animations
- Consistent spacing
- Community-driven data
- Family-first usability

Every feature should help parents find useful places as quickly and effortlessly as possible.

---

© Parents Map
