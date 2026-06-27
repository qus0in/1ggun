#!/bin/bash
set -euo pipefail

REPO_ARCHIVE="https://github.com/qus0in/1gun/archive/refs/heads/main.tar.gz"
AGENTS_DIR=".agents"

echo "[1gun] installing..."

# 1. Download sound_hook.sh and sound/ into .agents/
mkdir -p "${AGENTS_DIR}"
TMP=$(mktemp -d)
trap 'rm -rf "${TMP}"' EXIT

curl -fsSL "${REPO_ARCHIVE}" | tar xz -C "${TMP}"
cp "${TMP}/1gun-main/.agents/sound_hook.sh" "${AGENTS_DIR}/"
cp -r "${TMP}/1gun-main/.agents/sound" "${AGENTS_DIR}/"
chmod +x "${AGENTS_DIR}/sound_hook.sh"
echo "downloaded: ${AGENTS_DIR}/"

# 2. Merge hooks into config files
python3 - <<'PYEOF'
import json, os

def read_json(path):
    if os.path.exists(path):
        with open(path) as f:
            return json.load(f)
    return {}

def write_json(path, data):
    os.makedirs(os.path.dirname(path) or '.', exist_ok=True)
    with open(path, 'w') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write('\n')

def hook_entry(cmd):
    return [{"hooks": [{"type": "command", "command": cmd, "timeout": 30}]}]

# .agents/hooks.json — AGY (직접 넣기)
agy = read_json(".agents/hooks.json")
agy["AGY"] = {
    "enabled": True,
    "PreInvocation": [{"type": "command", "command": "bash sound_hook.sh agy PreInvocation", "timeout": 30}],
    "Stop":          [{"type": "command", "command": "bash sound_hook.sh agy Stop",          "timeout": 30}],
}
write_json(".agents/hooks.json", agy)
print("updated: .agents/hooks.json")

# .claude/settings.json — Claude Code
cc = read_json(".claude/settings.json")
cc.setdefault("hooks", {}).update({
    "SessionStart":      hook_entry("bash .agents/sound_hook.sh cc"),
    "UserPromptSubmit":  hook_entry("bash .agents/sound_hook.sh cc"),
    "PermissionRequest": hook_entry("bash .agents/sound_hook.sh cc"),
    "Notification":      hook_entry("bash .agents/sound_hook.sh cc"),
    "Stop":              hook_entry("bash .agents/sound_hook.sh cc"),
})
write_json(".claude/settings.json", cc)
print("updated: .claude/settings.json")

# .codex/hooks.json — Codex
codex = read_json(".codex/hooks.json")
codex.setdefault("hooks", {}).update({
    "SessionStart":      hook_entry("bash .agents/sound_hook.sh codex"),
    "UserPromptSubmit":  hook_entry("bash .agents/sound_hook.sh codex"),
    "PermissionRequest": hook_entry("bash .agents/sound_hook.sh codex"),
    "Stop":              hook_entry("bash .agents/sound_hook.sh codex"),
})
write_json(".codex/hooks.json", codex)
print("updated: .codex/hooks.json")
PYEOF

echo ""
echo "[1gun] done"
echo "  .agents/sound_hook.sh  +  .agents/sound/"
echo "  .agents/hooks.json     (AGY    - 명 일꾼)"
echo "  .claude/settings.json  (Claude Code - 조선 일꾼)"
echo "  .codex/hooks.json      (Codex  - 일본 일꾼)"
