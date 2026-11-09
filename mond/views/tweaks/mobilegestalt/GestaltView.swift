//
//  GestaltView.swift
//  mond
//
//  Created by ruter on 11.08.26.
//

import SwiftUI
import PartyUI
import UniformTypeIdentifiers

private struct GestaltBackupDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.propertyList] }

    var data: Data

    init(data: Data) { self.data = data }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.data = data
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}

private extension mg_tweak.InfoType {
    var party_info_type: ToggleInfoType {
        switch self {
            case .info: return .info
            case .warning, .error: return .warning
        }
    }
}

struct TweakToggle: View {
    let title: String

    var body: some View {
        if let tweak = tweak(title) {
            PlainToggle(
                text: tweak.title,
                infoType: tweak.info_t?.party_info_type ?? .none,
                infoMessage: tweak.info_msg ?? "",
                minSupportedVersion: tweak.minv ?? 0.0,
                isOn: mg_tweak_binding(tweak)
            )
        }
    }
}

fileprivate func mg_ui_state() -> (String, Bool, String, String) {
    (selected_st, enable_device_name, mg_device_name, product_type)
}

fileprivate func mg_apply_ui_state(_ selected: String, _ enableName: Bool, _ deviceName: String, _ product: String) {
    selected_st = selected
    enable_device_name = enableName
    mg_device_name = deviceName
    product_type = product
}

struct GestaltView: View {
    @EnvironmentObject var state: AppState

    @State private var show_settings: Bool = false

    @State private var selected_st: String = "og"
    @State private var enable_device_name: Bool = false
    @State private var mg_device_name: String = ""
    @State private var product_type: String = ""
    @State private var tweak_version: Int = 0
    @State private var checkingReadOnlyAccess = false
    @State private var readOnlyReport: [String] = []
    @State private var confirmExperimentalIPadOS = false
    @State private var showOriginalBackupExporter = false
    @State private var originalBackupDocument: GestaltBackupDocument?
    @State private var originalBackupFeedback: String?
    @State private var showWorkingIPadBackupExporter = false
    @State private var workingIPadBackupDocument: GestaltBackupDocument?
    @State private var hybridStatus = "Checking current layout..."
    @State private var hybridFeedback: String?
    @State private var confirmHybridTest = false
    @State private var confirmHybridRestore = false
    @State private var windowingReport: [String] = []
    @State private var showWindowingBackupExporter = false
    @State private var windowingBackupDocument: GestaltBackupDocument?
    @State private var confirmWindowingTest = false
    @State private var confirmWindowingRestore = false

    private var originalDeviceLabel: String {
        switch machine_name() {
        case "iPhone18,3": return "iPhone 17"
        case "iPhone18,1": return "iPhone 17 Pro"
        case "iPhone18,2": return "iPhone 17 Pro Max"
        case "iPhone18,4": return "iPhone Air"
        default: return "This device"
        }
    }

    private func applySelectedTweaks() {
        mg_apply_ui_state(selected_st, enable_device_name, mg_device_name, product_type)
        mg_apply()
        tweak_version += 1
        hybridStatus = mg_hybrid_status()
    }

    private func runHybridOperation(_ operation: () throws -> String) {
        do {
            let result = try operation()
            hybridFeedback = result
            Alertinator.shared.alert(title: "Hybrid iPadOS experiment", body: result)
        } catch {
            hybridFeedback = "Failed: \(error.localizedDescription)"
            Alertinator.shared.alert(title: "Hybrid experiment not applied", body: "\(error.localizedDescription) Do not restart if an on-disk verification failed. Check the diagnostics.")
        }
        hybridStatus = mg_hybrid_status()
        tweak_version += 1
    }

    var body: some View {
        NavigationStack {
            List {
                if !is_valid || is_empty {
                    Section {
                        if is_empty {
                            PlainAlert(title: "Do not reboot!", icon: "exclamationmark.triangle.fill", text: "Your MobileGestalt.plist seems to be empty.", color: Color.yellow)
                        }

                        if !is_valid {
                            PlainAlert(title: "Do not reboot!", icon: "exclamationmark.triangle.fill", text: "Your MobileGestalt.plist seems to be invalid.", color: Color.yellow)
                        }
                    } header: {
                        Label("Warning", systemImage: "exclamationmark.triangle")
                    } footer: {
                        Text("Rebooting now might cause a bootloop. Try pressing 'Revert Tweaks'. If the warnings dont go away after that, you're fucked.")
                    }
                }

                Section {
                    Button {
                        checkingReadOnlyAccess = true
                        DispatchQueue.global(qos: .userInitiated).async {
                            let report = mg_read_only_report()
                            DispatchQueue.main.async {
                                readOnlyReport = report
                                checkingReadOnlyAccess = false
                            }
                        }
                    } label: {
                        HStack {
                            Text("Check MobileGestalt Access")
                            Spacer()
                            if checkingReadOnlyAccess { ProgressView() }
                        }
                    }
                    .disabled(checkingReadOnlyAccess)

                    if !readOnlyReport.isEmpty {
                        ForEach(readOnlyReport, id: \.self) { line in
                            Text(line)
                                .font(.footnote)
                                .textSelection(.enabled)
                        }

                        DiagnosticExportControls(
                            report: readOnlyReport.joined(separator: "\n"),
                            filename: "mond-mobilegestalt-diagnostic"
                        )
                    }
                } header: {
                    Label("Read-Only Diagnostic", systemImage: "checkmark.shield")
                } footer: {
                    Text("Reads the current cache and checks its structure. Does not modify MobileGestalt, grant write access, or guarantee that tweaks can be safely applied.")
                }

                Section {
                    Button {
                        do {
                            let url = URL(fileURLWithPath: AppPaths.backups).appendingPathComponent("SavedGestalt.plist")
                            let original = try Data(contentsOf: url)
                            _ = try PropertyListSerialization.propertyList(from: original, format: nil)
                            originalBackupDocument = GestaltBackupDocument(data: original)
                            showOriginalBackupExporter = true
                            originalBackupFeedback = nil
                        } catch {
                            originalBackupFeedback = "Cannot export saved original: \(error.localizedDescription)"
                        }
                    } label: {
                        Label("Export Original MobileGestalt (.plist)", systemImage: "square.and.arrow.up.on.square")
                    }
                    .fileExporter(
                        isPresented: $showOriginalBackupExporter,
                        document: originalBackupDocument,
                        contentType: .propertyList,
                        defaultFilename: "Original-MobileGestalt"
                    ) { result in
                        switch result {
                        case .success:
                            originalBackupFeedback = "Original MobileGestalt exported. Keep this file private and store a copy outside the iPhone."
                        case .failure(let error):
                            originalBackupFeedback = "Export failed: \(error.localizedDescription)"
                        }
                    }
                    if let originalBackupFeedback {
                        Text(originalBackupFeedback)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Label("iPadOS Recovery Preparation", systemImage: "externaldrive")
                } footer: {
                    Text("Export the original before attempting iPadOS Mode. A .plist backup alone cannot guarantee recovery from an iOS boot loop; make a separate computer/device backup too. Never share the original publicly because it may contain device information.")
                }

                if machine_name() == "iPhone18,3" && UIDevice.current.systemVersion == "27.0.1" {
                    Section {
                        Text(hybridStatus)
                            .font(.footnote)
                            .textSelection(.enabled)

                        Button {
                            runHybridOperation { try mg_hybrid_capture_working_snapshot() }
                        } label: {
                            Label("Save Current Working iPadOS Layout", systemImage: "externaldrive")
                        }

                        Button {
                            do {
                                let snapshot = try mg_hybrid_working_snapshot()
                                workingIPadBackupDocument = GestaltBackupDocument(data: snapshot)
                                showWorkingIPadBackupExporter = true
                            } catch {
                                hybridFeedback = "Cannot export working snapshot: \(error.localizedDescription)"
                            }
                        } label: {
                            Label("Export Working Layout to Files", systemImage: "square.and.arrow.up")
                        }
                        .fileExporter(
                            isPresented: $showWorkingIPadBackupExporter,
                            document: workingIPadBackupDocument,
                            contentType: .propertyList,
                            defaultFilename: "Working-iPadOS-Before-Hybrid"
                        ) { result in
                            switch result {
                            case .success:
                                hybridFeedback = "Working iPadOS layout exported. Keep the file private and outside this app."
                            case .failure(let error):
                                hybridFeedback = "Working snapshot export failed: \(error.localizedDescription)"
                            }
                        }

                        Button("Test Hybrid: iPhone Layout + iPad Flags") {
                            confirmHybridTest = true
                        }
                        .confirmationDialog(
                            "Experimental hybrid layout",
                            isPresented: $confirmHybridTest,
                            titleVisibility: .visible
                        ) {
                            Button("Write Hybrid Test", role: .destructive) {
                                runHybridOperation { try mg_hybrid_apply_test() }
                            }
                        } message: {
                            Text("This writes DeviceClassNumber=1 but keeps all five iPadOS flags. Windowed apps may disappear, the UI may become unstable, and the device could bootloop. Capture and export the working iPadOS file and keep a computer backup first. This is NOT a verified layout fix.")
                        }

                        Button("Restore Working iPadOS Layout") {
                            confirmHybridRestore = true
                        }
                        .confirmationDialog(
                            "Restore previous iPadOS layout",
                            isPresented: $confirmHybridRestore,
                            titleVisibility: .visible
                        ) {
                            Button("Restore Exact Snapshot", role: .destructive) {
                                runHybridOperation { try mg_hybrid_restore_working() }
                            }
                        } message: {
                            Text("Restore the exact class-3, five-flag MobileGestalt saved before the hybrid experiment. Any MobileGestalt changes made after the snapshot will be lost. This does not guarantee recovery from a bootloop.")
                        }

                        if let hybridFeedback {
                            Text(hybridFeedback)
                                .font(.footnote)
                                .textSelection(.enabled)
                        }
                    } header: {
                        Label("Hybrid Layout Experiment", systemImage: "rectangle.on.rectangle")
                    } footer: {
                        Text("Test A only: changes the on-disk device class while preserving all five flags. Save and export the current working iPadOS layout first. After a successful read-back, respring or reboot only if you accept the bootloop risk and have a separate recoverable backup.")
                    }

                    Section {
                        Button {
                            windowingReport = mg_windowing_prefs_report()
                        } label: {
                            Label("Check SpringBoard Windowing Preferences", systemImage: "doc.text.magnifyingglass")
                        }

                        if !windowingReport.isEmpty {
                            ForEach(windowingReport, id: \.self) { line in
                                Text(line)
                                    .font(.footnote)
                                    .textSelection(.enabled)
                            }
                            DiagnosticExportControls(
                                report: windowingReport.joined(separator: "\n"),
                                filename: "mond-springboard-windowing-diagnostic"
                            )
                        }

                        Button {
                            runHybridOperation { try mg_windowing_capture_snapshots() }
                        } label: {
                            Label("Save Both Working System Snapshots", systemImage: "externaldrive.badge.plus")
                        }

                        Button {
                            do {
                                let snapshot = try mg_windowing_prefs_snapshot()
                                windowingBackupDocument = GestaltBackupDocument(data: snapshot)
                                showWindowingBackupExporter = true
                            } catch {
                                hybridFeedback = "Cannot export SpringBoard snapshot: \(error.localizedDescription)"
                            }
                        } label: {
                            Label("Export SpringBoard Snapshot to Files", systemImage: "square.and.arrow.up")
                        }
                        .fileExporter(
                            isPresented: $showWindowingBackupExporter,
                            document: windowingBackupDocument,
                            contentType: .propertyList,
                            defaultFilename: "SpringBoard-Preferences-Before-Hybrid"
                        ) { result in
                            switch result {
                            case .success:
                                hybridFeedback = "SpringBoard snapshot exported. Also export the working iPadOS layout in the section above."
                            case .failure(let error):
                                hybridFeedback = "SpringBoard export failed: \(error.localizedDescription)"
                            }
                        }

                        Button("Test B: iPhone Layout + SpringBoard Windowing") {
                            confirmWindowingTest = true
                        }
                        .confirmationDialog(
                            "Unverified SpringBoard windowing experiment",
                            isPresented: $confirmWindowingTest,
                            titleVisibility: .visible
                        ) {
                            Button("Write Three Prefs and Hybrid Class", role: .destructive) {
                                runHybridOperation { try mg_windowing_apply_test() }
                                windowingReport = mg_windowing_prefs_report()
                            }
                        } message: {
                            Text("This saves both exact backups, writes three SpringBoard windowing keys, and sets iPhone class 1 while retaining all five iPad flags. This combination has never been verified on an iPhone. A respring or reboot can make the device unusable. Export BOTH snapshots and keep a separate computer backup first. No automatic restart occurs.")
                        }

                        Button("Restore Both Working System Files") {
                            confirmWindowingRestore = true
                        }
                        .confirmationDialog(
                            "Restore known-working iPadOS configuration",
                            isPresented: $confirmWindowingRestore,
                            titleVisibility: .visible
                        ) {
                            Button("Restore Class 3 and SpringBoard Keys", role: .destructive) {
                                runHybridOperation { try mg_windowing_restore_both() }
                                windowingReport = mg_windowing_prefs_report()
                            }
                        } message: {
                            Text("Restore the exact saved MobileGestalt class-3 layout and return only the three SpringBoard keys to their original values. Other SpringBoard preferences are preserved. This cannot guarantee recovery from a boot loop.")
                        }

                        Button("Restore SpringBoard Keys Only") {
                            runHybridOperation { try mg_windowing_restore_prefs_only() }
                            windowingReport = mg_windowing_prefs_report()
                        }
                    } header: {
                        Label("Hybrid B: SpringBoard Windowing", systemImage: "macwindow.on.rectangle")
                    } footer: {
                        Text("Experimental and unverified: these keys exist in iOS 27.0.1, but were only shown controlling windowing on an iPad simulator. File read-back does not prove SpringBoard will honor the values. Preference caching may overwrite them. This test never automatically resprings or reboots. The working class-3 main release is unchanged.")
                    }
                }

                Section {
                    Button {
                        if tweak("Enable iPadOS Mode")?.is_on(in: mg_dict_now) == true {
                            confirmExperimentalIPadOS = true
                        } else {
                            applySelectedTweaks()
                        }
                    } label: {
                        Text("Apply Tweaks")
                    }

                    Button {
                        mg_revert()
                        tweak_version += 1
                        hybridStatus = mg_hybrid_status()
                    } label: {
                        Text("Revert Tweaks")
                    }
                    
                    Button {
                        state.respring()
                    } label: {
                        Text("Respring")
                    }
                } footer: {
                    Text("**WARNING:** These tweaks have the capability to break features on your device or softbrick it if misused!")
                }

                Section {
                    Picker(selection: $selected_st) {
                        Text("Original: \(originalDeviceLabel) (\(og_st))").tag("og")

                        if is_device_good() {
                            Text("Disable Dynamic Island").tag("no_dynamic_island")
                        }

                        Text("iPhone 14 Pro").tag("14p")
                        Text("iPhone 14 Pro Max").tag("14pm")
                        Text("iPhone 15 Pro Max").tag("15pm")

                        if doubleSystemVersion() >= 18.0 {
                            Text("iPhone 16 Pro").tag("16p")
                            Text("iPhone 16 Pro Max").tag("16pm")
                        }

                        if doubleSystemVersion() >= 26.0 {
                            Text("iPhone Air").tag("air")
                        }

                        if has_home_button() {
                            Text("iPhone X Gestures").tag("x")
                        }
                    } label: {
                        HStack {
                            Text("Subtype")
                            Spacer()
                        }
                    }

                    Toggle("Custom Device Name", isOn: $enable_device_name)

                    if enable_device_name {
                        TextField("Device Name", text: $mg_device_name)
                    }
                } header: {
                    Label("Device Artwork", systemImage: "paintbrush.pointed")
                }

                Section {
                    TweakToggle(title: "Enable Dynamic Island Capability")
                    TweakToggle(title: "Always-On Display")
                    TweakToggle(title: "AOD Vibrancy")
                    TweakToggle(title: "Disable Wallpaper Parallax")
                    TweakToggle(title: "Charge Limit Menu")
                    TweakToggle(title: "Boot & Shutdown Chime")
                    TweakToggle(title: "Enable Liquid Glass Low-Performance Mode")
                    TweakToggle(title: "Disable Liquid Glass Low-Performance Mode")
                } header: {
                    Label("Software-Oriented Features", systemImage: "gearshape")
                }

                Section {
                    TweakToggle(title: "iPhone 16 Camera Control Settings")
                    TweakToggle(title: "Action Button Settings")
                    TweakToggle(title: "Collision SOS")
                    if has_home_button() {
                        TweakToggle(title: "Tap to Wake")
                    }
                    TweakToggle(title: "Pulse Width Modulation")
                } header: {
                    Label("Hardware-Oriented Features", systemImage: "iphone")
                }

                Section {
                    TweakToggle(title: "Security Research Device Mode")
                    TweakToggle(title: "Disable Region Restrictions")
                    TweakToggle(title: "Apple Intelligence")

                    HStack(spacing: 10) {
                        Picker("Spoofing", selection: $product_type) {
                            Text("Default").tag(machine_name())
                            if UIDevice.current.userInterfaceIdiom == .pad {
                                if doubleSystemVersion() >= 17.4 {
                                    Text("iPad Pro 11-inch (M4)").tag("iPad16,3")
                                    Text("iPad Pro 11-inch (M4, Cellular)").tag("iPad16,4")
                                }
                                Text("iPad Pro 11-inch (4th Gen)").tag("iPad14,3")
                                Text("iPad Pro 11-inch (4th Gen, Cellular)").tag("iPad14,4")
                            } else {
                                Text("iPhone 15 Pro").tag("iPhone16,1")
                                Text("iPhone 15 Pro Max").tag("iPhone16,2")
                                if doubleSystemVersion() >= 18.0 {
                                    Text("iPhone 16").tag("iPhone17,3")
                                    Text("iPhone 16 Plus").tag("iPhone17,4")
                                    Text("iPhone 16 Pro").tag("iPhone17,1")
                                    Text("iPhone 16 Pro Max").tag("iPhone17,2")
                                }
                                if doubleSystemVersion() >= 19.0 {
                                    Text("iPhone 17").tag("iPhone18,3")
                                    Text("iPhone 17 Pro").tag("iPhone18,1")
                                    Text("iPhone 17 Pro Max").tag("iPhone18,2")
                                    Text("iPhone Air").tag("iPhone18,4")
                                }
                            }
                        }

                        Button {
                            Alertinator.shared.alert(
                                title: "Device Spoofing Info",
                                body: "Only spoof your device model if you want to download Apple Intelligence. This may break Face ID. If you decide to unspoof and want to keep Apple Intelligence, do NOT re-enter the Apple Intelligence & Siri menu in Settings."
                            )
                        } label: {
                            Image(systemName: "info.circle")
                                .frame(width: 24, height: 22)
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    Label("Eligibility", systemImage: "checklist")
                }

                Section {
                    TweakToggle(title: "Allow iPad Apps")
                    TweakToggle(title: "Apple Pencil Settings")

                    if UIDevice.current.userInterfaceIdiom == .pad {
                        TweakToggle(title: "Stage Manager Support")
                    }

                    if let reason = tweak("Enable iPadOS Mode")?.can_apply(mg_dict_now) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Enable iPadOS Mode")
                                Spacer()
                                Text("Unsupported")
                                    .foregroundStyle(.secondary)
                            }
                            Text(reason)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .accessibilityElement(children: .combine)
                    } else {
                        TweakToggle(title: "Enable iPadOS Mode")
                            .disabled({
                                let cache_extra = mg_dict_now["CacheExtra"] as? [String: Any]
                                return cache_extra?["+3Uf0Pm5F8Xy7Onyvko0vA"] as? String != "iPhone"
                            }())
                    }
                } header: {
                    Label("iPadOS Features", systemImage: "ipad")
                }

                Section {
                    TweakToggle(title: "Internal Storage View")
                    TweakToggle(title: "Internal Features")
                    TweakToggle(title: "Apple Internal Install")
                } header: {
                    Label("Internal", systemImage: "ant")
                }
            }
            .navigationTitle("MobileGestalt")
            .tint(Color("AccentColor"))
            .task {
                mg_load()
                while is_loading {
                    try? await Task.sleep(for: .milliseconds(50))
                }
                let s = mg_ui_state()
                selected_st = s.0
                enable_device_name = s.1
                mg_device_name = s.2
                product_type = s.3
                hybridStatus = mg_hybrid_status()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button {
                            show_settings = true
                        } label: {
                            Image(systemName: "gear")
                        }
                    }
                }
            }
            .sheet(isPresented: $show_settings) {
                SettingsView()
            }
            .alert("Experimental iPadOS Mode", isPresented: $confirmExperimentalIPadOS) {
                Button("Cancel", role: .cancel) {}
                Button("Apply Anyway", role: .destructive) {
                    applySelectedTweaks()
                }
            } message: {
                Text("This patch has NOT been verified on iPhone 17 / iOS 27.0.1. It changes the device class in MobileGestalt and can cause a boot loop, missing audio, or loss of system functionality. A saved plist is not a guarantee of recovery. Continue only if you have an external recovery backup.")
            }
        }
    }
}
