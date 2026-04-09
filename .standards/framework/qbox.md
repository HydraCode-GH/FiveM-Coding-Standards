# Qbox Standards

## Detection

- Detect Qbox through resource state and configured framework preference.
- Keep detection inside shared framework bridge, not feature files.

## Integration Rules

- Treat Qbox as a first-class framework type (`Framework.Type = 'qbox'`).
- Implement Qbox wrappers in shared bridge functions.
- Keep feature modules framework-agnostic and wrapper-driven.

## Guidance

- Use the same wrapper surface as ESX/QBCore.
- Keep notify/admin/job helpers behaviorally consistent across frameworks.
- If project uses Qbox-compatible QB APIs, still route through wrappers to avoid lock-in.
