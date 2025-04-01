
# 🚀 PMAC Example: Bootstrapping a Funded Startup with Automated Ops

## 🧪 Scenario: From Seed Round to Software Company

**Startup:** PMAC AI Inc.  
**Funding:** $2M seed round  
**Team:** 2 founders, 1 contractor, and 3 engineers starting next week  
**Goal:** Launch MVP in 90 days and prepare for a Series A pitch  
**Challenge:** Set up operations, collaboration, compliance, and project planning rapidly without overwhelming the founding team.

---

## ✅ PMAC-Driven Setup Plan

Using **Project Management as Code (PMAC)**, the founders define everything in version-controlled JSON/YAML. The system automates tool provisioning, team onboarding, and operational workflows.

### 📁 `pmac_startup_bootstrap.json`
```json
{
  "company_name": "PMAC AI Inc.",
  "project_name": "MVP Buildout",
  "departments": ["engineering", "design", "product", "bizops"],
  "tools": ["Slack", "GitHub", "Jira", "Confluence", "Google Workspace"],
  "roles": {
    "planner": "CEO",
    "servant_leader": "COO",
    "builders": ["Engineer_1", "Engineer_2"],
    "refiners": ["Product_Lead"],
    "ai_assistants": {
      "MeetingBot": "Schedules standups and retros",
      "DocBot": "Auto-generates tech specs & wiki pages",
      "OpsBot": "Manages recurring billing, compliance, onboarding"
    }
  },
  "infra_setup": {
    "slack_channels": ["#general", "#dev", "#support", "#standups"],
    "github_repos": ["mvp-backend", "mvp-frontend"],
    "jira_board": {
      "template": "agile-kanban",
      "default_sprints": ["MVP Planning", "Sprint 1", "Sprint 2"]
    }
  },
  "automation": {
    "on_new_employee": "trigger onboarding pipeline",
    "on_pr_open": "link to Jira + notify #dev",
    "weekly_check": "generate sprint progress & team capacity report"
  }
}
```

---

## ⚙️ PMAC Auto-Generated Setup (via GitHub Actions + APIs)

### 🔧 Slack
- Create private workspace
- Add core channels: #general, #dev, #support, #standups
- Add onboarding workflow for all new members

### 🔧 GitHub
- Create org `pmac`
- Initialize `mvp-backend` and `mvp-frontend` repos with README + CI templates
- Configure protected branches + auto-link PRs to Jira

### 🔧 Jira
- Create project: "MVP Launch"
- Set board type to Agile Kanban
- Load issues from `pmac/sprints/sprint1.json`
- Integrate with GitHub + Slack

### 🔧 Google Workspace
- Create team email addresses + groups
- Sync calendars with sprint plans and standups

### 🤖 AI Assistant Configs
- `MeetingBot` sets up standups at 9am in each region
- `DocBot` turns GitHub README + PRs into Confluence pages
- `OpsBot` sends monthly compliance reminders, team surveys, onboarding checklists

---

## 🧠 Escalation Rules

### `escalation_rules.json`
```json
{
  "defaults": { "max_response_time_hours": 24, "on_failure": "escalate_to_role:planner" },
  "roles": {
    "builder": {
      "alternate": "ai_assistants.OpsBot",
      "escalate_if_blocked": "servant_leader"
    },
    "support": {
      "alternate": "admin",
      "escalate_if_blocked": "planner"
    }
  }
}
```

---

## 🧪 Example Day 1 Outcome
After running `pmac_bootstrap.py` with this config:
- Slack is ready with roles invited
- GitHub repos exist and are CI-enabled
- Jira has all sprint tasks ready
- Docs and standup invites are scheduled
- Everyone knows their role
- No one needs to manually configure tools

---

## 💡 Benefits for Startups
- Save **days to weeks** of manual setup time
- Ensure **structure without slowing speed** and best practices
- Create **audit trail** from day 1
- Prevent drift and team confusion
- Enable seamless **AI + human hybrid work** from the start

---

**PMAC turns your funded idea into an operating machine in 24 hours.**

**GitHub Repo:** https://github.com/schneidergithub/pmac  
**Contact:** Aaron Schneider 