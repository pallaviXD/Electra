# Electra – AI-Powered Election Assistant

> A civic tech Flutter app that helps citizens understand, prepare for, and participate in elections using AI.

---

## What is Electra?

Electra is a cross-platform mobile and web application built for the **General Elections 2026**. It combines an AI chatbot, real-time election tools, and civic education into one accessible platform — designed for every Indian voter regardless of literacy level or language.

---

## Features

### Authentication
- Secure sign up with government-required fields: Full Name, Date of Birth, Mobile Number, Email
- Age gate — minimum 18 years enforced at registration
- Persistent login session using local storage
- Sign in / Sign out from Settings

### AI Chatbot (Electra AI)
- Powered by **Groq API** (Llama 3.3 70B) — fast, free, and reliable
- Strictly neutral — never endorses any party or candidate
- **Multilingual** — responds in 11 Indian languages: English, Hindi, Telugu, Tamil, Kannada, Marathi, Bengali, Gujarati, Punjabi, Malayalam, Urdu
- Language selector directly in the chat screen
- Suggestion chips for follow-up questions
- Trust & Transparency metadata on every AI response
- Sensitive query detection — redirects "who should I vote for" questions appropriately

### Election Tools
| Tool | Description |
|------|-------------|
| How to Vote | Step-by-step voting guide |
| Election Timeline | Key dates and phases |
| Check Eligibility | Voter eligibility checker |
| Find Polling Booth | Locate your nearest booth |
| Voting Simulator | Practice the voting process |
| Compare Candidates | Side-by-side candidate comparison |
| Manifesto Simplifier | AI simplifies party manifestos into plain language |
| Fact Checker | AI-powered misinformation detection |
| Who Matches Me? | Quiz to find aligned political values |
| Results Tracker | Live election results |
| News & Updates | Latest election news |

### UI / UX
- Clean, modern Material 3 design with a parrot green brand palette
- Floating glassmorphism bottom navigation bar
- Smooth animations via `flutter_animate`
- Fully responsive — works on Android, iOS, and Web
- Disclaimer banners on all AI-generated content

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x (Dart) |
| AI / Chatbot | Groq API — Llama 3.3 70B Versatile |
| State Management | Provider |
| Navigation | GoRouter |
| Backend / Auth | Firebase Auth + Firestore (optional), local auth via SharedPreferences |
| Fonts | Google Fonts (Inter) |
| Animations | flutter_animate, shimmer |
| Storage | shared_preferences |
| HTTP | http package |
| TTS / STT | flutter_tts, speech_to_text |

---

## Getting Started

### Prerequisites
- Flutter SDK `^3.11.5`
- Dart SDK `^3.11.5`
- A free Groq API key from [console.groq.com/keys](https://console.groq.com/keys)

### Installation

```bash
# Clone the repo
git clone https://github.com/your-username/electra.git
cd electra

# Install dependencies
flutter pub get
```

### Configure API Key

Open `lib/config/constants.dart` and replace the key:

```dart
static const String geminiApiKey = 'gsk_YOUR_GROQ_KEY_HERE';
```

Get a free key at [console.groq.com/keys](https://console.groq.com/keys) — no billing required, 14,400 requests/day free.

### Run

```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# Windows
flutter run -d windows
```

---

## Firebase Setup (Optional)

Firebase is optional — the app runs fully without it using local auth. To enable cloud sync:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

This generates `lib/firebase_options.dart` and enables cloud-based auth and Firestore sync.

---

## Project Structure

```
lib/
├── config/
│   ├── constants.dart       # API keys, system prompt, app constants
│   ├── routes.dart          # GoRouter navigation config
│   └── theme.dart           # Brand colors, typography, shadows
├── models/                  # Data models (ChatMessage, Candidate, etc.)
├── providers/
│   ├── auth_provider.dart   # Local auth state (signup/login/session)
│   ├── chat_provider.dart   # Chat state management
│   └── settings_provider.dart
├── screens/
│   ├── auth/                # Login, Signup, AuthGate
│   ├── chat/                # AI chatbot screen
│   ├── home/                # Home dashboard
│   ├── candidates/          # Candidate comparison
│   ├── eligibility/         # Voter eligibility checker
│   ├── manifesto/           # Manifesto simplifier
│   ├── misinfo/             # Fact checker
│   ├── news/                # Election news
│   ├── polling_booth/       # Booth finder
│   ├── quiz/                # Political values quiz
│   ├── results/             # Results tracker
│   ├── simulator/           # Voting simulator
│   ├── timeline/            # Election timeline
│   └── voting_guide/        # How to vote guide
├── services/
│   ├── ai_orchestrator.dart # Routes AI requests, handles sensitive queries
│   ├── firebase_service.dart
│   ├── gemini_service.dart  # Groq API client
│   └── trust_service.dart   # Trust metadata for AI responses
└── widgets/                 # Reusable UI components
```

---

## AI Neutrality Policy

Electra is built on strict neutrality principles:

- Never endorses, recommends, or favors any political party, candidate, or ideology
- Sensitive queries ("who should I vote for") are detected and redirected
- All AI responses include Trust & Transparency metadata
- Disclaimer banners on all AI-generated content
- Users are always reminded they are interacting with an AI

---

## Supported Languages

English · हिन्दी · తెలుగు · தமிழ் · ಕನ್ನಡ · मराठी · বাংলা · ગુજરાતી · ਪੰਜਾਬੀ · മലയാളം · اردو

---

## License

This project was built for a hackathon. All rights reserved.

---

## Disclaimer

Electra is an informational platform only. It is not affiliated with the Election Commission of India or any government body. All AI-generated content is for educational purposes and should not be taken as official guidance.
