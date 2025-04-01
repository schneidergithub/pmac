# Bootstrap start-up

Traditional Way: It takes days or weeks to set up a project — repo structure, docs, Jira board, Slack channel, calendar invites.

PMAC Way:

One pmac.json file bootstraps:

GitHub repo

Jira project + stories

Confluence wiki space

CI/CD pipeline templates

Calendar templates with recurring meetings

🎯 Impact: A single declarative file replaces dozens of manual steps

# Drift Detection & Task Creation

Many project issues come from silent drift — misalignments between what's planned and what's actually deployed or delivered, or worse, misalignment of expected current state.

PMAC Innovation:

Drift between desired_state.yaml and observed_state.  Optional: Future state.

yaml triggers:

Auto-generated Jira ticket

Team-specific routing (builder, refiner, support)

AI-enhanced suggestion for remediation.  Think of dependabot for project management.  User stories are analyzed for enhancements and submitted as a PR.

🎯 Impact: Automation catches creeping risk before it escalates.

# Reusability of High-Impact Templates

Typical Issue: High-performing teams waste time reinventing process structure.

PMAC Solution:

Public/shared PMAC project templates encode:

Proven team configurations

Sprint goals, Gherkin tests, automated ceremonies / meetings.

Best-practice README, CI workflows

🎯 Impact: Repeatable setup gives teams a repeatable foundation for success.

# Hybrid Human & AI teams
Hybrid Human-AI Workload Distribution

Business Pain: Project managers spending time on routine coordination instead of strategy.

PMAC Enhancement:

AI bots (documenters, testers, reviewers) handle repetitive tasks

Rotating & backup roles ensure no single point of failure.  SLAs could be something like "if person is on PTO, reassign or update capacity & timeline"

AI and humans share the same schema, so substitution is seamless.

Impact: Treating AI like a coworker facilitates planning and simulations.  Hot-swappable roles, human-assisted AI / AI-assisted Human. 

#  Performance-Based Role Evaluation

Leadership Problem: Team delays stem from a few blocked or misassigned contributors.

PMAC Insight:

All roles and assignments are tracked in Git

Tasks are tagged with owners, timestamps, and pass/fail criteria

Drift in individual or team performance shows up as data, not blame

🎯 Impact: Data surfaces of accountability and improvement opportunities.