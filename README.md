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

**Version:** 2.0.0

