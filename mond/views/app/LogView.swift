//
//  LogView.swift
//  mond
//
//  Created by ruter on 28.07.26.
//

import SwiftUI
import PartyUI

struct LogView: View {
    @State private var log = ""

    var body: some View {
        GeometryReader { _ in
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    Text(log)
                        .font(.system(size: 10, design: .monospaced))
                        .multilineTextAlignment(.leading)
                        .textSelection(.enabled)
                        .padding(.top)

                    if !log.isEmpty {
                        DiagnosticExportControls(
                            report: log,
                            filename: "mond-logs"
                        )
                        .padding(.vertical)
                    }

                    Spacer()
                        .id(0)
                }
                .onAppear {
                    pipe.fileHandleForReading.readabilityHandler = { fh in
                        let data = fh.availableData

                        if data.isEmpty {
                            fh.readabilityHandler = nil
                            sema.signal()
                            return
                        }

                        guard let text = String(data: data, encoding: .utf8) else {
                            return
                        }

                        DispatchQueue.main.async {
                            log.append(text)
                            proxy.scrollTo(0)
                        }
                    }
                }
            }
        }
    }
}

