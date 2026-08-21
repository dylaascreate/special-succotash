# Azure DevOps Tools: Comprehensive Notes

## Overview
Azure DevOps is a cloud-based suite of collaborative software development tools provided by Microsoft. It supports the entire software development lifecycle (SDLC) by offering a set of modern DevOps services for planning, developing, delivering, and maintaining applications. It can be used as a cohesive whole or as individual, integrated services.

---

## 1. Azure Boards
**Purpose:** Agile project management, work item tracking, and reporting.

*   **Work Items:** Track bugs, epics, features, user stories, and tasks.
*   **Kanban & Scrum:** Built-in boards and sprint planning tools that natively support Agile, Scrum, and CMMI frameworks.
*   **Dashboards & Reporting:** Customizable dashboards to monitor project health, sprint burndowns, and team velocity.
*   **Integration:** Easily links commits, pull requests, and builds directly to work items for full traceability.

## 2. Azure Repos
**Purpose:** Source control management (SCM).

*   **Git Repositories:** Free, private, unlimited Git repositories for distributed version control.
*   **Team Foundation Version Control (TFVC):** Centralized version control for teams that require it.
*   **Pull Requests:** Advanced PR workflows with inline discussions, required reviewer policies, and automated branch protection.
*   **Semantic Search:** Code-aware search across all projects and repositories to easily find functions, classes, or configuration details.

## 3. Azure Pipelines
**Purpose:** Continuous Integration and Continuous Delivery (CI/CD).

*   **Language & Platform Agnostic:** Supports Node.js, Python, Java, PHP, C++, .NET, Android, iOS, and more.
*   **Cloud Native:** Easily deploys to Kubernetes, serverless architectures, Azure web apps, AWS, or GCP.
*   **YAML-based pipelines:** Define builds and deployments as code (`azure-pipelines.yml`) alongside the application code.
*   **Release Management:** Multi-stage deployments with automated testing, manual approval gates, and environment-specific variables.
*   **Extensible:** A massive marketplace of tasks to integrate with third-party tools like SonarQube, Jenkins, and Docker.

## 4. Azure Test Plans
**Purpose:** Manual, exploratory, and automated testing management.

*   **Test Management:** Plan, execute, and track scripted tests with actionable defects tied directly to Azure Boards.
*   **Exploratory Testing:** Browser extensions allow QA engineers to capture screenshots, record user steps, and document bugs on the fly without pre-defined test scripts.
*   **User Acceptance Testing (UAT):** Allows stakeholders to provide feedback directly into the DevOps ecosystem.
*   **Traceability:** End-to-end traceability from requirements to test cases and deployment stages.

## 5. Azure Artifacts
**Purpose:** Package management and distribution.

*   **Universal Package Management:** Create, host, and share Maven, npm, NuGet, and Python packages.
*   **Upstream Sources:** Cache packages from public registries (like npmjs or PyPI) to ensure they remain available even if the public source goes down.
*   **Seamless Pipeline Integration:** Easily publish and consume packages within Azure Pipelines while maintaining strict version control and security protocols.

---

## Key Benefits of Azure DevOps

1.  **Flexibility:** You can use the entire suite or pick specific services (e.g., using GitHub for repos but Azure Pipelines for CI/CD).
2.  **Extensibility:** The Azure DevOps Marketplace contains hundreds of extensions (e.g., Slack integrations, time trackers, security scanners).
3.  **Security and Compliance:** Built-in compliance standards, enterprise-grade security, and role-based access control (RBAC).
4.  **Cloud & On-Premises:** Available as a hosted cloud service (Azure DevOps Services) or as an on-premises deployment (Azure DevOps Server, formerly TFS).