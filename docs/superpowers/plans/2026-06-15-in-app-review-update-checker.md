# In-App Review + Update Checker Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add update checker dialog and non-intrusive in-app review to PocketList.

**Architecture:** Use `upgrader` package for automatic update prompts from Play Store/App Store. Use `in_app_review` package for native review dialogs with conservative frequency (90 days, 3+ lists).

**Tech Stack:** Flutter, Dart, `upgrader`, `in_app_review`, SharedPreferences

---

## File Structure

| File | Action | Purpose |
|------|--------|---------|
| `pubspec.yaml` | Modify | Add `upgrader` and `in_app_review` dependencies |
| `lib/main.dart` | Modify | Wrap MaterialApp with UpgradeAlert |
| `lib/src/Shared_Prefs/Preferencias_user.dart` | Modify | Add `lastReviewRequestTimestamp` getter/setter |
| `lib/src/pages/New-List/newList.dart` | Modify | Trigger review check after list completion |

---

### Task 1: Add Dependencies

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Add upgrader and in_app_review to pubspec.yaml**

```yaml
dependencies:
  # ... existing dependencies ...
  upgrader: ^13.5.0
  in_app_review: ^2.0.9
```

- [ ] **Step 2: Run flutter pub get**

Run: `flutter pub get`
Expected: Dependencies resolved successfully

- [ ] **Step 3: Verify no conflicts**

Run: `flutter analyze`
Expected: No new errors

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "feat: add upgrader and in_app_review dependencies"
```

---

### Task 2: Add Review Timestamp Preference

**Files:**
- Modify: `lib/src/Shared_Prefs/Preferencias_user.dart`

- [ ] **Step 1: Add getter/setter for lastReviewRequestTimestamp**

Open `lib/src/Shared_Prefs/Preferencias_user.dart` and add after the existing getters/setters:

```dart
int get lastReviewRequestTimestamp {
  return _prefs.getInt('lastReviewRequestTimestamp') ?? 0;
}

set lastReviewRequestTimestamp(int value) {
  _prefs.setInt('lastReviewRequestTimestamp', value);
}
```

- [ ] **Step 2: Verify no errors**

Run: `flutter analyze`
Expected: No new errors

- [ ] **Step 3: Commit**

```bash
git add lib/src/Shared_Prefs/Preferencias_user.dart
git commit -m "feat: add lastReviewRequestTimestamp preference"
```

---

### Task 3: Integrate Update Checker

**Files:**
- Modify: `lib/main.dart`

- [ ] **Step 1: Add import for upgrader**

Add at the top of `lib/main.dart`:

```dart
import 'package:upgrader/upgrader.dart';
```

- [ ] **Step 2: Wrap MaterialApp with UpgradeAlert**

In `DarkLightTheme` widget, wrap the `MaterialApp` with `UpgradeAlert`:

```dart
@override
Widget build(BuildContext context) {
  return UpgradeAlert(
    upgrader: Upgrader(
      durationUntilAlertAgain: Duration(days: 3),
      showReleaseNotes: true,
    ),
    child: MaterialApp(
      title: 'PocketList',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(
        prefs.color,
        false,
        customColor: prefs.customColorValue,
      ),
      darkTheme: AppTheme.getTheme(
        prefs.color,
        true,
        customColor: prefs.customColorValue,
      ),
      themeMode: prefs.darkLightTheme ? ThemeMode.dark : ThemeMode.light,
      locale: locale,
      // ... rest of MaterialApp configuration
    ),
  );
}
```

- [ ] **Step 3: Verify no errors**

Run: `flutter analyze`
Expected: No new errors

- [ ] **Step 4: Test update checker**

1. Change version in `pubspec.yaml` to `1.0.0+1`
2. Run app on device/emulator
3. If app is published in store, dialog should appear
4. If not published, no dialog (expected behavior)

- [ ] **Step 5: Commit**

```bash
git add lib/main.dart
git commit -m "feat: integrate upgrader for update checking"
```

---

### Task 4: Implement Review Check Logic

**Files:**
- Create: `lib/src/utils/review_helper.dart`

- [ ] **Step 1: Create review_helper.dart with maybeRequestReview function**

```dart
import 'package:in_app_review/in_app_review.dart';
import 'package:pocketlist/src/Shared_Prefs/Preferencias_user.dart';
import 'package:pocketlist/src/providers/db_provider.dart';

class ReviewHelper {
  static const int _minCompletedLists = 3;
  static const int _cooldownDays = 90;

  static Future<void> maybeRequestReview() async {
    try {
      final prefs = PreferenciasUsuario();
      final now = DateTime.now().millisecondsSinceEpoch;
      final lastRequest = prefs.lastReviewRequestTimestamp;

      // Check 90 days cooldown
      final cooldownMs = _cooldownDays * 24 * 60 * 60 * 1000;
      if (lastRequest != 0 && (now - lastRequest) < cooldownMs) {
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

      if (completedCount >= _minCompletedLists) {
        final review = InAppReview.instance;
        if (await review.isAvailable()) {
          await review.requestReview();
          prefs.lastReviewRequestTimestamp = now;
        }
      }
    } catch (e) {
      // Silently fail - review is not critical
    }
  }
}
```

- [ ] **Step 2: Verify no errors**

Run: `flutter analyze`
Expected: No new errors

- [ ] **Step 3: Commit**

```bash
git add lib/src/utils/review_helper.dart
git commit -m "feat: add ReviewHelper with conservative review logic"
```

---

### Task 5: Integrate Review Check in newList.dart

**Files:**
- Modify: `lib/src/pages/New-List/newList.dart`

- [ ] **Step 1: Add import for review_helper**

Add at the top of `lib/src/pages/New-List/newList.dart`:

```dart
import 'package:pocketlist/src/utils/review_helper.dart';
```

- [ ] **Step 2: Find the _completeAllItems method or similar completion logic**

Search for where items are marked as complete (look for `complete == 1` or `_completeAll`).

- [ ] **Step 3: Add review check after list completion**

After a list is marked as complete, add:

```dart
// Request review after completing a list
ReviewHelper.maybeRequestReview();
```

- [ ] **Step 4: Verify no errors**

Run: `flutter analyze`
Expected: No new errors

- [ ] **Step 5: Commit**

```bash
git add lib/src/pages/New-List/newList.dart
git commit -m "feat: trigger review check after list completion"
```

---

### Task 6: Final Verification

**Files:**
- None (verification only)

- [ ] **Step 1: Run flutter analyze**

Run: `flutter analyze`
Expected: 0 errors

- [ ] **Step 2: Test on device/emulator**

1. Run app on Android/iOS device or emulator
2. Verify no crash on startup
3. Complete 3 lists to trigger review (debug mode)
4. Verify update dialog appears if version is lower than store

- [ ] **Step 3: Update CHANGELOG.md**

Add entry for v3.5.0:

```markdown
## [3.5.0] - 2026-06-15

### Added
- **Update Checker:** Automatic update prompts from Play Store/App Store using `upgrader` package
- **In-App Review:** Non-intrusive review requests (90-day cooldown, 3+ completed lists required)
```

- [ ] **Step 4: Update analysis.md**

Mark items as fixed:
- Update checker: ✅ FIXED
- In-App Review: ✅ FIXED

- [ ] **Step 5: Commit**

```bash
git add CHANGELOG.md analysis.md
git commit -m "docs: update changelog and analysis for v3.5.0"
```

---

## Summary

| Task | Description | Files |
|------|-------------|-------|
| 1 | Add dependencies | `pubspec.yaml` |
| 2 | Add review timestamp preference | `Preferencias_user.dart` |
| 3 | Integrate update checker | `main.dart` |
| 4 | Create ReviewHelper | `review_helper.dart` |
| 5 | Integrate review in newList | `newList.dart` |
| 6 | Final verification | `CHANGELOG.md`, `analysis.md` |

**Total estimated time:** 15-20 minutes
