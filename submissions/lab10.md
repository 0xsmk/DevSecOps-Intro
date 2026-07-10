# Lab 10 — Submission

## Task 1: DefectDojo Setup + Import

### DefectDojo version

- Compose checkout: `django-DefectDojo` tag `2.58.4`
- Running app version: `2.58.4`
- Images: `defectdojo/defectdojo-django:2.58.4`, `defectdojo/defectdojo-nginx:2.58.4`
- Local URL: `http://localhost:8080`
- Admin user: `admin`
- Initializer admin password: `pZad9vDOktHBpVvkrBosOJ`

### Product + Engagement

- Product ID: `1`
- Product name: `OWASP Juice Shop`
- Engagement ID: `1`
- Engagement name: `Course Semester Run`
- Engagement status: `In Progress`
- SLA configuration ID: `3`

### Imports completed

| Lab | Scan type | File | Test ID | Findings imported |
|-----|-----------|------|--------:|------------------:|
| 4 | Anchore Grype | `labs/lab4/grype-from-sbom.json` | 1 | 104 |
| 4 | Trivy Scan | `labs/lab4/trivy.json` | 2 | 113 |
| 5 | Semgrep JSON Report | `labs/lab5/results/semgrep.json` | 3 | 22 |
| 5 | ZAP Scan | `labs/lab5/results/auth-report.json` converted to ZAP XML | 4 | 6 |
| 6 | Checkov Scan | `labs/lab6/results/checkov-terraform/results_json.json` | 5 | 80 |
| 6 | KICS Scan | `labs/lab6/results/kics-ansible/results.json` | 6 | 10 |
| 6 | KICS Scan | `labs/lab6/results/kics-pulumi/results.json` | 7 | 6 |
| 7 | Trivy Scan (image) | `labs/lab7/results/trivy-image.json` | 8 | 50 |
| 7 | Trivy Operator Scan | `labs/lab7/results/trivy-k8s.json` | 9 | 0 |
| 9 | Falco runtime log | `labs/lab9/falco/logs/falco.log` | n/a | Not imported: custom runtime log format |
| **Total raw imports** | | | | **391** |
| **After dedup** | | | | **389 active unique findings** |

ZAP note: DefectDojo `2.58.4` exposes `ZAP Scan` as an XML parser. The Lab 5 artifact is JSON, so I converted the same report content to OWASP ZAP XML in `labs/lab10/work/auth-report-zap.xml` before import.

### Dedup example

- CVE/ID: `CVE-2026-45447` in `libssl3t64:3.5.5-1~deb13u2`
- Source tools: 3 — Grype SBOM, Trivy Lab 4, Trivy image Lab 7
- Canonical DefectDojo finding ID: `12`
- Duplicate findings marked inactive: `119`, `342`

## Task 2: Governance Report

### Executive Summary

Juice Shop was scanned across SCA, SAST, DAST, IaC, image, Kubernetes, signing, and runtime layers, with 389 active findings after deduplication. The current open backlog contains 17 Critical and 162 High findings, so remediation should focus first on exploitable package and image vulnerabilities before lower-severity hardening work. No findings were closed in this DefectDojo period, so MTTR is not yet measurable from closed records.

### SLA matrix applied

SLA configuration `Lecture 9/10 SLA` was created through the DefectDojo API and assigned to the product:

| Severity | SLA |
|----------|----:|
| Critical | 1 day / 24 hours |
| High | 7 days |
| Medium | 30 days |
| Low | 90 days |

### Findings by severity (active only)

| Severity | Count |
|----------|------:|
| Critical | 17 |
| High | 162 |
| Medium | 170 |
| Low | 28 |
| Info | 12 |

### Findings by source tool

| Tool / test | Active | Mitigated | False Positive | Risk Accepted | Duplicate | Total |
|-------------|-------:|----------:|---------------:|--------------:|----------:|------:|
| Anchore Grype | 104 | 0 | 0 | 0 | 0 | 104 |
| Trivy Scan (Lab 4) | 112 | 0 | 0 | 0 | 1 | 113 |
| Semgrep JSON Report | 22 | 0 | 0 | 0 | 0 | 22 |
| ZAP Scan | 6 | 0 | 0 | 0 | 0 | 6 |
| Checkov Scan | 80 | 0 | 0 | 0 | 0 | 80 |
| KICS Scan (Ansible) | 10 | 0 | 0 | 0 | 0 | 10 |
| KICS Scan (Pulumi) | 6 | 0 | 0 | 0 | 0 | 6 |
| Trivy Scan (image) | 49 | 0 | 0 | 0 | 1 | 50 |
| Trivy Operator Scan | 0 | 0 | 0 | 0 | 0 | 0 |

### Program metrics

- **MTTD**: 0 days. All reports were imported into DefectDojo on the same day they were processed for this lab.
- **MTTR**: n/a. There are 0 mitigated findings in this DefectDojo period.
- **Vuln-age median**: 0 days for open findings.
- **Backlog trend**: -2 findings versus the raw imported baseline after deduplicating `CVE-2026-45447`.
- **SLA compliance**: 100.0% for 377 active Critical/High/Medium/Low findings; all were detected on 2026-07-10 and are still inside the configured SLA windows.

### Risk-accepted items

No findings were risk accepted. This keeps the program conservative: any future accepted risk must include an owner, reason, and explicit expiry date.

### Next-quarter goal

Next quarter I would mature OWASP SAMM **Defect Management** by moving from one-time aggregation to continuous vulnerability intake with enforced ownership. The current dataset has 179 Critical/High active findings and no closed findings, so the concrete target is to assign owners for all Critical/High items, close or formally risk-accept the top 25, and reduce High/Critical MTTR below 7 days.

## Bonus: Interview Walkthrough

- Walkthrough script: see `submissions/lab10-walkthrough.md`
- Practiced runtime: approximately `4:45`
- Two anticipated Q&A questions covered: yes
- Strongest claim in the script: "I turned separate scanner outputs into a vulnerability-management program with ownership, SLA pressure, deduplication, and measurable backlog."
