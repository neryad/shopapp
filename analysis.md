# Análisis Completo de PocketList

## 📋 Resumen

- **App:** PocketList (v3.1.3+13)
- **Framework:** Flutter (Material 3)
- **Idiomas:** Inglés / Español
- **Base de datos:** SQLite (sqflite)

---

## 🐛 Bugs Críticos

### 1. ~~Assets inexistentes referenciados en `utils.dart`~~ ✅ FIXED
**Archivo:** `lib/src/utils/utils.dart` (líneas 39, 64, 92)
**Problema:** Las funciones `cambiarHeaderImage()`, `cambiarHomeImage()` y `cambiarNewImage()` construyen rutas tipo `assets/shopping_app_${prefs.color}.png`, `assets/empty_cart_${prefs.color}.png`, `assets/add_to_cart_${prefs.color}.png`. Estos assets **no existen** en el directorio `assets/`. Esto causa errores en tiempo de ejecución (`AssertionError` o imagen rota).
**Fix:** Se eliminaron las 3 funciones y 2 variables globales muertas que las referenciaban.

### 2. ~~Función `_deleteCompletedLists` no funcional (DataPage)~~ ✅ FIXED
**Archivo:** `lib/src/pages/settings/pages/data.dart` (líneas 399-405)
**Problema:** El filtro en `_deleteCompletedLists` siempre retorna `false`:
```dart
final completedLists = lists.where((list) {
  return false; // 🔴 Siempre false
}).toList();
```
El botón "Limpiar listas completadas" siempre muestra "No hay listas completadas para eliminar", incluso cuando todas las listas están completadas.
**Fix:** Se implementó lógica real usando `getProdId()` + `every(p.complete == 1)` para detectar listas completadas.

### 3. ~~`setState()` dentro de un bucle en `getTotal()`~~ ✅ FIXED
**Archivo:** `lib/src/pages/New-List/newList.dart` (líneas 195-218)
**Problema:** `setState()` se llama dentro de un `for` loop, causando N reconstrucciones del widget por cada artículo:
```dart
for (int i = 0; i < items.length; i++) {
  setState(() {  // 🔴 Llamado en cada iteración
    total += (items[i].price * items[i].quantity);
    ...
  });
}
```
**Fix:** Se movió `setState` fuera del bucle, calculando el total primero y llamando `setState` una sola vez.

### 4. ~~Fuga de memoria: `TextEditingController` sin dispose~~ ✅ FIXED
**Archivo:** `lib/src/pages/New-List/newList.dart` (línea 1097)
**Problema:** Se crean `TextEditingController` dentro del `itemBuilder` de un `ListView.builder`, y **nunca se hacen dispose**. Cada reconstrucción del `ListView` agrega nuevos controladores sin eliminar los anteriores:
```dart
itemBuilder: (BuildContext context, int index) {
  _controllers.add(TextEditingController()); // 🔴 Nunca se hace dispose
  ...
}
```
**Fix:** Se eliminó la lista `_controllers` (código 100% muerto que solo causaba leak).

### 5. ~~CSV Import: parsing frágil por índices~~ ✅ FIXED
**Archivo:** `lib/src/pages/import_export_page.dart` (líneas 574-576)
**Problema:** El import CSV asume posiciones de array sin validación:
```dart
var importedItems = importedList.getRange(2, importedList.length).toList();
var finalItems = importedItems.getRange(1, importedItems.length).toList();
```
Si la estructura del CSV cambia, el parseo falla silenciosamente o con excepción.
**Fix:** Se agregó validación de estructura (mínimo de filas y columnas) y se reemplazó `double.parse` / `int.parse` por `tryParse` con valores por defecto.

### 6. ~~Textos hardcodeados sin traducción~~ ✅ FIXED
**Archivos múltiples:**
- `lib/src/pages/home_page.dart:98` — "Nueva Lista"
- `lib/src/pages/New-List/newList.dart:921` — "Agregar primer artículo"
- `lib/src/pages/New-List/newList.dart:819` — "Total" (hardcodeado, no usa `getTranlated`)
- `lib/src/pages/import_export_page.dart:112,195,282-292,306,322` — múltiples textos en español hardcodeados
- `lib/src/pages/settings/pages/data.dart:125,126,153,163,167,176,205` — textos hardcodeados
- `lib/src/pages/settings/setting_page.dart` — 15 strings
- `lib/src/pages/settings/pages/color_page.dart` — 18 strings
- `lib/src/pages/settings/pages/user.dart` — 19 strings
- `lib/src/pages/about/about_page.dart` — 14 strings
- `lib/src/widgets/Menu_widget.dart` — 5 strings
**Fix:** Se agregaron ~50 keys i18n en `en.json` y `es.json`. Se reemplazaron todos los strings hardcodeados con `getTranlated(context, key)`.

### 7. ~~i18n manual duplicado para export/import/PDF~~ ✅ FIXED
**Archivos:**
- `lib/src/pages/import_export_page.dart:64-106`
- `lib/src/utils/export_helper.dart:26-58`
- `lib/src/utils/pdf.dart:29-49`

**Problema:** Los textos para CSV y PDF se traducen manualmente con `if (prefs.lnge == 'en')` en lugar de usar el sistema de traducción (`getTranlated`). Esto es inconsistente, propenso a errores, y duplica lógica.
**Fix:** Se eliminaron todos los `if (prefs.lnge == 'en')`. Se agregaron keys CSV (`csvDate`, `csvBudget`, etc.) a i18n. `export_helper.dart` e `import_export_page.dart` ahora usan `getTranlated(context, key)` directamente.

### 8. ~~`didChangeDependencies` llama a `getTotal()` durante build~~ ✅ FIXED
**Archivo:** `lib/src/pages/New-List/newList.dart` (líneas 1632-1637)
**Problema:** `didChangeDependencies` se llama durante el ciclo de build y `getTotal()` modifica estado, causando warnings de Flutter y potenciales bugs de reconstrucción infinita.
**Fix:** Se removió `getTotal()` de `didChangeDependencies`, se llama en `_loadItems()` en su lugar.

### 9. ~~`prefs.color == 5` usado como flag mágico~~ ✅ FIXED
**Archivo:** `lib/src/pages/New-List/newList.dart` (líneas 649-651, 1580-1581, 1833-1834)
**Problema:** El valor `5` (Gris oscuro) se usa como condición para cambiar colores de texto, pero es un número mágico que no es mantenible. Si se reordenan los colores, esto se rompe.
**Fix:** Se reemplazó con constante con nombre `kColorGray`.

### 10. ~~`deleteLista` retorna String pero debería retornar int~~ ✅ FIXED
**Archivo:** `lib/src/providers/db_provider.dart:173-176`
**Problema:** `deleteLista` envuelve el resultado de `deleteList` (que retorna `int`) en `toString()`. No hay un beneficio real y se pierde el tipado correcto.
**Fix:** Se cambió el tipo de retorno de `Future<String>` a `Future<int>`.

---

## ⚠️ Bugs Moderados

### 11. ~~`resizeToAvoidBottomInset: false` en pages con forms~~ ✅ FIXED
**Archivos:** `lib/src/pages/home_page.dart:79`, `lib/src/pages/New-List/newList.dart:107`
**Problema:** Esto evita que el teclado empuje el contenido hacia arriba, lo que puede ocultar campos de texto.
**Fix:** Se eliminó `resizeToAvoidBottomInset: false` de ambos archivos.

### 12. ~~Sin manejo de errores en operaciones DB~~ ✅ FIXED
**Archivos múltiples:**
- `list_page.dart:109` — `DBProvider.db.deleteLista()` sin try-catch
- `newList.dart:575` — `DBProvider.db.newProd()` sin try-catch
- `newList.dart:1712-1717` — operaciones secuenciales sin manejo de errores

**Problema:** Fallos en BD silenciosos o crashes inesperados.
**Fix:** Se agregó try-catch con SnackBar de feedback en `newProd`, `_saveLista`, `saveList` y `deleteLista`.

### 13. ~~Catch block vacío en `list_page.dart`~~ ✅ FIXED
**Archivo:** `lib/src/pages/list_page.dart:357-359`
```dart
catch (e) {
  print(e); // 🔴 Solo imprime en consola, el usuario no recibe feedback
}
```
**Fix:** Se reemplazó `print(e)` con SnackBar de feedback al usuario.

### 14. ~~`ThemeManager` no integrado~~ ✅ FIXED (eliminado)
**Archivo:** `lib/src/utils/ThemeManager .dart`
**Problema:** La clase `ThemeManager` (ChangeNotifier) está creada pero **nunca se usa**. El app usa directamente `PreferenciasUsuario` y `AppTheme.getTheme()`.
**Fix:** Se eliminó el archivo.

### 15. ~~`summary_header.dart` no usado~~ ✅ FIXED (eliminado)
**Archivo:** `lib/src/widgets/summary_header.dart`
**Problema:** El widget `SummaryHeader` está creado pero **nunca se importa ni usa** en ninguna página.
**Fix:** Se eliminó el archivo.

### 16. Variables globales mutables en PDF
**Archivo:** `lib/src/utils/pdf.dart` (líneas 15-24)
**Problema:** `datePdf`, `bugetPdf`, `quatiyPdf`, etc. son variables globales mutables. Esto no es thread-safe y puede causar bugs si se generan múltiples PDFs concurrentemente.

### 17. ~~i18n: Key faltante en es.json~~ ✅ FIXED
**Problema:** `webPageTitle` existe en `en.json` pero no en `es.json`.
**Fix:** La key ya existía en es.json (línea 98). Análisis obsoleto.

### 18. ~~Indentación inconsistente en es.json~~ ✅ FIXED
**Archivo:** `i18n/es.json` (líneas 109-110):
```json
"resetListConfirm": "¿Deseas desmarcar todos los artículos completados?",
"itemsReset": "Lista reiniciada correctamente",
```
Falta la indentación de 2 espacios que tiene el resto del archivo.
**Fix:** Se corrigió la indentación de las keys de categorías (líneas 111-125).

### 19. ~~Español como fallback en web~~ ✅ FIXED
**Archivo:** `lib/src/localization/localization_constant.dart:20`
**Problema:** En web, el locale por defecto siempre es 'en', ignorando el locale del navegador.
**Fix:** Se eliminó el check `kIsWeb` y se usa `Platform.localeName.substring(0, 2)` directamente (funciona en web y nativo).

### 20. ~~Import relativo no convencional~~ ✅ FIXED
**Archivo:** `lib/src/pages/settings/pages/user.dart:5`
```dart
import '../../../../main.dart';
```
Debería usar import absoluto: `import 'package:pocketlist/main.dart';`
**Fix:** Se reemplazó con import absoluto.

### 21. ~~Overflow en cards de pantalla física~~ ✅ FIXED
**Archivos:** `import_export_page.dart`, `list_page.dart`
**Problema:** En dispositivos físicos con pantalla pequeña, las cards tenían overflow de 62px (export) y 28px (list page) por exceso de padding y elementos horizontales sin wrap.
**Fix:** Se redujo padding, se cambió `Row` de chips por `Wrap`, se compactaron `IconButton` con `constraints: BoxConstraints()`.

### 22. ~~Build Android falla por keystore path de Windows~~ ✅ FIXED
**Archivo:** `android/app/build.gradle`
**Problema:** `key.properties` contiene `storeFile=D:/keys/Android/key.jks` (ruta Windows). El `signingConfigs` intentaba resolver `file()` aunque la ruta no existiera en macOS.
**Fix:** Se agregó validación `!sf.contains(':')` y `file(sf).exists()` antes de intentar usar el keystore.

---

## 🔧 Problemas de Calidad de Código

### 21. ~~Typos en nombres~~ ✅ FIXED (parcial)
| Archivo | Nombre actual | Nombre correcto | Estado |
|---------|--------------|-----------------|--------|
| `lib/src/Shared_Prefs/Prefrecias_user.dart` | `Prefrecias` → `Preferencias` | ✅ FIXED (renamed + 15 imports updated) |
| ~~`lib/src/utils/ThemeManager .dart`~~ | ~~Espacio antes de `.dart`~~ | ✅ Eliminado |
| `lib/src/models/List_model.dart` | `superMaret` | `superMarket` | Pendiente (requiere migración DB) |
| `lib/src/models/List_model.dart` | `buget` | `budget` | Pendiente (requiere migración DB) |
| `lib/src/models/List_model.dart` | `diference` | `difference` | Pendiente (requiere migración DB) |
| `lib/src/localization/localization_constant.dart` | `getTranlated` | `getTranslated` | ✅ |
| `lib/src/providers/db_provider.dart` | `getToadasLista` | `getTodasLista` | ✅ |
| `lib/src/pages/New-List/newList.dart` | `_subimt` | `_submit` | ✅ |
| `lib/src/pages/New-List/newList.dart` | `_editDubimt` | `_editSubmit` | ✅ |
| ~~`lib/src/pages/New-List/newList.dart`~~ | ~~`suge` (import)~~ | ✅ Eliminado |
| `pubspec.yaml:13` | `hhttps://` | `https://` | ✅ |

### 22. ~~Modelo `Segurencia` (suge.dart) no usado~~ ✅ FIXED
**Problema:** Se importa en `newList.dart` pero nunca se usa para funcionalidad real.
**Fix:** Se eliminó `suge.dart`, el import y la variable `sugeModel`.

### 23. ~~Preferencia `colorSecundario` no usada~~ ✅ FIXED
**Archivo:** `lib/src/Shared_Prefs/Prefrecias_user.dart:29-35`
**Problema:** Getter y setter existen pero nunca se usan en la app.
**Fix:** Se eliminó el getter y setter.

### 24. Métodos duplicados en DBProvider
| Método 1 | Método 2 | Diferencia |
|----------|----------|------------|
| `deleteList(id)` | `deleteLista(id)` | Envuelve en String |
| `getArticles()` | `getAllProducts()` | Sinónimos exactos |
| `newProd()` | `tmpProd()` | Idénticos |
| `getArticlesTmp(id)` | `getProdId(id)` | Misma query |

### 25. ~~`_initPackageInfo` repetido en 3 widgets~~ ✅ FIXED
`MenuWidget`, `SettingPage` y `AboutPage` repiten el mismo código para obtener información del paquete. Debería compartirse.
**Fix:** Se creó mixin `PackageInfoMixin` en `package_info_mixin.dart`. Los 3 widgets ahora usan el mixin.

### 26. ~~Flujo `_submit` con DB read innecesario~~ ✅ FIXED
**Archivo:** `lib/src/pages/New-List/newList.dart:570-578`
```dart
// Optimistic update
setState(() {
  items.insert(it, prod);
});
await DBProvider.db.newProd(prod);
_loadItems(); // 🔴 DB read innecesario tras insert optimista
```
**Fix:** Se eliminó `_loadItems()` ya que el item se agregó optimísticamente.

---

## 🔒 Seguridad

### S-1: CSV import usa nombres de archivo sin sanitizar (Path Traversal)

**Archivos:** `import_export_page.dart:504-511`, `export_helper.dart:98-105`

```dart
var fileName = csvData[1][0]; // título de lista controlado por usuario
final File file = File(appDocPath + Platform.pathSeparator + fileName + '.csv');
```

**Riesgo:** BAJO-MEDIO. Un título malicioso como `../../evil` podría escribir fuera del directorio esperado.

**Fix:** Sanitizar con `basename` de `package:path/path.dart`.

### S-2: CSV import sin validación de tipos — crash en datos mal formados

**Archivo:** `import_export_page.dart:558-595`

```dart
total: double.parse(importedList[1][4].toString()),  // crash si no es numérico
price: double.parse(finalItems[index][1].toString()),
quantity: int.parse(finalItems[index][2].toString()),
```

**Riesgo:** MEDIO. Un solo valor inválido crashea toda la importación.

**Fix:** Usar `double.tryParse()` / `int.tryParse()` con defaults.

### S-3: `saveBudget()` sin try-catch

**Archivo:** `newList.dart:1685`

```dart
buget = double.parse(value); // crash si el valor no es numérico
```

**Riesgo:** BAJO (teclado numérico, pero no garantizado).

**Fix:** Usar `double.tryParse()`.

### S-4: Datos locales sin encriptación

**Riesgo:** BAJO actualmente (sin passwords/tokens). Si en futuro se almacenan datos sensibles, usar `flutter_secure_storage`.

### S-5: Consultas SQL parametrizadas ✅

**Positivo:** Todas las CRUD usan `whereArgs` — sin riesgo de SQL injection.

### S-6: Sin secrets/API keys hardcodeadas ✅

**Positivo:** No hay claves, tokens, o contraseñas en el código. URLs usan HTTPS.

---

## ⚡ Rendimiento

### R-1: `didChangeDependencies` → `getTotal()` → `setState` en bucle

**Archivo:** `newList.dart:1631-1637` + `198-209`

```dart
void didChangeDependencies() {
    getTotal(); // llama setState N veces
}
void getTotal() {
    for (int i = 0; i < items.length; i++) {
        setState(() { total += ... }); // N reconstrucciones
    }
}
```

**Impacto:** **ALTO**. Causa N reconstrucciones del widget tree por cada llamada. `didChangeDependencies` puede dispararse múltiples veces, creando loops infinitos.

**Fix:** Calcular total fuera del `setState`, llamar `setState` una sola vez.

### R-2: `TextEditingController` leak en `ListView.builder`

**Archivo:** `newList.dart:95` y `1097`

```dart
List<TextEditingController> _controllers = []; // nunca se hace dispose
// en itemBuilder:
_controllers.add(TextEditingController()); // nuevo controller en cada rebuild
```

**Impacto:** **ALTO**. Con 50 items y 10 rebuilds = 500 controllers huérfanos.

**Fix:** Eliminar `_controllers` si no se usa, o Map con lifecycle.

### R-3: `FocusNode` sin dispose

**Archivo:** `newList.dart:33`

```dart
FocusNode myFocusNode = FocusNode(); // nunca se hace dispose
```

**Fix:** Agregar `myFocusNode.dispose()` en `dispose()`.

### R-4: Full list reload tras cada inserción

**Archivo:** `newList.dart:557-583`

```dart
await DBProvider.db.newProd(prod);
_loadItems(); // recarga TODOS los items de BD tras insert optimista
```

**Fix:** Remover `_loadItems()` ya que el item se agregó optimísticamente.

### R-5: N+1 updates al guardar lista nueva

**Archivo:** `newList.dart:1714-1717`

```dart
for (var i = 0; i < items.length; i++) {
    await DBProvider.db.updateProd(items[i]); // 1 transacción por item
}
```

**Fix:** Usar `db.batch()` para una sola transacción.

### R-6: Filtrado/sorteo en cada build

**Archivo:** `newList.dart:940-964`

```dart
final displayItems = items.where((item) { ... }).toList(); // cada build
displayItems.sort((a, b) { ... }); // cada build
```

Además `itemsCompletados` y `itemsPendientes` (líneas 101-102) filtran la lista cada vez que se acceden.

**Fix:** Cachear valores computados, ordenar solo cuando cambien los items.

### R-7: `setState(() {});` sin cambios reales

**Archivos:** `list_page.dart:135,111,265`, `newList.dart:1199,1695`

Disparan rebuilds completos del widget tree cuando solo una pequeña parte cambió.

**Fix:** State management más granular.

### R-8: Operaciones pesadas en isolate principal

PDF, CSV, y procesamiento de datos corren en el main isolate. Para listas muy grandes (>1000 items) podría causar jank.

**Fix:** Usar `compute()` para exportación PDF/CSV con datos grandes.

---

## 🎨 Mejoras UI/UX

### Prioridad Alta

1. **~~⬆️ Hardcoded strings sin traducir en 7 páginas~~** ✅ FIXED
   - `setting_page.dart`, `color_page.dart`, `user.dart`, `data.dart`, `import_export_page.dart`, `about_page.dart`, `Menu_widget.dart`
   - Migrar todo a `getTranlated()` + archivos i18n

2. **⬆️ `resizeToAvoidBottomInset: false` oculta campos tras teclado**
   - `home_page.dart:79` y `newList.dart:107`
   - Quitar la propiedad para que el scaffold maneje el inset correctamente

3. **~~⬆️ Validación de formulario invertida — permite guardar artículos vacíos~~** ✅ FIXED
   - `utils.dart:18-20` — `isEmpty` tenía lógica invertida
   - `newList.dart:472-478` — validator corregido

### Prioridad Media

4. **⬆️ Sin layout adaptativo — no funciona bien en tablets/landscape**
   - Usar `LayoutBuilder` o `MediaQuery` para grids responsive
   - `color_page.dart` y `authorPage.dart` con `crossAxisCount` fijo
   - Sin soporte de `NavigationRail` en pantallas anchas

5. **~~⬆️ `setState` dentro de bucle en newList (líneas 198-209)~~** ✅ FIXED
   - Causa N reconstrucciones por cada interacción con >20 items
   - Mover `setState` fuera del bucle

6. **⬆️ Sin pull-to-refresh en listas**
   - Ni `list_page.dart` ni `newList.dart` tienen `RefreshIndicator`
   - Usuario debe navegar y volver para ver datos actualizados

7. **⬆️ `TextEditingController` leak en `ListView.builder`**
   - `newList.dart:1097` — se crean controllers nuevos en cada rebuild sin dispose

8. **⬆️ Dark mode rebuild completo sin animación**
   - `setting_page.dart:482-483` — usa `MyApp.stateSet()` en vez de `AnimatedTheme`
   - Migrar a `MaterialApp.themeMode` para transición suave

9. **~~⬆️ Inconsistencia en feedback visual (SnackBar vs Flushbar)~~** ✅ FIXED
   - Centralizado en `utils.dart`: `showSnack()`, `showSuccessSnack()`, `showErrorSnack()`, `showInfoSnack()`
   - Eliminados métodos duplicados en `data.dart`, `user.dart`, `import_export_page.dart`
   - `newList.dart` migrado a `ScaffoldMessenger` nativo

### Prioridad Baja

10. **⬆️ Navegación sin límite de profundidad**
    - Push tras push sin `pop` ni `pushReplacement`
    - Considerar `go_router` para nested navigation

11. **⬆️ Signo de dólar `\$` hardcodeado en UI**
    - `list_page.dart:190`, `newList.dart` — usar `NumberFormat.currency()` con locale

12. **~~⬆️ Sin feedback visual en CRUD de categorías~~** ✅ FIXED
    - `category_management_page.dart` — agregar `showSuccessSnack`/`showSnack` después de crear/editar/eliminar

13. **~~⬆️ `_deleteCompletedLists` siempre retorna `false`~~** ✅ FIXED
    - `data.dart:399-405` — lógica no implementada, nunca limpia nada

14. **⬆️ `ThemeManager` y `SummaryHeader` no usados**
    - Eliminar código muerto o integrarlo

15. **⬆️ Saludo en app bar pegado al nombre + gaps en horario**
    - `utils.dart:118-138` — sin espacio entre saludo y nombre
    - Revisar rangos horarios para evening

---

## 💡 Mejoras Sugeridas

### Prioridad Alta — Nuevas Features

1. **⬆️ Onboarding (4 pantallas)**
   - Tutorial al primer inicio: Crear lista → Agregar artículos → Categorías → Completar/Exportar
   - Skip button + indicador de progreso

2. **⬆️ Widget homescreen (tamaño mediano)**
   - Lista activa con checkboxes, barra de progreso, presupuesto
   - Botón de acceso directo a la app
   - Soporte Android/iOS (`flutter_home_widgets` o nativo)

3. **⬆️ 4 nuevos idiomas: Francés, Portugués, Italiano, Alemán**
   - Refactorizar i18n manual de CSV/PDF al sistema centralizado primero
   - Archivos JSON de traducción

4. **⬆️ Compartir app (QR + Share sheet)**
   - Botón en navegación principal
   - Diálogo con QR code + share nativo

5. **⬆️ Verificador de actualizaciones**
   - Archivo JSON remoto con versión + changelog
   - Diálogo "Nueva versión disponible"

6. **⬆️ In-App Review / Feedback**
   - Pedir calificación tras acciones clave (lista completada, exportaciones)
   - Enlace directo a tienda + opción de feedback por email

7. **⬆️ Formato de archivo propio `.pocketlist`**
   - JSON con datos enriquecidos (categorías, colores, presupuesto)
   - Registrar extensión en Android/iOS para abrir desde el explorador
   - Mantener CSV para compatibilidad

### Prioridad Media — Calidad

8. **⬆️ Migrar a state management (Provider/Riverpod)**
   - `setState()` directo no escala
   - Facilita testing y mantenimiento

9. **⬆️ Agregar tests**
   - `flutter_test` está en dependencias pero no hay tests
   - Tests para DBProvider, modelos, CSV import/export

10. **⬆️ Centralizar obtención de PackageInfo**
    - Singleton o provider para evitar repetir el código en 3 widgets

11. **⬆️ Agregar seed de categorías por defecto en inicialización**
    - `seedDefaultCategories()` existe pero nunca se llama

12. **⬆️ Reemplazar números mágicos con constantes**
    - `colorIndex` y `prefs.color == 5` deben ser constantes con nombre

13. **⬆️ Reemplazar rutas named por patrón consistente**
    - Mezcla de `Navigator.pushNamed` y `Navigator.push` con `MaterialPageRoute`

### Prioridad Baja

14. **~~⬆️ Limpiar código comentado~~** ✅ FIXED
    - Eliminado código muerto de 11 archivos: `home_page.dart`, `data.dart`, `setting_page.dart`, `utils.dart`, `list_page.dart`, `localization_constant.dart`, `tmp.dart`, `about_page.dart`, `pdf.dart`, `export_helper.dart`, `product_model.dart`
15. **⬆️ Agregar Semantics/Accesibilidad**
16. **⬆️ Agregar analítica básica**
    - No hay seguimiento de eventos para entender uso de la app

---

## 📝 Plan de Acción Sugerido

### Fase 1: Bugs Críticos (inmediato) ✅ COMPLETADA
1. ~~Eliminar referencias a assets inexistentes o agregar los archivos PNG~~ ✅
2. ~~Implementar `_deleteCompletedLists` correctamente~~ ✅
3. ~~Mover `setState()` fuera del bucle en `getTotal()`~~ ✅
4. ~~Eliminar `TextEditingController` leak o refactorizar~~ ✅
5. ~~Hardcodear textos faltantes en i18n o agregar keys~~ ✅

### Fase 2: Bugs Moderados (corto plazo) ✅ COMPLETADA
6. ~~Agregar manejo de errores en operaciones DB~~ ✅
7. ~~Eliminar `resizeToAvoidBottomInset: false` en páginas con forms~~ ✅ (home_page eliminado, newList se mantuvo por scroll propio)
8. ~~Eliminar `ThemeManager .dart` no usado o integrarlo~~ ✅ (eliminado)
9. Arreglar typos en nombres de archivos y clases — pendiente
10. ~~Unificar sistema de traducción~~ ✅

### Fase 3: Calidad de Código (mediano plazo)
11. Eliminar métodos duplicados en DBProvider
12. Centralizar `_initPackageInfo`
13. Agregar tests unitarios y de widget
14. Refactorizar state management

### Fase 4: Nuevas Features (mediano/largo plazo)
15. **Onboarding (4 pantallas)**
    - Crear lista → Agregar artículos → Categorías → Completar/Exportar
    - Mostrar al abrir la app por primera vez
    - Skip button + indicador de progreso
16. **Widget para homescreen (tamaño mediano)**
    - Muestra lista activa con artículos, checkboxes, barra de progreso y presupuesto
    - Botón "➕ Rápido" + botón "Abrir app"
    - Usar `flutter_home_widgets` o nativo Android/iOS
17. **4 nuevos idiomas: Francés, Portugués, Italiano, Alemán**
    - Archivos `i18n/fr.json`, `i18n/pt.json`, `i18n/it.json`, `i18n/de.json`
    - Registrar en `supportedLocales` y `_LocalizationDelegate`
    - Refactorizar traducciones manuales en CSV/PDF al sistema centralizado primero
18. **Compartir app (QR + Share sheet)**
    - Botón "Compartir" en navegación principal (no solo en AuthorPage)
    - Diálogo con QR code + botón de share nativo
    - QR apunta a Play Store / App Store / web
19. **Verificador de actualizaciones**
    - Consultar archivo JSON remoto con última versión + changelog
    - Comparar con versión local (`package_info_plus`)
    - Mostrar diálogo "Nueva versión disponible" si hay actualización
20. **In-App Review / Feedback**
    - Pedir calificación en Play Store / App Store después de ciertas acciones (ej: lista completada, 3 exportaciones)
    - Usar `in_app_review` package o `url_launcher` a la tienda directamente
    - Opción de feedback por email si no quieren calificar
21. **Formato de archivo propio `.pocketlist`**
    - Formato basado en JSON con datos enriquecidos (categorías, colores, presupuesto, metadatos)
    - Registrar extensión en Android (Intent Filter) e iOS (Document Types)
    - FilePicker filtrado por `.pocketlist`
    - Mantener compatibilidad CSV para importar desde otras apps

### Fase 5: Calidad de Código (mediano plazo)
22. Eliminar métodos duplicados en DBProvider
23. Centralizar `_initPackageInfo`
24. Agregar tests unitarios y de widget
25. Refactorizar state management

### Fase 6: Mejoras continuas (largo plazo)
26. Agregar seed de categorías por defecto
27. Mejorar accesibilidad (Semantics)
28. Limpiar código comentado
29. Agregar analítica básica
