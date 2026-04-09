# Framework Standards

Use a shared framework bridge so gameplay code stays framework-agnostic.

## Files

- [implementation.md](implementation.md): Step-by-step framework implementation pattern.
- [shared.md](shared.md): Shared detection/bridge rules used by all frameworks.
- [editable.md](editable.md): Editable extension points for notifications, dispatch, and integrations.
- [esx.md](esx.md): ESX-specific integration rules.
- [qbcore.md](qbcore.md): QBCore-specific integration rules.
- [qbox.md](qbox.md): Qbox-specific integration rules.

## Core Requirement

- Framework detection and common wrappers belong in shared code.
- Feature logic should call shared wrappers, not framework APIs directly.
- Keep framework-specific implementations isolated in their own files.
