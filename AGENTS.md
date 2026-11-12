# Git Conventions

- Never add Claude, Anthropic, or any AI assistant as an author, co-author, or contributor: no `Co-Authored-By` trailers, and no AI attribution in commit messages, PR descriptions, issues, or review comments.
- Commit as the configured git user; never change `user.name` / `user.email`.
- Use Conventional Commits: `type(scope): summary`, with types `feat`, `fix`, `refactor`, `chore` and the area (`terraform`, `ansible`, `tailscale`, `cloudflare`, `bytebase`, `ci`, `repo`) as scope.
- Don't amend or rewrite existing commits just to change attribution unless explicitly asked.
- Never push to `main` or merge into it; changes reach `main` only through a pull request the user merges.
- Never `git merge main` into a branch; rebase it onto `main` instead.
- Never force push, except to update a branch after a rebase (use `--force-with-lease`).
