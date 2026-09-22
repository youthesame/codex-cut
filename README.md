# codex-cut

通常のCodex Desktopを変更せず、軽量設定の「Codex CUT」を別プロセスで同時起動するmacOS向けインストーラーです。

通常版は従来どおり `~/.codex` と `~/Library/Application Support/Codex` を使います。CUT版は `~/.codex-cut` と `~/Library/Application Support/Codex-CUT` を使うため、設定・ログイン状態・セッションを分離できます。

## CUT版

- Shell、Web検索、画像生成は残す
- multi-agent、apps、plugins、computer useなどは無効化する
- `openai-docs` と `plugin-creator` Skillは無効化する
- CompactはCodexのデフォルトを使う
- system promptは次の1行だけにする

```text
Coding agent in a git repo. Be concise. Never run destructive git or rm without asking.
```

## インストール

```bash
git clone https://github.com/youthesame/codex-cut.git
cd codex-cut
./install.sh
open "$HOME/Applications/Codex CUT.app"
```

既存の `~/.codex-cut/config.toml` または `~/Applications/Codex CUT.app` がある場合、インストーラーは上書きせず終了します。

## 確認

通常のCodex Desktopを開いたまま `~/Applications/Codex CUT.app` を起動し、両方のウィンドウが同時に存在すれば分離できています。CUT側のプロセスには次の引数が付きます。

```text
--user-data-dir=.../Library/Application Support/Codex-CUT
```

`~/.codex-cut` には認証情報、会話履歴、SQLite、ログ、キャッシュなどが生成されます。このディレクトリ自体はGit管理・公開しないでください。

## アンインストール

Codex CUTを終了してから、次の3か所を手動で削除します。通常版の `~/.codex` は削除しないでください。

```text
~/.codex-cut
~/Library/Application Support/Codex-CUT
~/Applications/Codex CUT.app
```
