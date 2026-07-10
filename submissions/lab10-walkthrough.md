# 5-Minute DevSecOps Program Walkthrough — Juice Shop

## (0:00-0:30) Context

I built a DevSecOps vulnerability-management program around OWASP Juice Shop as the target application. The scope covered dependency and image scanning, SAST, authenticated DAST, IaC scanning, Kubernetes checks, Cosign verification, Falco runtime detection, and DefectDojo aggregation with an SLA model.

## (0:30-2:00) Layers

The program starts before code reaches production. At the pre-commit layer, the course workflow used secret scanning and SSH-signed commits to protect source integrity. At build time, Syft produced an SBOM, Grype and Trivy found dependency and image vulnerabilities, and Semgrep found source-level issues in the Juice Shop codebase.

Before deployment, Checkov and KICS reviewed Terraform, Ansible, and Pulumi infrastructure definitions, while Cosign signing and verification proved image integrity. At runtime, Falco provided syscall-level detection for behaviors like shell execution and unexpected writes inside containers. DefectDojo then became the program layer: it aggregated findings, tracked deduplication, applied the Critical/High/Medium/Low SLA matrix, and gave a single backlog for remediation.

## (2:00-3:00) Findings + Closures

After importing the reports, DefectDojo held 391 raw findings and 389 active findings after deduplication. The most important correlated example was `CVE-2026-45447` in `libssl3t64`, seen by Grype, Trivy Lab 4, and the Trivy image scan; I kept finding `12` as canonical and marked the other two as duplicates.

No findings were closed in this DefectDojo reporting period, so I would not claim MTTR improvement yet. I also did not risk-accept any findings; that was deliberate because accepted risk without owner and expiry is a governance failure. If a business owner later accepts risk, I would require an expiry date and review trigger.

## (3:00-4:00) Metrics

The active backlog is 389 findings: 17 Critical, 162 High, 170 Medium, 28 Low, and 12 Info. MTTD is 0 days because the scan reports were imported the same day, while MTTR is not measurable yet because there are no mitigated findings. Median open vulnerability age is 0 days, and SLA compliance is currently 100% across the 377 active findings covered by the SLA matrix. The useful management signal is backlog pressure: 179 Critical/High findings need ownership first.

## (4:00-4:30) Next Steps

If I had another quarter, I would mature OWASP SAMM Defect Management from reporting to enforced remediation ownership. The target would be to assign every Critical/High item, close or formally risk-accept the top 25, and bring High/Critical MTTR below 7 days.

## (4:30-5:00) Q&A Anticipation

**How would you handle a Log4Shell scenario?** I would start from the SBOM and DefectDojo inventory to identify affected components, then prioritize internet-facing and runtime-reachable services. I would use SCA and image scans to confirm exposure, open emergency remediation tickets for affected assets, verify patched images with Cosign, and monitor runtime behavior with Falco while remediation is underway.

**Why didn't you use IAST or paid tools?** For this course program I prioritized repeatable open-source controls that cover the SDLC end to end: SBOM, SCA, SAST, DAST, IaC, signing, runtime detection, and centralized vulnerability management. IAST or commercial scanners could improve signal quality, but they would not replace the need for ownership, deduplication, SLA discipline, and measurable remediation metrics.
