# Safe Space - Wellbeing Application

A Flutter application designed for wellbeing, powered by Google Gemini AI and Firebase.

## Features

- **AI Companion**: Chat with a supportive AI assistant (Gemini).
- **Journaling**: (Coming Soon) Track your daily thoughts.
- **Meditation**: (Coming Soon) Mindfulness resources.

## Setup Instructions

### 1. Prerequisites

- Flutter SDK installed (`flutter doctor`)
- Firebase CLI installed (`npm install -g firebase-tools`)
- A Google Cloud Project with Gemini API enabled.

### 2. Firebase Configuration

Run the following command to connect your app to Firebase:

```bash
flutterfire configure
```

This will generate `lib/firebase_options.dart`. Once generated, uncomment the Firebase initialization code in `lib/main.dart`.

### 3. Gemini API Key

Get your API key from [Google AI Studio](https://makersuite.google.com/app/apikey).

You can run the app with your API key using:

```bash
flutter run --dart-define=GEMINI_API_KEY=your_api_key_here
```

Or, for development, you can hardcode it in `lib/services/gemini_service.dart` (not recommended for production).

### 4. Running the App

```bash
flutter run
```
