#!/bin/zsh
set -eu

cut_codex_home="$HOME/.codex-cut"
launcher_app="$HOME/Applications/Codex CUT.app"

if [[ ! -d "/Applications/ChatGPT.app" ]]; then
  print -u2 "ChatGPT.app が /Applications に見つかりません。"
  exit 1
fi

if [[ -e "$cut_codex_home/config.toml" || -e "$launcher_app" ]]; then
  print -u2 "既存のCodex CUT設定またはランチャーがあります。上書きせず終了します。"
  exit 1
fi

/bin/mkdir -p "$cut_codex_home" "$HOME/Applications"

print -r -- "model_instructions_file = \"$cut_codex_home/claudecut-system-prompt.md\"
web_search = \"live\"

[agents]
enabled = false

[features]
apps = false
artifact = false
browser_use = false
browser_use_external = false
computer_use = false
goals = false
hooks = false
image_generation = true
in_app_browser = false
in_app_local_automation = false
memories = false
multi_agent = false
plugins = false
plugin_sharing = false
recommended_plugins = false
remote_plugin = false
tool_suggest = false
view_image = false
worktrees = false
workspace_dependencies = false
shell_tool = true

[[skills.config]]
name = \"openai-docs\"
enabled = false

[[skills.config]]
name = \"plugin-creator\"
enabled = false" > "$cut_codex_home/config.toml"

print -r -- \
  "Coding agent in a git repo. Be concise. Never run destructive git or rm without asking." \
  > "$cut_codex_home/claudecut-system-prompt.md"

print -r -- '#!/bin/zsh
set -eu

cut_codex_home="$HOME/.codex-cut"
cut_user_data="$HOME/Library/Application Support/Codex-CUT"

/bin/mkdir -p "$cut_codex_home" "$cut_user_data"

exec /usr/bin/open -n \
  --env "CODEX_HOME=$cut_codex_home" \
  -a "/Applications/ChatGPT.app" \
  --args \
  "--user-data-dir=$cut_user_data"' \
  > "$cut_codex_home/launch-codex-cut.sh"
/bin/chmod 755 "$cut_codex_home/launch-codex-cut.sh"

/usr/bin/osacompile \
  -o "$launcher_app" \
  -e 'on run' \
  -e 'do shell script quoted form of ((POSIX path of (path to home folder)) & ".codex-cut/launch-codex-cut.sh")' \
  -e 'end run'

/bin/cp "/Applications/ChatGPT.app/Contents/Resources/app.icns" \
  "$launcher_app/Contents/Resources/applet.icns"
/usr/bin/codesign --force --deep --sign - "$launcher_app"

print "インストールしました: $launcher_app"
