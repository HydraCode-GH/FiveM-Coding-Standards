# FiveM Standards Map

Use this file as the entry point for all coding standards.

## Files

- [readme.md](readme.md): How to write a resource README.
- [require.md](require.md): `require`, `lib.load`, and `lib.loadJson` — when and how to use each.
- [sql.md](sql.md): OxMySQL wrapper usage and function reference.
- [debug.md](debug.md): Structured print/debug system (`libs/shared/debug.lua`).
- [events.md](events.md): Event naming, registration style, and network exposure rules.
- [citizen-functions.md](citizen-functions.md): `Citizen.` alias guidance and preferred runtime helpers.
- [communication.md](communication.md): Event-based communication patterns and client/server flow rules.
- [exports.md](exports.md): Export implementation standard and code-first export registration.
- [server-validation.md](server-validation.md): Server-side validation and anti-cheat safety checks.
- [naming-conventions.md](naming-conventions.md): Naming rules for variables, functions, events, exports, and booleans.
- [file-naming.md](file-naming.md): File naming rules and structure patterns.
- [documentation.md](documentation.md): Function documentation with `---@param` and `---@return` annotations.
- [fxmanifest.md](fxmanifest.md): Required `fxmanifest.lua` structure and conventions.
- [libs.md](libs.md): Reusable libs folder structure and version checker/versioning files.
- [ox-lib.md](ox-lib.md): Standard patterns for using `ox_lib`.
- [framework.md](framework.md): Framework bridge standard using `libs/shared/framework.lua`.
- [deprecated-patterns.md](deprecated-patterns.md): Legacy patterns to avoid and modern replacements.

## Suggested Read Order

1. `readme.md`
2. `naming-conventions.md`
3. `file-naming.md`
4. `fxmanifest.md`
5. `require.md`
6. `debug.md`
7. `sql.md`
8. `events.md`
9. `communication.md`
10. `exports.md`
11. `server-validation.md`
12. `documentation.md`
13. `libs.md`
14. `framework.md`
15. `ox-lib.md`
16. `citizen-functions.md`
17. `deprecated-patterns.md`
