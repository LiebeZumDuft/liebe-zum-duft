# Neue automatische Bestandsreduzierung – Einrichtung

1. ZUERST `SUPABASE_RESERVIERUNG_EINRICHTEN.sql` in Supabase > SQL Editor > **New query** einfügen und **Run** drücken. Nicht noch einmal `datenbank.sql` ausführen.
2. Anschließend `index.html` aus dieser ZIP auf GitHub hochladen. Die andere Dateien **nicht** ersetzen – insbesondere `config.js` nicht! Dort ist deine echte Supabase-Verbindung bereits eingetragen.
3. Test: Im Adminbereich einen TEST-Duft bei 30 ml auf 3 setzen. Auf der Kundenseite genau diese Größe reservieren. Auf `Reservierung anlegen & WhatsApp öffnen` klicken. Bestand sollte auf 2 sinken. Nachricht zusätzlich in WhatsApp absenden. Danach 0 Stück testen: statt Abbuchung Bestellanfrage.
4. Eine Reservierung zieht die gewählte Größe **beim verbindlichen Klick auf der Website** ab, bevor WhatsApp geöffnet wird. Der Browser kann **nicht** erkennen, ob die WhatsApp-Nachricht tatsächlich abgesendet wurde. Die Reservation ist deshalb zunächst nur vorgemerkt; im Adminbereich kann Bilal bei abgebrochenen Nachrichten den Bestand wieder erhöhen.
5. Sehr wichtig: Öffentlich erreichbare Reservierungen können absichtlich oder versehentlich missbraucht werden (z.B. unzählige Anfragen ohne WhatsApp-Nachricht). Für ernsthaften Livebetrieb empfiehlt sich zusätzlich ein serverseitiger Spamschutz/CAPTCHA und eine Reservierungsübersicht mit Freigabe oder Ablaufzeit. Ohne diese schützt die Version zwar vor negativen und doppelten Abbuchungen derselben Anfrage, aber nicht vor vielen **verschiedenen** Anfragen.

## Admin-Anmeldung
Das Feld `Benutzername` ist jetzt leer, Passwort bleibt leer; Anmeldung erfolgt weiter über Supabase.

## Bestandslogik
- Größer als 0: Automatische Abbuchung exakt eines Flakons in der gewählten Größe und Speicherung der Reservierungsnummer.
- Gleich 0: „Bestellbar“, keine Bestandsreduzierung; WhatsApp-Bestellanfrage.
- Kein Bestand hinterlegt: Keine automatische Reservierung, klare Fehlermeldung.
- Anfragen ohne Supabase-Verbindung: keine Reservierung.

**Hinweis:** Dies ist keine vollwertige Warenwirtschaft / kein automatischer WhatsApp-Nachrichtenversand. Die Abholung/Bestätigung muss weiterhin persönlich geklärt werden.
