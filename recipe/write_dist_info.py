"""Create Python distribution metadata for the direct CMake installation."""

import sys
from pathlib import Path


def main(site_packages: str, version: str) -> None:
    dist_info = Path(site_packages) / f"z5py-{version}.dist-info"
    dist_info.mkdir(parents=True, exist_ok=True)

    metadata = f"""Metadata-Version: 2.1
Name: z5py
Version: {version}
Summary: Lightweight C++ and Python library for reading and writing zarr and n5 files
License: MIT
Requires-Python: >=3.11
Requires-Dist: numpy

"""
    (dist_info / "METADATA").write_text(metadata, encoding="utf-8")
    (dist_info / "INSTALLER").write_text("conda\n", encoding="utf-8")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise SystemExit("usage: write_dist_info.py SITE_PACKAGES VERSION")
    main(sys.argv[1], sys.argv[2])
