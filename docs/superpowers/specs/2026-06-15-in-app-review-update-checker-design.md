# Design Spec: In-App Review + Update Checker

## Overview

Add two features to PocketList:
1. **Update Checker** — Prompt users to update when a new version is available in the app store
2. **In-App Review** — Request app store rating after positive user actions (non-intrusive)

## Feature 1: Update Checker

### Package
- `upgrader: ^13.5.0` (pub.dev)
- 2.4k likes, 199k downloads, actively maintained
- Supports Android (Play Store) and iOS (App Store)
- 39 languages including Spanish

### Integration
Wrap `MaterialApp` with `UpgradeAlert` widget in `main.dart`.

### Configuration
```dart
UpgradeAlert(
  upgrader: Upgrader(
    durationUntilAlertAgain: Duration(days: 3),
    showReleaseNotes: true,
  ),
  child: MaterialApp(...)
)
```

### Behavior
- Checks Play Store / App Store for newer version
- Shows dialog with: title, message, release notes, 3 buttons
- **Ignore** — Suppresses alert for this version permanently
- **Later** — Closes dialog, can show again after 3 days
- **Update Now** — Opens store listing
- Localized automatically (es/en)

### Files Modified
- `lib/main.dart` — Wrap MaterialApp with UpgradeAlert

## Feature 2: In-App Review

### Package
- `in_app_review: ^2.0.9` (pub.dev)
- Cross-platform (Android, iOS, macOS, Windows, Linux)
- Uses native review dialogs

### Logic (Conservative)
- Maximum **1 request every 90 days**
- Only after user has **3+ completed lists**
- Store timestamp in SharedPreferences
- If user already reviewed, never ask again

### Flow
1. User completes a list (marks all items or manually completes)
2. Check: Has 90+ days passed since last review request?
3. Check: Does user have 3+ completed lists?
4. If both conditions met → request review via `in_app_review`
5. Store current timestamp in SharedPreferences

### Storage
- Key: `lastReviewRequestTimestamp`
- Value: Unix timestamp (milliseconds)
- Store in existing `PreferenciasUsuario` (SharedPreferences)

### Files Modified
- `lib/src/Shared_Prefs/Preferencias_user.dart` — Add `lastReviewRequestTimestamp` getter/setter
- `lib/src/pages/New-List/newList.dart` — Trigger review check after list completion

### Review Check Function
```dart
Future<void> maybeRequestReview() async {
  final prefs = PreferenciasUsuario();
  final now = DateTime.now().millisecondsSinceEpoch;
  final lastRequest = prefs.lastReviewRequestTimestamp;
  
  // Check 90 days cooldown
  if (lastRequest != 0 && (now - lastRequest) < 90 * 24 * 60 * 60 * 1000) {
    return;
  }
  
  // Check 3+ completed lists
  final lists = await DBProvider.db.getTodasLista();
  int completedCount = 0;
  for (final list in lists) {
    final products = await DBProvider.db.getProdId(list.id);
    if (products.isNotEmpty && products.every((p) => p.complete == 1)) {
      completedCount++;
    }
  }
  
  if (completedCount >= 3) {
    final review = InAppReview.instance;
    if (await review.isAvailable()) {
      await review.requestReview();
      prefs.lastReviewRequestTimestamp = now;
    }
  }
}
```

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `upgrader` | ^13.5.0 | Update checker dialog |
| `in_app_review` | ^2.0.9 | Native review dialog |

## Testing

1. **Update Checker**: Change version in pubspec.yaml to lower than store version → dialog should appear
2. **In-App Review**: Complete 3 lists → review dialog should appear (only in debug mode for testing)

## Risk Assessment

- **Low risk**: Both packages are well-maintained and widely used
- **No data impact**: No database changes
- **User experience**: Non-intrusive, respects user choice (ignore/later)
