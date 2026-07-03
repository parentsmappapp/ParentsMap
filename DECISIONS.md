# Architecture & Product Decisions

This document records important technical and product decisions made throughout the development of Parents Map.

Its purpose is to prevent revisiting the same discussions and to provide context for future contributors (including AI assistants).

---

# Decision Log

## MapKit over Google Maps

**Status:** Accepted

### Decision

Use Apple's native MapKit as the primary mapping framework.

### Why

- Native iOS experience
- Excellent SwiftUI integration
- Better performance
- No API usage costs
- Matches Apple's design language

### Trade-offs

- Fewer built-in POI features than Google Maps
- Less custom styling

These trade-offs are acceptable for this project.

---

## Supabase as Backend

**Status:** Accepted

### Decision

Use Supabase for authentication, database and storage.

### Why

- PostgreSQL
- Authentication included
- Storage included
- Row Level Security
- Simple Swift SDK
- Rapid development

---

## SwiftUI Only

**Status:** Accepted

### Decision

The application is built entirely in SwiftUI.

UIKit should only be introduced when SwiftUI cannot achieve the required behaviour.

---

## Service-Driven Architecture

**Status:** Accepted

### Decision

Business logic belongs in Services rather than Views.

### Why

Keeps Views simple.

Improves:

- testing
- maintenance
- reuse

---

## Community Moderation

**Status:** Accepted

### Decision

Community submissions require approval before becoming public.

### Why

Protects data quality.

Prevents spam.

Improves trust.

---

## Preview Card

**Status:** Accepted

### Decision

Use an Apple Maps style Preview Card.

### Why

Parents frequently browse multiple locations.

The Preview Card allows quick comparison without leaving the map.

---

## Search Experience

**Status:** Accepted

### Decision

Search is presented as a dedicated full-screen experience.

### Why

Cleaner UX.

Better keyboard handling.

Allows future additions like:

- recent searches
- suggestions
- trending places

---

## Native Look & Feel

**Status:** Permanent Principle

The app should always feel like a native Apple application.

When unsure, choose the option that feels closest to Apple Maps.

---

## Typography

Primary

Quicksand

Secondary

Poppins

This should remain consistent throughout the app.

---

## Colour Palette

Colours come exclusively from the Asset Catalog.

Avoid introducing additional colours unless required by the design system.

---

## Navigation

Navigation uses:

- NavigationStack
- sheet()
- fullScreenCover()

Avoid complex navigation architectures unless genuinely required.

---

## Animations

Animations should be subtle.

Reference applications:

- Apple Maps
- Apple Photos

Not:

- TikTok
- Instagram

---

## Search Philosophy

Search should require the fewest possible taps.

Preferred flow:

Tap

↓

Type

↓

Select

↓

Map animates

↓

Done

---

## Documentation

Documentation is considered part of the codebase.

Major architectural or product changes should be reflected in:

- README
- ARCHITECTURE
- CURRENT_STATE
- TODO
- CHANGELOG
- DECISIONS

---

# Future Decisions

Future architectural decisions should be added here rather than replacing older decisions.

Old decisions provide valuable historical context.
