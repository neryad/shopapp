# Changelog

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
