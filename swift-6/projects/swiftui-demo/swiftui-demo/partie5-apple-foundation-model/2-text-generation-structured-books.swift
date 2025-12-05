import SwiftUI
import FoundationModels
import Observation

// MARK: - Structured Models with @Generable

@Generable
struct Book: Equatable {
    let title: String
    let author: String
    let genre: String
    let yearPublished: Int
    let summary: String
    let rating: Double
}

@Generable
struct BookRecommendations: Equatable {
    let recommendations: [Book]
    let totalCount: Int
}

// MARK: - ViewModel

@Observable
class StructuredBooksViewModel {
    var topic = ""
    var books: [Book] = []
    var isLoading = false
    var errorMessage: String?
    var modelAvailable = false

    init() {
        checkModelAvailability()
    }

    func checkModelAvailability() {
        let model = SystemLanguageModel.default
        modelAvailable = model.availability == .available
    }

    func generateBookRecommendations() async {
        guard !topic.isEmpty else {
            errorMessage = "Please enter a topic"
            return
        }

        isLoading = true
        errorMessage = nil
        books = []

        do {
            let model = SystemLanguageModel.default

            guard model.availability == .available else {
                errorMessage = "Language model is not available. Enable Apple Intelligence in Settings."
                isLoading = false
                return
            }

            let session = LanguageModelSession(
                model: model,
                instructions: { """
                You are a knowledgeable book recommender.
                Generate book recommendations based on the user's topic.
                Provide accurate information with realistic ratings (1.0-5.0).
                """ }
            )

            let prompt = """
            Recommend 3 excellent books about \(topic).
            For each book, provide:
            - Title
            - Author
            - Genre
            - Year published
            - Brief summary (2-3 sentences)
            - Rating out of 5.0

            Return the data as BookRecommendations with an array of Book objects.
            """

            let result = try await session.respond(
                to: prompt,
                generating: BookRecommendations.self,
                options: GenerationOptions(temperature: 0.8)
            )

            books = result.content.recommendations
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
        }

        isLoading = false
    }
}

// MARK: - View

struct StructuredBooksGeneration: View {
    @State private var viewModel = StructuredBooksViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                ModelStatusRow(modelAvailable: viewModel.modelAvailable)

                // Input Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Book Topic")
                        .font(.headline)

                    TextField("e.g., Swift programming, Science Fiction...", text: $viewModel.topic)
                        .textFieldStyle(.roundedBorder)
                        .disabled(viewModel.isLoading)

                    Button {
                        Task {
                            await viewModel.generateBookRecommendations()
                        }
                    } label: {
                        if viewModel.isLoading {
                            HStack {
                                ProgressView()
                                    .tint(.white)
                                Text("Finding Books...")
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            Text("Get Book Recommendations")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(viewModel.isLoading || !viewModel.modelAvailable)
                }

                // Error Display
                if let error = viewModel.errorMessage {
                    ErrorBanner(message: error)
                }

                // Books Display
                if !viewModel.books.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recommended Books (\(viewModel.books.count))")
                            .font(.headline)

                        ForEach(Array(viewModel.books.enumerated()), id: \.offset) { index, book in
                            BookCardView(book: book, index: index + 1)
                        }
                    }
                }

                // Info Box
                InfoBox(iconName: "info.circle.fill", tint: .blue, title: "@Generable Benefits") {
                    VStack(alignment: .leading, spacing: 6) {
                        BulletPoint(text: "Type-safe: Get Book structs, not strings")
                        BulletPoint(text: "No manual JSON parsing required")
                        BulletPoint(text: "Compile-time safety with Swift types")
                        BulletPoint(text: "Automatic validation and conversion")
                        BulletPoint(text: "Works with complex nested structures")
                    }
                }

                // Code Example
                CodeExampleBox(code: """
                @Generable
                struct Book: Equatable {
                    let title: String
                    let author: String
                    let genre: String
                    let yearPublished: Int
                    let summary: String
                    let rating: Double
                }

                let result = try await session.respond(
                    to: prompt,
                    generating: BookRecommendations.self
                )
                """)
            }
            .padding()
        }
        .navigationTitle("Structured Generation")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Supporting Views

struct BookCardView: View {
    let book: Book
    let index: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with number badge
            HStack {
                Text("\(index)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 24, height: 24)
                    .background(Color.accentColor)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(book.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text("by \(book.author)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // Rating
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.1f", book.rating))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }

            // Book details
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label(book.genre, systemImage: "tag.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Label("\(book.yearPublished)", systemImage: "calendar")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text(book.summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        StructuredBooksGeneration()
    }
}
