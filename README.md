# Flutter Mini‑Ecommerce Coding Challenge
This is a mini‑ecommerce application with Admin and User roles. Users can browse products, manage a cart, place orders, and view past orders. Admins can add products and view orders/low-stock items.
<br>
<br>
**Frontend**: Flutter (Stable channel, null-safe Dart), Provider for state management
<br>
**Backend**: Spring Boot 3.2+, Java 17, Postgres, REST API
## How to Run
### Backend:
1. Clone the repo and navigate to backend:
```
git clone https://github.com/Hsenhydr/Mini-Ecommerce-Challenge.git
cd mini_ecommerce_backend
```
2. Configure the database in `application.properties`
```
spring.datasource.url=jdbc:postgresql://localhost:5432/mini_ecommerce
spring.datasource.username=postgres
spring.datasource.password=yourpassword
```
3. Run the Spring Boot app
```
mvn spring-boot:run
```
### Frontend:
1. Navigate to Flutter frontend:
```
cd mini_ecommerce_mobile
```
2. Install dependencies
```
flutter pub get
```
3. Run the app:
```
flutter run
```
## State Management Choice
* provider
  * already familiar with
  * find it the most lightweight when searching
## Minimal test:
* Backend: Postman / integration tests optional
* Frontend:
    * Unit tests for Cart Provider
    * Widget test for Cart
## Bonus Features Implemented
* Theming: Dark mode toggle.

## Demo Video

[▶️ Watch Demo Video](https://github.com/Hsenhydr/Mini-Ecommerce-Challenge/blob/main/mini_ecommerce_mobile/lib/IMG_1720.MOV)

