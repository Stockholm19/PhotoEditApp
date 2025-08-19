<details>
<summary><strong>English version</strong></summary>

# PhotoEditApp

**PhotoEditApp** is an iOS app for image editing with Firebase-based authentication.  
Built as a test project using **SwiftUI**, **MVVM**, and **Firebase Auth**.

## Test Assignment Summary

**Goal:** Develop an iOS application with user authentication and photo editing tools.

**Key Requirements:**

- Sign in via email/password and Google account
- Registration and password reset functionality
- Photo editing features:
  - Scaling, rotation, repositioning
  - Text overlay and freehand drawing (PencilKit)
  - Applying CoreImage filters (Sepia, Mono, Blur)
- Save edited images and export them
- Tech stack: `Swift`, `SwiftUI`, `Firebase/Auth`, `GoogleSignIn`, `Combine`, `CoreImage`, `PencilKit`
- Architecture: `MVVM`, UI should follow Apple Human Interface Guidelines

**Expected Result:**

- Fully working app with clean and intuitive interface
- Well-structured code with reusable components
- Documented `README.md` describing features and architecture

## Screenshots

| Email Login | Google Sign-In | Editing | Filters | Drawing | Export |
|--------------|----------------|---------|---------|---------|--------|
| <img src="Screenshots/login.gif" width="200"/> | <img src="Screenshots/Google.jpeg" width="200"/> | <img src="Screenshots/edit.jpg" width="270"/> | <img src="Screenshots/filters.jpg" width="270"/> | <img src="Screenshots/draw.jpeg" width="270"/> | <img src="Screenshots/export.jpg" width="270"/> |

## Features

- Email/password registration and login
- Google Sign-In support
- Basic email/password validation
- Password reset (placeholder)
- Load an image from the gallery
- Store image locally using `UserDefaults`
- Persist image across sessions
- Replace or delete the image
- Scale, rotate, and move the image using gestures
- Add a text overlay with drag gesture
- Drawing mode on top of the image (PencilKit)
- Apply CoreImage filters (Sepia, Mono, Blur)
- Export the final image via Share Sheet

## Technologies

- `SwiftUI 5`
- MVVM architecture
- `Firebase Auth`
- `PhotosPicker` (SwiftUI)
- `PencilKit` via `UIViewRepresentable`
- `CoreImage` (Sepia, Mono, Blur)
- `UIActivityViewController`
- `Combine`, `AppStorage`
- Custom form validation, animations, and error handling

## Architecture

The project follows the **MVVM** pattern:
- `View` — handles UI rendering and user input
- `ViewModel` — manages business logic and state
- `Model` / `Service` — responsible for Firebase operations and image filters

Data flow is managed using `@StateObject`, `@Published`, `Combine`, and `@AppStorage`.

## Testing

Unit tests verify data validation logic:

- `AuthValidatorTests` — verify email format correctness.

Tests are written using `XCTest`. Future work will expand test coverage to other modules.

## Installation

1. Clone the repository  
2. Open the `.xcodeproj` file in **Xcode 15 or later**  
3. Configure Firebase:  
   - Visit [Firebase Console](https://console.firebase.google.com/)  
   - Go to Project Settings → iOS tab  
   - Download `GoogleService-Info.plist`  
   - Place it in `PhotoEditApp/Services/`  
   - Note: The file is not included in the repo (contains private keys)  
4. Run the app on a device or simulator

## Planned Improvements

- [ ] Enable password reset via Firebase
- [ ] Upload images to Firebase Storage
- [ ] Store user profiles in Firestore
- [ ] Text editing: font, color, alignment
- [ ] Support for iPad and multitouch
- [ ] Improved theming and animations

## Author

**Roman Pshenichnikov**  
[GitHub](https://github.com/Stockholm19)

</details>

---

# PhotoEditApp

**PhotoEditApp** — iOS-приложение для редактирования фотографий с авторизацией через Firebase.  
Разработано как тестовое задание с использованием **SwiftUI**, **Firebase** и архитектуры **MVVM**.

## Описание тестового задания

**Цель:** создать iOS-приложение с авторизацией и инструментами редактирования изображений.

**Основные требования:**

- Авторизация через email/пароль и Google Sign-In
- Регистрация и сброс пароля
- Редактирование фотографий:
  - Масштабирование, поворот, перемещение
  - Добавление текста и рисование (PencilKit)
  - Фильтры CoreImage (Sepia, Mono, Blur)
- Сохранение и экспорт результата
- Стек: `Swift`, `SwiftUI`, `Firebase/Auth`, `GoogleSignIn`, `Combine`, `CoreImage`, `PencilKit`
- Архитектура: `MVVM` с соблюдением Apple Human Interface Guidelines

**Ожидаемый результат:**

- Работоспособное приложение с понятным интерфейсом
- Чистый и структурированный код с переиспользуемыми компонентами
- README с описанием функциональности и архитектуры

## Скриншоты

| Вход (email) | Вход (Google) | Редактирование | Фильтры | Рисование | Экспорт |
|--------------|----------------|----------------|---------|-----------|---------|
| <img src="Screenshots/login.gif" width="200"/> | <img src="Screenshots/Google.jpeg" width="200"/> | <img src="Screenshots/edit.jpg" width="270"/> | <img src="Screenshots/filters.jpg" width="270"/> | <img src="Screenshots/draw.jpeg" width="270"/> | <img src="Screenshots/export.jpg" width="270"/> |

## Возможности

- Регистрация и вход по email/паролю
- Вход через Google-аккаунт
- Простая валидация форм (email, пароль)
- Сброс пароля (заглушка)
- Загрузка изображения из галереи
- Сохранение изображения в `UserDefaults`
- Отображение изображения между сессиями
- Замена и удаление изображения
- Масштабирование, поворот и перемещение (жесты)
- Наложение текста с перетаскиванием
- Рисование поверх изображения (PencilKit)
- Применение фильтров CoreImage (Sepia, Ч/Б, Blur)
- Экспорт через Share Sheet

## Технологии

- `SwiftUI 5`
- Архитектура `MVVM`
- `Firebase Auth`
- `PhotosPicker` (SwiftUI)
- `PencilKit` через `UIViewRepresentable`
- `CoreImage`
- `UIActivityViewController`
- `Combine`, `AppStorage`
- Кастомная валидация, анимации, обработка ошибок

## Архитектура

Проект реализован по принципу **MVVM**:
- `View` — отвечает за UI и ввод
- `ViewModel` — бизнес-логика и состояние
- `Model` / `Service` — работа с Firebase и фильтрами

Данные передаются через `@StateObject`, `@Published`, `Combine` и `@AppStorage`.

## Тестирование

Юнит-тесты проверяют валидацию данных:

- `AuthValidatorTests` — проверка формата email.

Тесты написаны на `XCTest`. В планах расширение покрытия.

## Установка

1. Клонируйте репозиторий  
2. Откройте `.xcodeproj` в **Xcode 15+**  
3. Настройте Firebase:  
   - [Firebase Console](https://console.firebase.google.com/)
   - Project Settings → вкладка iOS
   - Скачать `GoogleService-Info.plist`
   - Поместить файл в `PhotoEditApp/Services/`  
   - Файл не включён в репозиторий (приватные ключи)
4. Запустите приложение на устройстве или симуляторе

## Планы по доработке

- [ ] Сброс пароля через Firebase
- [ ] Хранение изображений в Firebase Storage
- [ ] Профиль пользователя в Firestore
- [ ] Редактирование текста (шрифт, цвет, выравнивание)
- [ ] Поддержка iPad и мультитач
- [ ] Улучшение тем и анимаций

