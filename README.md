# MiniDocto+ Backend

Application de mise en relation patients-professionnels de santé avec système de prise de rendez-vous.

## 📋 Description

MiniDocto+ est une API REST développée avec Spring Boot permettant aux patients de trouver des professionnels de santé, de consulter leurs disponibilités, de prendre rendez-vous et de laisser des avis.

## 🚀 Technologies Utilisées

- **Java 17**
- **Spring Boot 3.5.0**
- **Spring Security** - Authentification et autorisation
- **Spring Data MongoDB** - Persistance des données
- **JWT (JSON Web Token)** - Gestion des tokens d'authentification
- **MongoDB** - Base de données NoSQL
- **Lombok** - Réduction du code boilerplate
- **Maven** - Gestion des dépendances

## 📦 Architecture

```
src/main/java/com/minidocto/
├── config/              # Configuration de sécurité
├── controller/          # Contrôleurs REST
├── dto/                 # Data Transfer Objects
├── exception/           # Gestion des exceptions
├── model/              # Entités du domaine
├── repository/         # Repositories MongoDB
├── security/           # Filtres et providers JWT
└── service/            # Logique métier
```

## 🔧 Prérequis

- Java JDK 17 ou supérieur
- Maven 3.6+
- MongoDB 4.0+
- Un IDE Java (IntelliJ IDEA)

## ⚙️ Installation

### 1. Cloner le projet

```bash
git clone https://github.com/soltan-mohamed/MiniDocto-.git
cd backend
```

### 2. Configurer MongoDB

Assurez-vous que MongoDB est installé et en cours d'exécution sur `localhost:27017`.

### 3. Configurer les variables d'environnement

Modifiez le fichier `src/main/resources/application.properties` :

```properties
# MongoDB Configuration
spring.data.mongodb.uri=mongodb://localhost:27017/minidoctoplus
spring.data.mongodb.database=minidoctoplus

# JWT Configuration
jwt.secret="VOTRE_CLE_SECRETE_JWT" ⚠️ **Important** : Générez une clé secrète forte pour `jwt.secret` en production.
jwt.expiration=86400000

# CORS Configuration
cors.allowed.origins=http://localhost:3000,http://localhost:5173
```


### 4. Installer les dépendances

```bash
mvn clean install
```

### 5. Lancer l'application

```bash
mvn spring-boot:run
```

L'API sera accessible sur `http://localhost:8080`

## 📡 API Endpoints

### Authentification

| Méthode | Endpoint | Description | Authentification |
|---------|----------|-------------|------------------|
| POST | `/api/auth/register` | Inscription d'un utilisateur | Non |
| POST | `/api/auth/login` | Connexion d'un utilisateur | Non |

### Professionnels

| Méthode | Endpoint | Description | Authentification |
|---------|----------|-------------|------------------|
| GET | `/api/professionals/list` | Liste des professionnels | Non |

### Créneaux Horaires

| Méthode | Endpoint | Description | Authentification |
|---------|----------|-------------|------------------|
| POST | `/api/timeslots` | Créer un créneau horaire | Oui (Professionnel) |
| GET | `/api/timeslots/professional/{professionalId}` | Créneaux d'un professionnel | Non |

### Rendez-vous

| Méthode | Endpoint | Description | Authentification |
|---------|----------|-------------|------------------|
| POST | `/api/appointments` | Créer un rendez-vous | Oui (Patient) |
| GET | `/api/appointments/patient` | Rendez-vous du patient | Oui (Patient) |
| GET | `/api/appointments/professional` | Rendez-vous du professionnel | Oui (Professionnel) |
| PUT | `/api/appointments/{id}/confirm` | Confirmer un rendez-vous | Oui (Professionnel) |
| PUT | `/api/appointments/{id}/cancel` | Annuler un rendez-vous | Oui |
| PUT | `/api/appointments/{id}/complete` | Compléter un rendez-vous | Oui (Professionnel) |

### Avis

| Méthode | Endpoint | Description | Authentification |
|---------|----------|-------------|------------------|
| POST | `/api/reviews` | Créer un avis | Oui (Patient) |
| GET | `/api/reviews/professional/{professionalId}` | Avis d'un professionnel | Non |

## 🔐 Authentification

L'API utilise JWT (JSON Web Tokens) pour l'authentification. Pour accéder aux endpoints protégés :

1. Inscrivez-vous ou connectez-vous via `/api/auth/register` ou `/api/auth/login`
2. Récupérez le token JWT dans la réponse
3. Ajoutez le token dans l'en-tête des requêtes suivantes :

```
Authorization: Bearer <votre_token_jwt>
```

## 👥 Rôles Utilisateurs

- **PATIENT** : Peut prendre rendez-vous et laisser des avis
- **PROFESSIONAL** : Peut gérer ses créneaux horaires et confirmer/compléter les rendez-vous

## 📊 Modèles de Données

### User
- id, email, password, firstName, lastName, role, phoneNumber, speciality, bio, profileImage, address, averageRating

### TimeSlot
- id, professionalId, date, startTime, endTime, isAvailable

### Appointment
- id, patientId, professionalId, timeSlotId, status, reason, notes

### Review
- id, patientId, professionalId, appointmentId, rating, comment

## 🛠️ Build du Projet

### Package l'application

```bash
mvn clean package
```

Le fichier JAR sera généré dans `target/mini-docto-plus-1.0.0.jar`

### Exécuter le JAR

```bash
java -jar target/mini-docto-plus-1.0.0.jar
```

## 🐛 Débogage

Les logs sont configurés au niveau DEBUG. Consultez la console pour les informations détaillées sur :
- Les requêtes HTTP
- L'authentification
- Les opérations MongoDB
- Les erreurs

## 📝 Exemples de Requêtes

### Inscription

```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "patient@example.com",
    "password": "password123",
    "firstName": "Mohamed",
    "lastName": "Soltan",
    "role": "PATIENT",
    "phoneNumber": "55201869"
  }'
```

### Connexion

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "patient@example.com",
    "password": "password123"
  }'
```

### Liste des professionnels

```bash
curl -X GET http://localhost:8080/api/professionals/list
```

## 🤝 Contribution

1. Forkez le projet
2. Créez une branche pour votre fonctionnalité (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Committez vos changements (`git commit -m 'feat: Ajout d'une nouvelle fonctionnalité'`)
4. Poussez vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Ouvrez une Pull Request

# MiniDocto+ Pro Web App

Application web professionnelle pour la gestion de rendez-vous médicaux, développée avec React et Vite.

## 🚀 Fonctionnalités

- 📅 Gestion des créneaux horaires
- 🩺 Prise de rendez-vous
- 👤 Authentification utilisateur (Login/Register)
- 📊 Tableau de bord personnalisé
- 🔐 Protection des routes avec authentification

## 🛠️ Technologies

- **React** 18.2.0 - Bibliothèque UI
- **Vite** 5.0.8 - Build tool et dev server
- **React Router DOM** 6.20.0 - Gestion du routing
- **Axios** 1.6.2 - Client HTTP
- **React Calendar** 4.7.0 - Composant calendrier
- **date-fns** 3.0.0 - Manipulation de dates

## 📋 Prérequis

- Node.js (version 16 ou supérieure)
- npm ou yarn

## 🔧 Installation

1. Cloner le repository :
```bash
git clone https://github.com/soltan-mohamed/MiniDocto-.git
cd pro-web-app
```

2. Installer les dépendances :
```bash
npm install
```

## 🚀 Démarrage

### Mode développement
```bash
npm run dev
```
L'application sera accessible sur `http://localhost:3000`

### Build de production
```bash
npm run build
```

### Prévisualiser le build
```bash
npm run preview
```

## 📁 Structure du projet

```
pro-web-app/
├── src/
│   ├── components/     # Composants réutilisables
│   ├── pages/         # Pages de l'application
│   │   ├── LoginPage.jsx
│   │   ├── RegisterPage.jsx
│   │   ├── DashboardPage.jsx
│   │   ├── TimeSlotsPage.jsx
│   │   └── AppointmentsPage.jsx
│   ├── services/      # Services API
│   ├── App.jsx        # Composant principal
│   ├── main.jsx       # Point d'entrée
│   └── index.css      # Styles globaux
├── public/            # Assets statiques
├── index.html         # Template HTML
├── package.json
├── vite.config.js
└── .gitignore
```

## 🔐 Authentification

L'application utilise un système d'authentification basé sur les tokens JWT stockés dans le localStorage. Les routes protégées redirigent automatiquement vers la page de connexion si l'utilisateur n'est pas authentifié.

## 👥 Pages disponibles

- `/login` - Page de connexion
- `/register` - Page d'inscription
- `/dashboard` - Tableau de bord (protégé)
- `/time-slots` - Gestion des créneaux horaires (protégé)
- `/appointments` - Gestion des rendez-vous (protégé)

## 👨‍💻 Auteur

Mohamed Soltan

---

**Version Web** 2.1.0

# MiniDocto+ Patient Mobile App

Application mobile Flutter pour les patients permettant de trouver des professionnels de santé, prendre rendez-vous et laisser des avis.

## 🚀 Fonctionnalités

- 🔐 **Authentification sécurisée** - Inscription et connexion avec JWT
- 👨‍⚕️ **Recherche de professionnels** - Liste des professionnels avec spécialités et scores
- 📅 **Prise de rendez-vous** - Consultation des créneaux disponibles et réservation
- 📋 **Gestion des rendez-vous** - Visualisation, annulation et suivi des rendez-vous
- ⭐ **Système d'avis** - Notation et commentaires pour les professionnels
- 🔄 **Synchronisation temps réel** - Actualisation automatique des données
- 🎨 **Design moderne** - Interface attrayante avec dégradés et animations

## 🛠️ Technologies

- **Flutter** 3.x - Framework de développement mobile
- **Dart** 3.x - Langage de programmation
- **Provider** 6.1.1 - Gestion d'état
- **HTTP** 1.1.2 - Client HTTP pour API REST
- **Shared Preferences** 2.2.2 - Stockage local sécurisé
- **Intl** 0.18.1 - Internationalisation et formatage de dates

## 📋 Prérequis

- Flutter SDK (version 3.0 ou supérieure)
- Dart SDK (version 3.0 ou supérieure)
- Android Studio / Xcode (pour émulation)
- Chrome (pour web)
- Backend MiniDocto+ en cours d'exécution sur `http://localhost:8080`

## 🔧 Installation

### 1. Cloner le projet
```bash
git clone https://github.com/soltan-mohamed/MiniDocto-.git
cd patient_app
```

### 2. Installer les dépendances
```bash
flutter pub get
```

### 3. Configurer l'API
Vérifiez que l'URL de l'API est correcte dans `lib/services/api_service.dart` :
```dart
static const String baseUrl = 'http://localhost:8080/api';
```

### 4. Lancer l'application

**Pour Chrome (Web) :**
```bash
flutter run -d chrome
```

**Pour Android :**
```bash
flutter run -d android
```

**Pour iOS :**
```bash
flutter run -d ios
```

## 📁 Structure du Projet

```
patient_app/
├── lib/
│   ├── main.dart                    # Point d'entrée de l'application
│   ├── models/                      # Modèles de données
│   │   ├── appointment.dart         # Modèle Rendez-vous
│   │   ├── professional.dart        # Modèle Professionnel
│   │   ├── timeslot.dart           # Modèle Créneau horaire
│   │   ├── user.dart               # Modèle Utilisateur
│   │   └── review.dart             # Modèle Avis
│   ├── providers/                   # Gestion d'état avec Provider
│   │   ├── auth_provider.dart      # Authentification
│   │   ├── professional_provider.dart
│   │   └── appointment_provider.dart
│   ├── screens/                     # Écrans de l'application
│   │   ├── auth/                   # Authentification
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── home/                   # Navigation principale
│   │   │   └── home_screen.dart
│   │   ├── professionals/          # Professionnels
│   │   │   ├── professional_list_screen.dart
│   │   │   └── professional_detail_screen.dart
│   │   └── appointments/           # Rendez-vous
│   │       ├── appointment_list_screen.dart
│   │       └── rate_appointment_screen.dart
│   └── services/                    # Services API
│       └── api_service.dart        # Client HTTP
├── pubspec.yaml                     # Dépendances Flutter
└── analysis_options.yaml           # Configuration Dart
```

## 🎨 Design et Interface

### Palette de Couleurs
- **Primaire** : Dégradé violet-bleu (#667eea → #764ba2)
- **Score** : Dégradé doré (#ffd700 → #ffed4e)
- **Statuts** :
  - Confirmé : Vert (#4caf50)
  - En attente : Orange (#ff9800)
  - Annulé : Rouge (#f44336)
  - Terminé : Bleu (#2196f3)

### Composants Stylisés
- **Cartes** : BorderRadius 20px, ombres portées colorées
- **Boutons** : Dégradés avec effet d'élévation
- **Champs de texte** : Bordures arrondies avec focus coloré
- **Badges** : Coins arrondis avec couleurs distinctives
- **Avatars** : Circulaires avec dégradés et initiales

## 📱 Fonctionnalités Détaillées

### 1. Authentification

#### Inscription
```dart
POST /api/auth/register
{
  "email": "patient@gmail.com",
  "password": "password123",
  "firstName": "Mohamed",
  "lastName": "Soltan",
  "phone": "+21655201869",
  "role": "PATIENT"
}
```

**Fonctionnalités :**
- Validation des champs (email, téléphone, mot de passe min 6 caractères)
- Design avec dégradé en arrière-plan
- Feedback visuel en cas d'erreur
- Redirection automatique après inscription

#### Connexion
```dart
POST /api/auth/login
{
  "email": "patient@gmail.com",
  "password": "password123"
}
```

**Fonctionnalités :**
- Stockage sécurisé du token JWT dans SharedPreferences
- Persistance de la session
- Gestion des erreurs avec messages explicites
- Redirection vers l'écran principal

### 2. Liste des Professionnels

**Endpoint :** `GET /api/professionals`

**Affichage :**
- Cartes avec bordure dégradée
- Avatar circulaire avec initiales
- Badge de spécialité
- Score sur 100 avec icône étoile dorée
- Actualisation par pull-to-refresh

**Fonctionnalités :**
- Tri automatique par score décroissant
- Recherche par spécialité (future)
- Navigation vers les détails du professionnel

### 3. Détails du Professionnel

**Informations affichées :**
- Nom complet et spécialité
- Score et nombre d'avis
- Description professionnelle
- Adresse du cabinet
- Coordonnées (téléphone, email)

**Créneaux disponibles :**
```dart
GET /api/timeslots/professional/{professionalId}/available
```

**Fonctionnalités :**
- Liste des créneaux horaires disponibles
- Calendrier des disponibilités
- Sélection du créneau pour réservation
- Formulaire de motif de consultation

### 4. Prise de Rendez-vous

**Processus de réservation :**

1. **Sélection du créneau** : L'utilisateur choisit un horaire disponible
2. **Motif de consultation** : Saisie du motif dans une boîte de dialogue
3. **Confirmation** : Création du rendez-vous

```dart
POST /api/appointments
{
  "professionalId": "id_professionnel",
  "timeSlotId": "id_creneau",
  "reason": "Consultation de contrôle"
}
```

**Statuts des rendez-vous :**
- `CONFIRMED` : Confirmé par le professionnel
- `PENDING` : En attente de confirmation
- `COMPLETED` : Rendez-vous terminé
- `CANCELLED` : Annulé

### 5. Gestion des Rendez-vous

**Endpoint :** `GET /api/appointments/patient`

**Affichage par carte :**
- Badge de statut coloré
- Nom du professionnel avec icône
- Spécialité avec badge
- Date et heure formatées (format français)
- Motif de consultation
- Actions contextuelles selon le statut

**Actions disponibles :**

#### Annuler un rendez-vous
```dart
PUT /api/appointments/{id}/cancel
```
- Disponible pour les rendez-vous confirmés
- Confirmation avant annulation
- Libération automatique du créneau

#### Noter un rendez-vous
```dart
POST /api/reviews
{
  "professionalId": "id_professionnel",
  "appointmentId": "id_rendez_vous",
  "rating": 5,
  "comment": "Excellent professionnel"
}
```
- Disponible uniquement pour les rendez-vous terminés
- Note de 1 à 5 étoiles
- Commentaire optionnel
- Mise à jour automatique du score du professionnel

### 6. Système de Notation

**Calcul du score :**
```
Score = (Moyenne des notes) × 20
```

**Exemple :**
- 3 avis : ⭐⭐⭐⭐⭐ (5), ⭐⭐⭐⭐ (4), ⭐⭐⭐⭐⭐ (5)
- Moyenne : (5 + 4 + 5) / 3 = 4.67
- Score : 4.67 × 20 = 93/100

**Mise à jour automatique :**
- Le score est recalculé à chaque nouvel avis
- Synchronisation entre mobile et web
- Score initial : 20/100 pour les nouveaux professionnels

## 🔐 Sécurité

### Gestion des Tokens
```dart
// Stockage sécurisé du token
final prefs = await SharedPreferences.getInstance();
await prefs.setString('token', token);

// Ajout automatique dans les headers
headers['Authorization'] = 'Bearer $token';
```

### Protection des Routes
- Vérification du token au démarrage
- Redirection automatique vers login si non authentifié
- Déconnexion automatique si token expiré

## 🔄 Synchronisation et Actualisation

### Actualisation automatique
- **Pull-to-refresh** sur toutes les listes
- **Rechargement automatique** après actions (création, annulation, notation)
- **Gestion du cache** avec SharedPreferences

### Gestion des États
```dart
// Provider Pattern
class AppointmentProvider with ChangeNotifier {
  List<Appointment> _appointments = [];
  bool _isLoading = false;
  String? _error;
  
  Future<void> loadAppointments() async {
    _isLoading = true;
    notifyListeners();
    // API call...
    notifyListeners();
  }
}
```

## 🌐 Internationalisation

### Format de Date (Français)
```dart
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// Initialisation
await initializeDateFormatting('fr_FR', null);

// Usage
DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(date);
// Affiche: "vendredi 12 décembre 2025"

DateFormat('HH:mm', 'fr_FR').format(time);
// Affiche: "16:59"
```

## 🐛 Gestion des Erreurs

### Affichage des Erreurs
```dart
try {
  await apiService.createAppointment(data);
  // Succès
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Rendez-vous réservé avec succès')),
  );
} catch (e) {
  // Erreur
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Erreur: $e'),
      backgroundColor: Colors.red,
    ),
  );
}
```

### Types d'Erreurs Gérées
- Erreurs réseau (connexion API)
- Erreurs d'authentification (token invalide)
- Erreurs de validation (champs requis)
- Erreurs métier (créneau non disponible, etc.)

## 📊 Performance

### Optimisations Implémentées
- **Lazy Loading** : Chargement des données à la demande
- **Caching** : Mise en cache des données utilisateur
- **Debouncing** : Limitation des appels API redondants
- **Pagination** : Pour les futures listes longues

## 🧪 Tests

### Tester l'Application

**Scénario complet :**
1. **Inscription** : Créer un compte patient
2. **Navigation** : Explorer la liste des professionnels
3. **Détails** : Consulter un professionnel et ses disponibilités
4. **Réservation** : Prendre un rendez-vous
5. **Gestion** : Voir ses rendez-vous dans "Mes rendez-vous"
6. **Annulation** : Annuler un rendez-vous si nécessaire
7. **Notation** : Noter un rendez-vous terminé
8. **Déconnexion** : Se déconnecter de l'application

## 📝 Dépendances Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1          # Gestion d'état
  http: ^1.1.2              # Client HTTP
  shared_preferences: ^2.2.2 # Stockage local
  intl: ^0.18.1             # Internationalisation

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0     # Analyse de code
```

## 🚀 Build et Déploiement

### Build pour Android
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (Google Play Store)
flutter build appbundle --release
```

### Build pour iOS
```bash
# Ouvrir dans Xcode
open ios/Runner.xcworkspace

# Build depuis CLI
flutter build ios --release
```

### Build pour Web
```bash
flutter build web --release
```

## 🔧 Configuration Avancée

### Modifier l'URL de l'API
```dart
// lib/services/api_service.dart
static const String baseUrl = 'https://votre-api.com/api';
```

### Personnaliser les Couleurs
```dart
// lib/main.dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF667eea),
  ),
  useMaterial3: true,
),
```

## 📱 Compatibilité

- **Android** : 5.0 (API 21) et supérieur
- **iOS** : 12.0 et supérieur
- **Web** : Chrome, Firefox, Safari, Edge (dernières versions)

## 🤝 Contribution

Pour contribuer au développement de l'application mobile :

1. Fork le projet
2. Créer une branche (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Suivre les conventions de code Flutter/Dart
4. Tester sur plusieurs plateformes
5. Commit avec des messages clairs
6. Push et créer une Pull Request


## 👨‍💻 Auteur

Mohamed Soltan

---

**Version Mobile:** 1.0.0

## 📊 Firebase Analytics - Suivi et Monitoring

### Configuration Firebase

L'application intègre **Firebase Analytics** pour le suivi en temps réel des utilisateurs et des événements sur les plateformes mobile et web.

**Projet Firebase :** `minidoctoplus`
- **Project ID :** minidoctoplus
- **App ID Web :** 1:916796032700:web:9fe77786bf1e64117e72b9
- **App ID Android :** 1:916796032700:android:9fe77786bf1e64117e72b9
- **Measurement ID :** G-6EJNTRZMPH

### 📱 Intégration Mobile (Flutter)

#### Configuration
```dart
// firebase_options.dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyCvFtmoXC7jOl47R5xOPAEn4y3yRenZb_o',
  authDomain: 'minidoctoplus.firebaseapp.com',
  projectId: 'minidoctoplus',
  storageBucket: 'minidoctoplus.firebasestorage.app',
  messagingSenderId: '916796032700',
  appId: '1:916796032700:web:9fe77786bf1e64117e72b9',
  measurementId: 'G-6EJNTRZMPH',
);
```

#### Dépendances
```yaml
dependencies:
  firebase_core: ^4.2.1
  firebase_analytics: ^12.0.4
```

#### Événements Trackés

**Authentification :**
- `login` - Connexion utilisateur avec méthode (email)
- `sign_up` - Inscription avec rôle utilisateur (PATIENT)

**Rendez-vous :**
- `appointment_booked` - Réservation avec ID professionnel, nom, date
- `appointment_cancelled` - Annulation avec ID rendez-vous

**Avis :**
- `review_submitted` - Soumission d'avis avec note et ID rendez-vous

**Navigation :**
- `view_professional` - Consultation d'un professionnel avec spécialité

**Propriétés Utilisateur :**
- `user_id` - ID unique de l'utilisateur
- `user_role` - Rôle (PATIENT/PROFESSIONAL)

#### Service Analytics
```dart
// lib/services/analytics_service.dart
class AnalyticsService {
  static Future<void> logLogin(String method) async {
    await FirebaseAnalytics.instance.logLogin(loginMethod: method);
  }
  
  static Future<void> logAppointmentBooked({
    required String professionalId,
    required String professionalName,
    required String date,
  }) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'appointment_booked',
      parameters: {
        'professional_id': professionalId,
        'professional_name': professionalName,
        'appointment_date': date,
      },
    );
  }
}
```

### 🌐 Intégration Web (React)

#### Configuration
L'intégration utilise les CDN Firebase pour éviter les dépendances npm :

```html
<!-- index.html -->
<script type="module">
  import { initializeApp } from "https://www.gstatic.com/firebasejs/12.6.0/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/12.6.0/firebase-analytics.js";

  const firebaseConfig = {
    apiKey: "AIzaSyCvFtmoXC7jOl47R5xOPAEn4y3yRenZb_o",
    authDomain: "minidoctoplus.firebaseapp.com",
    projectId: "minidoctoplus",
    storageBucket: "minidoctoplus.firebasestorage.app",
    messagingSenderId: "916796032700",
    appId: "1:916796032700:web:9fe77786bf1e64117e72b9",
    measurementId: "G-6EJNTRZMPH"
  };

  const app = initializeApp(firebaseConfig);
  const analytics = getAnalytics(app);
  window.firebaseAnalytics = analytics;
</script>
```

#### Service Analytics Web
```javascript
// src/services/analytics.js
export const analytics = {
  logLogin: (method = 'email') => {
    window.logAnalyticsEvent('login', { method });
  },
  
  logAppointmentCreated: (appointmentData) => {
    window.logAnalyticsEvent('appointment_created', {
      appointment_id: appointmentData.id,
      patient_name: appointmentData.patientName,
      date: appointmentData.date,
    });
  },
  
  logScoreUpdate: (newScore, oldScore) => {
    window.logAnalyticsEvent('score_updated', {
      new_score: newScore,
      old_score: oldScore,
    });
  },
};
```

#### Événements Trackés (Web)
- `login` / `sign_up` - Authentification professionnelle
- `appointment_created` - Création de rendez-vous
- `appointment_status_changed` - Changement de statut
- `time_slot_created` - Création de créneaux horaires
- `score_updated` - Mise à jour du score professionnel
- `page_view` - Navigation entre les pages

### 📈 Métriques Collectées

**Données Automatiques :**
- 👥 Utilisateurs actifs (quotidiens, hebdomadaires, mensuels)
- 📱 Sessions et durée moyenne
- 🌍 Localisation géographique
- 📊 Démographie des utilisateurs
- 💻 Appareils et navigateurs utilisés
- 🔄 Taux de rétention

**Événements Personnalisés :**
- Nombre de connexions/inscriptions
- Rendez-vous réservés par jour
- Annulations de rendez-vous
- Avis soumis avec distribution des notes
- Professionnels consultés
- Créneaux horaires créés

### 🔍 Accès aux Analytics

**Console Firebase :**
1. Connectez-vous à https://console.firebase.google.com
2. Sélectionnez le projet "minidoctoplus"
3. Naviguez vers **Analytics** → **Dashboard**

**Sections disponibles :**
- **Vue d'ensemble** : Métriques principales en temps réel
- **Événements** : Liste détaillée de tous les événements
- **Conversions** : Suivi des objectifs clés
- **Audiences** : Segmentation des utilisateurs
- **Entonnoirs** : Analyse du parcours utilisateur

### ⚙️ Configuration Android

**Fichiers Gradle :**
```gradle
// android/build.gradle
buildscript {
  dependencies {
    classpath 'com.google.gms:google-services:4.4.4'
  }
}

// android/app/build.gradle
plugins {
  id 'com.google.gms.google-services'
}

dependencies {
  implementation platform('com.google.firebase:firebase-bom:34.6.0')
  implementation 'com.google.firebase:firebase-analytics'
}
```

**Fichier de configuration :**
- Emplacement : `android/app/google-services.json`
- Téléchargé depuis Firebase Console
- Contient les clés API et identifiants du projet

### 🎯 Utilisation pour Monitoring

**Cas d'usage :**
- 📊 **Monitoring des performances** : Suivre l'engagement utilisateur
- 🐛 **Détection d'anomalies** : Identifier les drops d'utilisation
- 📈 **Optimisation** : Analyser les parcours utilisateurs
- 🎯 **Objectifs** : Mesurer les taux de conversion
- 🔔 **Alertes** : Notifications sur événements critiques

**Exemples de métriques clés :**
- Taux de conversion inscription → premier rendez-vous
- Temps moyen entre inscription et première réservation
- Professionnels les plus consultés
- Heures de pointe d'utilisation
- Taux d'annulation des rendez-vous

### 📝 Notes Importantes

⚠️ **Sécurité :**
- Les clés API Firebase sont publiques et peuvent être exposées dans le frontend
- La sécurité repose sur les règles Firebase Security Rules
- Les événements sensibles ne doivent pas contenir de données personnelles

⚠️ **Limites :**
- Les données Analytics ont un délai de traitement de 24-48h pour les rapports détaillés
- Les événements en temps réel sont disponibles dans la section "DebugView"
- Quota gratuit : 500 événements distincts, données illimitées

🔧 **Mode Debug (Flutter) :**
```bash
# Activer le mode debug Analytics
flutter run --dart-define=FIREBASE_ANALYTICS_DEBUG_MODE=true
```

🔧 **Mode Debug (Web) :**
```javascript
// Ajouter dans la console du navigateur
gtag('config', 'G-6EJNTRZMPH', { debug_mode: true });
```

### 🚀 Prochaines Évolutions

- 📧 Notifications push avec Firebase Cloud Messaging
- 🔐 Authentification Firebase (alternative à JWT)
- 💾 Cloud Firestore pour données temps réel
- 📂 Firebase Storage pour images de profil
- 🔥 Remote Config pour features flags
- ⚡ Performance Monitoring

---

## 🆕 Nouveautés - Version 2.1.0 

### ✅ Amélioration de la gestion des créneaux horaires

#### 1. Validation anti-chevauchement des créneaux
Le système empêche maintenant la création de créneaux qui se chevauchent temporellement :

**Fonctionnement :**
- Lors de la création d'un nouveau créneau, le système vérifie automatiquement si l'horaire choisi chevauche un créneau existant
- Si un chevauchement est détecté, une erreur claire est affichée : *"Ce créneau chevauche un créneau existant. Veuillez choisir un autre horaire."*
- La vérification prend en compte tous les scénarios de chevauchement :
  - Créneau qui englobe un créneau existant
  - Créneau qui commence pendant un créneau existant
  - Créneau qui se termine pendant un créneau existant

**Exemple :**
```
Créneau existant : 08:00 - 10:00
❌ Ne peut pas créer : 08:30 - 09:30 (chevauche)
❌ Ne peut pas créer : 07:00 - 08:30 (chevauche)
❌ Ne peut pas créer : 09:00 - 11:00 (chevauche)
✅ Peut créer : 10:00 - 12:00 (ne chevauche pas)
✅ Peut créer : 06:00 - 08:00 (ne chevauche pas)
```

#### 2. Mise à jour automatique du statut des créneaux expirés
Les créneaux passés sont automatiquement marqués comme indisponibles sans nécessiter de rafraîchissement manuel :

**Fonctionnement :**
- Une tâche planifiée s'exécute automatiquement toutes les 60 secondes côté serveur
- Les créneaux dont l'heure de fin est dépassée sont automatiquement marqués comme indisponibles
- Le frontend actualise la liste des créneaux toutes les 60 secondes pour refléter les changements en temps réel
- Interface utilisateur toujours à jour sans intervention manuelle

**Avantages :**
- 🚫 Les créneaux passés ne peuvent plus être réservés par erreur
- ⏱️ Mise à jour en temps quasi-réel du statut des créneaux
- 🔄 Synchronisation automatique entre le serveur et l'interface
- 👍 Meilleure expérience utilisateur

### 🔧 Améliorations techniques

**Backend (Spring Boot) :**
- Ajout de `findOverlappingSlots()` dans `TimeSlotRepository` : Requête MongoDB optimisée pour détecter les chevauchements
- Ajout de `findByAvailableAndEndTimeBefore()` : Recherche efficace des créneaux expirés
- Implémentation de `@Scheduled` dans `TimeSlotService` : Tâche automatique de mise à jour
- Activation de `@EnableScheduling` dans `MiniDoctoApplication`
- Amélioration de la validation lors de la création de créneaux

**Frontend (React) :**
- Gestion améliorée des erreurs avec affichage des messages détaillés du serveur
- Ajout d'un `setInterval` pour l'actualisation automatique des créneaux
- Interface utilisateur réactive avec feedback en temps réel
- Nettoyage automatique des intervalles lors du démontage des composants

### 📝 Instructions pour tester les nouvelles fonctionnalités

**Test de validation anti-chevauchement :**
1. Connectez-vous en tant que professionnel
2. Créez un créneau : 08:00 - 10:00
3. Essayez de créer un créneau chevauchant : 08:30 - 09:30
4. Le système doit refuser avec un message d'erreur explicite

**Test de mise à jour automatique :**
1. Créez un créneau avec une heure de fin proche (ex: dans 2 minutes)
2. Attendez que l'heure de fin soit dépassée
3. Après maximum 1 minute, le créneau devrait automatiquement passer à "Réservé" (indisponible)
4. Aucun rafraîchissement manuel de la page n'est nécessaire

### ⚙️ Configuration avancée

La fréquence de mise à jour automatique peut être personnalisée dans `TimeSlotService.java` :
```java
@Scheduled(fixedRate = 60000)
```

Pour ajuster la fréquence, modifiez la valeur en millisecondes (ex: 30000 pour 30 secondes).


