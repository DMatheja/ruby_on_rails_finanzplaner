# Finanzplaner

## Beschreibung

Der Finanzplaner ist eine webbasierte Anwendung zur persönlichen Finanzverwaltung. Sie ermöglicht es Nutzern, ihre Ausgaben in Kategorien zu organisieren, Produkte und Abonnements zu verwalten sowie den eigenen Kontostand im Blick zu behalten.

- **Was macht das Projekt?** Nutzer können Budgetkategorien mit Limits anlegen, Produkte diesen Kategorien zuweisen, als gekauft markieren und so ihren Kontostand automatisch aktualisieren lassen. Abonnements mit festgelegten Abrechnungsdaten sowie ein Sparziel-Rechner ergänzen den Funktionsumfang.
- **Für wen ist es gedacht?** Für Einzelpersonen, die ihre monatlichen Ausgaben strukturiert verfolgen möchten.
- **Welches Problem wird gelöst?** Die manuelle und unübersichtliche Haushaltsbuchhaltung wird durch eine strukturierte, rollenbasierte Webanwendung ersetzt.

---

## Umfang

### Abgesprochene Funktionen

- [x] Einfaches Login mit festgelegten Testusern
- [x] Header-Navigation
- [x] Nutzer: Auswahl, Bearbeiten, Anlegen, Löschen (rollenbasiert)
- [x] Kategorien mit Limits & Summenanzeige: Seite, Bearbeiten, Anlegen, Löschen
- [x] Produkte: Seite, Bearbeiten, Anlegen, Löschen (nur kategorielose Produkte in der Hauptliste)
- [x] Subscriptions mit Abrechnungsdatum: Seite, Bearbeiten, Anlegen, Löschen
- [x] Produkte als gekauft markieren + Ausgabenliste
- [x] Kontostand und Einkommen eines Nutzers mit Einkommensdatum
- [x] Sparziel-Rechner
- [x] Home Page mit Nutzername, Kontostand, Sparzielrechner und zuletzt aufgerufen
- [x] Grafische Übersicht des Kontostandes (Einkommen, Ausgaben pro Monat)

### Optionale Funktionen

- [ ] Gruppen von Usern erstellen mit Limit und Summe

### Nicht umgesetzt / bewusst ausgelassen

---

## Eingesetzte Technologien

- **Frontend:** ERB-Templates (Embedded Ruby), Stimulus.js, Turbo (Hotwire), Importmap
- **Backend:** Ruby on Rails 8.1, Puma Web Server
- **Datenbank / Speicherung:** SQLite 3
- **Framework(s):** Ruby on Rails 8.1 (MVC-Architektur)
- **Weitere Bibliotheken / Tools:**
  - `bcrypt` – Passwort-Hashing (`has_secure_password`)
  - `solid_cache`, `solid_queue`, `solid_cable` – datenbankbasiertes Caching, Jobs & WebSockets
  - `brakeman` – statische Sicherheitsanalyse
  - `bundler-audit` – Sicherheits-Audit für Gem-Abhängigkeiten
  - `rubocop-rails-omakase` – Code-Style-Linting
  - `propshaft` – Asset-Pipeline
  - `thruster` – HTTP-Caching/Komprimierung vor Puma
  - Docker – Containerisierung

---

## Projektstruktur

```
app/
├── controllers/          – Anfragen verarbeiten, Logik koordinieren
├── models/               – Datenstruktur & Geschäftslogik
├── views/                – ERB-Templates pro Resource
│   └── shared/_header    – Gemeinsame Navigation
config/
├── routes.rb             – URL-Routen
├── database.yml          – SQLite-Konfiguration
db/
├── schema.rb             – Aktuelle Datenbankstruktur
├── migrate/              – Migrationen (Datenbankänderungen)
└── seeds.rb              – Testdaten für den ersten Start
lib/
└── security_dictionary.rb – Wörterbuch für Passwort-Demo
test/
└── models/                – Modell-Tests
```

---

## Setup

### Voraussetzungen

- Ruby 3.4.9 (siehe `.ruby-version`)
- Bundler (`gem install bundler`)
- SQLite 3
- Docker & Docker Compose (für Container-Start)

### Lokales Starten

```bash
# 1. Repository klonen
git clone https://github.com/DMatheja/ruby_on_rails_finanzplaner.git
cd ruby_on_rails_finanzplaner
```

```bash
# 2. Abhängigkeiten installieren
bundle install
```

```bash
# 3. Datenbank erstellen, migrieren und Testdaten laden
rails db:setup
```

```bash
# 4. Entwicklungsserver starten
rails s
```

Die Anwendung ist danach unter `http://localhost:3000` erreichbar.

### Start mit Container

Das Projekt enthält ein produktionsreifes `Dockerfile`. Für den einfachen lokalen Start:

```bash
# Image bauen
docker build -t finanzplaner .
```

```bash
# Container starten (RAILS_MASTER_KEY aus config/master.key eintragen)
docker run -d -p 80:80 \
  -e RAILS_MASTER_KEY=<wert_aus_config/master.key> \
  --name finanzplaner \
  finanzplaner
```

> **Hinweis:** Beim Start des Containers wird `bin/docker-entrypoint` automatisch ausgeführt, welches `rails db:prepare` aufruft – die Datenbank wird also beim ersten Start automatisch erstellt und migriert. Testdaten müssen ggf. separat mit `rails db:seed` geladen werden.

**Gestartete Dienste:**

- Rails-App via Thruster + Puma (Port 80)
- SQLite-Datenbank (lokal im Container unter `storage/`)

---

## Tests

### Was wurde getestet?

- Produktmodell: Grundlegende Modellstruktur (`test/models/product_test.rb`)
- Sicherheit: Statische Analyse mit `brakeman` (Rails-Sicherheitslücken) und `bundler-audit` (bekannte Gem-Schwachstellen)
- JavaScript-Abhängigkeiten: `importmap audit`
- Code-Style: RuboCop mit Rails-Omakase-Regelwerk

### Wie wurde getestet?

- **Manuell getestet:**
  - Login mit verschiedenen Rollen (Admin, User, Viewer)
  - CRUD-Operationen für alle Ressourcen
  - Rollenbasierte Zugriffsbeschränkungen
  - Rate-Limiting & Account-Sperrung nach 3 Fehlversuchen
- **Automatisiert getestet:**
  - `brakeman` – statische Sicherheitsanalyse
  - `bundler-audit` – Gem-Sicherheitscheck
  - RuboCop – Linting & Code-Style
  - GitHub Actions CI läuft bei jedem Push auf `main` und bei Pull Requests

### Testen des Projekts

```bash
# Unit- und Integrationstests ausführen
bin/rails db:test:prepare test
```

```bash
# System-Tests ausführen
bin/rails db:test:prepare test:system
```

```bash
# Sicherheitsanalyse
bin/brakeman --no-pager
```

```bash
# Gem-Sicherheitscheck
bin/bundler-audit
```

```bash
# Code-Style prüfen
bin/rubocop
```

---

## Users

| Name      | Rolle  | Passwort  |
| --------- | ------ | --------- |
| max       | User   | 123456    |
| admin     | Admin  | password  |
| viewer    | Viewer | 123456789 |

> Die Testnutzer werden beim ersten Start automatisch über `db/seeds.rb` angelegt.

---

## Bekannte Einschränkungen

---

## Contributors

| Name          | Matrikelnummer |
| ------------- | -------------- |
| Simon Hauck   | 7182169        |
| David Matheja | 9809395    |
| Leon Scherer  | 4348355        |
