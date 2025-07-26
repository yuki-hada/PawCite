# Package

version       = "0.1.0"
author        = "yuki"
description   = "PawCite is a Nim‑based CLI tool that retrieves metadata from the Crossref API using a DOI and generates a concise citation string."
license       = "GPL-3.0-or-later"
srcDir        = "src"
bin           = @["pawcite"]


# Dependencies

requires "nim >= 2.2.4"
requires "puppy >= 2.1.2"
