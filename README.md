# Inventory App 📦

Una aplicación móvil desarrollada en Flutter que permite gestionar una lista de productos obtenidos desde la API de FakeStore. Los usuarios pueden guardar productos con nombres personalizados y administrarlos localmente.

## 📱 Características

- ✅ **Catálogo de productos**: Consulta y visualiza productos desde FakeStore API
- ✅ **Búsqueda en tiempo real**: Filtra productos por nombre, descripción o categoría
- ✅ **Guardado personalizado**: Guarda productos con nombres personalizados
- ✅ **Gestión local**: Edita y elimina productos guardados
- ✅ **Persistencia**: Los datos se mantienen usando Hive
- ✅ **Diseño responsive**: Adaptable a diferentes tamaños de pantalla
- ✅ **Animaciones fluidas**: Transiciones y micro-interacciones suaves

## 🏗️ Arquitectura

El proyecto sigue una arquitectura **Feature-First Clean Architecture** combinada con **Atomic Design** para los componentes de UI.

### Estructura de Carpetas

```
lib/
├── app.dart                          # Widget principal de la app
├── main.dart                         # Entry point
├── injection_container.dart          # Inyección de dependencias (GetIt)
│
├── core/                             # Funcionalidades core compartidas
│   ├── constants/                    # Constantes (API, App)
│   ├── error/                        # Manejo de errores (Failures, Exceptions)
│   ├── network/                      # Cliente HTTP y Network Info
│   ├── router/                       # Configuración de rutas (GoRouter)
│   ├── theme/                        # Tema de la aplicación
│   └── usecases/                     # Base de casos de uso
│
├── design_system/                    # Sistema de diseño (Atomic Design)
│   ├── tokens/                       # Tokens de diseño
│   │   ├── app_colors.dart           # Paleta de colores
│   │   ├── app_typography.dart       # Tipografía
│   │   ├── app_spacing.dart          # Espaciado y radios
│   │   └── app_shadows.dart          # Sombras
│   ├── atoms/                        # Componentes atómicos
│   │   ├── app_text.dart             # Texto
│   │   ├── app_button.dart           # Botones
│   │   ├── app_image.dart            # Imágenes con caché
│   │   ├── app_text_field.dart       # Campos de texto
│   │   ├── app_loading.dart          # Indicadores de carga
│   │   └── app_badge.dart            # Badges/Chips
│   ├── molecules/                    # Moléculas (combinación de átomos)
│   │   ├── app_card.dart             # Cards
│   │   ├── app_list_item.dart        # Items de lista
│   │   ├── app_empty_state.dart      # Estados vacíos/error
│   │   └── app_dialog.dart           # Diálogos y Snackbars
│   ├── organisms/                    # Organismos (componentes complejos)
│   │   ├── product_card.dart         # Card de producto
│   │   ├── saved_item_card.dart      # Card de item guardado
│   │   └── app_app_bar.dart          # AppBar personalizado
│   └── templates/                    # Plantillas de página
│       └── page_template.dart        # Templates base
│
└── features/                         # Features de la aplicación
    ├── api_products/                 # Feature: Productos de API
    │   ├── data/
    │   │   ├── datasources/          # Remote data source
    │   │   ├── models/               # Modelos (fromJson/toJson)
    │   │   └── repositories/         # Implementación de repositorio
    │   ├── domain/
    │   │   ├── entities/             # Entidades de dominio
    │   │   ├── repositories/         # Contratos de repositorio
    │   │   └── usecases/             # Casos de uso
    │   └── presentation/
    │       ├── cubit/                # Estado (ApiProductsCubit)
    │       ├── pages/                # Páginas
    │       └── widgets/              # Widgets específicos
    │
    ├── saved_items/                  # Feature: Items Guardados
    │   ├── data/
    │   │   ├── datasources/          # Local data source (Hive)
    │   │   ├── models/               # Modelo Hive
    │   │   └── repositories/         # Implementación de repositorio
    │   ├── domain/
    │   │   ├── entities/             # Entidad SavedItem
    │   │   ├── repositories/         # Contrato de repositorio
    │   │   └── usecases/             # CRUD use cases
    │   └── presentation/
    │       ├── cubit/                # Estado (SavedItemsCubit)
    │       └── pages/                # Páginas (lista, crear, detalle)
    │
    └── splash/                       # Feature: Splash Screen
        └── presentation/
            ├── cubit/                # SplashCubit
            └── pages/                # Splash animado
```

## 🛠️ Tecnologías y Dependencias

| Categoría | Librería | Propósito |
|-----------|----------|-----------|
| **State Management** | flutter_bloc | Patrón BLoC/Cubit |
| **Navigation** | go_router | Rutas nombradas |
| **Network** | http | Cliente HTTP |
| **Local Storage** | hive, hive_flutter | Base de datos local |
| **DI** | get_it | Inyección de dependencias |
| **Functional** | dartz | Either, Option |
| **Images** | cached_network_image | Caché de imágenes |
| **Connectivity** | connectivity_plus | Estado de red |

## 📍 Rutas

| Ruta | Descripción |
|------|-------------|
| `/` | Splash screen |
| `/api-list` | Listado de productos de la API |
| `/prefs` | Listado de items guardados |
| `/prefs/new` | Crear nuevo item guardado |
| `/prefs/:id` | Detalle de item guardado |

## 🚀 Instalación y Ejecución

### Requisitos Previos

- Flutter 3.35.5 o superior
- Dart 3.9.2 o superior

### Pasos

1. **Clonar el repositorio**
   ```bash
   git clone <repository-url>
   cd inventory_app
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Generar archivos de Hive** (si es necesario)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Ejecutar la aplicación**
   ```bash
   # Debug
   flutter run

   # Release
   flutter run --release
   ```

### Ejecutar Tests
```bash
flutter test
```

### Build
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 🎨 Sistema de Diseño

### Tokens de Color
- **Primary**: Indigo (#6366F1)
- **Secondary**: Emerald (#10B981)
- **Tertiary**: Amber (#F59E0B)
- **Neutrals**: Escala de grises

### Tipografía
- Font Family: Roboto
- Escalas: Display, Headline, Title, Body, Label

### Espaciado
- Base unit: 4px
- Scale: xs(4), sm(8), md(12), lg(16), xl(20), xxl(24), xxxl(32)

## 📋 Decisiones Técnicas

### ¿Por qué Clean Architecture?
- **Separación de responsabilidades**: Cada capa tiene un propósito específico
- **Testabilidad**: Las dependencias se inyectan, facilitando el testing
- **Mantenibilidad**: Cambios en una capa no afectan a otras
- **Escalabilidad**: Fácil agregar nuevas features siguiendo el patrón

### ¿Por qué Cubit sobre BLoC?
- **Simplicidad**: Para operaciones simples, Cubit es más conciso
- **Menor boilerplate**: No requiere definir eventos separados
- **Mismo poder**: Hereda de BLoC, acceso a streams y estados

### ¿Por qué Hive?
- **Performance**: Extremadamente rápido, escrito en Dart puro
- **No SQL**: Perfecto para datos simples de key-value
- **Type-safe**: Adaptadores generados con código tipado
- **Sin dependencias nativas**: Funciona en todas las plataformas

### ¿Por qué Atomic Design?
- **Reutilización**: Componentes pequeños y combinables
- **Consistencia**: UI uniforme en toda la app
- **Mantenibilidad**: Cambios en un átomo se reflejan globalmente

## 👨‍💻 Autor

Desarrollado como prueba técnica de Flutter.

## 📄 Licencia

Este proyecto es de uso privado para evaluación técnica.
