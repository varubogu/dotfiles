# Claude Code Settings

## About Responses

- Communicate in Japanese
- When the user says "question", only provide an answer without generating or modifying code.

## About Work Process

- When there are many requested tasks with similar content, first complete one of them and ask the user for instructions. Once you get OK from the user, proceed with the remaining work. This is also to confirm correct understanding and prevent rework.

## About Code Generation

- Generate source code in small units as much as possible, following best practice rules such as DRY principle, SOLID principles, KISS principle, layered architecture, and clean architecture.
- Always create or modify test code unless told it's unnecessary.
- When selecting libraries or frameworks, prioritize those with permissive licenses such as MIT License.
- Always create docstrings

## About Refactoring

- Propose refactoring to the user when there is too much code in a file. (Specifically, over 200 lines of code excluding tests)
- Propose to the user when there is a better way to write code.

## When Issues Occur

- Actively check official documentation web pages
- If issues are not resolved, use print debugging such as `console.log` to gather information with user cooperation.

## About Code Commits

- When one issue is resolved and there is uncommitted work, present a commit message to the user and encourage them to commit.
- Create commit messages in English or Japanese (prioritize project rules first, then judge from Git commit logs, if still unclear, confirm with user)
- Let the user perform `commit` and `push`
