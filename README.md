# Homebrew tap for Miles

[Miles](https://github.com/astraldev/Miles) is a port of GNOME Files (Nautilus) to MacOS. This tap installs it with Homebrew, on Apple silicon.

```bash
brew install astraldev/tap/miles
```

Then open it:

```bash
open "$(brew --prefix miles)/Miles.app"
```

Keep it in the Dock to find it again. The command `miles` starts it too.

## Updating the formula

1. Set `tag`, `revision` and `version` in `Formula/miles.rb` to the new tag of Miles, and remove the `bottle` block.
2. Run the Bottle workflow from the Actions tab. It builds the formula, uploads the bottle to a release of this repository and writes the new `bottle` block into the formula.
