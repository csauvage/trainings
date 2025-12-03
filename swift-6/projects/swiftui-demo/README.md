# Structure de l'Application SwiftUI Demo

## Vue d'ensemble
L'application de démonstration offre une présentation complète de tous les exemples SwiftUI du cours de formation, organisés par "Partie".

## Structure des dossiers

```
swiftui-demo/
├── app-demo/
│   ├── DemoScript.swift          # Modèles de données (DemoScript, Partie)
│   ├── DemoData.swift             # Les 36 démos organisées par partie
│   ├── DemoListView.swift         # Liste principale avec sections par partie
│   └── ScriptDetailView.swift     # Vue de détail pour chaque démo
│
├── partie1-lifecycle/             # 8 démos sur le cycle de vie
├── partie2-performance/           # 8 démos sur les performances
├── partie3-animations/            # 8 démos sur les animations
└── partie4-liquid-glass/          # 12 démos sur le liquid glass
```

## Fonctionnalités de l'application

### Vue de liste principale (DemoListView)
- Organisée par 4 parties comme en-têtes de section
- Chaque partie a un badge coloré (bleu, vert, violet, orange)
- Affiche les 36 démos avec :
  - Badge numéroté
  - Titre
  - Description

### Vue de détail (ScriptDetailView)
- En-tête avec numéro de démo et informations
- Aperçu de la démo en plein écran
- Contenu défilable

### Structure des données
- **Partie** : Regroupe les démos par section de formation
- **DemoScript** : Démo individuelle avec titre, description et vue

## Exécution de l'application

Le point d'entrée principal de l'application (`swiftui_demoApp.swift`) lance maintenant `DemoListView()` qui fournit la navigation vers les 36 démos.

## Détail des parties

### Partie 1 : Cycle de Vie SwiftUI (8 démos)
1. Identité et cycle de vie des vues
2. Compteur @State
3. Liaison parent-enfant
4. ViewModel @Observable
5. @Observable vs ObservableObject
6. Utilisation basique de l'environnement
7. Valeurs d'environnement personnalisées
8. Suivi des dépendances des vues

### Partie 2 : Patterns de Performance (8 démos)
1. ❌ Anti-Pattern : Body coûteux
2. ✅ Solution : Propriétés calculées
3. ViewModel avec @Observable
4. Comparaison LazyVStack
5. Identifiable et IDs stables
6. ❌ Anti-Pattern : Vue monolithique
7. ✅ Pattern : Sous-vues extraites
8. Carte personnalisée @ViewBuilder

### Partie 3 : Animations et Transitions (8 démos)
1. Bases des animations
2. Courbes d'animation
3. Implicite vs Explicite
4. Transitions de base
5. Transitions personnalisées
6. Effet de géométrie correspondante
7. Phase Animator (iOS 17+)
8. Keyframe Animator (iOS 17+)

### Partie 4 : Liquid Glass - iOS 26+ (12 démos)
1. Modificateur d'effet de verre
2. Conteneur d'effet de verre
3. Morphing de verre
4. Styles de boutons en verre
5. NavigationSplitView en verre
6. TabView en verre
7. Sheets en verre
8. Effet de verre UIKit
9. Bonnes pratiques de teinture
10. Accessibilité
11. Nettoyage de migration
12. Carte de verre personnalisée

## Total : 36 démos fonctionnelles

## Auteur

Clément SAUVAGE
