# Adminzugang für „Liebe zum Duft“ – Bilal

Die Seite läuft auf GitHub Pages, die gemeinsame Bestandsverwaltung auf Supabase. Der sichtbare Loginname ist **Bilal**. Die Anmeldung wird durch Supabase Authentication geprüft; ein Passwort wird **nicht** in HTML, JavaScript oder GitHub gespeichert.

## Einmalige Einrichtung (Pflicht)

1. Öffne dein Supabase-Projekt. Falls noch kein Projekt existiert, lege eines im kostenlosen Tarif an.
2. Öffne **SQL Editor** und führe den Inhalt von `datenbank.sql` aus, sofern noch nicht geschehen. Das erstellt Tabelle, Bestandsregeln und Admin-Berechtigungen.
3. Gehe zu **Authentication → Users** und wähle **Add user → Create new user**. Trage **eine gültige E-Mail-Adresse ein, auf die Bilal Zugriff hat**, und lege sein Passwort fest. Am besten lässt du Bilal das Passwort selbst festlegen. Falls du das im Chat genannte Passwort verwenden willst, trage es **nur im geschützten Supabase-Formular** ein, nicht in den GitHub-Dateien. Da es bereits im Chat genannt wurde, empfiehlt sich ein neues, einzigartiges Passwort. Bei Bedarf E-Mail-Bestätigung abschließen / bestätigen.
4. Kopiere die **User ID (UUID)** des neu angelegten Kontos.
5. Öffne den **SQL Editor** und führe folgendes SQL aus. Ersetze die Platzhalter-UUID durch die UUID dieses Kontos:

```sql
insert into public.admin_users (user_id)
values ('HIER-BILAL-USER-ID-ALS-UUID')
on conflict (user_id) do nothing;
```

6. Öffne **Project Settings → API** (bzw. **API Keys** in neueren Oberflächen). Kopiere die **Project URL** und den **öffentlichen publishable/anon Key**.
7. Bearbeite `config.js`:

```javascript
window.LZD_CONFIG = {
  supabaseUrl: "https://DEIN-PROJEKT.supabase.co",
  supabaseAnonKey: "DEIN-OEFFENTLICHER-KEY",
  adminLoginEmail: "DIE-EMAIL-VON-BILALS-SUPABASE-KONTO"
};
```

8. Lade `index.html` und die konfigurierte `config.js` auf GitHub hoch. **Keinen service_role-Key, secret Key oder Passwort hochladen.**
9. Öffne die Webseite → **Admin**. Melde dich mit **Bilal** und dem in Supabase vergebenen Passwort an.
10. Suche einen Duft. Trage **30 ml**, **50 ml**, **100 ml** als ganze Stückzahlen ein (jeweils 0 oder mehr). Klicke **Speichern**. Auf der Kundenseite sollen diese Werte erscheinen. Bei 0 wird „Bestellbar“ angezeigt.

## Wissenswert

- Der Benutzername **Bilal** wird im Browser angezeigt/validiert; technisch läuft die sichere Authentifizierung über die in `config.js` hinterlegte E-Mail des Supabase-Kontos. Die E-Mail ist kein Geheimnis.
- Nur eine in `admin_users` berechtigte Supabase-Nutzer-ID kann Bestände schreiben. Nicht angemeldete Besucher haben ausschließlich Leserechte.
- GitHub Pages kann Benutzerpasswörter nicht sicher selbst speichern oder prüfen.
- Jede Änderung wird in Supabase gespeichert. Offene Kundenseiten laden spätestens etwa jede Minute nach; beim erneuten Anzeigen ebenfalls.
- Neue Reservierungen über WhatsApp ziehen den Bestand nicht automatisch ab. Der Admin pflegt den tatsächlichen Bestand.
- Ungepflegte Bestände sind nicht automatisch 0; zuerst für alle drei Größen Zahlen speichern.
- Bei einer bereits eingerichteten Supabase-Verbindung den bisherigen URL/Key in `config.js` beibehalten und nur `adminLoginEmail` ergänzen.
