# Liebe zum Duft – Einrichtung der Bestandsverwaltung

## Was geändert wurde
- Alle Preise 10 € reduziert: 30 ml **25 €**, 50 ml **35 €**, 100 ml **45 €**.
- Reservierungen gehen per WhatsApp an **+49 176 70499636**.
- Jeder Duft hat getrennte Bestände für **30 / 50 / 100 ml**.
- Bei **0 Stück** steht **„Bestellbar“** (Reservierungsanfrage weiterhin möglich); bei positiven Beständen steht **„X verfügbar“**.
- Adminbereich über **Admin** oben im Menü. Die öffentliche Webseite aktualisiert Lagerdaten beim Öffnen, beim Zurückwechseln in den Tab und ungefähr jede Minute.

## Unbedingt vor der Veröffentlichung erledigen
Das Original war eine reine statische HTML-Seite ohne gemeinsamen Server. Deshalb sind online gültige Bestandszahlen erst nach Einrichtung einer Supabase-Datenbank möglich. Ohne Verbindung zeigen die Seiten **„Bestand wird geladen“** bzw. **„nicht hinterlegt“**, keine ausgedachten Lagerzahlen. Im Adminbereich wird ein Hinweis zur fehlenden Konfiguration angezeigt.

1. Auf https://supabase.com ein Projekt anlegen.
2. Im **SQL Editor** die Datei `datenbank.sql` ausführen.
3. In **Authentication → Users** einen Admin-Benutzer (E-Mail + Passwort) anlegen. E-Mail-Bestätigung gegebenenfalls abschließen.
4. In der Benutzeransicht seine **UUID** kopieren.
5. Im **SQL Editor** die Berechtigung setzen, die UUID ersetzen:

   ```sql
   insert into public.admin_users (user_id)
   values ('HIER-DIE-UUID-DES-ADMINS-EINSETZEN');
   ```

6. Im Supabase-Projekt unter **Project Settings → API** die **Project URL** und den öffentlichen **anon/publishable key** kopieren. In `config.js` die Felder `supabaseUrl` und `supabaseAnonKey` eintragen. **Niemals `service_role` oder geheime Schlüssel in eine Webseite schreiben!**
7. `index.html`, `hero.jpg` und `config.js` zusammen auf demselben Webhosting veröffentlichen (mit HTTPS). Die `.sql`-Datei und diese Anleitung müssen nicht öffentlich hochgeladen werden.
8. Die Seite aufrufen, **Admin** wählen, mit dem angelegten Konto anmelden. Mit der Suche einen Duft finden, für jede Größe eine Stückzahl (auch 0) eintragen und **Speichern** drücken.
9. Auf einem zweiten Gerät die öffentliche Seite öffnen und prüfen, ob die Bestände synchron erscheinen. WhatsApp-Reservierung testen.

## Hinweise
- Der Bestand wird derzeit **manuell** durch den Admin gepflegt. Eine WhatsApp-Reservierungsanfrage zieht **nicht automatisch** Ware ab, denn sie ist noch keine bestätigte Reservierung.
- Noch nicht gepflegte Artikel stehen als **„nicht hinterlegt“**. Nur wirklich als 0 gepflegte Größen stehen als **„Bestellbar“**.
- Bei Verbindungsproblemen zeigt die öffentliche Seite **„Bestand wird geladen“**; es wird **kein möglicherweise veralteter Bestand als aktuell ausgegeben**.
- Die 0-Stück-Angabe betrifft die jeweilige **Flaschengröße**, nicht pauschal alle Größen eines Dufts.
- Nur Admins, deren Benutzer-ID in `admin_users` steht, dürfen über die Datenbankrechte Bestand ändern.
- Änderungen werden sofort in Supabase gespeichert. Bereits offene Kundenseiten aktualisieren spätestens ungefähr nach einer Minute, solange sie aktiv sind.
