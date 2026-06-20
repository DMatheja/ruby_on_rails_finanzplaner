### Kurze Start-&-Seed-Anleitung

1. In das Projekt-Verzeichnis wechseln:

```bash
cd /home/david/ruby_on_rails_finanzplaner/ruby_on_rails_finan

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

> Wenn du die DB komplett neu anlegen willst, kannst du statt `db:seed` auch zuerst `sudo docker compose exec web bin/rails db:setup` ausführen.