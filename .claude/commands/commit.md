---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*), Bash(git log:*)
description: Create git commit(s) for current changes
---

## Context

- Current branch: !`git branch --show-current`
- Git status: !`git status --short`
- Staged and unstaged changes: !`git diff HEAD`
- Recent commits (for style reference): !`git log --oneline -5`

## Your Task

Based on the changes shown above, create git commit(s).

## Guidelines

1. **Analyze the changes:**
   - Consider whether changes should be one commit or multiple logical commits
   - Group related changes together
   - Keep commits focused and atomic

2. **Commit message style:**
   - Use imperative mood ("Add feature" not "Added feature")
   - Focus on why, not just what
   - Match the style of recent commits shown above

3. **Execute:**
   - Use `git add` with specific files (never `-A` or `.`)
   - Create commits with clear messages
   - Show result with `git log --oneline -n [count]`

## Important

- **NO co-author information or Claude attribution**
- Do not include "Generated with Claude" or "Co-Authored-By" lines
- Write commit messages as if the user wrote them
