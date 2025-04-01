# Disaster Recovery & Self-Healing Playbook – Dentist Office

## 1. Staff Unavailable
- Detect via Slack/LeaveBot or AI scheduler conflict
- Lookup `coverage-policy-v1.md` to identify backup staff
- Notify both substitute and original assignee
- AI schedules the shift automatically if backup confirms

## 2. AI Receptionist Unresponsive
- Ping check every 2 mins
- If 3 checks fail, escalate to:
  - Human front desk staff (SMS + email)
  - Trigger Office Dashboard alert
- Auto-restart container if hosted on clinic VM

## 3. Insurance Billing Failure
- Monitor return codes from insurance gateway
- Log errors to `billing_logs/errors/`
- Send summary report via email with retries up to 3x
- If exceeded, escalate to Billing Supervisor (AI or human)

## 4. Reschedule Patient No-Shows
- Detect no-show based on time slot check-in absence
- Flag record in database
- Send SMS/email to patient with smart reschedule form
- Notify admin if repeat offender

## 5. Daily Test: Self-Healing Status
- Validate AI agent reachability
- Validate calendar sync
- Confirm API endpoints with `/status` healthcheck
- Output to `selfheal_report.log`
