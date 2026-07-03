# Contributing

Thank you for contributing to Parents Map.

This document describes the development standards used throughout the project.

---

# Philosophy

Every contribution should improve one or more of:

- usability
- maintainability
- consistency
- performance

Avoid adding unnecessary complexity.

---

# Before You Start

Read:

- README.md
- ARCHITECTURE.md
- AI_GUIDE.md
- DECISIONS.md

These documents describe how the project is intended to evolve.

---

# Coding Standards

## Swift

Prefer:

- readable code
- descriptive names
- reusable components

Avoid:

- duplicated logic
- large View files
- deeply nested code

---

## SwiftUI

Views should primarily display UI.

Business logic belongs inside shared services.

---

## Components

If UI is repeated more than once, consider extracting a reusable component.

Examples:

- Buttons
- Cards
- Filter pills
- Chips
- Rows

---

# Naming

Good examples:

```
MapService
SearchView
SavedPlacesService
PlacePreviewCard
```

Avoid generic names like:

```
Helper
Manager
Data
Utilities
```

---

# Formatting

Follow standard Swift formatting.

Use meaningful whitespace.

Prefer small functions over very long ones.

---

# Git Workflow

Commit related changes together.

Good commit messages:

```
Improve search experience

Implement saved places

Refine preview card animations

Update project documentation
```

Avoid:

```
fix

changes

stuff

update
```

---

# Pull Requests

Before opening a pull request:

- Build successfully
- Test on simulator
- Test on device (when possible)
- Remove debug code
- Remove unused files
- Update documentation if required

---

# Testing Checklist

Before merging:

- [ ] Builds successfully
- [ ] No compiler warnings
- [ ] No console errors
- [ ] Navigation works
- [ ] Animations are smooth
- [ ] UI matches design system
- [ ] No duplicated state

---

# Design Principles

The application should always feel:

- native
- lightweight
- welcoming
- simple

Avoid clutter.

---

# Performance

Prefer:

- LazyVStack
- reusable services
- lightweight views

Avoid unnecessary work on the main thread.

---

# Accessibility

When possible:

- support Dynamic Type
- maintain good contrast
- use appropriate accessibility labels
- provide generous tap targets

Accessibility should be considered throughout development rather than added at the end.

---

# Documentation

Documentation should be updated whenever:

- architecture changes
- navigation changes
- new services are added
- significant features are completed

The documentation is treated as part of the project, not an afterthought.

---

# AI-Assisted Development

AI tools such as ChatGPT, Claude and Gemini are encouraged to assist development.

However:

- Review all generated code.
- Test all changes.
- Keep implementations consistent with the project's architecture and design system.
- Never merge AI-generated code without understanding it.

---

# Final Principle

Every contribution should leave the project in a better state than it was found.

Small, thoughtful improvements accumulate into a polished product.
