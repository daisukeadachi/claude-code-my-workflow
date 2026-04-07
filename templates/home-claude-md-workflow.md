## Claude Code Workflow (auto-added by setup.sh)

Skills, agents, and rules are managed in:
`~/Documents/GitHub/claude-code-my-workflow/`

### Core Principles

- **Plan first** — use `EnterPlanMode` for non-trivial tasks; save plans to `quality_reports/plans/`
- **Verify after** — compile/run and confirm output at the end of every task
- **Quality gates** — 80/100 to commit, 90/100 for PR
- **Session logs** — save to `quality_reports/session_logs/YYYY-MM-DD_description.md`

### Available Skills (use `/skill-name`)

| Skill | Purpose |
|-------|---------|
| `/commit` | Stage, commit, PR, merge |
| `/deep-audit` | Repository-wide consistency audit |
| `/lit-review [topic]` | Literature search and synthesis |
| `/research-ideation [topic]` | Research questions and empirical strategies |
| `/interview-me [topic]` | Interactive research interview |
| `/review-paper [file]` | Manuscript review |
| `/data-analysis [dataset]` | End-to-end R/Python analysis |
| `/proofread [file]` | Grammar, typos, overflow |
| `/compile-latex [file]` | 3-pass XeLaTeX + bibtex |
| `/context-status` | Session health and context usage |
| `/learn [skill-name]` | Extract discovery into persistent skill |

### Hooks (project-local)

To enable session logging, context monitoring, and file protection in a project,
copy `.claude/hooks/` and `.claude/settings.json` from the workflow repo into
that project's `.claude/` directory.
