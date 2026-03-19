# Expense Tracker

A production-ready Flutter mobile app for tracking personal expenses, income, and transfers across multiple accounts. Built with clean architecture and Supabase authentication.

## Features

- **Authentication**: Email/password login and registration via Supabase
- **Multi-Account Support**: Track balances across bank accounts, cash, UPI, and credit cards
- **Transaction Management**: Record expenses, income, and transfers between accounts
- **Dashboard**: View total balance and account summaries at a glance
- **Pull-to-Refresh**: Sync data from backend with pull gesture

## Tech Stack

| Technology | Purpose |
|------------|---------|
| Flutter | Cross-platform mobile framework |
| GetX | State management, routing, dependency injection |
| Dio | HTTP client for API requests |
| Supabase | Authentication (email/password) |
| flutter_secure_storage | Secure JWT token storage |
| flutter_dotenv | Environment variable management |

## Project Structure

```
lib/
├── main.dart                 # App entry point
└── app/
    ├── core/
    │   ├── config/
    │   │   └── env_config.dart       # Environment variables
    │   ├── theme/
    │   │   ├── app_colors.dart       # Color constants
    │   │   ├── app_spacing.dart      # Spacing & sizing
    │   │   ├── app_text_styles.dart  # Typography
    │   │   └── app_theme.dart        # ThemeData
    │   └── utils/
    │       └── logger.dart           # Debug logging
    ├── data/
    │   └── constants.dart            # API endpoints & keys
    ├── models/
    │   ├── user_model.dart
    │   ├── account_model.dart
    │   ├── transaction_model.dart
    │   └── api_response.dart
    ├── services/
    │   ├── api_service.dart          # Dio HTTP client
    │   ├── storage_service.dart      # Secure storage
    │   └── supabase_service.dart     # Supabase client
    ├── repositories/
    │   ├── auth_repository.dart      # Auth data operations
    │   ├── account_repository.dart   # Account CRUD
    │   └── transaction_repository.dart
    ├── controllers/
    │   ├── auth_controller.dart
    │   ├── dashboard_controller.dart
    │   ├── account_controller.dart
    │   └── transaction_controller.dart
    ├── bindings/                     # Dependency injection
    ├── routes/                       # Navigation
    ├── modules/                      # Screens
    │   ├── splash/
    │   ├── auth/
    │   ├── dashboard/
    │   ├── accounts/
    │   └── transactions/
    └── widgets/                      # Reusable UI components
        ├── custom_text_field.dart
        ├── custom_button.dart
        ├── custom_dropdown.dart
        ├── balance_card.dart
        ├── account_tile.dart
        ├── transaction_tile.dart
        └── ...
```

## Getting Started

### Prerequisites

- Flutter SDK (^3.11.0)
- Dart SDK
- A Supabase project (for authentication)
- Backend API (FastAPI) running

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd expense_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   
   Copy the example environment file:
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` with your credentials:
   ```env
   # Supabase Configuration
   # Get from: https://supabase.com -> Project Settings -> API
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your_anon_key_here
   
   # Backend API
   API_BASE_URL=http://localhost:8000
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Supabase Setup

1. Create a project at [supabase.com](https://supabase.com)
2. Go to **Project Settings** → **API**
3. Copy the **Project URL** and **anon public** key
4. Paste them in your `.env` file

## Architecture

The app follows **Clean Architecture** principles:

```
┌─────────────────────────────────────────────┐
│                   UI Layer                   │
│              (Screens/Widgets)               │
├─────────────────────────────────────────────┤
│              Business Logic                  │
│               (Controllers)                  │
├─────────────────────────────────────────────┤
│               Data Layer                     │
│             (Repositories)                   │
├─────────────────────────────────────────────┤
│              Service Layer                   │
│      (API Service, Supabase, Storage)        │
└─────────────────────────────────────────────┘
```

- **Screens**: Display UI, handle user interactions
- **Controllers**: Manage state, validation, orchestrate actions
- **Repositories**: Data operations, transform API responses to models
- **Services**: Low-level API clients, storage, external services

## API Endpoints

The app expects a backend API with these endpoints:

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/login` | User login |
| POST | `/auth/register` | User registration |
| GET | `/accounts` | List all accounts |
| POST | `/accounts` | Create account |
| GET | `/transactions` | List all transactions |
| POST | `/transactions` | Create transaction |

## Screens

| Screen | Description |
|--------|-------------|
| Splash | Check auth status, route to login/dashboard |
| Login/Register | Email/password authentication |
| Dashboard | Total balance, account list |
| Add Account | Create new account |
| Add Transaction | Record expense/income/transfer |
| Transaction List | View transaction history |

## Debugging

The app includes a built-in logger. View logs in the debug console:

```
[Main] Starting app initialization...
[SupabaseService] Initializing Supabase...
[SupabaseService] Supabase initialized successfully
[AuthRepository] Attempting login for: user@example.com
❌ [AuthRepository] Auth exception during login
   Error: Invalid login credentials
```

## License

This project is for personal/educational use.
