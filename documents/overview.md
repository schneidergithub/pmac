# PMAC Positioning Paper

## Executive Summary

Project Management as Code (PMAC) introduces a new global standard for reproducible, test-driven, failure-resistant project execution. In contrast to traditional frameworks like PMP, Scrum, or SAFe—which provide guidance and tooling—PMAC defines **structured, executable blueprints** for building and running projects across hybrid human-AI teams.

PMAC is Git-native, automation-first, and designed for resilience. It enables the full project lifecycle to be declared, automated, tested, recovered, and replayed from a single source of truth: `pmac.json`.

---

## Unique Strengths of PMAC

### 🧩 1. Declarative Project Management
- Replaces ad-hoc project setup with structured JSON/YAML
- Enables reproducible environments like `Dockerfile` for teams
- Ensures version control, change tracking, and replayability

### 🤖 2. Hybrid AI-Human Team Modeling
- AI and humans defined side by side
- Time zone, SLA, working hours, and capabilities modeled per member
- Role fallback and escalation handled through automation

### 🔁 3. Built-In Self-Healing & Failure-Driven Design (FDD)
- Failures escalate and retry using `.pmac/state.json`
- Notifications and resolution playbooks embedded in spec
- Projects don’t just fail — they fix themselves or escalate responsibly

### 🧪 4. Acceptance Test-Driven Development (ATDD) Native
- Stories generate or reference Gherkin `.feature` files
- `test_all.py` validates structure, expectations, and logic
- Projects pass automated tests before execution

### 🔐 5. Policy and Governance as Code
- Org charts, IAM roles, and permissions are version-controlled
- Roles built for least privilege by default
- Playbooks create GitHub teams, Jira groups, email aliases

### 🔂 6. Full Lifecycle Coverage
- Plan: `pmac.json`
- Execute: `bootstrap.py`
- Heal: `state.json` + auto-retry
- Replay: `lock.json` (planned)

### 🌍 7. World-Ready: Time Zones, Environments, GitOps
- Timezone-aware team orchestration ("Follow-the-Sun")
- Supports `dev`, `staging`, `prod` overlays via `envs/`
- Integration-ready with GitHub, Jira, Confluence, Terraform, and Slack

---

## Comparison Table

| Feature                   |  Dev/GitOps       | PMAC |
|--------                   |----------------   |------|
| Declarative Setup         |  ✅ (infra only)  | ✅ (infra + people + stories)
| Hybrid AI Support         |  ❌               | ✅ |
| Self-Healing Logic        |  🟡 (infra only)  | ✅ |
| ATDD Built-In             |  ❌               | ✅ |
| IAM + Policy-as-Code      |  ✅ (infra)       | ✅ (team + org + tasks)
| Time Zone Awareness       |  ❌               | ✅ |
| Full Lifecycle Tracking   |  🟡               | ✅ |

---

## Vision for the Future

PMAC will become the foundation of:
- Global project automation templates
- AI-assisted Scrum/Kanban boards
- Self-healing and self-documenting teams
- Disaster recovery for organizational structure and strategy
- Repeatable bootstraps for startups, departments, and agencies

---

## Get Involved

- GitHub: Jira Tools are going here: https://github.com/schneidergithub/pmac-tools/blob/master/jira-import-readme.md
- Email: TBD
- License: MIT + CC BY 4.0