import SwiftUI

class DemoData {
    static let shared = DemoData()

    let parties: [Partie]

    private init() {
        // Partie 1: Lifecycle
        let partie1Scripts = [
            DemoScript(
                number: 1,
                title: "View Identity & Lifecycle",
                description: "Understanding view identity with .id() modifier",
                view: ViewIdentityLifecycle()
            ),
            DemoScript(
                number: 2,
                title: "@State Counter",
                description: "Basic @State property wrapper usage",
                view: StateCounterView()
            ),
            DemoScript(
                number: 3,
                title: "Parent-Child Binding",
                description: "@Binding for communication between views",
                view: BindingParentView()
            ),
            DemoScript(
                number: 4,
                title: "@Observable ViewModel",
                description: "iOS 17+ @Observable macro usage",
                view: ObservableViewModelDemo()
            ),
            DemoScript(
                number: 5,
                title: "@Observable vs ObservableObject",
                description: "Comparison of old and new observation patterns",
                view: ObservableComparison()
            ),
            DemoScript(
                number: 6,
                title: "Environment Basic Usage",
                description: "Reading environment values like colorScheme",
                view: EnvironmentBasicUsage()
            ),
            DemoScript(
                number: 7,
                title: "Custom Environment Values",
                description: "Creating and using custom environment keys",
                view: CustomEnvironmentValues()
            ),
            DemoScript(
                number: 8,
                title: "View Dependencies Tracking",
                description: "Understanding how SwiftUI tracks dependencies",
                view: ViewDependenciesTracking(
                    user: User(
                        name: "John Doe",
                        bio: "SwiftUI developer passionate about building great UX"
                    )
                )
            )
        ]

        // Partie 2: Performance
        let partie2Scripts = [
            DemoScript(
                number: 1,
                title: "❌ Anti-Pattern: Expensive Body",
                description: "Bad practice: heavy computation in body",
                view: AntipatternExpensiveBody()
            ),
            DemoScript(
                number: 2,
                title: "✅ Solution: Computed Properties",
                description: "Good practice: use computed properties",
                view: SolutionComputedProperties()
            ),
            DemoScript(
                number: 3,
                title: "ViewModel with @Observable",
                description: "Using ViewModels for complex logic",
                view: ViewModelObservablePattern()
            ),
            DemoScript(
                number: 4,
                title: "LazyVStack Comparison",
                description: "LazyVStack vs VStack performance",
                view: LazyVStackComparison()
            ),
            DemoScript(
                number: 5,
                title: "Identifiable & Stable IDs",
                description: "Importance of stable identifiers",
                view: IdentifiableStableIDs()
            ),
            DemoScript(
                number: 6,
                title: "❌ Anti-Pattern: Monolithic View",
                description: "Bad practice: everything in one view",
                view: AntipatternMonolithicView()
            ),
            DemoScript(
                number: 7,
                title: "✅ Pattern: Extracted Subviews",
                description: "Good practice: extract subviews",
                view: PatternExtractedSubviews()
            ),
            DemoScript(
                number: 8,
                title: "@ViewBuilder Custom Card",
                description: "Creating reusable container views",
                view: ViewBuilderCustomCard()
            )
        ]

        // Partie 3: Animations
        let partie3Scripts = [
            DemoScript(
                number: 1,
                title: "Animation Basics",
                description: "Basic spring animations",
                view: AnimationBasics()
            ),
            DemoScript(
                number: 2,
                title: "Animation Curves",
                description: "Different animation timing curves",
                view: AnimationCurves()
            ),
            DemoScript(
                number: 3,
                title: "Implicit vs Explicit",
                description: "Two ways to animate in SwiftUI",
                view: ImplicitExplicitAnimations()
            ),
            DemoScript(
                number: 4,
                title: "Transitions Basic",
                description: "Adding transitions to appearing/disappearing views",
                view: TransitionsBasic()
            ),
            DemoScript(
                number: 5,
                title: "Custom Transitions",
                description: "Creating custom transition effects",
                view: TransitionsCustom()
            ),
            DemoScript(
                number: 6,
                title: "Matched Geometry Effect",
                description: "Hero animations between views",
                view: MatchedGeometryEffectDemo()
            ),
            DemoScript(
                number: 7,
                title: "Phase Animator (iOS 17+)",
                description: "Phase-based animations",
                view: PhaseAnimatorDemo()
            ),
            DemoScript(
                number: 8,
                title: "Keyframe Animator (iOS 17+)",
                description: "Complex keyframe animations",
                view: KeyframeAnimatorDemo()
            )
        ]

        // Partie 4: Liquid Glass (iOS 26+)
        let partie4Scripts = [
            DemoScript(
                number: 1,
                title: "Glass Effect Modifier",
                description: "Basic glassEffect() usage (iOS 26+)",
                view: GlassEffectModifier()
            ),
            DemoScript(
                number: 2,
                title: "Glass Effect Container",
                description: "GlassEffectContainer for groups",
                view: GlassEffectContainerDemo()
            ),
            DemoScript(
                number: 3,
                title: "Glass Morphing",
                description: "Morphing transitions between glass views",
                view: GlassMorphingDemo()
            ),
            DemoScript(
                number: 4,
                title: "Button Styles Glass",
                description: ".glass and .glassProminent button styles",
                view: ButtonStylesGlass()
            ),
            DemoScript(
                number: 5,
                title: "NavigationSplitView Glass",
                description: "Glass effects in navigation",
                view: NavigationSplitViewGlass()
            ),
            DemoScript(
                number: 6,
                title: "TabView Glass",
                description: "Glass effects in tab bars",
                view: TabViewGlass()
            ),
            DemoScript(
                number: 7,
                title: "Sheets Glass",
                description: "Automatic glass in sheets",
                view: SheetsGlass()
            ),
            DemoScript(
                number: 8,
                title: "UIKit Glass Effect",
                description: "UIGlassEffect in UIKit (iOS 26+)",
                view: UIKitGlassEffectDemo()
            ),
            DemoScript(
                number: 9,
                title: "Tinting Best Practices",
                description: "Good vs bad tinting patterns",
                view: TintingBestPractices()
            ),
            DemoScript(
                number: 10,
                title: "Accessibility",
                description: "Reduce transparency support",
                view: AccessibilityReduceTransparency()
            ),
            DemoScript(
                number: 11,
                title: "Migration Cleanup",
                description: "Removing obsolete modifiers",
                view: MigrationCleanup()
            ),
            DemoScript(
                number: 12,
                title: "Custom Glass Card",
                description: "Building custom glass components",
                view: CustomGlassCardDemo()
            )
        ]

        self.parties = [
            Partie(number: 1, title: "Cycle de Vie SwiftUI", scripts: partie1Scripts),
            Partie(number: 2, title: "Patterns de Performance", scripts: partie2Scripts),
            Partie(number: 3, title: "Animations & Transitions", scripts: partie3Scripts),
            Partie(number: 4, title: "Liquid Glass (iOS 26+)", scripts: partie4Scripts)
        ]
    }
}
