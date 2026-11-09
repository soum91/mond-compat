#!/usr/bin/env python3
"""Package and strictly inspect the opt-in Mond/GoldenNugget community tweak.

This performs only local JSON/ZIP operations. It never contacts an iPhone,
reads a device backup, invokes an exploit, or runs a restore operation.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile

ROOT = Path(__file__).resolve().parent
CONFIG = ROOT / "config.json"
ENTRY = "MondWindowing/config.json"
KEYS = {"SBChamoisWindowingEnabled": True, "SBMedusaMultitaskingEnabled": True}
TARGET = "/var/Managed Preferences/mobile/com.apple.springboard.plist"


def check(data: dict) -> None:
    assert data["format_version"] == "3", "GoldenNugget Community Tweaks require format 3"
    assert data["min_version"] == data["max_version"] == "27.0.1", "device OS must be restricted"
    assert isinstance(data.get("title"), str) and data["title"].strip()
    assert isinstance(data.get("author"), str) and data["author"].strip()
    assert "domain" not in data and "options" not in data, "switch-only package must not restore app files"
    assert isinstance(data.get("tweaks"), list) and len(data["tweaks"]) == 1
    tweak = data["tweaks"][0]
    assert tweak["default"] is False, "never silently enable the experiment"
    assert tweak["writes_off"] == [], "disable is not an assumed rollback"
    assert tweak["min_version"] == tweak["max_version"] == "27.0.1"
    assert len(tweak["writes"]) == 1
    write = tweak["writes"][0]
    assert write == {"type": "plist", "path": TARGET, "values": KEYS}, "unexpected target or values"
    assert "SBFlexibleWindowingPreviouslyEnabledAutomaticStageCreation" not in write["values"], (
        "runtime/history state must not be written"
    )


def verify(path: Path) -> None:
    with ZipFile(path) as archive:
        assert archive.namelist() == [ENTRY], "archive should contain one config only"
        assert archive.testzip() is None, "archive CRC validation failed"
        loaded = json.loads(archive.read(ENTRY))
    check(loaded)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "Mond-iPhone-Stage-Experiment.batter")
    parser.add_argument("--verify", type=Path, help="read-only validation of an existing .batter archive")
    args = parser.parse_args()
    if args.verify:
        verify(args.verify)
        print(f"Validated (OFF by default): {args.verify}")
        return
    data = json.loads(CONFIG.read_text(encoding="utf-8"))
    check(data)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with ZipFile(args.output, "w", compression=ZIP_DEFLATED) as archive:
        archive.writestr(ENTRY, json.dumps(data, ensure_ascii=False, indent=2) + "\n")
    verify(args.output)
    print(f"Packaged (OFF by default): {args.output}")


if __name__ == "__main__":
    try:
        main()
    except (AssertionError, KeyError, ValueError) as error:
        print(f"Template verification failed: {error}", file=sys.stderr)
        raise SystemExit(1) from error
