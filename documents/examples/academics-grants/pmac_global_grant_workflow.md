# 🌍 Global Grant Proposal Workflow with PMAC: Hybrid Team + Escalation Handling

## 🧪 Scenario

You’re part of a **globally distributed academic team** applying for a multimillion-dollar NSF/NIH grant with international partners. The team uses **PMAC** to encode everything: team roles, sprint tasks, AI bots, and escalation policies—so that **when things go wrong**, the system knows how to respond.

---

### Team Structure

- **Principal Investigator (PI)** – USA  
- **Co-PI** – Australia  
- **Co-PI** – Germany  
- **Grant Writer** – USA  
- **Admin Assistant** – Philippines  
- **PhD Students** – Brazil & India  
- **AI Assistants** – SummarizerBot, ComplianceBot, ReviewBot  

The project includes:  
- A 40-page proposal  
- Budget sheets and justifications  
- International forms  
- Letters of support  
- Biosketches  
- Gantt chart and logic model  
- Revisions and reviewer feedback  

---

## 😩 Common Pain Points for Global Teams

| **Pain Point**         | **Example**                          | **PMAC Solution**                                      |
|-------------------------|--------------------------------------|-------------------------------------------------------|
| **Time Zone Delays**    | Overnight waits for feedback         | Task handoffs use regional config and AI bridging     |
| **Role Confusion**      | Who owns what section?               | JSON-defined role ownership with auto-reassignments   |
| **Sick or Missing Staff** | Co-PI is sick; task stuck           | Escalation policies reassign or notify alternates     |
| **Review Loops**        | Reviewer doesn't respond             | AI bot summarizes and auto-progresses                |
| **Proposal Rejected**   | Agency requests major edits          | Emergency sprint is created and roles are reassigned  |

---

## ✅ PMAC Features in Action

### 1. 🧱 Hybrid Team Defined in Code

**File: `team/roles.json`**

```json
{
  "planner": "PI_USA",
  "builders": ["GrantWriter_US", "PhD_India", "PhD_Brazil"],
  "reviewers": ["CoPI_AUS", "CoPI_GER"],
  "support": ["Admin_PH"],
  "ai_assistants": {
    "SummarizerBot": "OpenAI",
    "ComplianceBot": "Validator",
    "ReviewBot": "AI Reviewer"
  }
}
```

---

### 2. 🛠️ Region & Timezone-Aware Task Config

**sprints/sprint1.json**
```json
{
  "summary": "Draft Methods Section",
  "owner": "PhD_India",
  "region": "Asia",
  "handoff_to": "SummarizerBot",
  "due": "2025-05-10T04:00Z"
}
```

---

### 3. 🤖 AI Boundaries

**policy/ai_bounds.json**
```json
{
  "SummarizerBot": {
    "can_edit_sections": ["Introduction", "Background"],
    "must cite sources": true,
    "must run grammar/language style check": true
  },
  "ComplianceBot": {
    "checklist": ["Page limits", "Biosketch date", "Budget format"],
    "notify_if_failed": true
  }
}
```

---

### 4. 🚨 Escalation Handling

**escalation_rules.json**
```json
{
  "defaults": {
    "max_response_time_hours": 24,
    "on_failure": "escalate_to_role:planner"
  },
  "roles": {
    "reviewer": {
      "alternate": "ai_assistants.ReviewBot",
      "escalate_if_blocked": "support"
    },
    "support": {
      "alternate": "admin_backup",
      "escalate_if_blocked": "planner"
    }
  },
  "tasks": {
    "Grant Narrative - Edits Round 2": {
      "owner": "CoPI_AUS",
      "on_blocked": "auto_reassign_to:PhD_India"
    }
  }
}
```

---

### 5. ⏱️ Emergency Sprint Auto-Creation

**sprints/sprint_emergency_edits.json**
```json
{
  "name": "Emergency Edits Sprint",
  "trigger": "agency_request",
  "stories": [
    {
      "summary": "Rewrite Broader Impacts",
      "owner": "GrantWriter_US"
    },
    {
      "summary": "Reformat Budget Appendix",
      "owner": "ComplianceBot"
    }
  ]
}
```

---

### 6. 🧠 Notifications & Logs

PMAC logs escalations and sends messages like:
> ⚠️ `Task ‘Finalize Budget Justification’ overdue. Auto-reassigned to GrantWriter_US. Notified PI_USA.`

---

## 🎯 Benefits Recap

| Benefit | PMAC Impact |
|--------|----------------|
| ⏰ 24/7 Productivity | AI fills in during human downtime |
| 🔀 Automated Handoffs | Time zones and outages no longer block progress |
| 🔍 Transparent State | Git tracks who owns what and what changed |
| 🔁 Rapid Recovery | Emergency sprints and auto-escalations keep deadlines alive |
| 📚 Reusability | Clone workflows from last year’s grant and adapt instantly |

---

PMAC increases confidence for global academic teams with failure responses built in.

**Learn More:** 
https://github.com/schneidergithub/pmac
