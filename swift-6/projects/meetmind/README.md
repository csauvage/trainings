# MeetMind

> Assistant de réunions intelligent avec Apple Intelligence

Une application professionnelle pour iOS qui transforme vos réunions en actions concrètes. Prise de notes intelligente, extraction automatique d'action items, et intégration native avec Calendar.

![iOS](https://img.shields.io/badge/iOS-26.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## ✨ Features

### Core Features
- 📝 **Notes structurées** : Prise de notes pendant la réunion avec auto-save
- ✅ **Action items** : Extraction et suivi des tâches avec assignation
- 👥 **Participants** : Gestion des participants avec avatars et rôles
- 📅 **Calendar sync** : Synchronisation bidirectionnelle avec iOS Calendar
- ☁️ **iCloud sync** : Vos meetings sur tous vos appareils
- 🔒 **Privacy-first** : Données chiffrées, confidentialité garantie

### Apple Intelligence (iOS 26+)
- 🤖 **Action items extraction** : Détection automatique depuis les notes
- 🎯 **Meeting tone analysis** : Analyse du ton (productif, neutre, tendu)
- ✨ **Writing Tools** : Amélioration, résumé natifs
- 🗣️ **App Intents** : "Hey Siri, create a standup meeting"
- 📊 **Smart insights** : Métriques et recommendations

### Interface Liquid Glass
- 🎨 Design professionnel avec effets glass/blur
- ✨ Animations fluides et naturelles
- 🌓 Support Dark Mode complet
- 📱 Optimisé iPad avec Split View

### Productivity Features
- 📤 **Multi-channel sharing** : Email, Slack, Teams
- 🔁 **Recurring meetings** : Support des réunions récurrentes
- ⏱️ **Time tracking** : Temps passé en réunion par type/participant
- 📈 **Analytics** : Dashboard avec métriques de productivité
- 🎯 **Focus Filters** : Filtrage selon mode Focus iOS

## 🏗️ Architecture

### Stack Technique

```
SwiftUI + Swift 6
├── SwiftData (persistence)
├── Actors (thread-safety)
├── async/await (concurrency)
├── EventKit (Calendar integration)
├── NaturalLanguage (AI on-device)
├── App Intents (Siri integration)
└── Swift Charts (analytics)
```

### Architecture en Couches

```
MeetMindApp
├── Data Layer (SwiftData)
│   ├── @Model Meeting
│   ├── @Model ActionItem
│   ├── @Model Participant
│   └── ModelContainer
├── Domain Layer (Actors)
│   ├── MeetingRepository
│   ├── CalendarSyncManager
│   ├── ShareService
│   └── ActionItemExtractor
├── Presentation Layer (SwiftUI)
│   ├── Views (Timeline, Editor, Detail, Stats)
│   ├── Components (GlassCard, TypeSelector)
│   └── ViewModels (@Observable)
└── Intelligence Layer
    ├── App Intents (Siri)
    ├── EventKit (Calendar sync)
    ├── NaturalLanguage (action items, tone)
    └── Webhooks (Slack, Teams)
```

## 📋 Prérequis

- macOS Sequioa+
- Xcode 26.0+
- iOS 18.0+ (ideal 26.0+ pour Writing Tools)
- Swift 6.0
- Compte développeur Apple

## 🚀 Installation

1. **Cloner le repository**
   ```bash
   git clone https://github.com/csauvage/trainings.git
   cd meetmind
   ```

2. **Créer le projet**
   
3. **Configurer le signing**

4. **Configurer Calendar permissions**
   ```xml
   <!-- Info.plist -->
   <key>NSCalendarsUsageDescription</key>
   <string>MeetMind needs access to sync your meetings</string>
   ```

5. **Build & Run**
   - Cmd+R ou cliquer sur le bouton Play
   - Accepter les permissions Calendar

## 🗂️ Structure du Projet

```
MeetMind/
├── App/
│   ├── MeetMindApp.swift          # Entry point
│   └── DataController.swift       # SwiftData config
├── Models/
│   ├── Meeting.swift              # @Model principal
│   ├── ActionItem.swift           # @Model tâches
│   ├── Participant.swift          # @Model personnes
│   ├── MeetingType.swift          # Enum types
│   ├── Priority.swift             # Enum priorités
│   └── RecurrenceRule.swift       # Struct récurrence
├── Services/
│   ├── MeetingRepository.swift    # Actor CRUD
│   ├── CalendarSyncManager.swift  # Actor EventKit
│   ├── ShareService.swift         # Actor multi-canal
│   ├── ActionItemExtractor.swift  # Actor NLP
│   └── WebhookService.swift       # Actor Slack/Teams
├── Views/
│   ├── TimelineView.swift         # Liste des meetings
│   ├── EditorView.swift           # Création/édition
│   ├── DetailView.swift           # Lecture meeting
│   └── StatsView.swift            # Dashboard analytics
├── Components/
│   ├── GlassCard.swift            # Base component
│   ├── MeetingTypeSelector.swift  # Sélecteur type
│   ├── ActionItemRow.swift        # Row avec checkbox
│   ├── ParticipantPill.swift      # Pills participants
│   └── DurationPicker.swift       # Picker durée
├── ViewModels/
│   ├── TimelineViewModel.swift
│   ├── EditorViewModel.swift
│   └── StatsViewModel.swift
├── Intelligence/
│   ├── AppIntents/
│   │   ├── CreateMeetingIntent.swift
│   │   ├── AddActionItemIntent.swift
│   │   └── ShowUpcomingMeetingsIntent.swift
│   └── Analytics/
│       └── ProductivityEngine.swift
└── Resources/
    ├── Assets.xcassets
    ├── Colors.swift               # Design system
    └── Fonts.swift                # Typography
