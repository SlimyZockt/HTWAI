# Aufgabe

Diese Aufgabe besteht aus zwei Teilen:

1. Inhaltliche Abgabe (Template mit 10 Fragen)  
2. Technische Umsetzung (AI + Docker + Kubernetes mit zwei Services + Pitch)  

Gruppengrösse ist 1 bis 2 Personen pro Gruppe.
Gruppen sind per Email an alkurdiz@htw-berlin.de ODER per Moodle einzutragen https://moodle.htw-berlin.de/mod/wiki/view.php?id=2035127.

Die Abgabe der Prüfungsleistung hat bis spätestens am 22.11.2025 23:59:59 Uhr per E-Mail an alkurdiz@htw-berlin.de und richtero@htw-berlin.de zu erfolgen.
---

## Kategorien und Themen  

### Hinweis zu Daten  
Für alle Projekte dürfen **Dummy-Daten oder simulierte Daten** verwendet werden.  
Wichtig ist, dass die Funktionsweise der AI **klar nachvollziehbar** gezeigt wird – auch ohne Live-Daten.  

---

### Kategorie 1: Nachhaltigkeit und Umwelt
- Conscious Shopping – Einkaufsberater, der nachhaltige Produkte empfiehlt (Dummy-Produktlisten erlaubt)  
- EcoFood Coach – KI analysiert Rezepte oder Einkaufslisten und schlägt klimafreundliche Alternativen vor (Dummy-Rezepte erlaubt)  
- Smart Recycle Bot – KI ordnet Gegenstände dem richtigen Müll zu (Dummy-Beispiele wie Glasflasche, Plastiktüte erlaubt)  
- Energy Saver AI – Tipps zur Stromnutzung (Dummy-Simulation von Verbrauchsdaten)  
- Water Guardian – Wasserspar-Tipps im Alltag mit Challenges (Dummy-Szenarien)  
- Sustainable Travel Advisor – zeigt CO₂ für Routen (Dummy-Reisedaten)  
- Eigenes Thema – frei  

---

### Kategorie 2: Smart City und Gesellschaft 
- CityMind 2030 – KI-Assistent für Bürger-Services (Dummy-Fahrpläne, Parkhaus-Daten erlaubt)  
- My City Talks – Chatbot, der als Stadt selbst spricht (Dummy-Dialoge erlaubt)  
- Civic Voice – Bürger:innen melden Probleme („Loch in der Straße“) und die KI leitet weiter (Dummy-Meldungen erlaubt)  
- Eigenes Thema – frei  

---

### Kategorie 3: Reisen und Kultur
- LocalLens – KI zeigt Insider-Tipps und Geschichten (Dummy-Ortsdaten erlaubt)  
- Smart Packing Assistant – erstellt Packlisten basierend auf Wetter, Dauer und Zielort (Dummy-Wetterdaten erlaubt)  
- Green Routes – plant nachhaltige Routen und zeigt CO₂-Einsparung (Dummy-Routen erlaubt)  
- Budget Travel Planner – plant Reisen innerhalb eines Budgets (Dummy-Preise erlaubt)  
- Eigenes Thema – frei  

---

### Kategorie 4: Bildung und Arbeit der Zukunft  
- AI StudyTwin – KI-Zwilling zum Mitlernen (Dummy-Texte erlaubt)  
- Focus Friend – Erinnerungen und Pausen-Tipps (Dummy-Nutzungsdaten erlaubt)  
- Eigenes Thema – frei  

---

### Kategorie 5: Sicherheit & Governance  
- KI für Verwaltung und Gesellschaft (Dummy-Szenarien erlaubt)  
- Fake-News-Erkennung (Dummy-Nachrichten erlaubt)  
- Cybersecurity-Assistenz (Dummy-Protokolle erlaubt)  
- Eigenes Thema – frei  

---

# Teil 1: Abgabe-Template - Inhaltliche Abgabe 

Bitte beantworten Sie die folgenden Abschnitte in vollständigen Sätzen.
Jede Antwort 7–10 Zeilen (nicht nur Stichpunkte, sondern Sätze).
README.md soll am Ende max. 220 Zeilen haben.

1. Executive Summary – Kurze Zusammenfassung des Projekts.  
2. Ziele des Projekts – Welche Ziele verfolgt Ihr Projekt, welches Problem wird gelöst?  
3. Anwendung und Nutzung – Wie wird die Lösung verwendet, wer sind die Hauptnutzer:innen?  
   - Hier bitte auch den Link zum Code-Repository und zum Pitch (Audio bevorzugt, alternativ Video) einfügen.  
4. Entwicklungsstand – Idee, Proof of Concept, Prototyp oder Einsatzbereit?  
5. Projektdetails – Welche Kernfunktionen oder Besonderheiten bietet Ihr Projekt?  
6. Innovation – Was ist neu und besonders innovativ?  
7. Wirkung (Impact) – Welchen konkreten Nutzen bringt Ihr Projekt?  
8. Technische Exzellenz – Welche Technologien, Daten oder Algorithmen werden genutzt?  
9. Ethik, Transparenz und Inklusion – Wie stellen Sie Fairness, Transparenz und Sicherheit sicher?  
10. Zukunftsvision – Wie könnte das Projekt in 5–10 Jahren aussehen?  

---

# Teil 2: Technische Umsetzung 

1. **AI-Komponente**  
   - Mindestens eine Funktion (z. B. Zusammenfassung, Empfehlung, Chat).  
   - Nutzung einer API (z. B. Deepseek, OpenAI) erlaubt. (Key"s werden vom Dozent bereitgestellt) 
   - Antworten sollen verlässlich sein: lieber „weiß ich nicht“ als falsche Antworten. Wenig wie möglich Halluzinationen der AI.  

2. **Docker**  
   - App containerisieren (Dockerfile).  
   - Lokal startbar mit `docker compose up -d`.  

3. **Kubernetes (lokal, kind)**  
   - mindstens 2 Services (z. B. api ).  
   - Mindestens ein Deployment pro Service.  
   - Nur API-Endpunkte, keine grafische Oberfläche notwendig. 

4. **Pitch (Audio bevorzugt, alternativ Video)**  
   - Dauer: 1–3 Minuten.  

---

# Abgabeformat  

1. **Code** mit:  
   - Dockerfile  
   - Kubernetes-Manifeste (Ordner `k8s/` mit mindestens zwei Services)
2. **README** (dieses Dokument, max. 220 Zeilen mit Antworten auf die 10 Fragen). Kann im Code enthalten sein. 
3. **Pitch** (Audio bevorzugt, alternativ Video, max. 25 MB). Kann im Code enthalten sein.  

---

# Bewertung (100 Punkte)  

- Konzept und README – 40 Punkte  
- AI-Komponente – 25 Punkte  
- Docker – 20 Punkte  
- Kubernetes (mindestens zwei Services) – 10 Punkte
- Pitch (Audio oder Video) – 5 Punkte  

---
## Notenskala

- **1.0 (sehr gut)**: 95 – 100 Punkte  
- **1.3**: 90 – 94 Punkte  
- **1.7**: 85 – 89 Punkte  
- **2.0 (gut)**: 80 – 84 Punkte  
- **2.3**: 75 – 79 Punkte  
- **2.7**: 70 – 74 Punkte  
- **3.0 (befriedigend)**: 65 – 69 Punkte  
- **3.3**: 60 – 64 Punkte  
- **3.7**: 55 – 59 Punkte  
- **4.0 (ausreichend)**: 50 – 54 Punkte  
- **5.0 (nicht bestanden)**: < 50 Punkte 

## Hinweise

- Dummy-Daten sind in allen Projekten erlaubt.  
- Nachweise bitte **textbasiert** ins README, nicht als Screenshot.  
- Pitch: Audio bevorzugt, Video optional.

---
# To-do-Liste  

1. Thema wählen (aus den Kategorien).  
2. AI-Komponente bauen.  
3. App in Docker packen (Dockerfile).  
4. k8s Cluster in Docker starten.  
5. Services in Kubernetes deployen (Ordner `k8s/`).  
6. Pitch aufnehmen (Audio bevorzugt, alternativ Video, 1–3 Minuten).  
7. Finale Kontrolle: README.md (10 Fragen) und nicht mehr als 220 Zeilen, Code, Kubernetes, Pitch vollständig. Per E-mail an alkurdiz@htw-berlin.de und richtero@htw-berlin.de bis 23:59:59 Uhr am 22.11.2025!
