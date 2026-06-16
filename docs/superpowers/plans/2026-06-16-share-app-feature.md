# Share App Feature Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a "Share App" feature with QR code display and native share sheet, accessible from the main navigation drawer.

**Architecture:** A new `ShareAppDialog` widget displays a QR code pointing to the app's web URL (`https://pockelist-web.neryad.dev/`) with a native share button. The dialog is triggered from a new menu item in the navigation drawer. Uses `qr_flutter` for QR generation and `share_plus` (already installed) for native sharing.

**Tech Stack:** `qr_flutter` (new dependency), `share_plus` (existing), `package_info_plus` (existing), `url_launcher` (existing), i18n via `getTranslated()`

---

## File Structure

| Action | File | Responsibility |
|--------|------|----------------|
| Create | `lib/src/widgets/share_app_dialog.dart` | QR code dialog widget |
| Modify | `lib/src/widgets/Menu_widget.dart` | Add "Share App" menu item |
| Modify | `i18n/en.json` | Add 4 new translation keys |
| Modify | `i18n/es.json` | Add 4 new translation keys |
| Modify | `pubspec.yaml` | Add `qr_flutter` dependency |

---

### Task 1: Add `qr_flutter` dependency

**Files:**
- Modify: `pubspec.yaml:1` (dependencies section)

- [ ] **Step 1: Add qr_flutter to pubspec.yaml**

Add `qr_flutter: ^4.1.0` under dependencies in `pubspec.yaml`. The dependencies section starts around line 15. Add it after the existing `share_plus` entry (or anywhere in the dependencies block):

```yaml
  qr_flutter: ^4.1.0
```

- [ ] **Step 2: Run flutter pub get**

Run: `flutter pub get`
Expected: Dependencies resolve successfully, `qr_flutter` installed.

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "feat: add qr_flutter dependency for share app QR code"
```

---

### Task 2: Add i18n translation keys

**Files:**
- Modify: `i18n/en.json` (add 4 keys before the closing `}`)
- Modify: `i18n/es.json` (add 4 keys before the closing `}`)

- [ ] **Step 1: Add English translations**

Open `i18n/en.json`. Add these 4 keys before the final `}` (after line 319, before the closing brace):

```json
  "shareDialogTitle": "Share PocketList",
  "scanToDownload": "Scan the QR code to download the app",
  "copyLink": "Copy link",
  "linkCopied": "Link copied to clipboard"
```

- [ ] **Step 2: Add Spanish translations**

Open `i18n/es.json`. Add these 4 keys before the final `}` (after line 319, before the closing brace):

```json
  "shareDialogTitle": "Compartir PocketList",
  "scanToDownload": "Escanea el código QR para descargar la app",
  "copyLink": "Copiar enlace",
  "linkCopied": "Enlace copiado al portapapeles"
```

- [ ] **Step 3: Commit**

```bash
git add i18n/en.json i18n/es.json
git commit -m "feat: add i18n keys for share app dialog"
```

---

### Task 3: Create ShareAppDialog widget

**Files:**
- Create: `lib/src/widgets/share_app_dialog.dart`

- [ ] **Step 1: Create the ShareAppDialog widget**

Create file `lib/src/widgets/share_app_dialog.dart` with the following content:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pocketlist/src/localization/localization_constant.dart';

const String _appShareUrl = 'https://pockelist-web.neryad.dev/';

class ShareAppDialog extends StatelessWidget {
  const ShareAppDialog({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const ShareAppDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              getTranslated(context, 'shareDialogTitle'),
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              getTranslated(context, 'scanToDownload'),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: QrImageView(
                data: _appShareUrl,
                version: QrVersions.auto,
                size: 200,
                backgroundColor: Colors.white,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.roundedOuter,
                  color: colorScheme.primary,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.roundedOuter,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _appShareUrl,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                          const ClipboardData(text: _appShareUrl));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              getTranslated(context, 'linkCopied')),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: Text(getTranslated(context, 'copyLink')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Share.share(
                        getTranslated(context, 'shareMsg'),
                        subject: getTranslated(context, 'shareSubject'),
                      );
                    },
                    icon: const Icon(Icons.share, size: 18),
                    label: Text(getTranslated(context, 'share')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify file compiles**

Run: `flutter analyze lib/src/widgets/share_app_dialog.dart`
Expected: No errors (warnings/info are acceptable).

- [ ] **Step 3: Commit**

```bash
git add lib/src/widgets/share_app_dialog.dart
git commit -m "feat: create ShareAppDialog widget with QR code and share button"
```

---

### Task 4: Add Share App menu item to drawer

**Files:**
- Modify: `lib/src/widgets/Menu_widget.dart` (add import + menu item)

- [ ] **Step 1: Add import for ShareAppDialog**

Open `lib/src/widgets/Menu_widget.dart`. Add this import after the existing imports (around line 7, after the `share_plus` or other widget imports):

```dart
import 'package:pocketlist/src/widgets/share_app_dialog.dart';
```

- [ ] **Step 2: Add Share App menu item to drawer**

Open `lib/src/widgets/Menu_widget.dart`. Find the "Data" section (around line 166-174). Add a new "Share App" menu item **after** the Import/Export item and **before** the divider that precedes the "Settings" section.

Insert this block after the Import/Export `_createMenuItem` (after line 174) and before `const SizedBox(height: 8)` (line 176):

```dart
                _createMenuItem(
                  context,
                  icon: Icons.share_outlined,
                  activeIcon: Icons.share,
                  title: getTranslated(context, 'shareApp'),
                  onTap: () {
                    Navigator.pop(context); // Cerrar drawer
                    ShareAppDialog.show(context);
                  },
                ),
```

- [ ] **Step 3: Verify file compiles**

Run: `flutter analyze lib/src/widgets/Menu_widget.dart`
Expected: No errors.

- [ ] **Step 4: Commit**

```bash
git add lib/src/widgets/Menu_widget.dart
git commit -m "feat: add Share App button to navigation drawer"
```

---

### Task 5: Full verification

- [ ] **Step 1: Run full analysis**

Run: `flutter analyze`
Expected: No new errors introduced.

- [ ] **Step 2: Manual test flow**

1. Run the app: `flutter run` (or on device/simulator)
2. Open the drawer menu
3. Verify "Share App" item appears with share icon between "Import/Export" and "Settings"
4. Tap "Share App" → dialog opens with QR code
5. Verify QR code is visible and scannable (points to `https://pockelist-web.neryad.dev/`)
6. Tap "Copy link" → snackbar shows "Link copied to clipboard"
7. Tap "Share" → native share sheet opens with the share message
8. Close dialog → returns to home page

- [ ] **Step 3: Final commit (if any fixes needed)**

```bash
git add -A
git commit -m "feat: share app feature complete - QR code + native share from drawer"
```
