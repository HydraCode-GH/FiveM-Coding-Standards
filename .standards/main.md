# FiveM Standards Map

Use this file as the entry point for all coding standards.

## Files

- [events.md](events.md): Event naming, registration style, and network exposure rules.
- [citizen-functions.md](citizen-functions.md): `Citizen.` alias guidance and preferred runtime helpers.
- [exports-and-communication.md](exports-and-communication.md): Exports vs events and client/server communication patterns.
- [exports.md](exports.md): Export implementation standard and code-first export registration.
- [server-validation.md](server-validation.md): Server-side validation and anti-cheat safety checks.
- [naming-conventions.md](naming-conventions.md): Naming rules for variables, functions, events, exports, and booleans.
- [file-naming.md](file-naming.md): File naming rules and structure patterns.
- [documentation.md](documentation.md): Function documentation with `---@param` and `---@return` annotations.
- [fxmanifest.md](fxmanifest.md): Required `fxmanifest.lua` structure and conventions.
- [ox-lib.md](ox-lib.md): Standard patterns for using `ox_lib`.
- [framework/main.md](framework/main.md): Shared framework bridge and separated ESX/QBCore/Qbox standards.
- [framework/implementation.md](framework/implementation.md): Step-by-step framework implementation guide.
- [deprecated-patterns.md](deprecated-patterns.md): Legacy patterns to avoid and modern replacements.

## Suggested Read Order

1. `events.md`
2. `exports-and-communication.md`
3. `exports.md`
4. `server-validation.md`
5. `naming-conventions.md`
6. `file-naming.md`
7. `documentation.md`
8. `fxmanifest.md`
9. `framework/main.md`
10. `framework/implementation.md`
11. `ox-lib.md`
12. `citizen-functions.md`
13. `deprecated-patterns.md`
