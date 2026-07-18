#!/bin/sh
# Runs SwiftLint during the Xcode build. Invoked as a Tuist build script.
# SwiftLint is pinned in .mise.toml so every machine/CI uses the same version.

# Xcode's build phase PATH doesn't include Homebrew/mise shims, so add them.
export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin"

# Skip lint on CI-less indexing / SwiftUI previews to keep them fast.
if [ "${ENABLE_PREVIEWS}" = "YES" ]; then
  exit 0
fi

cd "${SRCROOT}" || exit 0

if command -v mise >/dev/null 2>&1; then
  mise exec -- swiftlint --config "${SRCROOT}/.swiftlint.yml"
elif command -v swiftlint >/dev/null 2>&1; then
  swiftlint --config "${SRCROOT}/.swiftlint.yml"
else
  echo "warning: SwiftLint not installed. Run 'mise install' (or 'brew install swiftlint')."
fi
