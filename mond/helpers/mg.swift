//
//  mg.swift
//  mond
//
//  Created by ruter on 16.07.26.
//

import SwiftUI
import PartyUI
import Darwin
import MachO
import UIKit

struct mg_tweak {
    let title: String
    let minv: Double?
    let info_t: InfoType?
    let info_msg: String?
    let can_apply: (NSMutableDictionary) -> String?
    
    let r: (NSMutableDictionary) -> Bool
    let w_on: (NSMutableDictionary) -> Void
    let w_off: (NSMutableDictionary) -> Void
    
    enum InfoType {
        case info
        case warning
        case error
    }
}

extension mg_tweak {
    private static func cache_extra(_ dict: NSMutableDictionary) -> NSMutableDictionary? {
        if let extra = dict["CacheExtra"] as? NSMutableDictionary {
            return extra
        }
        guard let extra = dict["CacheExtra"] as? NSDictionary else { return nil }
        let mutable = NSMutableDictionary(dictionary: extra)
        dict["CacheExtra"] = mutable
        return mutable
    }

    init<T: Equatable>(title: String, minv: Double? = nil, key: String, value: T) {
        self.init(
            title: title,
            minv: minv,
            info_t: nil,
            info_msg: nil,
            can_apply: { _ in nil },
            r: { dict in
                guard let extra = dict["CacheExtra"] as? NSDictionary else { return false }
                return extra[key] as? T == value
            },
            w_on: { dict in
                guard let extra = Self.cache_extra(dict) else { return }
                extra[key] = value
            },
            w_off: { dict in
                guard let extra = Self.cache_extra(dict) else { return }
                extra.removeObject(forKey: key)
            }
        )
    }

    init<T: Equatable>(title: String, minv: Double? = nil, keys: [String], value: T) {
        self.init(
            title: title,
            minv: minv,
            info_t: nil,
            info_msg: nil,
            can_apply: { _ in nil },
            r: { dict in
                guard let extra = dict["CacheExtra"] as? NSDictionary,
                      let key = keys.first
                else {
                    return false
                }
                return extra[key] as? T == value
            },
            w_on: { dict in
                guard let extra = Self.cache_extra(dict) else { return }
                for key in keys {
                    extra[key] = value
                }
            },
            w_off: { dict in
                guard let extra = Self.cache_extra(dict) else { return }
                for key in keys {
                    extra.removeObject(forKey: key)
                }
            }
        )
    }

    init<T: Equatable>(title: String, minv: Double? = nil, key: String, value: T, info_t: InfoType, info_msg: String) {
        self.init(
            title: title,
            minv: minv,
            info_t: info_t,
            info_msg: info_msg,
            can_apply: { _ in nil },
            r: { dict in
                guard let extra = dict["CacheExtra"] as? NSDictionary else { return false }
                return extra[key] as? T == value
            },
            w_on: { dict in
                guard let extra = Self.cache_extra(dict) else { return }
                extra[key] = value
            },
            w_off: { dict in
                guard let extra = Self.cache_extra(dict) else { return }
                extra.removeObject(forKey: key)
            }
        )
    }

    init<T: Equatable>(title: String, minv: Double? = nil, keys: [String], value: T, info_t: InfoType, info_msg: String) {
        self.init(
            title: title,
            minv: minv,
            info_t: info_t,
            info_msg: info_msg,
            can_apply: { _ in nil },
            r: { dict in
                guard let extra = dict["CacheExtra"] as? NSDictionary,
                      let key = keys.first
                else {
                    return false
                }
                return extra[key] as? T == value
            },
            w_on: { dict in
                guard let extra = Self.cache_extra(dict) else { return }
                for key in keys {
                    extra[key] = value
                }
            },
            w_off: { dict in
                guard let extra = Self.cache_extra(dict) else { return }
                for key in keys {
                    extra.removeObject(forKey: key)
                }
            }
        )
    }
}

private let region_code_key = "h63QSdBCiT/z0WU6rdQv6Q"
private let region_info_key = "yK+xavymRGZ3xWc1tb8XDg"

let all_tweaks: [mg_tweak] = [
    mg_tweak(title: "Enable Dynamic Island Capability", minv: 19.0, key: "YlEtTtHlNesRBMal1CqRaA", value: 1, info_t: .info, info_msg: "An alternate way to enable the Dynamic Island, as used by Nugget."),
    mg_tweak(title: "Always-On Display", minv: 18.0, keys: ["2OOJf1VhaM7NxfRok3HbWQ", "j8/Omm6s1lsmTDFsXjsBfA"], value: 1, info_t: .warning, info_msg: "Can increase screen burn-in risk on devices that don't officially support it."),
    mg_tweak(title: "AOD Vibrancy", minv: 18.0, key: "ykpu7qyhqFweVMKtxNylWA", value: 1, info_t: .info, info_msg: "Turn this on if your Always-On Display renders incorrectly."),
    mg_tweak(title: "Disable Wallpaper Parallax", key: "UIParallaxCapability", value: 0, info_t: .info, info_msg: "Prevents the wallpaper from moving when you tilt or move the device."),
    mg_tweak(title: "Enable Liquid Glass Low-Performance Mode", minv: 19.0, key: "SAGvsp6O6kAQ4fEfDJpC4Q", value: 1, info_t: .info, info_msg: "Intended for iOS 26 and newer."),
    mg_tweak(title: "Disable Liquid Glass Low-Performance Mode", minv: 19.0, key: "SAGvsp6O6kAQ4fEfDJpC4Q", value: 0, info_t: .info, info_msg: "Don't use this at the same time as the option above."),
    mg_tweak(title: "Boot & Shutdown Chime", key: "QHxt+hGLaBPbQJbXiUJX3w", value: 1, info_t: .info, info_msg: "Adds the chime sound when the device powers on or shuts down."),
    mg_tweak(title: "Charge Limit Menu", minv: 17.0, key: "37NVydb//GP/GrhuTN+exg", value: 1, info_t: .info, info_msg: "Reveals the Settings menu; whether it actually limits charging depends on your hardware."),
    mg_tweak(title: "Tap to Wake", key: "yZf3GTRMGTuwSV/lD7Cagw", value: 1, info_t: .info, info_msg: "Meant for devices like the iPhone SE where tapping to wake isn't otherwise available."),
    mg_tweak(title: "iPhone 16 Camera Control Settings", minv: 18.0, keys: ["CwvKxM2cEogD3p+HYgaW0Q", "oOV1jhJbdV3AddkcCg0AEA"], value: 1, info_t: .info, info_msg: "Exposes the Camera Control settings and its related capabilities."),
    mg_tweak(title: "Apple Pencil Settings", key: "yhHcB0iH0d1XzPO/CFd3ow", value: 1, info_t: .info, info_msg: "Reveals the Apple Pencil settings page."),
    mg_tweak(title: "Action Button Settings", minv: 17.0, key: "cT44WE1EohiwRzhsZ8xEsw", value: 1, info_t: .info, info_msg: "Reveals the Action Button settings page."),
    mg_tweak(title: "Collision SOS", key: "HCzWusHQwZDea6nNhaKndw", value: 1, info_t: .info, info_msg: "Reveals the collision detection options in the SOS settings."),
    mg_tweak(title: "Pulse Width Modulation", minv: 19.0, key: "6IejgN+1Fmu5/QrZFOIeNw", value: 1),
    mg_tweak(title: "Security Research Device Mode", minv: 26.0, key: "XYlJKKkj2hztRP1NWWnhlw", value: 1, info_t: .info, info_msg: "Flags the device as an Apple Security Research Device."),
    mg_tweak(title: "Allow iPad Apps", key: "9MZ5AdH43csAUajl/dU+IQ", value: [1, 2], info_t: .info, info_msg: "Allows iPad apps to be installed on iPhone."),
    mg_tweak(title: "Stage Manager Support", key: "qeaj75wk3HF4DwQ8qbIi7g", value: 1, info_t: .info, info_msg: "Flags the device as capable of Stage Manager."),
    mg_tweak(title: "Apple Internal Install", key: "EqrsVvjcYDdxHBiQmGhAWw", value: 1, info_t: .warning, info_msg: "Turns on internal features like the Metal HUD; some services may act up."),
    mg_tweak(title: "Internal Storage View", key: "LBJfwOEzExRxzlAnSuI7eg", value: 1, info_t: .warning, info_msg: "Displays internal files in the Storage settings; can be dangerous on some iPads."),
    
    mg_tweak(
        title: "Disable Region Restrictions",
        minv: nil,
        info_t: .info,
        info_msg: "This tweak may be broken or have no effect on some iOS versions or devices.",
        can_apply: { _ in nil },
        r: { dict in
            guard let cache_extra = dict["CacheExtra"] as? NSMutableDictionary else { return false }
            return cache_extra[region_code_key] as? String == "LL" &&
                   cache_extra[region_info_key] as? String == "LL/A"
        },
        w_on: { dict in
            guard let cache_extra = dict["CacheExtra"] as? NSMutableDictionary else { return }
            Alertinator.shared.alert(title: "Warning!", body: "Please do not use this feature to bypass region restrictions that would equate to breaking regional laws (e.g. disabling the camera shutter sound). We will NOT be held responsible for enabling any illegal activites!")
            cache_extra[region_code_key] = "LL"
            cache_extra[region_info_key] = "LL/A"
        },
        w_off: { dict in
            guard let cache_extra = dict["CacheExtra"] as? NSMutableDictionary else { return }
            cache_extra.removeObject(forKey: region_code_key)
            cache_extra.removeObject(forKey: region_info_key)
        }
    ),
    
    mg_tweak(
        title: "Apple Intelligence",
        minv: 18.1,
        info_t: .info,
        info_msg: "How to use this tweak:\n1. Spoof to the model next to the first one supported by Apple Intelligence.\n2. Spoof back to your model.\n3. Spoof to your final model and you should see the Apple Intelligence icon in Settings.\n4. Connect iPhone to power and leave the Settings > Storage tab open for ~1 hour.\n\nNOTE: Do not spoof back.",
        can_apply: { _ in nil },
        r: { dict in
            guard let cache_extra = dict["CacheExtra"] as? NSMutableDictionary else { return false }
            return (cache_extra["A62OafQ85EJAiiqKn4agtg"] as? Int) == 1
        },
        w_on: { dict in
            guard let cache_extra = dict["CacheExtra"] as? NSMutableDictionary else { return }
            cache_extra["A62OafQ85EJAiiqKn4agtg"] = 1
            Alertinator.shared.alert(
                title: "Apple Intelligence Spoof",
                body: "How to use this tweak:\n1. Spoof to the model next to the first one supported by Apple Intelligence.\n2. Spoof back to your model.\n3. Spoof to your final model and you should see the Apple Intelligence icon in Settings.\n4. Connect iPhone to power and leave the Settings > Storage tab open for ~1 hour.\n\nNOTE: Do not spoof back."
            )
        },
        w_off: { dict in
            guard let cache_extra = dict["CacheExtra"] as? NSMutableDictionary else { return }
            cache_extra.removeObject(forKey: "A62OafQ85EJAiiqKn4agtg")
        }
    ),
    
    mg_tweak(
        title: "Enable iPadOS Mode",
        minv: nil,
        info_t: .warning,
        info_msg: "Experimental and high risk; This is a very dangerous tweak to use! If you use an alphanumeric passcode, DO NOT USE THIS TWEAK AT ALL! Please do not turn off \"Show Dock In Stage Manager\" or your device will BOOTLOOP when rotating to landscape! Some users have also reported that enabling the iPadOS UI and then tapping Stage Manager can cause the device to enter Recovery Mode, even when the UI itself appears unchanged. The Settings search bar may move to the top before this happens. With these three things in mind, you may experience general instability, or other major issues such as app data randomly disappearing. But I guess some funny multitasking features that still make the device relatively unusable are cool? Whatever dude, I'm not here to tell you how to use your own device.",
        can_apply: { dict in
            guard let cache_data = dict["CacheData"] as? NSMutableData else {
                return "CacheData is missing from MobileGestalt."
            }
            guard let patch = validated_ipados_patch_location(in: cache_data) else {
                return "DeviceClassNumber location could not be uniquely validated for this device/iOS version. The iPadOS Mode binary patch remains disabled."
            }
            guard let value = patch.readValue(from: cache_data), value == 1 || value == 3 else {
                return "DeviceClassNumber is not an expected iPhone/iPad value. Refusing to patch."
            }
            if UIDevice.current.systemVersion == "27.0.1" {
                let backup = URL(fileURLWithPath: AppPaths.backups).appendingPathComponent("SavedGestalt.plist")
                guard let savedData = try? Data(contentsOf: backup),
                      let savedPlist = try? PropertyListSerialization.propertyList(from: savedData, format: nil),
                      let savedDict = savedPlist as? [String: Any],
                      let savedCacheData = savedDict["CacheData"] as? Data,
                      savedCacheData.count == cache_data.length,
                      let original = validated_ipados_patch_location(in: NSMutableData(data: savedCacheData)),
                      original.readValue(from: NSMutableData(data: savedCacheData)) == 1 else {
                    return "The original MobileGestalt backup is missing or does not match this CacheData layout. iPadOS Mode is disabled until an original backup is available."
                }
            }
            return nil
        },
        r: { dict in
            guard let cache_extra = dict["CacheExtra"] as? NSMutableDictionary,
                  let cache_data = dict["CacheData"] as? NSMutableData,
                  let patch = validated_ipados_patch_location(in: cache_data),
                  patch.readValue(from: cache_data) == 3 else { return false }
            let values: [String: Int] = [
                "mG0AnH/Vy1veoqoLRAIgTA": 1,
                "UCG5MkVahJxG1YULbbd5Bg": 1,
                "ZYqko/XM5zD3XBfN5RmaXA": 1,
                "nVh/gwNpy7Jv1NOk00CMrw": 1,
                "uKc7FPnEO++lVhHWHFlGbQ": 1,
            ]
            return values.allSatisfy { key, value in
                (cache_extra[key] as? Int) == value
            }
        },
        w_on: { dict in
            guard let cache_data = dict["CacheData"] as? NSMutableData,
                  let cache_extra = dict["CacheExtra"] as? NSMutableDictionary,
                  let patch = validated_ipados_patch_location(in: cache_data) else { return }
            
            patch.apply(3, to: cache_data)
            
            let values: [String: Int] = [
                "mG0AnH/Vy1veoqoLRAIgTA": 1,
                "UCG5MkVahJxG1YULbbd5Bg": 1,
                "ZYqko/XM5zD3XBfN5RmaXA": 1,
                "nVh/gwNpy7Jv1NOk00CMrw": 1,
                "uKc7FPnEO++lVhHWHFlGbQ": 1,
            ]
            
            for (key, value) in values {
                cache_extra[key] = value
            }
        },
        w_off: { dict in
            guard let cache_data = dict["CacheData"] as? NSMutableData,
                  let cache_extra = dict["CacheExtra"] as? NSMutableDictionary,
                  let patch = validated_ipados_patch_location(in: cache_data) else { return }
            
            patch.apply(1, to: cache_data)
            
            let keys = ["mG0AnH/Vy1veoqoLRAIgTA", "UCG5MkVahJxG1YULbbd5Bg", "ZYqko/XM5zD3XBfN5RmaXA", "nVh/gwNpy7Jv1NOk00CMrw", "uKc7FPnEO++lVhHWHFlGbQ"]
            for key in keys {
                cache_extra.removeObject(forKey: key)
            }
        }
    ),
    
    mg_tweak(
        title: "Internal Features",
        minv: nil,
        info_t: nil,
        info_msg: nil,
        can_apply: { dict in
            guard let cache_data = dict["CacheData"] as? NSMutableData else {
                return "CacheData is missing from MobileGestalt."
            }
            let keys = ["EqrsVvjcYDdxHBiQmGhAWw", "Oji6HRoPi7rH7HPdWVakuw", "LBJfwOEzExRxzlAnSuI7eg"]
            for key in keys {
                if cache_data_safe_offset(key, in: cache_data) == nil {
                    return "CacheData offset not found for \(key). Internal Features binary patch is not supported on this device/iOS version."
                }
            }
            return nil
        },
        r: { dict in
            guard let cache_data = dict["CacheData"] as? NSMutableData,
                  let off = cache_data_safe_offset("EqrsVvjcYDdxHBiQmGhAWw", in: cache_data) else { return false }
            return cache_data.bytes.load(fromByteOffset: off, as: Int.self) == 1
        },
        w_on: { dict in
            guard let cache_data = dict["CacheData"] as? NSMutableData,
                  let off_apple_internal_install = cache_data_safe_offset("EqrsVvjcYDdxHBiQmGhAWw", in: cache_data),
                  let off_has_internal_settings_bundle = cache_data_safe_offset("Oji6HRoPi7rH7HPdWVakuw", in: cache_data),
                  let off_internal_build = cache_data_safe_offset("LBJfwOEzExRxzlAnSuI7eg", in: cache_data) else { return }
            
            cache_data.mutableBytes.storeBytes(of: 1, toByteOffset: off_apple_internal_install, as: Int.self)
            cache_data.mutableBytes.storeBytes(of: 1, toByteOffset: off_has_internal_settings_bundle, as: Int.self)
            cache_data.mutableBytes.storeBytes(of: 1, toByteOffset: off_internal_build, as: Int.self)
        },
        w_off: { dict in
            guard let cache_data = dict["CacheData"] as? NSMutableData,
                  let off_apple_internal_install = cache_data_safe_offset("EqrsVvjcYDdxHBiQmGhAWw", in: cache_data),
                  let off_has_internal_settings_bundle = cache_data_safe_offset("Oji6HRoPi7rH7HPdWVakuw", in: cache_data),
                  let off_internal_build = cache_data_safe_offset("LBJfwOEzExRxzlAnSuI7eg", in: cache_data) else { return }
            
            cache_data.mutableBytes.storeBytes(of: 0, toByteOffset: off_apple_internal_install, as: Int.self)
            cache_data.mutableBytes.storeBytes(of: 0, toByteOffset: off_has_internal_settings_bundle, as: Int.self)
            cache_data.mutableBytes.storeBytes(of: 0, toByteOffset: off_internal_build, as: Int.self)
        }
    )
]

extension mg_tweak {
    func is_on(in dict: NSMutableDictionary) -> Bool { return r(dict) }
    func apply_on(to dict: NSMutableDictionary) { w_on(dict) }
    func apply_off(to dict: NSMutableDictionary) { w_off(dict) }
    
    func supported() -> Bool {
        guard let minv = minv else { return true }
        return doubleSystemVersion() >= minv
    }
}

func is_device_good() -> Bool {
    let supported: [String] = ["iPhone15,2", "iPhone15,3", "iPhone15,4", "iPhone15,5", "iPhone16,1", "iPhone16,2", "iPhone17,3", "iPhone17,4", "iPhone17,1", "iPhone17,2", "iPhone18,3", "iPhone18,1", "iPhone18,2", "iPhone17,5"]
    
    if supported.contains(machine_name()) && doubleSystemVersion() < 19.0 {
        return true
    }
    
    return false
}

func machine_name() -> String {
    var sys_info = utsname()
    uname(&sys_info)
    let machine_mirror = Mirror(reflecting: sys_info.machine)
    
    return machine_mirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
}

var _cache_data_offsets: [String: Int] = [:]

func cache_data_offset(_ key: String) -> Int {
    if let cached = _cache_data_offsets[key] {
        return cached
    }

    let lib_mg = "/usr/lib/libMobileGestalt.dylib"
    dlopen(lib_mg, RTLD_GLOBAL)

    var header: UnsafePointer<mach_header_64>?
    for i in 0..<_dyld_image_count() {
        if String(cString: _dyld_get_image_name(i)) == lib_mg {
            header = unsafeBitCast(_dyld_get_image_header(i), to: UnsafePointer<mach_header_64>.self)
            break
        }
    }
    guard let header else { return 0 }

    var text_size = 0
    guard let cstring = getsectiondata(header, "__TEXT", "__cstring", &text_size) else { return 0 }
    let cstr = cstring.withMemoryRebound(to: CChar.self, capacity: text_size) { $0 }

    var key_ptr = cstr
    while Int(key_ptr - cstr) < text_size {
        if String(cString: key_ptr) == key { break }
        key_ptr += strlen(key_ptr) + 1
    }

    var const_size = 0
    var ptr = getsectiondata(header, "__AUTH_CONST", "__const", &const_size)?.withMemoryRebound(to: UInt.self, capacity: const_size / 8) { $0 }
    if ptr == nil {
        ptr = getsectiondata(header, "__DATA_CONST", "__const", &const_size)?.withMemoryRebound(to: UInt.self, capacity: const_size / 8) { $0 }
    }

    guard let ptr else { return 0 }
    for i in 0..<const_size / 8 {
        if ptr[i] == UInt(bitPattern: key_ptr) {
            let offset = Int((ptr.advanced(by: i).withMemoryRebound(to: UInt16.self, capacity: 1) { $0[0x9a / 2] }) << 3)
            _cache_data_offsets[key] = offset
            return offset
        }
    }

    _cache_data_offsets[key] = 0
    return 0
}

func cache_data_safe_offset(_ key: String, in data: NSMutableData) -> Int? {
    let offset = cache_data_offset(key)
    guard offset > 0, offset <= data.length - MemoryLayout<Int>.size else { return nil }
    return offset
}

/// An iPadOS device-class change must never rely on an arbitrary integer offset.
/// The first resolver uses the MobileGestalt mapping in the loaded system library.
/// For iOS 27.0.1 only, the fallback mirrors Nugget's CacheData structural
/// locator and additionally requires one unambiguous, validated candidate.
private enum IPadOSPatchLocation {
    case integer(byteOffset: Int)
    case nibble(hexOffset: Int)

    var description: String {
        switch self {
        case .integer(let byteOffset): return "MobileGestalt mapping (byte \(byteOffset))"
        case .nibble(let hexOffset): return "validated CacheData layout (byte \(hexOffset / 2))"
        }
    }

    var byteOffset: Int {
        switch self {
        case .integer(let offset): return offset
        case .nibble(let hexOffset): return hexOffset / 2
        }
    }

    func readValue(from data: NSMutableData) -> UInt8? {
        guard byteOffset >= 0, byteOffset < data.length else { return nil }
        let first = data.bytes.load(fromByteOffset: byteOffset, as: UInt8.self)
        switch self {
        case .integer(let offset):
            guard offset + MemoryLayout<UInt64>.size <= data.length else { return nil }
            let bytes = [UInt8](data as Data)
            guard bytes[(offset + 1)..<(offset + 8)].allSatisfy({ $0 == 0 }) else { return nil }
            return first
        case .nibble(let hexOffset):
            return hexOffset.isMultiple(of: 2) ? first >> 4 : first & 0x0f
        }
    }

    func apply(_ value: UInt8, to data: NSMutableData) {
        switch self {
        case .integer(let byteOffset):
            var number = UInt64(value)
            data.replaceBytes(in: NSRange(location: byteOffset, length: MemoryLayout<UInt64>.size), withBytes: &number)
        case .nibble(let hexOffset):
            let byteOffset = hexOffset / 2
            let existing = data.bytes.load(fromByteOffset: byteOffset, as: UInt8.self)
            var replacement: UInt8
            if hexOffset.isMultiple(of: 2) {
                replacement = (existing & 0x0f) | (value << 4)
            } else {
                replacement = (existing & 0xf0) | value
            }
            data.replaceBytes(in: NSRange(location: byteOffset, length: 1), withBytes: &replacement)
        }
    }
}

private func validated_ipados_patch_location(in data: NSMutableData) -> IPadOSPatchLocation? {
    let bytes = [UInt8](data as Data)
    let originalOffset = cache_data_safe_offset("mtrAoWJ3gsq+I90ZnQ0vQw", in: data)

    // Known older layout: the value must be an intact 64-bit integer 1 or 3.
    let mapped: IPadOSPatchLocation? = {
        guard let offset = originalOffset, offset + 8 <= bytes.count,
              [UInt8(1), 3].contains(bytes[offset]),
              bytes[(offset + 1)..<(offset + 8)].allSatisfy({ $0 == 0 }) else { return nil }
        return .integer(byteOffset: offset)
    }()

    // Keep the alternate locator scoped to the firmware requested; no unknown
    // version gets a guessed layout merely because the OS major matches.
    guard UIDevice.current.systemVersion == "27.0.1" else { return mapped }

    let hex = Array(bytes.map { String(format: "%02x", $0) }.joined().utf8)
    let sliceStart = 1616
    let sliceLength = 200
    guard hex.count >= sliceStart + sliceLength,
          let regex = try? NSRegularExpression(pattern: "0+(?:5555)*([0-9a-f]{4})") else { return nil }

    let section = String(decoding: hex[sliceStart..<(sliceStart + sliceLength)], as: UTF8.self)
    let sectionBytes = Array(section.utf8)
    var locations: [Int] = []
    for match in regex.matches(in: section, range: NSRange(location: 0, length: sectionBytes.count)) {
        let group = match.range(at: 1)
        guard group.location != NSNotFound, group.location + group.length <= sectionBytes.count,
              sectionBytes[group.location..<(group.location + group.length)].filter({ $0 != 48 }).count >= 3 else { continue }

        let offset = sliceStart + group.location
        let left = offset - 67
        let right = offset + 13
        guard left > 0, right + 1 < hex.count else { continue }
        let validNibble: (Int) -> Bool = { i in
            (hex[i] == 49 || hex[i] == 51) && hex[i - 1] == 48 && hex[i + 1] == 48
        }
        guard validNibble(left), validNibble(right) else { continue }
        locations.append(left)
    }

    // A pattern match is only usable if it identifies exactly one location.
    guard locations.count == 1 else { return nil }
    let candidate = locations[0]

    // When the system's own mapping also resolves, both methods must identify
    // the same byte. A disagreement is evidence to refuse the patch.
    if let offset = originalOffset, mapped != nil, offset != candidate / 2 {
        return nil
    }
    return .nibble(hexOffset: candidate)
}

func ipados_mode_patch_status(in data: NSMutableData) -> String {
    guard let location = validated_ipados_patch_location(in: data) else {
        return "No uniquely validated DeviceClassNumber location. Do not apply iPadOS Mode."
    }
    let value = location.readValue(from: data).map(String.init) ?? "unreadable"
    return "Experimental candidate: \(location.description); on-disk class value \(value) (1=iPhone, 3=iPad). iOS activation is not verified."
}

private let ipadosCacheExtraKeys = [
    "mG0AnH/Vy1veoqoLRAIgTA", "UCG5MkVahJxG1YULbbd5Bg",
    "ZYqko/XM5zD3XBfN5RmaXA", "nVh/gwNpy7Jv1NOk00CMrw",
    "uKc7FPnEO++lVhHWHFlGbQ"
]

private func ipadosFlagCount(in dict: [String: Any]) -> Int {
    guard let extra = dict["CacheExtra"] as? [String: Any] else { return 0 }
    return ipadosCacheExtraKeys.filter { (extra[$0] as? Int) == 1 }.count
}

// Keep hybrid mode separate from the normal iPadOS toggle. This experiment
// changes only DeviceClassNumber; all five existing Medusa/iPad capability
// flags remain untouched. It does not assume that iPad multitasking will work
// once iOS sees an iPhone device class.
private let hybridWorkingSnapshotName = "WorkingIPadGestaltBeforeHybrid.plist"

private var hybridWorkingSnapshotURL: URL {
    URL(fileURLWithPath: AppPaths.backups).appendingPathComponent(hybridWorkingSnapshotName)
}

private enum MGHybridError: LocalizedError {
    case unsupportedDevice
    case originalBackupInvalid
    case currentLayoutInvalid
    case workingSnapshotConflict
    case workingSnapshotMissing
    case notHybrid

    var errorDescription: String? {
        switch self {
        case .unsupportedDevice:
            return "Hybrid mode is only validated for the experiment's iPhone18,3 / iOS 27.0.1 CacheData layout. No changes were made."
        case .originalBackupInvalid:
            return "The saved original iPhone-class MobileGestalt is missing or mismatched. No changes were made."
        case .currentLayoutInvalid:
            return "The current on-disk file is not the verified iPadOS state (class 3 with 5/5 flags). No changes were made."
        case .workingSnapshotConflict:
            return "An older working iPadOS snapshot differs from the current configuration. Export and preserve it before replacing any backup. No changes were made."
        case .workingSnapshotMissing:
            return "No validated working iPadOS snapshot was found. Restore is unavailable."
        case .notHybrid:
            return "The on-disk file is not the hybrid test state (class 1 with 5/5 flags). Restore was not attempted."
        }
    }
}

private func hybridSupportedDevice() -> Bool {
    machine_name() == "iPhone18,3" && UIDevice.current.systemVersion == "27.0.1"
}

private func hybridPlist(_ data: Data) throws -> NSMutableDictionary {
    guard let parsed = try PropertyListSerialization.propertyList(from: data, format: nil) as? NSDictionary else {
        throw MGHybridError.currentLayoutInvalid
    }
    return NSMutableDictionary(dictionary: parsed)
}

private func hybridClassAndFlags(_ data: Data) throws -> (UInt8, Int, Int) {
    let dict = try hybridPlist(data)
    guard let cache = dict["CacheData"] as? Data else { throw MGHybridError.currentLayoutInvalid }
    let mutable = NSMutableData(data: cache)
    guard let position = validated_ipados_patch_location(in: mutable),
          let value = position.readValue(from: mutable) else { throw MGHybridError.currentLayoutInvalid }
    let extra = dict["CacheExtra"] as? NSDictionary
    let flagCount = ipadosCacheExtraKeys.filter { (extra?[$0] as? Int) == 1 }.count
    return (value, flagCount, cache.count)
}

private func validateHybridOriginalBackup(matching cacheLength: Int) throws {
    let url = URL(fileURLWithPath: AppPaths.backups).appendingPathComponent("SavedGestalt.plist")
    guard let data = try? Data(contentsOf: url),
          let original = try? hybridClassAndFlags(data),
          original.0 == 1, original.2 == cacheLength else {
        throw MGHybridError.originalBackupInvalid
    }
}

/// A read-only status. This also covers unexpected intermediate states rather
/// than displaying a misleading "ready" indicator based on UI toggle state.
func mg_hybrid_status() -> String {
    guard hybridSupportedDevice() else { return "Unsupported device/iOS for this experiment" }
    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: TweakPaths.gestalt))
        let (deviceClass, flags, cacheLength) = try hybridClassAndFlags(data)
        try validateHybridOriginalBackup(matching: cacheLength)
        let state: String
        switch (deviceClass, flags) {
        case (3, 5): state = "Working iPadOS layout (class 3, 5/5 flags)"
        case (1, 5): state = "Hybrid test on disk (class 1, 5/5 flags)"
        default: state = "Other configuration (class \(deviceClass), \(flags)/5 flags)"
        }
        let snapshot = (try? mg_hybrid_working_snapshot()) == nil ? "missing" : "ready"
        return "\(state); return snapshot: \(snapshot)"
    } catch {
        return "Cannot validate hybrid state: \(error.localizedDescription)"
    }
}

/// Only a validated class-3/5-flag snapshot qualifies as a known-working
/// return target. Never use the original class-1 file for this operation.
func mg_hybrid_working_snapshot() throws -> Data {
    guard hybridSupportedDevice() else { throw MGHybridError.unsupportedDevice }
    guard let data = try? Data(contentsOf: hybridWorkingSnapshotURL),
          let snapshot = try? hybridClassAndFlags(data),
          snapshot.0 == 3, snapshot.1 == 5 else { throw MGHybridError.workingSnapshotMissing }
    try validateHybridOriginalBackup(matching: snapshot.2)
    return data
}

/// Capture, without writing MobileGestalt, the current working iPadOS layout.
/// A pre-existing different snapshot is deliberately never overwritten.
@discardableResult
func mg_hybrid_capture_working_snapshot() throws -> String {
    guard hybridSupportedDevice() else { throw MGHybridError.unsupportedDevice }
    let current = try Data(contentsOf: URL(fileURLWithPath: TweakPaths.gestalt))
    let (deviceClass, flags, cacheLength) = try hybridClassAndFlags(current)
    guard deviceClass == 3 && flags == 5 else { throw MGHybridError.currentLayoutInvalid }
    try validateHybridOriginalBackup(matching: cacheLength)

    if FileManager.default.fileExists(atPath: hybridWorkingSnapshotURL.path) {
        let existing = try mg_hybrid_working_snapshot()
        guard existing == current else { throw MGHybridError.workingSnapshotConflict }
        return "The working iPadOS snapshot already exists and matches the current file."
    }
    try current.write(to: hybridWorkingSnapshotURL, options: .atomic)
    let saved = try mg_hybrid_working_snapshot()
    guard saved == current else { throw MGHybridError.workingSnapshotConflict }
    return "Saved and verified the complete working iPadOS MobileGestalt in mond's private backup directory. Export it before testing."
}

/// Experimental A/B test: change the class to iPhone while deliberately
/// preserving all five iPadOS flags. Real UI activation can only be judged
/// after the user tests the phone; a successful write is not that proof.
func mg_hybrid_apply_test() throws -> String {
    try mg_hybrid_capture_working_snapshot()
    let current = try Data(contentsOf: URL(fileURLWithPath: TweakPaths.gestalt))
    let dict = try hybridPlist(current)
    guard let originalCache = dict["CacheData"] as? Data else { throw MGHybridError.currentLayoutInvalid }
    let cache = NSMutableData(data: originalCache)
    guard let patch = validated_ipados_patch_location(in: cache),
          patch.readValue(from: cache) == 3 else { throw MGHybridError.currentLayoutInvalid }
    patch.apply(1, to: cache)
    dict["CacheData"] = cache

    let staged = try PropertyListSerialization.data(fromPropertyList: dict, format: .xml, options: 0)
    try mg_write(staged)
    let verified = try verifyAppliedGestalt(staged, requestedIPadOS: false)
    let (writtenClass, writtenFlags, _) = try hybridClassAndFlags(staged)
    guard writtenClass == 1, writtenFlags == 5 else { throw MGHybridError.currentLayoutInvalid }
    mg_reload()
    print("(mg) hybrid test written: class 1, 5/5 iPadOS flags; \(verified)")
    return "\(verified) Hybrid test is ON DISK: class 1, 5/5 flags. It is not verified that iPad windows remain available after a restart. Your previously working iPadOS file is saved for restoration."
}

/// Restore the complete pre-test class-3 configuration, not a reconstructed
/// guess. Reject other layouts to avoid overwriting unrelated later tweaks.
func mg_hybrid_restore_working() throws -> String {
    let working = try mg_hybrid_working_snapshot()
    let current = try Data(contentsOf: URL(fileURLWithPath: TweakPaths.gestalt))
    let (deviceClass, flags, _) = try hybridClassAndFlags(current)
    guard deviceClass == 1 && flags == 5 else { throw MGHybridError.notHybrid }

    try mg_write(working)
    let verified = try verifyAppliedGestalt(working, requestedIPadOS: true)
    mg_reload()
    print("(mg) working iPadOS layout restored: \(verified)")
    return "\(verified) The exact pre-test working iPadOS configuration is back on disk. UI activation still requires testing on the phone."
}

private enum MGApplyVerificationError: LocalizedError {
    case readbackMismatch
    case invalidWrittenPlist
    case incorrectIPadClass(expected: UInt8, actual: UInt8?)
    case missingIPadFlags(Int)

    var errorDescription: String? {
        switch self {
        case .readbackMismatch:
            return "MobileGestalt was written but the on-disk content differs from the staged data. Do not respring or reboot. Check the original backup."
        case .invalidWrittenPlist:
            return "MobileGestalt read-back is not a valid property list. Do not respring or reboot."
        case .incorrectIPadClass(let expected, let actual):
            return "DeviceClassNumber read-back mismatch (expected \(expected), found \(actual.map(String.init) ?? "unavailable")). Do not respring or reboot."
        case .missingIPadFlags(let count):
            return "Only \(count) of 5 iPadOS flags survived the write. Do not respring or reboot."
        }
    }
}

/// Verify the file on disk, independently of the success reported by write(2).
/// This still does NOT prove SpringBoard will accept the changed device class.
private func verifyAppliedGestalt(_ staged: Data, requestedIPadOS: Bool) throws -> String {
    let onDisk = try Data(contentsOf: URL(fileURLWithPath: TweakPaths.gestalt))
    guard onDisk == staged else { throw MGApplyVerificationError.readbackMismatch }
    guard let raw = try PropertyListSerialization.propertyList(from: onDisk, format: nil) as? [String: Any] else {
        throw MGApplyVerificationError.invalidWrittenPlist
    }

    guard requestedIPadOS else { return "MobileGestalt bytes match the staged file." }
    guard let cache = raw["CacheData"] as? Data else { throw MGApplyVerificationError.invalidWrittenPlist }
    let mutable = NSMutableData(data: cache)
    let actual = validated_ipados_patch_location(in: mutable)?.readValue(from: mutable)
    guard actual == 3 else { throw MGApplyVerificationError.incorrectIPadClass(expected: 3, actual: actual) }
    let flags = ipadosFlagCount(in: raw)
    guard flags == ipadosCacheExtraKeys.count else { throw MGApplyVerificationError.missingIPadFlags(flags) }
    return "File read-back verified DeviceClassNumber=3 and all 5 iPadOS flags. iOS UI activation is still unverified."
}

let state = AppState.shared

let mg_device_name_key = "mg_device_name"
var mg_device_name: String {
    get {
        UserDefaults.standard.string(forKey: mg_device_name_key) ?? ""
    }
    set {
        UserDefaults.standard.set(newValue, forKey: mg_device_name_key)
    }
}

var og_st: Int = 0
var selected_st: String = "og"

var selected_st_value: Int {
    switch selected_st {
        case "og":
            return og_st
        case "no_dynamic_island":
            return 0
        case "14p":
            return 2436
        case "14pm":
            return 2796
        case "15pm":
            return 2976
        case "16p":
            return 2622
        case "16pm":
            return 2868
        case "air":
            return 2736
        case "x":
            return 2436
        default:
            return 0
    }
}

private var st_to_sel: [Int: String] {
    [
        0: "no_dynamic_island",
        2436: "14p",
        2796: "14pm",
        2976: "15pm",
        2622: "16p",
        2868: "16pm",
        2736: "air"
    ]
}

func tweak(_ title: String) -> mg_tweak? {
    all_tweaks.first { $0.title == title }
}

var is_loading: Bool = false
var is_empty: Bool = false

var enable_device_name: Bool = false
var og_device_name: String = ""
var product_type: String = ""

var is_valid: Bool = true

func mg_load() {
    guard !is_loading, mg_dict_now.count == 0 else { return }
    is_loading = true

    let mg_url_now = URL(fileURLWithPath: TweakPaths.gestalt)

    DispatchQueue.global(qos: .userInitiated).async {
        do {
            let file_size = (try? FileManager.default.attributesOfItem(atPath: mg_url_now.path))?[.size] as? UInt64 ?? 0

            let loaded_dict = try NSMutableDictionary(contentsOf: mg_url_now, error: ())

            // this'll cache gestalt and put it in a safe place
            let mg_url_saved = URL(fileURLWithPath: AppPaths.backups).appendingPathComponent("SavedGestalt.plist")

            if !FileManager.default.fileExists(atPath: mg_url_saved.path) {
                try FileManager.default.copyItem(at: mg_url_now, to: mg_url_saved)
            }

            // get og gestalt values
            let mg_saved_dict = try NSMutableDictionary(contentsOf: mg_url_saved, error: ())
            let og_cache_extra = mg_saved_dict["CacheExtra"] as? NSMutableDictionary ?? NSMutableDictionary()
            let og_artwork = og_cache_extra["oPeik/9e8lQWMszEjbPzng"] as? NSMutableDictionary ?? NSMutableDictionary()

            guard let og_subtype = og_artwork["ArtworkDeviceSubType"] as? Int else { throw mg_view_err.missing_artwork_st }
            guard let og_device_name = og_artwork["ArtworkDeviceProductDescription"] as? String else { throw mg_view_err.missing_artwork_device_name }

            let cache_extra = loaded_dict["CacheExtra"] as? NSMutableDictionary ?? NSMutableDictionary()
            let artwork = cache_extra["oPeik/9e8lQWMszEjbPzng"] as? NSMutableDictionary ?? NSMutableDictionary()

            let current_subtype = artwork["ArtworkDeviceSubType"] as? Int ?? og_subtype
            // Several models share artwork subtype values. Never mistake the original
            // model for an intentional spoof merely because a picker value matches.
            let new_selected_st = current_subtype == og_subtype ? "og" : (st_to_sel[current_subtype] ?? "og")
            let new_device_name = artwork["ArtworkDeviceProductDescription"] as? String ?? og_device_name
            let new_enable_device_name = new_device_name != og_device_name

            let new_product_type: String
            if let productType = cache_extra["h9jDsbgj7xIVeIQ8S3/X3Q"] as? String, !productType.isEmpty {
                new_product_type = productType
            } else {
                new_product_type = machine_name()
            }

            DispatchQueue.main.async {
                mg_dict_now = loaded_dict
                og_st = og_subtype
                selected_st = new_selected_st
                mg_device_name = new_device_name
                enable_device_name = new_enable_device_name
                product_type = new_product_type
                is_valid = true
                is_empty = file_size == 0
                is_loading = false
            }
        } catch {
            DispatchQueue.main.async {
                print("(mg) failed to load data: \(error)")
                is_valid = false
                is_empty = (try? FileManager.default.attributesOfItem(atPath: mg_url_now.path))?[.size] as? UInt64 == 0
                is_loading = false
                Alertinator.shared.alert(title: "Failed to load current MobileGestalt!", body: "Restart the app and try again. Check logs for more detailed information.")
            }
        }
    }
}

func mg_apply() {
    do {
        let requestedIPadOS = tweak("Enable iPadOS Mode")?.is_on(in: mg_dict_now) == true
        if requestedIPadOS, let reason = tweak("Enable iPadOS Mode")?.can_apply(mg_dict_now) {
            throw NSError(domain: "mond.iPadOS", code: 1, userInfo: [NSLocalizedDescriptionKey: reason])
        }
        let cache_extra = mg_dict_now["CacheExtra"] as? NSMutableDictionary ?? NSMutableDictionary()
        if !product_type.isEmpty {
            cache_extra["h9jDsbgj7xIVeIQ8S3/X3Q"] = product_type
        }
        
        let artwork_dict = cache_extra["oPeik/9e8lQWMszEjbPzng"] as? NSMutableDictionary ?? NSMutableDictionary()
        artwork_dict["ArtworkDeviceSubType"] = selected_st_value
        if enable_device_name {
            artwork_dict["ArtworkDeviceProductDescription"] = mg_device_name
        }
        
        let data = try PropertyListSerialization.data(fromPropertyList: mg_dict_now, format: .xml, options: 0)

        try mg_write(data)
        let verified = try verifyAppliedGestalt(data, requestedIPadOS: requestedIPadOS)
        mg_reload()
        enable_device_name = false

        print("(mg) applied MobileGestalt: \(verified)")
        if requestedIPadOS {
            Alertinator.shared.alert(
                title: "iPadOS patch written and verified",
                body: "\(verified) This only confirms the saved file. It does NOT prove that iOS 27.0.1 will accept the change after respring or reboot. Before testing, keep a separate, recoverable device backup and an external copy of your original MobileGestalt."
            )
        } else {
            Alertinator.shared.alert(title: "Successfully applied Gestalt tweaks!", body: "\(verified) Respring your device for changes to take effect. Note that some tweaks may require a reboot.", actionLabel: "Respring", action: {
                state.respring()
            })
        }
    } catch {
        print("(mg) failed to apply mobilegestalt: \(error)")
        Alertinator.shared.alert(title: "Failed to apply MobileGestalt!", body: "\(error.localizedDescription) Check logs and the read-only diagnostic before any respring or reboot.")
    }
}

func mg_revert() {
    do {
        let backup_url = URL(fileURLWithPath: AppPaths.backups).appendingPathComponent("SavedGestalt.plist")
        let backup_data = try Data(contentsOf: backup_url)
        try mg_write(backup_data)
        let verified = try verifyAppliedGestalt(backup_data, requestedIPadOS: false)
        mg_reload()

        print("(mg) reverted MobileGestalt: \(verified)")
        Alertinator.shared.alert(title: "Original MobileGestalt restored on disk", body: "\(verified) This does not guarantee recovery if iOS has already entered a boot loop. Confirm the current diagnostic before any restart.")
    } catch {
        print("(mg) failed to revert mobilegestalt: \(error)")
        Alertinator.shared.alert(title: "Failed to revert MobileGestalt!", body: "\(error.localizedDescription) Do not reboot until the on-disk file is verified. Check logs for error information.")
    }
}

func mg_reload() {
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: TweakPaths.gestalt)),
          let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? NSMutableDictionary else { return }
    mg_dict_now = dict
}

/// A deliberately read-only probe. In particular, this function does not call
/// `mg_load` (which creates a backup), `mg_write`, or any exploit function.
func mg_read_only_report() -> [String] {
    let path = URL(fileURLWithPath: TweakPaths.gestalt)
    var lines = ["MobileGestalt read-only diagnostic"]
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "unknown"
    let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "unknown"
    lines.append("mond version: \(version) (\(build))")
    lines.append("iOS: \(UIDevice.current.systemVersion); device: \(machine_name())")
    lines.append("Write method selected: \(UserDefaults.standard.bool(forKey: "atomic_write") ? "in-place with fsync" : "file replacement")")

    // O_RDWR does not write anything. Its result only tests whether opening
    // the existing file for writing is allowed, not whether writing is safe.
    let writeHandle = path.path.withCString { open($0, O_RDWR | O_CLOEXEC | O_NOFOLLOW) }
    if writeHandle >= 0 {
        close(writeHandle)
        lines.append("Non-mutating O_RDWR open: succeeded (actual write not tested)")
    } else {
        let code = errno
        lines.append("Non-mutating O_RDWR open: failed (errno \(code): \(String(cString: strerror(code))))")
    }

    do {
        let data = try Data(contentsOf: path)
        lines.append("File readable: yes (\(data.count) bytes)")
        guard !data.isEmpty else {
            lines.append("Structure: invalid, file is empty")
            return lines
        }

        let plist = try PropertyListSerialization.propertyList(from: data, format: nil)
        guard let dict = plist as? [String: Any] else {
            lines.append("Structure: invalid, root is not a dictionary")
            return lines
        }

        let extra = dict["CacheExtra"] as? [String: Any]
        let artwork = extra?["oPeik/9e8lQWMszEjbPzng"] as? [String: Any]
        lines.append("Property list: valid")
        lines.append("CacheExtra: \(extra == nil ? "missing" : "present")")
        lines.append("CacheData: \((dict["CacheData"] as? Data)?.count ?? 0) bytes")
        if let cacheData = dict["CacheData"] as? NSMutableData {
            lines.append("iPadOS Mode: \(ipados_mode_patch_status(in: cacheData))")
        }
        lines.append("iPadOS CacheExtra flags on disk: \(ipadosFlagCount(in: dict))/5")
        lines.append("Hybrid layout test: \(mg_hybrid_status())")
        if let subtype = artwork?["ArtworkDeviceSubType"] as? Int {
            lines.append("Current artwork subtype: \(subtype)")
        } else {
            lines.append("Artwork subtype: unavailable")
        }

        let backup = URL(fileURLWithPath: AppPaths.backups).appendingPathComponent("SavedGestalt.plist")
        if let original = try? Data(contentsOf: backup),
           let saved = try? PropertyListSerialization.propertyList(from: original, format: nil),
           let savedDict = saved as? [String: Any] {
            let savedExtra = savedDict["CacheExtra"] as? [String: Any]
            let savedArtwork = savedExtra?["oPeik/9e8lQWMszEjbPzng"] as? [String: Any]
            if let subtype = savedArtwork?["ArtworkDeviceSubType"] as? Int {
                lines.append("Saved original subtype: \(subtype)")
            }
            lines.append("Backup readable: yes")
            if let originalCache = savedDict["CacheData"] as? Data {
                let mutable = NSMutableData(data: originalCache)
                if let originalPatch = validated_ipados_patch_location(in: mutable) {
                    let originalValue = originalPatch.readValue(from: mutable).map(String.init) ?? "unreadable"
                    lines.append("Saved original DeviceClassNumber: \(originalValue) (expected 1 for iPhone)")
                } else {
                    lines.append("Saved original DeviceClassNumber: location unavailable")
                }
            }
        } else {
            lines.append("Backup readable: no")
        }
    } catch {
        lines.append("Read/parse failed: \(error.localizedDescription)")
    }

    lines.append("This is not a write-permission or safe-patching test.")
    return lines
}

private enum mg_write_err: Error {
    case open(errno: Int32)
    case truncate(errno: Int32)
    case write(errno: Int32)
    case sync(errno: Int32)
    case rollback(errno: Int32)
    case verificationFailed
}

private func read_all(_ fd: Int32) throws -> Data {
    var res = Data()
    var buf = [UInt8](repeating: 0, count: 64 * 1024)

    while true {
        let count = buf.withUnsafeMutableBytes { rawBuffer in
            read(fd, rawBuffer.baseAddress, rawBuffer.count)
        }

        if count > 0 {
            res.append(buf, count: count)
            continue
        }

        if count == 0 {
            return res
        }

        if errno == EINTR {
            continue
        }

        throw mg_write_err.verificationFailed
    }
}

private func write_all(_ fd: Int32, _ data: Data) throws {
    guard !data.isEmpty else { return }

    try data.withUnsafeBytes { rawBuffer in
        guard let base = rawBuffer.baseAddress else {
            throw mg_write_err.write(errno: EFAULT)
        }

        var offset = 0

        while offset < data.count {
            let res = write(
                fd,
                base.advanced(by: offset),
                data.count - offset
            )

            if res > 0 {
                offset += res
                continue
            }

            if res < 0 && errno == EINTR {
                continue
            }

            throw mg_write_err.write(errno: errno)
        }
    }
}

func mg_write(_ data: Data, to path: String) throws {
    let og = try Data(contentsOf: URL(fileURLWithPath: path))

    let fd = path.withCString {
        open($0, O_RDWR | O_CLOEXEC | O_NOFOLLOW)
    }

    guard fd >= 0 else {
        throw mg_write_err.open(errno: errno)
    }

    defer {
        close(fd)
    }

    do {
        guard ftruncate(fd, 0) == 0 else {
            throw mg_write_err.truncate(errno: errno)
        }

        try write_all(fd, data)

        guard fsync(fd) == 0 else {
            throw mg_write_err.sync(errno: errno)
        }

        guard lseek(fd, 0, SEEK_SET) >= 0 else {
            throw mg_write_err.verificationFailed
        }

        let verify = try read_all(fd)

        guard verify == data else {
            throw mg_write_err.verificationFailed
        }
    } catch {
        if ftruncate(fd, 0) == 0,
           lseek(fd, 0, SEEK_SET) >= 0 {
            _ = try? write_all(fd, og)
            _ = fsync(fd)
        }

        throw error
    }
}


func mg_write(_ data: Data) throws {
    let path = TweakPaths.gestalt

    if UserDefaults.standard.bool(forKey: "atomic_write") {
        try mg_write(data, to: path)
    } else {
        let target_url = URL(fileURLWithPath: path)
        let temp_url = target_url.deletingLastPathComponent()
            .appendingPathComponent(".\(target_url.lastPathComponent).\(UUID().uuidString).tmp")

        try data.write(to: temp_url, options: [.withoutOverwriting])
        defer { try? fm.removeItem(at: temp_url) }

        if fm.fileExists(atPath: target_url.path) {
            _ = try fm.replaceItemAt(target_url, withItemAt: temp_url)
        } else {
            try fm.moveItem(at: temp_url, to: target_url)
        }
    }
}

var mg_dict_now: NSMutableDictionary = NSMutableDictionary()

func mg_tweak_binding(_ tweak: mg_tweak) -> Binding<Bool> {
    Binding(
        get: {
            tweak.is_on(in: mg_dict_now)
        },
        set: { enabled in
            if let error = tweak.can_apply(mg_dict_now) {
                Alertinator.shared.alert(title: "Cannot apply \(tweak.title)", body: error)
                return
            }
            if enabled {
                tweak.apply_on(to: mg_dict_now)
            } else {
                tweak.apply_off(to: mg_dict_now)
            }
        }
    )
}

enum mg_view_err: Error, LocalizedError {
    case missing_artwork_st
    case missing_artwork_device_name
    
    var errorDescription: String? {
        switch self {
            case .missing_artwork_st:
                return "Failed to get ArtworkDeviceSubType!"
            case .missing_artwork_device_name:
                return "Failed to get ArtworkDeviceProductDescription!"
        }
    }
}
