# PMAC Scenario: RCP Update with Escalation Workflow

This scenario demonstrates the use of traditional compute, AI remediation, human escalation, and post-incident automation using PMAC with MCP integration.

## Workflow Overview

1. **Traditional Program (rcp_updater)** triggers a config update across 300 endpoints.
2. **AI Bot (ai_config_remediator)** retries after failures are detected.
3. **Support Engineer (human)** investigates and fixes IAM permission errors.
4. **AI Bot** retries successfully after human intervention.
5. **Audit Agent** logs post-incident report.
6. **Validator Bot** confirms the fix and adds validation task to automation queue.

## Artifacts

- `pmac_context.json` (this file): MCP-compatible project definition.
- `rcp_update.feature`: Gherkin test suite for the incident flow.