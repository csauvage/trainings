import SwiftUI
import FoundationModels
import Observation

@Observable
class StreamingTextViewModel {
    var prompt = ""
    var streamingResponse = ""
    var isStreaming = false
    var errorMessage: String?
    var modelAvailable = false
    var wordCount = 0
    var characterCount = 0

    init() {
        checkModelAvailability()
    }

    func checkModelAvailability() {
        let model = SystemLanguageModel.default
        modelAvailable = model.availability == .available
    }

    func generateStreamingText() async {
        guard !prompt.isEmpty else {
            errorMessage = "Please enter a prompt"
            return
        }

        isStreaming = true
        errorMessage = nil
        streamingResponse = ""
        wordCount = 0
        characterCount = 0

        do {
            let model = SystemLanguageModel.default

            guard model.availability == .available else {
                errorMessage = "Language model is not available. Enable Apple Intelligence in Settings."
                isStreaming = false
                return
            }

            let session = LanguageModelSession(
                model: model,
                instructions: { """
                You are an educational writing assistant for students.
                Provide detailed, well-structured responses.
                Use clear paragraphs and examples when appropriate.
                """ }
            )

            let stream = try await session.streamResponse(
                to: prompt,
                options: GenerationOptions(temperature: 0.7)
            )

            for try await partial in stream {
                streamingResponse = partial.content
                characterCount = partial.content.count
                wordCount = partial.content
                    .components(separatedBy: .whitespacesAndNewlines)
                    .filter { !$0.isEmpty }
                    .count
            }
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
        }

        isStreaming = false
    }

    func stopStreaming() {
        isStreaming = false
    }

    func clearResponse() {
        streamingResponse = ""
        wordCount = 0
        characterCount = 0
        errorMessage = nil
    }
}

struct StreamingTextGeneration: View {
    @State private var viewModel = StreamingTextViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                ModelStatusRow(modelAvailable: viewModel.modelAvailable)

                PromptInputSectionStreaming(viewModel: viewModel)

                if viewModel.isStreaming || !viewModel.streamingResponse.isEmpty {
                    StatisticsBar(
                        isStreaming: viewModel.isStreaming,
                        wordCount: viewModel.wordCount,
                        characterCount: viewModel.characterCount
                    )
                }

                if let error = viewModel.errorMessage {
                    ErrorBanner(message: error)
                }

                if !viewModel.streamingResponse.isEmpty {
                    LiveResponseSection(
                        response: viewModel.streamingResponse,
                        isStreaming: viewModel.isStreaming
                    )
                }

                InfoBox(iconName: "info.circle.fill", tint: .purple, title: "Streaming Benefits") {
                    VStack(alignment: .leading, spacing: 6) {
                        BulletPoint(text: "Real-time feedback: Users see progress immediately")
                        BulletPoint(text: "Better UX: No waiting for full response")
                        BulletPoint(text: "Perceived performance: Feels faster and more responsive")
                        BulletPoint(text: "Live updates: Process partial content as it arrives")
                        BulletPoint(text: "Perfect for ChatGPT-style interfaces")
                    }
                }

                CodeExampleBox(code: """
                let stream = try await session
                    .streamResponse(to: prompt)

                for try await partial in stream {
                    // Update UI with partial content
                    streamingResponse = partial.content
                }
                """)
            }
            .padding()
        }
        .navigationTitle("Streaming Generation")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Extracted Subviews specific to this screen

private struct PromptInputSectionStreaming: View {
    @Bindable var viewModel: StreamingTextViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Question")
                .font(.headline)

            TextField("Ask a detailed question...", text: $viewModel.prompt, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...6)
                .disabled(viewModel.isStreaming)

            HStack(spacing: 12) {
                Button {
                    Task {
                        await viewModel.generateStreamingText()
                    }
                } label: {
                    if viewModel.isStreaming {
                        HStack {
                            ProgressView()
                                .tint(.white)
                            Text("Streaming...")
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Start Streaming")
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isStreaming || !viewModel.modelAvailable)

                if !viewModel.streamingResponse.isEmpty {
                    Button {
                        viewModel.clearResponse()
                    } label: {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(.bordered)
                    .disabled(viewModel.isStreaming)
                }
            }
        }
    }
}

private struct StatisticsBar: View {
    let isStreaming: Bool
    let wordCount: Int
    let characterCount: Int

    var body: some View {
        HStack(spacing: 16) {
            StatisticView(
                icon: "doc.text.fill",
                label: "Words",
                value: "\(wordCount)"
            )

            Divider()
                .frame(height: 30)

            StatisticView(
                icon: "character",
                label: "Characters",
                value: "\(characterCount)"
            )

            Spacer()

            if isStreaming {
                HStack(spacing: 6) {
                    ProgressView()
                        .controlSize(.small)
                    Text("Streaming")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Complete")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

private struct LiveResponseSection: View {
    let response: String
    let isStreaming: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Live Response")
                    .font(.headline)

                Spacer()

                if isStreaming {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                        Text("LIVE")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                    }
                }
            }

            ScrollView {
                Text(response)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .frame(minHeight: 200, maxHeight: 400)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isStreaming ? Color.blue : Color(.systemGray4), lineWidth: isStreaming ? 2 : 1)
            )
            .cornerRadius(12)
            .animation(.easeInOut(duration: 0.3), value: isStreaming)
        }
    }
}

// MARK: - Supporting Views

struct StatisticView: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .font(.caption)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
        }
    }
}

#Preview {
    NavigationStack {
        StreamingTextGeneration()
    }
}
