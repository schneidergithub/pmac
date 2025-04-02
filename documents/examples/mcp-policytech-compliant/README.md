
# PMAC + Model Context Protocol (MCP)

This project integrates the [Anthropic Model Context Protocol](https://www.anthropic.com/news/model-context-protocol) into PMAC (Project Management as Code) to provide structured context for LLM agents.

## Key Additions

- **context_id**: Ties all tasks, documents, and roles together under a unified project ID.
- **roles**: Declares who (or what) is responsible for each task — includes AI, humans, and compute agents.
- **goals**: High-level objectives that guide the project execution.
- **documents**: Relevant artifacts such as policies, Gherkin tests, or Markdown guides.
- **tasks**: Individual responsibilities that can be tracked by Jira, GitHub, or manual logs.
- **state**: Captures current status and next actions — useful for autonomous agents.
- **metadata**: Adds useful tags, versioning, and authorship to support reuse and traceability.

## Usage

You can drop `pmac_context.json` into any PMAC project and load it into an AI system that supports the MCP format (such as Anthropic's Claude or integrated multi-agent frameworks).

