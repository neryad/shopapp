# Changelog

## [3.8.1] - 2026-07-13

### Changed
- Version bumped to 3.8.1+19

## [3.8.0] - 2026-07-13

### Added
- **Legal safeguard audit:** Comprehensive legal review and implementation
  - **Terms of Service:** Now rendered locally in-app via Markdown. Includes arbitration clause, class action waiver, DMCA takedown policy, and governing law (Dominican Republic)
  - **Privacy Policy:** Rewritten to accurately reflect zero data collection. All data is stored locally on device, no servers, no third-party tracking
  - **CCPA Notice:** New card in Settings → Legal with full California privacy rights disclosure
  - **PrivacyInfo.xcprivacy:** Apple-required privacy manifest added for iOS compliance
  - **iOS permissions cleanup:** Removed unused Camera, Location, and Photo Library permission declarations

### Changed
- Version bumped to 3.8.0+18

## [3.7.0] - 2026-06-22

### Added
- **Onboarding:** 4-screen onboarding flow shown automatically on first launch
  - Screen 1: Welcome — introduces PocketList
  - Screen 2: Budget — explains budget tracking
  - Screen 3: Import/Export — highlights sharing and PDF export
  - Screen 4: Customization — themes, dark mode, multi-language
  - Skip button on all screens, "Get Started" button on last screen
  - Persists completion state in SharedPreferences
  - Fully internationalized (English/Spanish)

## [3.6.0] - 2026-06-16

### Added
- **Share App:** New "Share App" button in navigation drawer with QR code dialog and native share sheet
  - QR code points to app web URL (`https://pockelist-web.neryad.dev/`)
  - "Copy link" button copies URL to clipboard with SnackBar feedback
  - "Share" button opens native share sheet with localized message
  - Fully internationalized (English/Spanish)

### Dependencies
- Added `qr_flutter: ^4.1.0`

## [3.5.0] - 2026-06-15

### Added
- **Update Checker:** `upgrader` package shows update dialog when new version available on Play Store/App Store
- **Localized update dialog:** Update messages translated to English and Spanish

### Dependencies
- Added `upgrader: ^13.5.0`
- Removed `in_app_review: ^2.0.9`

## [3.4.0] - 2026-06-15

### Security
- **Path traversal:** Added `_sanitizeFilename()` to prevent malicious CSV filenames
- **Input validation:** `saveBudget()` now uses `double.tryParse` instead of `double.parse`

### Performance
- **Batch update:** `_saveLista` now uses `updateProdsBatch()` instead of N+1 individual updates

### UX
- **Pull-to-refresh:** Added `RefreshIndicator` to list_page for pull-to-refresh
- **Unified notifications:** Centralized `showSnack`, `showSuccessSnack`, `showErrorSnack`, `showInfoSnack` in `utils.dart`
- **Category CRUD feedback:** Added success/info snackbars after create, update, and delete operations
- **Flushbar cleanup:** Removed duplicated Flushbar methods from `data.dart`, `user.dart`, `import_export_page.dart`
- **Native SnackBar:** Migrated `newList.dart` undo/completed snackbars from Flushbar to `ScaffoldMessenger`

## [3.3.0] - 2026-06-14

### Changed
- **Typo fix:** Renamed `getTranlated` → `getTranslated` across 15 files (~265 call sites)
- **Typo fix:** Renamed `getToadasLista` → `getTodasLista` in db_provider and 3 callers
- **Typo fix:** Renamed `_subimt` → `_submit` in newList.dart
- **Typo fix:** Renamed `_editDubimt` → `_editSubmit` in newList.dart
- **Typo fix:** Fixed `hhttps://` → `https://` in pubspec.yaml comment

### Removed
- Deleted unused `suge.dart` model and `sugeModel` variable from newList.dart
- Deleted unused `colorSecundario` getter/setter from Prefrecias_user.dart
- Removed redundant `_loadItems()` call after optimistic insert in `_submit`

### Added
- Created `PackageInfoMixin` to centralize `_initPackageInfo` (was duplicated in 3 widgets)
- `Menu_widget.dart`, `about_page.dart`, `setting_page.dart` now use the shared mixin
- 3 new i18n keys: `categoryCreated`, `categoryUpdated`, `categoryDeleted`

## [3.2.0] - 2026-06-14

### Fixed
- **Bug #1:** Removed dead code referencing non-existent assets in `utils.dart`
- **Bug #2:** Implemented real logic in `_deleteCompletedLists` (was always returning false)
- **Bug #3+8:** Moved `setState` outside `getTotal()` loop, removed from `didChangeDependencies`
- **Bug #4:** Removed dead `_controllers` list causing TextEditingController memory leak
- **Bug #5:** Added validation and `tryParse` to CSV import (was crashing on malformed data)
- **Bug #6+7:** Replaced all hardcoded strings with i18n keys across 7 files (~50 new keys added)
- **Bug #9:** Replaced magic number `5` with named constant `kColorGray`
- **Bug #10:** Changed `deleteLista()` return type from `Future<String>` to `Future<int>`
- **Bug #11:** Removed `resizeToAvoidBottomInset: false` from home_page (keyboard now pushes content)
- **Bug #12:** Added try-catch with user feedback to DB operations (`newProd`, `_saveLista`, `saveList`, `deleteLista`)
- **Bug #13:** Replaced empty `print(e)` catch block with SnackBar feedback in `list_page.dart`
- **Bug #14:** Deleted unused `ThemeManager.dart` file
- **Bug #15:** Deleted unused `summary_header.dart` file
- **Bug #17:** Verified `webPageTitle` key exists in `es.json` (analysis was outdated)
- **Bug #18:** Fixed inconsistent indentation in `es.json` (categories section)
- **Bug #19:** Fixed web locale fallback — now uses browser language instead of always defaulting to English
- **Bug #20:** Replaced relative import `../../../../main.dart` with absolute import in `user.dart`
- **Overflow:** Fixed bottom overflow (62px) on `import_export_page.dart` card on physical devices — compacted layout, used `Wrap` for info chips
- **Overflow:** Fixed bottom overflow (28px) on `list_page.dart` card — reduced padding, compacted icon buttons
- **Build:** Fixed Android build failure caused by Windows keystore path in `key.properties` — signing config now validates file exists before use
- **Greeting:** Fixed time-of-day greeting showing wrong period (was computed once at import)
- **Dismissible:** Swipe-to-delete now works reliably with confirmation dialog

### Changed
- `export_helper.dart`: Removed manual `if (prefs.lnge == 'en')` i18n, now uses `getTranlated(context, key)`
- `import_export_page.dart`: Removed `_initializeStrings()` method and 17 `late String` variables, all replaced with direct `getTranlated` calls
- `setting_page.dart`: 15 hardcoded strings replaced with i18n keys
- `color_page.dart`: 18 hardcoded strings replaced with i18n keys (color names, UI labels)
- `user.dart`: 19 hardcoded strings replaced with i18n keys (dialogs, validation, sections)
- `about_page.dart`: 14 hardcoded strings replaced with i18n keys
- `Menu_widget.dart`: 5 hardcoded strings replaced with i18n keys

### Added
- ~50 new i18n keys in `en.json` and `es.json` (settings, user, about, menu, colors, CSV export)
- Confirmation dialog on swipe-to-delete in list page
- `ValueKey` on `ListView.builder` for reliable Dismissible widget reconciliation

## [3.1.3+13] - Previous

- See git history for prior changes.
