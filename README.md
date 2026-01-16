# Project Management as Code (PMAC)

## Executive Summary
Project Management as Code (PMAC) is a modern approach to managing projects by encoding all elements of project governance, delivery, and collaboration into structured, version-controlled artifacts. PMAC extends the principles of GitOps to the domain of human and AI collaboration, providing a single source of truth for project scope, team roles, task execution, and system state. By embedding project logic in code, PMAC enables automation, reproducibility, and intelligent augmentation across the software delivery lifecycle.

---

## Introduction
Traditional project management tools often rely on disconnected documents, siloed communication, and manual workflows. PMAC addresses these challenges by treating project management itself as a form of infrastructure — defined declaratively, versioned in Git, and enforced by automation tools.

This approach bridges the gap between DevOps, Agile, and strategic planning, enabling:
- Automated project bootstrapping
- Human-AI hybrid team orchestration
- Intelligent backlog management
- Drift detection between planned and actual execution

---

## Core Principles

### 1. **Git as the Source of Truth**
All PMAC data — including epics, user stories, team structure, SLAs, and infrastructure configurations — is stored in a Git repository. This provides transparency, auditability, and rollback capabilities.

### 2. **Declarative JSON Structure**
The project is defined using structured JSON files, with schemas for:
- Team roles and assignments
- Sprint plans and tasks
- Environment configuration (infrastructure, application versions)
- Automation policies and testing expectations

### 3. **Test-Driven Project Management**
Each task and environment state includes validation scripts and acceptance tests. Drift between declared and actual state becomes a test failure.

### 4. **Hybrid Human-AI Collaboration**
PMAC supports AI bots as team members who participate in planning, reviewing, testing, and documentation. These agents are swappable with human roles using a common role schema.

### 5. **Lifecycle Automation**
PMAC projects can automatically:
- Bootstrap full companies - create & integrate git repositories, project management (jira), communication (email, slack, teams, etc), HR, finance
- Create Jira issues and Confluence documentation
- Track drift from desired state
- Generate next sprint tasks based on project history and AI suggestions

---

## Use Case: GitOps + PMAC
A GitOps project may define Kubernetes deployment YAMLs and Terraform infrastructure as code. PMAC adds:
- Team ownership and escalation policies
- Drift reports converted to Jira stories
- Approval workflows for promoting future state to desired state
- Full project reproducibility from Git

---

## Benefits

### Reproducibility
Entire project environments and workflows can be cloned and re-run.

### Observability
Every change to infrastructure, team structure, or policy, is versioned & trackable.

### Automation
CI/CD, testing, documentation, and reporting are all codified & executable.

### Human / AI collaboration
AI is embedded into daily workflows without replacing human accountability.

 

---

## Summary: 
This focus on project management offers a unified approach to planning, executing, and scaling modern software projects. By merging the rigor of GitOps with the flexibility of Agile, and embedding AI automation upfront facilitates automation to a higher degree.  

It's amazing to watch how a small improvement to project management can have exponential gains in productivity. 

---

*Author: Aaron Schneider*
*Date: 2025-04-01*

