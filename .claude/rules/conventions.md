---
description: Flutter project conventions that apply to all work — spacing widgets, code generation, and copyWith patterns.
---

## Spacing

Always use project spacer widgets instead of raw `SizedBox`:

- `VerticalSpacer(x)` — never `SizedBox(height: x)`
- `HorizontalSpacer(x)` — never `SizedBox(width: x)`

**Exception:** `SizedBox(width: x, height: x)` is fine when defining a fixed-size container, not spacing.

Sources: `lib/widgets/vertical_spacer.dart`, `lib/widgets/horizontal_spacer.dart`

## Code generation (.g.dart files)

Never edit `.g.dart` files manually — they are fully generated and any edits will be silently overwritten on the next build.

After any model change (new field, rename, removal), run:

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Always use `fvm flutter`, not bare `flutter` — the project is pinned to Flutter 3.32.0 via FVM (`.fvmrc`).

## Manual copyWith models

`Friendship`, `VisitInvitation`, `UserVisit`, and `CoVisitor` use hand-written `copyWith()` methods — **do NOT add `@CopyWith()` annotation** to these models.

When adding fields to these models, update the manual `copyWith()` by hand.
