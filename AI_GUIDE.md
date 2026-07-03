# AI Guide

This document is the primary reference for any AI assistant (ChatGPT, Claude, Gemini, Copilot, etc.) working on the Parents Map project.

Read this file before suggesting code changes.

---

# Project Goal

Parents Map helps parents quickly find family-friendly amenities nearby.

The app should feel like a polished, native Apple application—not a business directory or social media app.

Every design and engineering decision should support:

- Speed
- Simplicity
- Clarity
- Community contribution
- One-handed usability

---

# Core Philosophy

Always optimise for:

✅ Native iOS feel

✅ Clean interfaces

✅ Consistency

✅ Maintainability

Avoid unnecessary complexity.

If a solution is simpler while producing the same user experience, prefer the simpler solution.

---

# UI Principles

Parents Map follows Apple's Human Interface Guidelines with a softer, family-friendly aesthetic.

Design should feel similar to:

- Apple Maps
- Apple Photos
- Airbnb
- Uber Eats

Not:

- Instagram
- TikTok
- Facebook

---

# Typography

Primary font

Quicksand

Used for:

- Titles
- Buttons
- Body text
- Navigation

Secondary font

Poppins

Only used for:

- Metadata
- Small labels
- Dates
- Tiny captions

Never randomly mix fonts.

---

# Spacing

Always use an 8pt grid.

Preferred spacing:

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

Avoid random values like:

```
11
13
27
37
```

unless absolutely necessary.

---

# Corner Radius

Preferred values:

```
12
16
20
24
26
30
```

Keep the design soft and rounded.

---

# Colours

Colours come from Asset Catalog.

Use:

```
Color(.brandBrown)
Color(.brandCoral)
Color(.brandCream)
Color(.brandPink)
```

Avoid hardcoded RGB values unless creating gradients or shadows.

---

# Materials

Where appropriate use:

- .thinMaterial
- .ultraThinMaterial

The app intentionally uses frosted glass sparingly.

Do not overuse blur effects.

---

# Shadows

Shadows should be subtle.

Preferred opacity:

10–15%

Preferred blur:

6–12

Avoid heavy shadows.

---

# Buttons

Buttons should:

- feel tappable
- have generous hit areas
- use rounded corners
- animate naturally

Avoid tiny tap targets.

---

# Animations

Animations should feel like Apple Maps.

Preferred:

```
.easeInOut()

.spring(
    response: 0.35,
    dampingFraction: 0.85
)
```

Avoid:

- excessive bounce
- flashy transitions
- long animations

---

# Map Experience

The map is the heart of the application.

Always prioritise:

- map visibility
- smooth camera movement
- minimal obstruction

Avoid covering large portions of the map unnecessarily.

---

# Preview Card

The Preview Card should feel like a physical card resting on top of the map.

It should:

- expand smoothly
- collapse smoothly
- never feel like a modal

Keep interactions lightweight.

---

# Search

Search should feel instant.

Preferred flow:

Tap Search

↓

Search screen appears

↓

Typing filters immediately

↓

Tap result

↓

Search closes

↓

Map animates

↓

Preview card opens

Avoid unnecessary confirmation buttons.

---

# Place Detail

The Detail screen is for exploration.

The Preview Card is for quick decisions.

Do not duplicate too much information between the two.

---

# Code Style

Prefer:

Small reusable Views.

Small reusable Components.

Reusable modifiers.

Readable code over clever code.

---

# Naming

Good:

```
MapService

SearchView

PlacePreviewCard

SavedPlacesService
```

Avoid:

```
Manager2

Helper

DataStuff

Utilities2
```

Names should describe responsibility.

---

# SwiftUI

Prefer:

```
VStack

HStack

LazyVStack

ScrollView
```

Use custom components before duplicating layouts.

---

# State Management

Rule:

The smallest possible owner owns the state.

Use:

@State

for local UI.

Use:

@EnvironmentObject

for global state.

Use Services for:

- networking
- filtering
- persistence

Avoid duplicate state.

---

# Architecture

Views display.

Services think.

Supabase stores.

Keep those responsibilities separate.

---

# Map Service

MapService owns:

- places
- categories
- tags
- filtering

Views should never query Supabase directly.

---

# Authentication

AuthViewModel owns authentication.

Views simply react to authentication state.

---

# Saved Places

SavedPlacesService owns favourites.

Do not duplicate saved state elsewhere.

---

# Components

Whenever UI repeats:

Extract a reusable component.

Examples:

- Filter pills
- Buttons
- Chips
- Cards
- Rows

---

# Before Changing UI

Always ask:

1. Does this match the existing design language?

2. Does it feel native?

3. Can it be reused?

4. Is it simpler?

---

# Before Adding Code

Always check whether an existing component already exists.

Prefer extending existing code over creating new versions.

---

# Git

Commit meaningful milestones.

Good examples:

```
Improve search flow

Add Place Detail animations

Implement saved places

Update documentation
```

Avoid:

```
fix

changes

stuff

update
```

---

# Testing Checklist

Before considering a feature complete:

☐ Builds successfully

☐ Runs on simulator

☐ Runs on physical device

☐ No console errors

☐ Animations smooth

☐ Dark mode acceptable

☐ No clipped layouts

☐ Navigation works

☐ No duplicate state

---

# Current Priorities

Highest priority:

- Polish existing UX
- Improve search
- Improve map interactions
- Finish community contribution flow
- Add reviews
- Add photos

Lower priority:

- Notifications
- Offline mode
- Extra settings

---

# Things Never To Change Without Asking

Do not redesign:

- Navigation
- Colour palette
- Typography
- Animation style
- Overall architecture

These are intentional design decisions.

---

# Guiding Principle

Every new line of code should answer one question:

> **Does this help parents find the right place faster while keeping the app beautiful, intuitive and maintainable?**

If not, reconsider the implementation.
