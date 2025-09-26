# Mini Store - A Flutter E-Commerce Application

Welcome to Mini Store, a modern, feature-rich e-commerce application built with Flutter. This project demonstrates a complete, clean architecture approach to building scalable and maintainable mobile apps, featuring user authentication, product browsing, a persistent shopping cart, and a wishlist.



---

## Features

-   **User Authentication:** Secure sign-up and login functionality powered by **Supabase**, allowing for distinct user sessions.
-   **Product Listing:** Fetches and displays a grid of products from a live API, with elegant loading and error states.
-   **Product Detail Page:** A stylish, modern screen for each product, featuring a hero animation, quantity selector, and clear calls to action.
-   **Shopping Cart:** A fully functional cart where users can add, remove, and update the quantity of items. The cart's state is persisted locally for each user.
-   **Wishlist / Favorites:** Users can save their favorite items to a wishlist, which is also persisted locally on the device for each user account.
-   **User-Specific Data:** Both the cart and wishlist are tied to the logged-in user's ID. Data is cleared from the screen on logout and restored on the next login, ensuring a seamless and private experience.

---

## Framework & Architecture

This application is built using the **Flutter** framework and is designed to run on both iOS and Android.

The project follows a strict **Clean Architecture** pattern with a feature-first approach. This decouples the core business logic from the UI and data layers, making the app highly scalable, testable, and easy to maintain.

-   **Layers:** The architecture is divided into three main layers for each feature:
    1.  **Data:** Handles all data operations, fetching from remote sources (API, Supabase) and caching locally.
    2.  **Domain:** Contains the core business logic, entities, and use cases. This layer is independent of any UI or data implementation.
    3.  **Presentation:** Manages the UI (Widgets) and state (BLoC/Cubit).
-   **State Management:** State is managed efficiently using the **flutter_bloc** package, with Cubits for simpler state logic (like the cart and wishlist) and Blocs for more complex flows (like authentication and product fetching).

---

## Getting Started: Setup & Installation

To run this project locally, please follow these steps:

### Prerequisites

-   Flutter SDK (version 3.0.0 or newer)
-   An IDE such as Android Studio or VS Code with the Flutter plugin.
-   A Supabase account (free tier is sufficient).

### 1. Set Up Supabase Backend (optional you can run it on my own backend)

This project requires a Supabase backend for user authentication.

1.  Go to [supabase.com](https://supabase.com/) and create a new project.
2.  Inside your project, navigate to the **SQL Editor** and run the following script to create the `profiles` table that will store user names. This is automatically triggered when a new user signs up.
    ```sql
    -- Create a table for public profiles
    create table profiles (
      id uuid references auth.users not null primary key,
      name text
    );
    -- Set up Row Level Security (RLS)
    alter table profiles
      enable row level security;
    create policy "Public profiles are viewable by everyone." on profiles
      for select using (true);
    create policy "Users can insert their own profile." on profiles
      for insert with check ((select auth.uid()) = id);
    create policy "Users can update own profile." on profiles
      for update using ((select auth.uid()) = id);
    -- This trigger automatically creates a profile entry when a new user signs up
    create function public.handle_new_user()
    returns trigger as $$
    begin
      insert into public.profiles (id, name)
      values (new.id, new.raw_user_meta_data->>'name');
      return new;
    end;
    $$ language plpgsql security definer;
    create trigger on_auth_user_created
      after insert on auth.users
      for each row execute procedure public.handle_new_user();
    ```
3.  Navigate to **Project Settings > API**. Find your **Project URL** and **anon Public Key**.

### 2. Configure the App

1.  Clone the repository to your local machine.
2.  Open the `lib/core/secrets/app_secrets.dart` file.
3.  Replace the placeholder values with your own Supabase URL and anon Key from the previous step:
    ```dart
    class AppSecrets {
      static const supabaseUrl = 'YOUR_SUPABASE_URL';
      static const supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
    }
    ```

### 3. Run the Application

1.  Open your terminal and navigate to the project's root directory.
2.  Install the required dependencies:
    ```sh
    flutter pub get
    ```
3.  Run the app on your connected device or simulator:
    ```sh
    flutter run
    ```

---

## Assumptions Made

-   **API Data:** The application uses the public **`fakestoreapi.com`** for product data. This API is static, and the data is not expected to change.
-   **Local Persistence:** The shopping cart and wishlist are persisted locally on the user's device using the `shared_preferences` package. This data is **not** synced to a backend database. If the user uninstalls the app or clears its data, their cart and wishlist will be lost.
-   **No Checkout/Payment:** The "Proceed to Checkout" button are for UI demonstration purposes only and do not lead to a real payment gateway.
