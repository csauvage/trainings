# Mindful

> Journal personnel intelligent avec Apple Intelligence

Une application de journal intime moderne pour iOS qui utilise Swift 6, SwiftUI, et Apple Intelligence pour vous aider à capturer vos pensées, suivre vos humeurs, et réfléchir sur votre vie.

![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## ✨ Features

### Core Features
- ✍️ **Journal intime riche** : Texte formaté avec support Markdown
- 📸 **Photos & souvenirs** : Attachez plusieurs photos par entrée
- 😊 **Mood tracking** : Suivez votre humeur avec 5 états émotionnels
- 🏷️ **Tags intelligents** : Tags manuels et auto-tagging avec NLP
- ☁️ **iCloud sync** : Synchronisation automatique entre tous vos appareils
- 🔒 **Privacy-first** : Données chiffrées, aucun serveur tiers

### Apple Intelligence (iOS 18+)
- 🤖 **Sentiment analysis** : Détection automatique de l'humeur pendant la frappe
- ✨ **Writing Tools** : Amélioration, résumé, et reformulation natifs
- 🗣️ **App Intents** : "Hey Siri, add a journal entry about my day"
- 🧠 **Smart prompts** : Rappels contextuels et insights personnalisés

### Interface Liquid Glass
- 🎨 Design moderne avec effets glass/blur
- ✨ Animations fluides et naturelles
- 🌓 Support Dark Mode complet
- ♿️ Accessible (VoiceOver, Dynamic Type)

### Analytics & Insights
- 📊 **Mood trends** : Visualisez l'évolution de votre humeur
- 🔥 **Streak tracking** : Jours consécutifs d'écriture
- 📈 **Stats complètes** : Nombre de mots, temps de lecture, etc.
- 💡 **Insights** : "Il y a 1 an aujourd'hui, vous écriviez..."

## 🏗️ Architecture

### Stack Technique

```
SwiftUI + Swift 6
├── SwiftData (persistence)
├── Actors (thread-safety)
├── async/await (concurrency)
├── NaturalLanguage (AI on-device)
├── App Intents (Siri integration)
└── Swift Charts (analytics)
```

### Architecture en Couches

```
MindfulApp
├── Data Layer (SwiftData)
│   ├── @Model JournalEntry
│   ├── @Model Photo
│   └── ModelContainer
├── Domain Layer (Actors)
│   ├── JournalRepository
│   ├── PhotoProcessor
│   ├── ExportService
│   └── SentimentAnalyzer
├── Presentation Layer (SwiftUI)
│   ├── Views (Timeline, Editor, Detail, Stats)
│   ├── Components (GlassCard, MoodSelector)
│   └── ViewModels (@Observable)
└── Intelligence Layer
    ├── App Intents (Siri)
    ├── NaturalLanguage (sentiment, keywords)
    └── Writing Tools (iOS 18)
```

## 📋 Prérequis

- macOS Sequoia 14.0+
- Xcode 26.0+
- iOS 18.0+ (iOS 26.0+ pour AI)
- Swift 6.0
- Compte développeur Apple (gratuit suffit pour dev)

## 🚀 Installation

1. **Cloner le repository**
   ```bash
   git clone https://github.com/csauvage/trainings.git
   cd mindful
   ```

2. **Ouvrir Creer le projet**

3. **Configurer le signing**
   - Sélectionner votre équipe de développement
   - Changer le bundle identifier si nécessaire

4. **Build & Run**
   - Cmd+R ou cliquer sur le bouton Play
   - Sélectionner un simulateur ou appareil

## 🗂️ Structure du Projet

```
Mindful/
├── App/
│   ├── MindfulApp.swift           # Entry point
│   └── DataController.swift       # SwiftData config
├── Models/
│   ├── JournalEntry.swift         # @Model principal
│   ├── Photo.swift                # @Model photos
│   ├── Mood.swift                 # Enum humeurs
│   ├── Location.swift             # Struct localisation
│   └── Weather.swift              # Struct météo
├── Services/
│   ├── JournalRepository.swift    # Actor CRUD
│   ├── PhotoProcessor.swift       # Actor traitement photos
│   ├── ExportService.swift        # Actor exports
│   └── SentimentAnalyzer.swift    # Actor NLP
├── Views/
│   ├── TimelineView.swift         # Liste des entrées
│   ├── EditorView.swift           # Éditeur d'entrée
│   ├── DetailView.swift           # Lecture d'entrée
│   └── StatsView.swift            # Dashboard analytics
├── Components/
│   ├── GlassCard.swift            # Base component
│   ├── MoodSelector.swift         # Sélecteur d'humeur
│   ├── PhotoGallery.swift         # Galerie photos
│   └── TagPill.swift              # Pills pour tags
├── ViewModels/
│   ├── TimelineViewModel.swift
│   ├── EditorViewModel.swift
│   └── StatsViewModel.swift
├── Intelligence/
│   ├── AppIntents/
│   │   ├── AddJournalEntryIntent.swift
│   │   └── SearchEntriesIntent.swift
│   └── Analytics/
│       └── InsightsEngine.swift
└── Resources/
    ├── Assets.xcassets
    ├── Colors.swift               # Design system
    └── Fonts.swift                # Typography

```
### Configuration iCloud

**Capabilities** → **iCloud** → Activer :
- ☑️ CloudKit
- ☑️ Background fetch (pour sync)

**Info.plist** :
```xml
<key>NSUbiquitousContainers</key>
<dict>
    <key>iCloud.com.yourname.mindful</key>
    <dict>
        <key>NSUbiquitousContainerIsDocumentScopePublic</key>
        <true/>
    </dict>
</dict>
```

## 📚 Ressources & Documentation

### Documentation Apple

- [SwiftData](https://developer.apple.com/documentation/swiftdata)
- [SwiftUI](https://developer.apple.com/documentation/swiftui)
- [App Intents](https://developer.apple.com/documentation/appintents)
- [NaturalLanguage](https://developer.apple.com/documentation/naturallanguage)
- [Swift Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency)

