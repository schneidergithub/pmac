Feature: Daily dental operations resilience

  Scenario: Handle patient cancellation
    Given a patient cancels their appointment
    When the AI receptionist receives the cancellation
    Then it should notify the office and offer the slot to a waitlist candidate

  Scenario: Staff member reports sick
    Given a dental team member is marked unavailable
    When a backup is defined in the coverage policy
    Then the system should notify the substitute and update the schedule

  Scenario: Post-cancellation follow-up
    Given a patient no-shows or cancels
    When the AI assistant processes the event
    Then it should send a personalized rescheduling message
