# Nudge — Digital Icebreaker

Nudge is a Flutter-based mobile application designed to bridge the gap between strangers by providing AI-powered icebreakers and conversation starters. It's built to facilitate smoother social interactions in various real-world scenarios.

## 🚀 Features

- **AI-Powered Icebreakers**: Leverages the **Groq API (Llama 3.1)** to generate natural, context-aware opening lines based on the setting and chosen topic.
- **Handover Mode**: A dedicated flow for passing your device to a stranger to let them choose a topic they are comfortable with.
- **Scenario-Based Context**: Tailor icebreakers to specific environments (e.g., conferences, cafes, parks).
- **Multi-language Support**: Fully localized in **English**, **Sinhala**, and **Tamil**.
- **Interaction History**: Keep track of your social "nudges," including planned vs. actual conversation duration and outcomes.
- **Stay Awake**: Uses `wakelock_plus` to keep the screen on during the handover process.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: Provider
- **AI Integration**: Groq Cloud API (REST)
- **Persistence**: Shared Preferences
- **Environment Variables**: flutter_dotenv
- **Localization**: Flutter Intl (ARB files)

## 📦 Getting Started

### Prerequisites

- Flutter SDK (latest stable version recommended)
- A Groq API Key (get one at [console.groq.com](https://console.groq.com/))

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/Nudge---Digital-Icebreaker.git
   cd Nudge---Digital-Icebreaker
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Set up Environment Variables:**
   Create a `.env` file in the root directory and add your Groq API key:
   ```env
   GROQ_API_KEY=your_api_key_here
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## 📂 Project Structure

- `lib/models/`: Data structures (e.g., `Interaction`).
- `lib/providers/`: Business logic and state management (`NudgeProvider`).
- `lib/screens/`: UI components and screen layouts.
- `lib/l10n/`: Localization files (`.arb`).

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
