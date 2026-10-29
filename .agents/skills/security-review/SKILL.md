---
name: security-review
description: Independent pre-commit security audit evaluating git diffs for secret leaks, injection flaws, OWASP vulnerabilities, and unsafe dependencies.
argument-hint: "[fixed-point-ref (e.g. main, HEAD~1, branch)]"
disable-model-invocation: true
origin: "workflow/triage-team (MIT)"
---

# Security Review

Perform an independent, adversarial security evaluation of proposed bug fixes prior to PR creation.

## Responsibilities & Constraints
- **Role**: Executed by the **Security Agent**.
- **Boundaries**: Evaluates security posture, credentials, and threat surface. Does **not** re-verify functional test suites (owned by QA) or write production patches (owned by Developer).

---

## The 5 Security Checkpoints

### Checkpoint 1: Secret & Credential Leakage
Inspect all added/modified lines in the diff (`git diff <base>...HEAD`):
- API keys, JWTs, OAuth tokens, AWS/GCP keys, private keys, database connection strings, passwords.
- Verify test fixtures or mock data do not contain real credentials or production PII.

### Checkpoint 2: Injection & Parsing Vulnerabilities
Evaluate modified parsing or input-handling logic:
- SQL / NoSQL injection seams (parameterization vs string concatenation).
- OS Command Injection (`exec`, `spawn`, `subprocess` with shell=True, unescaped user input).
- Cross-Site Scripting (XSS), unsafe HTML rendering, or innerHTML injection.
- Unsafe deserialization or path traversal (`../` directory traversal in file lookups).
- ReDoS: Unbounded regular expressions executed against untrusted input.

### Checkpoint 3: Authentication & Authorization Boundaries
Ensure the bug fix does not inadvertently bypass permissions:
- Route guards, role-based access checks, or session validations.
- Insecure direct object references (IDOR).

### Checkpoint 4: Dependency & Package Hygiene
- Were any new external packages or packages-lock changes introduced?
- Check whether new dependencies are legitimate, pinned, and free from known CVEs.

### Checkpoint 5: Information Disclosure & Error Leakage
- Ensure stack traces, internal IP addresses, database schemas, or system paths are not exposed in production API responses or customer-facing error messages.

---

## Deliverable & Verdict

Generate `.triage/<issue-id>/security-audit.md`:
```markdown
# Security Audit Report: [Issue ID]

- **Verdict**: [APPROVED | BLOCKED]
- **Auditor**: Security Agent
- **Diff Evaluated**: `[Base Commit]...[Head Commit]`

## Checklist
- [ ] No hardcoded secrets or PII
- [ ] No injection vectors introduced (SQL, Shell, XSS, Path Traversal)
- [ ] Authorization / authentication boundaries intact
- [ ] No vulnerable or unpinned dependencies added
- [ ] Error messages do not leak internal system details

## Findings & Remediation (If Blocked)
[Details of any blocker with line numbers and required remediation]
```
