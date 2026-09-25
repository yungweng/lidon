#!/bin/sh
# lidon installer: adds `lidon` / `lidoff` to fish, bash and zsh.
set -e

[ "$(uname)" = "Darwin" ] || { echo "lidon works on macOS only." >&2; exit 1; }

SH_FILE="$HOME/.lidon.sh"
cat > "$SH_FILE" <<'SH'
# lidon: keep the Mac awake with the lid closed
lidon() { sudo pmset -a disablesleep 1 && echo "Lid close allowed (Mac stays awake). Afterwards: lidoff"; }
lidoff() { sudo pmset -a disablesleep 0 && echo "Normal sleep restored"; }
SH
echo "Wrote $SH_FILE"

# make sure the login shell's rc file exists
case "$SHELL" in
  */zsh) touch "$HOME/.zshrc" ;;
  */bash) touch "$HOME/.bash_profile" ;;
esac

# shellcheck disable=SC2016
for rc in "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.zshrc"; do
  [ -f "$rc" ] || continue
  grep -q '.lidon.sh' "$rc" || printf '\n[ -f "$HOME/.lidon.sh" ] && . "$HOME/.lidon.sh"\n' >> "$rc"
  echo "Hooked into $rc"
done

if command -v fish >/dev/null 2>&1 || [ -d "$HOME/.config/fish" ]; then
  dir="$HOME/.config/fish/functions"
  mkdir -p "$dir"
  cat > "$dir/lidon.fish" <<'FISH'
function lidon --description 'Keep the Mac awake with the lid closed'
    sudo pmset -a disablesleep 1; and echo "Lid close allowed (Mac stays awake). Afterwards: lidoff"
end
FISH
  cat > "$dir/lidoff.fish" <<'FISH'
function lidoff --description 'Restore normal sleep on lid close'
    sudo pmset -a disablesleep 0; and echo "Normal sleep restored"
end
FISH
  echo "Installed fish functions in $dir"
fi

echo "Done. Open a new terminal, then run: lidon"
