# Architecture

Parents Map follows a lightweight, service-driven MVVM architecture designed around a single principle:

> **Views display data. Services own data.**

The goal is to keep SwiftUI views focused on presentation while moving networking, persistence and business logic into shared services that can be reused throughout the application.

---

# High Level Architecture

```
                        SwiftUI Views
                              │
                              ▼
                    View State (@State)
                              │
                              ▼
          EnvironmentObjects / Shared Services
                              │
                              ▼
                      Supabase Backend
                              │
            ┌─────────────────┴─────────────────┐
            ▼                                   ▼
      PostgreSQL Database                  Storage
```

---

# Core Principles

## 1. Keep Views Lightweight

Views should primarily:

- Display UI
- Hold local UI state
- Trigger actions

Views should **not**:

- Fetch data directly
- Contain networking
- Contain database logic
- Duplicate business rules

---

## 2. Single Source of Truth

Each piece of data should have one owner.

Examples:

| Data | Owner |
|------|-------|
| Authentication | AuthViewModel |
| Places | MapService |
| Saved Places | SavedPlacesService |
| Device Location | LocationManager |

Avoid storing duplicate copies of the same data in multiple views.

---

## 3. Services Own Business Logic

Business logic belongs inside shared services whenever possible.

Example responsibilities include:

- downloading places
- filtering
- saving favourites
- authentication
- uploads
- Supabase communication

Views simply call those services.

---

# Project Structure

```
ParentsMap

├── App
│
├── Views
│   ├── Authentication
│   ├── Map
│   ├── Search
│   ├── Place Detail
│   ├── Submit Place
│   ├── Saved
│   ├── Settings
│   └── Shared Components
│
├── Services
│
├── Models
│
├── Utilities
│
├── Assets
│
├── Fonts
│
└── Documentation
```

Views are organised by feature wherever practical.

---

# Core Services

## AuthViewModel

Responsible for:

- Sign Up
- Login
- Logout
- Session persistence
- Current user
- Authentication state

Injected globally using:

```
.environmentObject(authViewModel)
```

---

## MapService

The application's primary data service.

Responsible for:

- Loading places
- Loading categories
- Loading tags
- Applying filters
- Supplying search data

MapView and SearchView both rely on this service.

---

## SavedPlacesService

Responsible for:

- Saving places
- Removing favourites
- Loading saved places
- Syncing favourites with Supabase

---

## LocationManager

Responsible for:

- Current device location
- Permission handling
- User location updates

This service never owns UI.

---

# Navigation

Navigation intentionally stays simple.

The application uses:

- NavigationStack
- sheet()
- fullScreenCover()

Navigation hierarchy:

```
MapView

├── SearchView
│
├── Filter Sheets
│
├── Preview Card
│
└── PlaceDetailView
```

---

# Search Architecture

Search intentionally lives outside MapView.

Flow:

```
Map Search Bar

↓

SearchView

↓

Live filtering

↓

User selects result

↓

Callback to MapView

↓

SearchView dismisses

↓

Camera animates

↓

Preview Card appears
```

Keeping search separate keeps MapView significantly simpler.

---

# Map Architecture

MapView is the application's central screen.

It owns:

- cameraPosition
- selectedPlace
- selected filters
- preview card visibility
- presentation of SearchView
- presentation of PlaceDetailView

MapView should remain responsible only for map-related state.

---

# Place Preview Card

Purpose:

Allow users to quickly inspect a location without leaving the map.

Responsibilities:

- Name
- Rating
- Category
- Amenities
- Favourite button
- Expand action

The Preview Card should always feel lightweight.

Detailed information belongs inside PlaceDetailView.

---

# Place Detail

The Detail screen is the application's richest screen.

Responsibilities:

- Photos
- Description
- Amenities
- Contact details
- Opening hours
- Directions
- Reviews
- Edit actions

---

# SearchView

SearchView is intentionally independent.

Responsibilities:

- Search UI
- Live filtering
- Display search results
- Return selected place

SearchView does **not** own map state.

Instead it returns the selected place through a callback.

---

# Submit Place Flow

The submission flow is intentionally broken into multiple small screens instead of one long form.

Reasons:

- easier completion
- lower cognitive load
- better mobile usability

Each step owns only its own UI state.

The final submission is assembled once the flow finishes.

---

# State Management

Use the smallest scope possible.

## @State

For local UI state only.

Examples:

- expanded sections
- search text
- selected tab

---

## @EnvironmentObject

For shared application state.

Examples:

- authentication
- saved places

---

## Services

For shared business logic and persistence.

Examples:

- networking
- Supabase
- filtering

---

# Animation Philosophy

Animations should feel subtle and native.

Prefer:

- easeInOut
- spring()
- material transitions

Avoid:

- excessive bounce
- long durations
- flashy effects

Reference:

Apple Maps.

Not social media apps.

---

# Design System

Primary font:

Quicksand

Secondary font:

Poppins

Spacing:

8pt grid

Typical spacing:

```
8
16
24
32
40
48
56
64
```

Corner radius:

Rounded but soft.

Materials:

Use Apple's frosted materials where appropriate.

Colours:

Defined inside the project's colour assets.

Avoid hardcoding colours unless necessary.

---

# Backend

Backend is powered by Supabase.

Current services used:

- PostgreSQL
- Authentication
- Storage
- Row Level Security

All database access should go through shared services.

Views should never talk directly to Supabase.

---

# Error Handling

Preferred order:

1. Validate locally.
2. Attempt service action.
3. Handle Supabase response.
4. Present user-friendly error.

Never expose raw backend errors directly to users.

---

# Performance Guidelines

Avoid:

- duplicate network requests
- duplicate state
- unnecessary view refreshes

Prefer:

- lazy stacks
- lightweight views
- shared services
- reusable components

---

# Future Architecture

Planned additions include:

- Photo uploads
- Reviews
- Moderation
- Notifications
- Offline caching
- List View
- Better search history

The current architecture is intentionally designed so these features can be added without major restructuring.

---

# Guiding Principle

Every architectural decision should support one goal:

> **Make it easy for parents to find useful places as quickly as possible while keeping the codebase simple, maintainable and scalable.**
