import SwiftUI
import FoundationModels
import Observation


@Observable
class UnstructuredTextViewModel {
    var prompt = ""
    var response = ""
    var isLoading = false
    var errorMessage: String?
    var modelAvailable = false
    var temperature: Double = 0.7

    // Manage lifecycle/cancellation
    private var currentTask: Task<Void, Never>?
    private var session: LanguageModelSession?

    init() {
        refreshAvailability()
        prepareSessionIfNeeded()
    }

    deinit {
        currentTask?.cancel()
    }

    func refreshAvailability() {
        let model = SystemLanguageModel.default
        modelAvailable = model.availability == .available
    }

    private func prepareSessionIfNeeded() {
        guard session == nil else { return }
        let model = SystemLanguageModel.default
        // If unavailable, keep session nil; generation will show a friendly error.
        guard model.availability == .available else { return }

        session = LanguageModelSession(
            model: model,
            instructions: { "You are a helpful assistant for students. Provide clear and concise answers." }
        )
    }

    func clear() {
        prompt = ""
        response = ""
        errorMessage = nil
    }

    func copyResponse() {
        #if canImport(UIKit)
        UIPasteboard.general.string = response
        #endif
    }

    func cancelGeneration() {
        currentTask?.cancel()
        isLoading = false
    }

    func generateText() {
        // Cancel any in-flight work before starting
        currentTask?.cancel()

        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Please enter a prompt"
            return
        }

        isLoading = true
        errorMessage = nil
        response = ""

        // Ensure availability and session are ready
        refreshAvailability()
        guard modelAvailable else {
            isLoading = false
            errorMessage = "Language model is not available. Enable Apple Intelligence in Settings."
            return
        }
        prepareSessionIfNeeded()

        // Launch the async work
        currentTask = Task { [weak self] in
            guard let self else { return }
            do {
                guard let session else {
                    self.errorMessage = "Unable to create a language model session."
                    self.isLoading = false
                    return
                }

                // Use the latest temperature value
                let result = try await session.respond(
                    to: trimmed,
                    options: GenerationOptions(temperature: temperature)
                )

                self.response = result.content
            } catch is CancellationError {
                // Silent cancellation
            } catch {
                self.errorMessage = "Error: \(error.localizedDescription)"
            }

            self.isLoading = false
        }
    }
}

struct UnstructuredTextGeneration: View {
    @State private var viewModel = UnstructuredTextViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SectionHeader("Unstructured Text Generation",
                              subtitle: "Basic text generation using Foundation Models with await")

                Divider()

                ModelStatusRow(
                    modelAvailable: viewModel.modelAvailable,
                    refreshAction: viewModel.refreshAvailability
                )

                TemperatureControlSection(viewModel: viewModel)

                PromptInputSectionUnstructured(viewModel: viewModel)

                if let error = viewModel.errorMessage {
                    ErrorBanner(message: error)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Error")
                        .accessibilityHint(error)
                }

                if !viewModel.response.isEmpty {
                    ResponseSectionUnstructured(
                        response: viewModel.response,
                        copyAction: viewModel.copyResponse
                    )
                }

                InfoBox(iconName: "info.circle.fill", tint: .blue, title: "How it works") {
                    VStack(alignment: .leading, spacing: 6) {
                        BulletPoint(text: "Uses SystemLanguageModel.default")
                        BulletPoint(text: "Checks model availability and caches a session")
                        BulletPoint(text: "Awaits response with async/await")
                        BulletPoint(text: "Returns unstructured text as String")
                        BulletPoint(text: "Supports cancellation and temperature control")
                        BulletPoint(text: "Runs on-device, private & offline")
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Text Generation")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.refreshAvailability()
        }
        .onDisappear {
            viewModel.cancelGeneration()
        }
    }
}

// MARK: - Extracted sections that are still screen-specific

private struct TemperatureControlSection: View {
    @Bindable var viewModel: UnstructuredTextViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Creativity")
                    .font(.headline)
                Spacer()
                Text(String(format: "Temperature: %.2f", viewModel.temperature))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Slider(value: $viewModel.temperature, in: 0.0...1.2, step: 0.05)
                .tint(.blue)
                .accessibilityLabel("Temperature")
                .accessibilityValue("\(viewModel.temperature)")
        }
    }
}

private struct PromptInputSectionUnstructured: View {
    @Bindable var viewModel: UnstructuredTextViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Question")
                .font(.headline)

            TextEditor(text: $viewModel.prompt)
                .frame(minHeight: 90, maxHeight: 160)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .disabled(viewModel.isLoading)
                .accessibilityLabel("Prompt input")

            HStack(spacing: 12) {
                Button {
                    viewModel.generateText()
                } label: {
                    if viewModel.isLoading {
                        HStack {
                            ProgressView()
                                .tint(.white)
                            Text("Generating...")
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        Text("Generate Response")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    viewModel.isLoading
                    || !viewModel.modelAvailable
                    || viewModel.prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                )

                if viewModel.isLoading {
                    Button {
                        viewModel.cancelGeneration()
                    } label: {
                        Image(systemName: "stop.fill")
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Cancel generation")
                } else if !viewModel.prompt.isEmpty || !viewModel.response.isEmpty {
                    Button {
                        viewModel.clear()
                    } label: {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Clear prompt and response")
                }
            }
        }
    }
}

private struct ResponseSectionUnstructured: View {
    let response: String
    let copyAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Response")
                    .font(.headline)
                Spacer()
                Button(action: copyAction) {
                    Image(systemName: "doc.on.doc")
                }
                .buttonStyle(.bordered)
                .accessibilityLabel("Copy response")
            }

            Text(response)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }
}

#Preview {
    NavigationStack {
        UnstructuredTextGeneration()
    }
}
