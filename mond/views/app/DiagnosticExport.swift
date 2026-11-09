// Shared, observable diagnostic export. Keep this control available in every
// diagnostic screen instead of shipping a silent pasteboard-only action.

import SwiftUI
import UniformTypeIdentifiers

private struct DiagnosticTextDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.plainText] }

    var contents: String

    init(_ contents: String) {
        self.contents = contents
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let decoded = String(data: data, encoding: .utf8) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        contents = decoded
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: Data(contents.utf8))
    }
}

struct DiagnosticExportControls: View {
    let report: String
    let filename: String

    @State private var feedback: String?
    @State private var showFileExporter = false

    private var hasReport: Bool { !report.isEmpty }

    var body: some View {
        Button {
            guard hasReport else {
                feedback = "No diagnostic text to copy. Run the diagnostic first."
                return
            }

            // Writing to the pasteboard is not evidence that the action worked.
            // Check the exact content immediately and give visible feedback.
            UIPasteboard.general.string = report
            if UIPasteboard.general.string == report {
                feedback = "Copied \(report.count) characters. Paste into ChatGPT or Notes."
            } else {
                feedback = "Clipboard copy could not be verified. Use Share or Save as Text instead."
            }
        } label: {
            Label("Copy Diagnostic", systemImage: "doc.on.doc")
        }
        .disabled(!hasReport)

        ShareLink(item: report) {
            Label("Share Diagnostic", systemImage: "square.and.arrow.up")
        }
        .disabled(!hasReport)

        Button {
            showFileExporter = true
        } label: {
            Label("Save Diagnostic as Text", systemImage: "square.and.arrow.down")
        }
        .disabled(!hasReport)
        .fileExporter(
            isPresented: $showFileExporter,
            document: DiagnosticTextDocument(report),
            contentType: .plainText,
            defaultFilename: filename
        ) { result in
            switch result {
            case .success:
                feedback = "Diagnostic text saved. You can attach the file to ChatGPT."
            case .failure(let error):
                feedback = "Could not save diagnostic: \(error.localizedDescription)"
            }
        }

        if let feedback {
            Text(feedback)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .accessibilityLabel(feedback)
        }
    }
}
