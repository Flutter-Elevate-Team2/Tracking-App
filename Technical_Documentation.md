# Flowery Driver: Delivery Partner App - Technical Documentation

## 1. Project Overview
**Flowery Driver** (Tracking-App) is a dedicated companion application designed specifically for Flowery delivery personnel. It serves as an end-to-end solution for drivers to manage assigned orders, navigate efficient routes, and broadcast real-time location updates directly to customers.

The application is built to be robust, battery-efficient, and highly responsive, providing seamless real-time tracking integration with the main Flowery customer app.

---

## 2. Architecture & Design Patterns
The project strictly adheres to **Clean Architecture** principles, ensuring a separation of concerns, scalability, and testability.

The application is divided into distinct layers:
*   **Domain Layer:** Contains core business logic, Use Cases, and repository interfaces. Independent of any external packages.
*   **Data Layer:** Handles data retrieval and submission. Consists of Repository Implementations, Mappers (to convert raw data/models to domain entities), and Data Sources (APIs, Firebase).
*   **Presentation Layer:** Contains UI components (Views/Widgets) and State Management logic using the **BLoC (Business Logic Component)** and **Cubit** patterns.

**Dependency Injection:** 
The application uses `get_it` along with `injectable` for robust and automated dependency injection, making it extremely easy to mock dependencies during testing.

---

## 3. Detailed Feature Breakdown

### 3.1. Authentication & Onboarding (`auth`)
*   **Login & Session:** Secure driver login using credentials. Sessions are cached securely using `shared_preferences`.
*   **Application Form:** A dedicated onboarding flow for new drivers. Allows them to upload necessary verification documents such as National ID, Driving License, and Vehicle Information for admin approval.
*   **Password Management:** Flows for password recovery and changing passwords.

### 3.2. Home & Dashboard (`home`)
*   **Live Order Feed:** A dashboard that listens for incoming orders assigned to the driver from the main Flowery App.
*   **Quick Actions:** Allows drivers to quickly review order summaries and **Accept** or **Reject** delivery tasks dynamically.

### 3.3. Order Management (`order`)
*   **Order History:** A comprehensive log of all previous orders, categorized by completed and cancelled statuses.
*   **Order Details:** Deep dive into specific orders, viewing financial breakdowns, detailed user addresses, and store locations.

### 3.4. Real-time Tracking & Navigation (`track_order`)
*   **Live Map Integration:** Utilizes **Mapbox** (`mapbox_maps_flutter`) for accurate routing and turn-by-turn navigation from the driver to the store, and subsequently to the customer.
*   **Status Progression:** Step-by-step order state management (Accepted -> Arrived at Store -> Out for Delivery -> Arrived at User).
*   **Real-time Synchronization:** Directly streams live location coordinates to Firestore (`active_orders`), keeping the customer informed in real-time.

### 3.5. Profile & Settings (`profile`)
*   **Profile Control:** Management of personal details and profile pictures.
*   **Location Settings:** Granular control over application location tracking behavior and permissions.

### 3.6. Vehicle Management (`vehicle`)
*   **Vehicle Settings:** Enables the driver to manage their active delivery vehicle details and types, integrated tightly with the Application Form during onboarding.

---

## 4. Core Engineering Highlights

*   **Robust Foreground Tracking:** Uses `Geolocator` combined with Android's `ForegroundNotificationConfig` to spawn a persistent foreground service. This ensures the operating system does not kill the location stream while the driver is delivering.
*   **High-Performance Map Rendering:** Bypasses the traditional, heavy widget tree rebuilds for map markers. By mapping physical coordinates to screen pixels and using `ValueNotifier<Offset?>` with `AnimatedPositioned`, markers glide smoothly at 60 FPS.
*   **Direct FCM Integration:** Bypasses middleman servers using `googleapis_auth`. The app securely signs Firebase requests directly on the client to send localized FCM v1 push notifications instantly to the customer when order statuses change.
*   **Smart Routing & API Throttling:** `GetDirectionsUseCase` is heavily throttled to prevent spamming Mapbox APIs. It only recalculates the route if the driver's coordinates deviate significantly from the last calculated position.
*   **Centralized Error Handling:** A robust Dio `AuthInterceptor` acts as a sentinel. If a session token expires (HTTP 401), it halts execution, broadcasts a session expiration event, and redirects the user to the login screen safely.

---

## 5. Routing
*   **GoRouter:** Handles deep linking, navigation guards, and strict redirect logic. If the app is killed during an active delivery, restarting it will instantly trap the driver back inside the active `trackOrderPath` utilizing local cached states to prevent order abandonment.

---

## 6. Testing Strategy
The project features a comprehensive and granular testing suite reflecting the Clean Architecture layers. The `test` directory mirrors the `lib` structure exactly.

*   **Domain Layer Testing:** 
    *   Unit tests for `UseCases` using `mockito` to mock repository interfaces, ensuring business logic rules (like routing throttling or data validation) hold true.
*   **Data Layer Testing:**
    *   **Mappers:** Strict unit tests to ensure API JSON models map perfectly to Domain entities without data loss.
    *   **Repositories:** Mocking data sources to test success and failure paths, caching mechanisms, and exception handling.
*   **Presentation Layer Testing:**
    *   **ViewModels/BLoC:** Using `bloc_test` to verify state emissions based on events (e.g., triggering a login event properly emits `loading` then `success` or `error` states).
    *   **Widget/UI Testing:** Extensive widget tests using `flutter_test` and `network_image_mock` to ensure views render correctly, forms validate as expected, and user interactions (like tapping the "Accept Order" button) trigger the appropriate callbacks.

---

## 7. Technology Stack
*   **Framework:** Flutter (v3.10+) / Dart (v3.10+)
*   **Architecture:** Clean Architecture
*   **State Management:** `flutter_bloc`, `cubit`
*   **Dependency Injection:** `get_it`, `injectable`
*   **Networking:** `dio`, `retrofit`
*   **Maps & Location:** `mapbox_maps_flutter`, `google_maps_flutter`, `geolocator`
*   **Backend & Sync:** Firebase Auth, Firestore, Firebase Cloud Messaging (FCM), Crashlytics
*   **Local Storage:** `hive`, `shared_preferences`
*   **Testing:** `flutter_test`, `bloc_test`, `mockito`
*   **UI Assets:** `lottie` (animations), `skeletonizer` (loading states), `shimmer`
