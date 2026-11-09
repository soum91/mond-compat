#!/usr/bin/env python3
"""Build/verify a narrowly scoped GoldenNugget Mobile v2 .batter archive.

No device, external network, backup, or restore access occurs here.
"""

from __future__ import annotations

import argparse
import json
import plistlib
import sys
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile


ROOT = Path(__file__).resolve().parent
CONFIG_PATH = ROOT / "config.json"
CONFIG_ENTRY = "config.json"
PLIST_ENTRY = "container/mobile/com.apple.springboard.plist"
VALUES = {
    "SBChamoisWindowingEnabled": True,
    "SBMedusaMultitaskingEnabled": True,
}


def check_config(config: dict) -> None:
    assert config["format_version"] == "2", "GoldenNugget Mobile supports v2, not v3"
    assert config["domain"] == "ManagedPreferencesDomain", "unexpected restore domain"
    assert config["min_version"] == config["max_version"] == "27.0.1"
    assert all(config[key] for key in ("title", "author", "description"))
    assert len(config["options"]) == 1, "unexpected number of options"
    option = config["options"][0]
    assert option["type"] == "remove"
    assert option["files"] == [PLIST_ENTRY], "the OFF switch must remove the payload file"
    assert option["inverted"] is True, "unchecked must exclude payload"
    assert option["default_value"] is False, "never opt users in automatically"
    assert "SBFlexibleWindowingPreviouslyEnabledAutomaticStageCreation" not in str(config)


def check_archive(path: Path) -> None:
    with ZipFile(path) as archive:
        assert sorted(archive.namelist()) == sorted([CONFIG_ENTRY, PLIST_ENTRY]), (
            "the archive must contain only the config and one SpringBoard plist"
        )
        assert archive.testzip() is None, "archive CRC check failed"
        config = json.loads(archive.read(CONFIG_ENTRY))
        check_config(config)
        payload = plistlib.loads(archive.read(PLIST_ENTRY))
        assert type(payload) is dict and payload == VALUES, "unexpected plist contents"
    assert "SBFlexibleWindowingPreviouslyEnabledAutomaticStageCreation" not in payload


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "Mond-iPhone-Windowing-Mobile.batter")
    parser.add_argument("--verify", type=Path, help="validate an existing .batter archive without writing")
    args = parser.parse_args()
    if args.verify:
        check_archive(args.verify)
        print(f"Verified default-OFF GoldenNugget Mobile template: {args.verify}")
        return

    config = json.loads(CONFIG_PATH.read_text(encoding="utf-8"))
    check_config(config)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with ZipFile(args.output, "w", ZIP_DEFLATED) as archive:
        archive.writestr(CONFIG_ENTRY, json.dumps(config, indent=2, ensure_ascii=False) + "\n")
        archive.writestr(PLIST_ENTRY, plistlib.dumps(VALUES, fmt=plistlib.FMT_XML, sort_keys=True))
    check_archive(args.output)
    print(f"Packaged default-OFF GoldenNugget Mobile template: {args.output}")


if __name__ == "__main__":
    try:
        main()
    except (AssertionError, KeyError, OSError, ValueError) as error:
        print(f"Mond mobile template failed validation: {error}", file=sys.stderr)
        raise SystemExit(1) from error
