# 🌟 Lumio - AI Wallpaper Generator

<div align="center">

  **AI-Powered Personalized Wallpaper App**

  [Features](#-features) • [Demo](#-demo) • [Installation](#-installation) • [How It Works](#-how-it-works)

</div>

---

## 📱 About

**Lumio** (Lucy Wall Paper) is an intelligent wallpaper generation app that creates unique, personalized wallpapers based on your mood, energy, style preferences, and even your zodiac sign!

### 🎯 Core Concept
- Answer 3 simple questions about your current state
- AI analyzes your personality, weather, and preferences
- Generates 9 beautiful card-style wallpapers
- Pick one lucky wallpaper that resonates with you

---

## ✨ Features

### 🧠 Intelligent Generation
- **Personalized Elements**: AI selects creative elements based on zodiac sign, age, weather
- **Two-Stage Selection**: Random pool shuffling + AI smart selection for maximum diversity
- **Coordinated Design**: AI ensures all elements work harmoniously together

### 🎨 Creative Elements
- **15 Locations**: From zen gardens to space nebulas
- **15 Art Styles**: Watercolor, cyberpunk, fantasy art, and more
- **20 Visual Elements**: Cherry blossoms, stars, crystals, lanterns
- **10 Atmospheres**: Dreamy soft, vibrant colors, mysterious dark
- **10 Lighting Effects**: Golden hour, moonlit night, starlit sky

### 🎲 Randomness System
- Fisher-Yates shuffle algorithm for true randomness
- Time-based random seeds (every generation is unique)
- 10^20 possible combinations (almost infinite variety)

### 💾 User Experience
- **First-time Onboarding**: Collect zodiac sign and age
- **Weather Integration**: Automatically fetches current weather
- **Local Storage**: Remembers your preferences
- **Save to Album**: One-tap save with watermark

---

## 🎬 Demo

### User Flow
```
Splash Screen
    ↓
Onboarding (First Time Only)
    ↓
Answer 3 Questions
    ├─ How's your mood? (Slider)
    ├─ What energy do you want? (Slider)
    └─ What style do you like? (Slider + Optional Input)
    ↓
AI Generation Process
    ├─ Fetch Weather
    ├─ Stage 1: Random Pool Shuffling
    ├─ Stage 2: AI Smart Selection
    ├─ Generate Description
    └─ Generate Image
    ↓
9-Card Selection
    ↓
Save Wallpaper
```

### Sample Outputs

#### Generation 1: Cyberpunk Space
```
🎲 Seed: 1710405805123
🎨 Elements: Space nebula, Cyberpunk style, Stars, Neon lights
📝 "A futuristic cyberpunk scene set in deep space with neon lights..."
```

#### Generation 2: Fantasy Mountain
```
🎲 Seed: 1710405898765
🎨 Elements: Mountain peak, Fantasy art, Floating lanterns, Mist
📝 "A mystical mountain landscape illuminated by floating lanterns..."
```

#### Generation 3: Ocean Dreams
```
🎲 Seed: 1710405951234
🎨 Elements: Ocean depths, Digital art, Crystals, Waves
📝 "A digital art interpretation of ocean depths with crystals..."
```

---

## 🚀 Installation

### Prerequisites
- Flutter SDK 3.41.4 or higher
- Dart SDK 3.11.1 or higher
- iOS Simulator / Android Emulator
- Xcode (for iOS development)

### Setup

1. **Clone the repository**
```bash
git clone https://github.com/youwan2y/lumio.git
cd lumio
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure API Keys**

Edit `lib/config/api_config.dart`:
```dart
class ApiConfig {
  // 通义千问 LLM API
  static const String llmApiKey = 'YOUR_LLM_API_KEY';

  // 豆包图像生成 API
  static const String imageApiKey = 'YOUR_IMAGE_API_KEY';
}
```

4. **Run the app**
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android
```

---

## 🔧 How It Works

### Three-Step Generation Process

#### Step 1: User Input & Weather
- Collect mood, energy, style preferences (sliders 0-1)
- Fetch current weather via wttr.in API
- Gather user profile (zodiac, age)

#### Step 2: AI Smart Selection (Two-Stage)

**Stage 1: Random Pool Shuffling**
- Generate random seed (timestamp)
- Shuffle all element pools using Fisher-Yates algorithm
- Select subset: 5 locations, 5 styles, 10 elements, 5 atmospheres, 5 lighting
- Result: 30 candidate elements

**Stage 2: AI Selection**
- Send 30 candidates to LLM (Qwen-Flash)
- AI selects 4-6 most harmonious elements
- Temperature: 1.0 (high creativity)
- Considers: zodiac traits, weather, user mood

#### Step 3: Description & Image Generation

**Description Generation**
- LLM creates poetic English description (80-100 words)
- Naturally fuses all selected elements
- Captures mood and atmosphere

**Image Generation**
- Send description to Doubao Image API
- Generate 2K HD wallpaper (3136x1312)
- Apply watermark: "Lumio - Lucy Wall Paper"
- Create 9 identical cards for selection

---

## 🎨 Technical Stack

### Frontend
- **Flutter 3.41.4** - Cross-platform framework
- **Provider** - State management
- **Dio** - HTTP client
- **Cached Network Image** - Image caching

### Backend APIs
- **通义千问 Qwen-Flash** - LLM for element selection & description
- **豆包 Doubao Seedream** - Image generation
- **wttr.in** - Weather data

### Storage
- **Shared Preferences** - Local user data

### Image Processing
- **image** package - Watermark overlay

---

## 📁 Project Structure

```
lib/
├── config/
│   ├── api_config.dart          # API keys and endpoints
│   └── app_theme.dart           # App theming
├── models/
│   └── models.dart              # Data models + RandomElementPool
├── providers/
│   └── app_state.dart           # Global state management
├── services/
│   └── services.dart            # LLM, Image, Weather services
├── screens/
│   ├── splash_screen.dart       # Launch screen
│   ├── onboarding_screen.dart   # First-time user info
│   ├── question_screen.dart     # 3-question input
│   ├── loading_screen.dart      # Generation progress
│   ├── card_screen.dart         # 9-card selection
│   └── result_screen.dart       # Final wallpaper view
├── widgets/
│   └── widgets.dart             # Shared components
└── main.dart                    # App entry point
```

---

## 🎯 Key Features Explained

### Two-Stage Random Selection

**Problem**: AI tends to select "safe" elements (e.g., always choosing "Japanese temple")

**Solution**:
1. **Stage 1 (Random)**: Shuffle all pools, select 30 random candidates
2. **Stage 2 (Smart)**: AI picks 4-6 harmonious elements from the 30

**Result**: 10^20 possible combinations, almost zero repetition!

### Zodiac-Based Personalization

- **Fire Signs** (Aries, Leo, Sagittarius) → Warm, energetic elements
- **Water Signs** (Cancer, Scorpio, Pisces) → Ocean, dreamy elements
- **Earth Signs** (Taurus, Virgo, Capricorn) → Natural, stable elements
- **Air Signs** (Gemini, Libra, Aquarius) → Sky, freedom elements

### Weather Integration

- Sunny → Bright, warm elements
- Rainy → Soft, misty elements
- Cloudy → Mysterious, dark elements

---

## 🧪 Testing

### Quick Test (5 minutes)

```bash
flutter run -d ios
```

1. Generate wallpaper → Note the seed and elements
2. Generate again → Verify different seed and elements
3. Confirm no repetition of styles

### Expected Results
- ✅ Different random seed each time
- ✅ Different shuffled pool each time
- ✅ Different AI-selected elements each time
- ✅ Visually distinct wallpapers

See [QUICK_TEST_GUIDE.md](QUICK_TEST_GUIDE.md) for detailed testing instructions.

---

## 📊 Performance

- **Generation Time**: ~33-45 seconds
  - Weather fetch: ~0.5s
  - Element selection: ~1-2s
  - Description: ~1-2s
  - Image generation: ~30-40s

- **Combination Space**: ~10^20 possibilities
- **Repetition Rate**: Almost 0%

---

## 🔐 Security Notes

⚠️ **Important**: Never commit API keys to version control!

- Add `lib/config/api_config.dart` to `.gitignore` if it contains real keys
- Use environment variables or secure key management in production

---

## 📚 Documentation

- [FLUTTER_TUTORIAL.md](FLUTTER_TUTORIAL.md) - Detailed Flutter development guide
- [THREE_STEP_GENERATION.md](THREE_STEP_GENERATION.md) - Generation system explanation
- [TWO_STAGE_RANDOM_SELECTION.md](TWO_STAGE_RANDOM_SELECTION.md) - Random selection algorithm
- [QUICK_TEST_GUIDE.md](QUICK_TEST_GUIDE.md) - Testing instructions

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

## 🙏 Acknowledgments

- **通义千问 Qwen** - LLM API
- **豆包 Doubao** - Image generation API
- **Flutter Team** - Amazing framework
- **wttr.in** - Free weather API

---

<div align="center">

**Made with ❤️ by Lumio Team**

[⬆ Back to Top](#-lumio---ai-wallpaper-generator)

</div>
