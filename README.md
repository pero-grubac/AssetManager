<div align="center">

# 📱 AssetManager

![Flutter](https://img.shields.io/badge/Flutter-Mobile_App-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-Language-0175C2?logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-State_Management-success?logo=dart)
![SQLite](https://img.shields.io/badge/SQLite-Local_DB-lightgrey?logo=sqlite&logoColor=003B57)
![Google Maps](https://img.shields.io/badge/Google_Maps-Location-4285F4?logo=googlemaps&logoColor=white)

<img src="readme_assets/demo.gif" alt="AssetManager demo" width="300">

</div>

## 📌 Project Overview

**AssetManager** is an Android application for tracking and managing company assets — furniture, electronics, and office supplies. Features barcode scanning, Google Maps location view, multi-language support, and full CRUD operations.

---

## ✨ Features

### 🏷️ Asset Management

- Full CRUD operations for assets
- Asset attributes: name, description, barcode, price, creation date, assigned employee, location, and image
- Barcode entry via manual input or camera scanning
- Image upload from gallery or camera capture

### 📋 Lists & Search

- Browse assets, employees, locations, and inventory lists
- Search by multiple criteria in each list

### 📦 Inventory Lists

- Create inventory lists with multiple items
- Each item tracks current and new employee assignment and location
- Barcode scanning auto-fills asset data during item creation

### 📍 Asset Location

- View asset location on Google Maps with city pin
- Click pin to see all assets in that location

### 🌐 Localization

- English and Serbian language support
- Switchable from Settings screen

### 🎨 Theming

- Dark and Light theme support

---

## 🚀 Setup & Run

### Prerequisites

- Flutter SDK `>=3.4.3`
- Android Studio with Android SDK
- Physical Android device or emulator (Android 8.0+)
- Google Maps API key

### 1. Clone the repository

```bash
git clone https://github.com/pero-grubac/AssetManager.git
cd AssetManager
```

### 2. Configure Google Maps API key

Create or edit `android/local.properties` and add:

```properties
MAPS_API_KEY=your_google_maps_api_key_here
```

Or add the key directly in `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
```

> Get a free API key at [Google Cloud Console](https://console.cloud.google.com/) — enable **Maps SDK for Android**.

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the app

```bash
flutter run
```

---

## 🛠️ Tech Stack

| Technology            | Usage                              |
| --------------------- | ---------------------------------- |
| Flutter / Dart        | Cross-platform mobile framework    |
| Riverpod              | State management                   |
| SQLite (sqflite)      | Local database                     |
| Google Maps Flutter   | Map and location display           |
| Mobile Scanner        | Barcode scanning via camera        |
| SharedPreferences     | User preferences (theme, language) |
| Image Picker          | Camera and gallery image selection |
| Flutter Localizations | EN / SR language support           |
