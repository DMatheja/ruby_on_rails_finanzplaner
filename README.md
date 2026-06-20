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
- [x] Produkte: Seite, Bearbeiten, Anlegen, Löschen
- [x] Filteroptionen für die Produktliste (nach Kategorie)
- [x] Subscriptions mit Abrechnungsdatum: Seite, Bearbeiten, Anlegen, Löschen
- [x] Produkte als gekauft markieren + Ausgabenliste
- [x] Kontostand und Einkommen eines Nutzers mit Einkommensdatum
- [x] Sparziel-Rechner
- [x] Home Page mit Nutzername, Kontostand, Sparzielrechner und zuletzt aufgerufen
- [x] Grafische Übersicht des Kontostandes (Einkommen, Ausgaben pro Monat)
- [x] Zeitsimulation für Administratoren
- [x] verschiedene Berechtigungen für verschiedene Rollen (Viewer, User, Admin)

### Optionale Funktionen

- [ ] Gruppen von Usern erstellen mit Limit und Summe

### Nicht umgesetzt / bewusst ausgelassen

- [ ] Gruppen von Usern erstellen mit Limit und Summe

---

## Eingesetzte Technologien

- **Frontend:** ERB-Templates (Embedded Ruby), Stimulus.js, Turbo (Hotwire), Importmap
- **Backend:** Ruby on Rails 8.1, Puma Web Server
- **Datenbank / Speicherung:** SQLite 3
- **Framework(s):** Ruby on Rails 8.1
- **Weitere Bibliotheken / Tools:**
  - `bcrypt` – Passwort-Hashing (`has_secure_password`)
  - `solid_cache`, `solid_queue`, `solid_cable` – datenbankbasiertes Caching, Jobs & WebSockets
  - `brakeman` – statische Sicherheitsanalyse
  - `bundler-audit` – Sicherheits-Audit für Gem-Abhängigkeiten
  - `rubocop-rails-omakase` – Code-Style-Linting
  - `propshaft` – Asset-Pipeline
  - `thruster` – HTTP-Caching/Komprimierung vor Puma
  - `timecop` – für Zeitsimulation
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

Das Projekt enthält ein `Docker-Compose`. Für den einfachen lokalen Start:

1. In das Projekt-Verzeichnis wechseln:

```bash
cd /ruby_on_rails_finanzplaner

```

2. Build und Start:

```bash
sudo docker compose up --build --detach

```

3. Status prüfen:

```bash
sudo docker compose ps

```

4. Datenbank seeden:

```bash
sudo docker compose exec web bin/rails db:seed

```

5. Logs anschauen:

```bash
sudo docker compose logs -f web

```

6. Beenden:

```bash
sudo docker compose down

```

> **Hinweis:** Wenn du die DB komplett neu anlegen willst, kannst du statt `db:seed` auch zuerst `sudo docker compose exec web bin/rails db:setup` ausführen.

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

| Name   | Rolle  | Passwort  | Berechtigungen                                          |
| ------ | ------ | --------- | ------------------------------------------------------- |
| max    | User   | 123456    | Read, Write, Delete (Produkte, Kategorien, Abonnements) |
| admin  | Admin  | password  | Read, Write, Delete (Alles, auch User)                  |
| viewer | Viewer | 123456789 | nur Read, kein Zugriff auf Usertabelle                  |


> Die Testnutzer werden beim ersten Start automatisch über `db/seeds.rb` angelegt.

---

## Bekannte Einschränkungen

  - optionale Features nicht umgesetzt
  
---

## Contributors

| Name          | Matrikelnummer |
| ------------- | -------------- |
| Simon Hauck   | 7182169        |
| David Matheja | 9809395        |
| Leon Scherer  | 4348355        |
