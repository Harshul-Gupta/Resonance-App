# 🎵 Resonance — Artist Registry

> A full-stack music artist registry built with **Java Spring Boot**, **MongoDB**, and **JSP/Spring MVC** — featuring AWS S3 image storage, live Spotify metrics, AOP-based logging, Spring Security authentication with Google OAuth2, and a dark glass UI. Containerized with **Docker** and deployed to **AWS Elastic Beanstalk**.

---

## 📸 Overview

Resonance is a web application for discovering and managing music artists. Users can browse a curated registry, search by name or genre, view rich artist profiles with live Spotify listener data, and (when authenticated via traditional login or **Google OAuth2**) add, edit, and manage artists with image uploads stored directly to **AWS S3**. It is a good first web app as it taught me lot of fundamentals and gave a brief idea of how web applications work in production. I kept UI simple with some animations with help of Claude as front-end development wasn't the point of this app.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Backend** | Java 25, Spring Boot 4, Spring MVC |
| **Database** | MongoDB (Spring Data, custom repository impl), MySQL (via `mysql-connector-j`) |
| **Cloud Storage** | AWS S3 (via AWS SDK v2 — artist image uploads) |
| **External API** | Spotify Web API (live monthly listener metrics) |
| **View Layer** | JSP, JSTL, EL expressions |
| **Frontend** | HTML5, CSS3, Vanilla JavaScript (Fetch API) |
| **Auth** | Spring Security (session-based, custom `UserDetailsService`) + **Google OAuth2 login** |
| **AOP** | Spring AOP (`@Aspect` — logging, global nav model) |
| **Build Tool** | Maven |
| **Containerization** | Docker |
| **Deployment** | AWS Elastic Beanstalk |

---

## ✨ Features

### 🔍 Artist Discovery
- Search artists by **name or genre** with results rendered via client-side DOM injection
- Artist tiles with cover art (served from S3), genre badges, and artist type tags
- Dedicated **artist detail pages** (`Artist.jsp`) populated via REST + Fetch API
- **Artist edit pages** (`editArtist.jsp`) with drag-and-drop image upload, live preview, and revert support

### 🎧 Live Spotify Integration
- `SpotifyMetricService` fetches **real-time monthly listener counts** from the Spotify Web API
- Artist profiles display live streaming metrics alongside registry data
- `SpotifyListenersResponse` models the API response as a clean DTO

### ☁️ AWS S3 Image Uploads
- `S3Config` wires an `AmazonS3` client bean using configured credentials
- `S3ImageService` handles multipart upload, generates public URLs, and stores them on the `Artist` document
- Drag-and-drop upload on `addArtist.jsp` / `editArtist.jsp` submits as `multipart/form-data` via `@RequestPart`

### 🔐 Authentication & Security
- `WebSecurityConfig` configures Spring Security: protected routes, login/logout endpoints, password encoding
- **Google OAuth2 sign-in** integrated into `login.jsp` alongside traditional username/password auth, wired through `spring-boot-starter-oauth2-client`
- `UserDetailsServiceImpl` loads users from MongoDB by username via `UserRepo`
- `UserPrincipal` wraps the `User` document as a `UserDetails` implementation
- Post-logout redirect with a success banner on `login.jsp` (JSTL conditional)
- User profile dropdown in nav with logout support

### ⚙️ Cross-Cutting Concerns (AOP)
- `LoggingAspect` — method-level logging across service/controller layers via `@Around` / `@Before` advice
- `GlobalNavigationAdvice` — `@ControllerAdvice` that injects nav model attributes (e.g. logged-in user) into every view automatically
- `GlobalExceptionHandler` — centralised exception handling; maps custom exceptions to appropriate HTTP responses and routes to `errors.jsp`

### 🚨 Custom Error Handling
- `CustomErrorController` implements `ErrorController` for branded error pages
- `InvalidSearchRequestException` — typed domain exception for malformed search requests
- `errors.jsp` renders user-friendly error messages

### 🎨 UI / UX
- Deep navy/slate dark theme with **liquid glass card effects** and purple/violet accents
- Animated ambient orbs and a **spinning vinyl record** decoration on the login page
- Mouse-tracking tilt effect on the login card
- Custom **vinyl record-inspired favicon** (`favicon.ico` + `favicon_preview.png`)
- `index.jsp` landing page, dedicated `search.jsp`, `Artist.jsp` detail view, `editArtist.jsp`, `addArtist.jsp` form

### 📦 Containerization & Deployment
- Application is **containerized with Docker** for consistent builds and portability
- Deployed to **AWS Elastic Beanstalk**, enabling managed scaling, load balancing, and environment configuration outside the app itself

---

## 🏗️ Architecture

```
src/main/java/com/hars/ArtistRegistry/
├── Aspect/
│   ├── GlobalExceptionHandler.java   # @ControllerAdvice — maps exceptions → error views
│   ├── GlobalNavigationAdvice.java   # @ControllerAdvice — injects nav model into all views
│   └── LoggingAspect.java            # @Aspect — AOP method logging across layers
│
├── Configuration/
│   ├── S3Config.java                 # AmazonS3 client bean (AWS credentials + region)
│   ├── WebConfig.java                # MVC config — view resolvers, resource handlers
│   └── WebSecurityConfig.java        # Spring Security — auth rules, login/logout, OAuth2, BCrypt
│
├── Controller/
│   ├── ArtistController.java         # MVC view controller — routes to JSP pages
│   ├── CustomErrorController.java    # Implements ErrorController — branded error pages
│   └── HomeController.java           # REST controller — JSON API endpoints
│
├── Exception/
│   └── InvalidSearchRequestException.java
│
├── Repository/
│   ├── Artist.java                   # @Document — MongoDB artist entity
│   ├── ArtistRepo.java               # Spring Data repository
│   ├── ArtistType.java               # Enum: SOLO | BAND | ORCHESTRA
│   ├── SearchRepo.java               # Custom search repository interface
│   ├── SearchRepoImpl.java           # Custom search implementation (MongoTemplate)
│   ├── Song.java                     # @Document — song/track entity
│   ├── SpotifyListenersResponse.java # DTO — Spotify API response model
│   ├── User.java                     # @Document — user entity
│   ├── UserPrincipal.java            # UserDetails wrapper for Spring Security
│   ├── UserResponseDTO.java          # DTO — user registration payload
│   └── UserRepo.java                 # User repository
│
├── Service/
│   ├── ArtistService.java            # Artist update/delete business logic
│   ├── RegisterService.java          # Handles new user registration
│   ├── S3ImageService.java           # Multipart upload → S3, returns public URL
│   ├── SpotifyMetricService.java     # Spotify Web API client — monthly listeners
│   └── UserDetailsServiceImpl.java   # Loads UserDetails from MongoDB for Spring Security
│
└── SpringMvcApplication.java
```

### Key Design Decisions

- **Dual controller pattern**: `ArtistController` handles view routing to JSPs; `HomeController` exposes the REST JSON API. This cleanly separates rendering from data concerns.
- **Custom `SearchRepoImpl`**: Extends Spring Data with a `MongoTemplate`-based implementation for flexible, dynamic search queries (by name and genre) that can't be expressed as simple derived methods.
- **AOP for cross-cutting concerns**: Logging and nav model population are handled declaratively via `@Aspect` and `@ControllerAdvice`, keeping controllers and services focused on business logic.
- **S3 for image storage**: Artist images are uploaded directly to AWS S3 rather than stored on disk, making the app stateless and cloud-deployable.
- **Spotify integration**: Live listener data is fetched at request time from the Spotify Web API, enriching static registry data with real-world metrics.
- **`UserPrincipal` adapter**: Decouples the `User` MongoDB document from Spring Security's `UserDetails` contract.
- **Dual auth strategy**: Traditional form login and Google OAuth2 are both wired through the same `WebSecurityConfig`, converging on the same `UserPrincipal`/session model so downstream code doesn't need to distinguish login method.
- **Container-first deployment**: Packaging as a Docker image keeps the runtime environment consistent between local development and the Elastic Beanstalk-managed production environment.

---

## 🚀 Getting Started

### Prerequisites
- Java 25+
- Maven 3.9+
- MongoDB running locally on port `27017`
- AWS account with an S3 bucket and IAM credentials
- Spotify Developer app credentials (Client ID + Secret)
- Google OAuth2 credentials (Client ID + Secret) for Google sign-in
- Docker (for containerized run/deploy)

### Run Locally (Maven)

```bash
git clone https://github.com/Harshul-Gupta/Artist-Registry-V2.git
cd Artist-Registry-V2
mvn spring-boot:run
```

App runs at `http://localhost:8080`

### Run Locally (Docker)

```bash
docker build -t resonance .
docker run -p 8080:8080 --env-file .env resonance
```

### Deploying to AWS Elastic Beanstalk

The app is packaged as a Docker image and deployed via Elastic Beanstalk's Docker platform. At a high level:

```bash
mvn clean package
docker build -t resonance .
eb init
eb create resonance-env
eb deploy
```

> Configure environment variables (Mongo URI, AWS creds, Spotify keys, Google OAuth2 client ID/secret) through the Elastic Beanstalk environment configuration rather than baking them into the image.

### Configuration (`application.properties`)

```properties
spring.application.name=ArtistRegistry
spring.mvc.view.prefix= /Views/
spring.mvc.view.suffix= .jsp

# MongoDB
spring.mongodb.uri=mongodb+srv://harshul:<Password>@<ClusterName>.mongodb.net/?appName=<AppName>
spring.mongodb.database=<DatabaseName>

logging.level.root=info

# AWS Configuration
aws.bucket.name=<BucketName>
aws.region=<Region>

#Multipart
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=15MB

# RapidAPI Configuration
rapidapi.spotify.url=<URL>
rapidapi.spotify.key=<RapidAPIKey>
rapidapi.spotify.host=spotify-artist-monthly-listeners.p.rapidapi.com

# Google OAuth2
spring.security.oauth2.client.registration.google.client-id=<GoogleClientId>
spring.security.oauth2.client.registration.google.client-secret=<GoogleClientSecret>
spring.security.oauth2.client.registration.google.scope=openid,profile,email

server.port=8080
```

> ⚠️ Never commit real credentials. Use environment variables or a `.env` file and add `application.properties` to `.gitignore`. I used this for local testing, should have used env variables here as well :P

---

## 📡 REST API Reference

All endpoints served by `HomeController` under `/api/artists`.

### Artists

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/artists/{id}` | Get artist by ID |
| `POST` | `/api/artists/send` | Add artist with image upload (multipart/form-data) |
| `PATCH` | `/api/artists/{mongoId}` | Update artist fields + optional image (multipart/form-data) |
| `DELETE` | `/api/artists/{mongoId}` | Delete artist |

### Users

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/api/artists/user` | Register a new user |

**Sample Response — `GET /api/artists/{id}`**
```json
{
  "id": "64f1a2b3c4d5e6f7a8b9c0d1",
  "name": "Tame Impala",
  "type": "BAND",
  "country": "Australia",
  "genre": ["Psychedelic Rock", "Indie Pop"],
  "imageURL": "https://your-bucket.s3.amazonaws.com/artists/tame-impala.jpg",
  "bio": "Australian psychedelic music project led by Kevin Parker.",
  "spotifyMonthlyListeners": 12480000
}
```

### MVC View Routes

Served by `ArtistController`.

| Method | Endpoint | View | Description |
|---|---|---|---|
| `GET` | `/` | `index` | Landing page with registry stats |
| `GET` | `/search` | `search` | Search by name/genre (MongoTemplate-backed, paginated) |
| `GET` | `/artists` | `artists` | Full artist library listing |
| `GET` | `/artist-details` | `Artist` | Artist detail page |
| `GET` | `/add` | `addArtist` | Add-artist form |
| `GET` | `/artist/edit/{id}` | `editArtist` | Edit-artist form |
| `GET` | `/register` | `registerArtist` | User registration page |
| `GET`/`POST` | `/login` | `login` | Login page — supports form login and Google OAuth2 |

---

## 🧠 Skills Demonstrated

| Skill | Where |
|---|---|
| Spring MVC (view + REST) | `ArtistController`, `HomeController` |
| Spring Security + custom auth | `WebSecurityConfig`, `UserDetailsServiceImpl`, `UserPrincipal` |
| OAuth2 login integration | `WebSecurityConfig`, `login.jsp` |
| Spring AOP | `LoggingAspect`, `GlobalNavigationAdvice`, `GlobalExceptionHandler` |
| AWS S3 SDK integration | `S3Config`, `S3ImageService` |
| Third-party REST API consumption | `SpotifyMetricService` |
| Custom MongoDB queries | `SearchRepo`, `SearchRepoImpl` (MongoTemplate) |
| Multipart file upload | `addArtist.jsp` / `editArtist.jsp` → `@RequestPart` → S3 |
| Global exception handling | `GlobalExceptionHandler`, `CustomErrorController`, `errors.jsp` |
| JSP / JSTL templating | All views in `src/main/webapp/Views/` |
| Frontend (JS Fetch API, CSS animations) | Client-side rendering, glassmorphism UI |
| Containerization | `Dockerfile`, local Docker run |
| Cloud deployment | AWS Elastic Beanstalk |

---

## 📄 License

MIT © Harshul Gupta
