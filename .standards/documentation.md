# Documentation Standards

Document non-trivial functions with a short description and type annotations.

## Required For

- Public module functions
- Exported functions
- Complex validation or business logic helpers

## Format

- Add a one-line summary above the function.
- Use EmmyLua annotations for parameters and return values.
- Keep descriptions practical and specific.

## Example

```lua
--- Checks whether a vehicle belongs to an allowed class list.
---@param vehicle number Vehicle entity id.
---@return boolean is_allowed True if vehicle class is allowed.
local function isAllowedVehicleClass(vehicle)
    if not next(allowedClassLookup) then
        return true
    end
    return allowedClassLookup[GetVehicleClass(vehicle)] == true
end
```

## Notes

- Use meaningful parameter names.
- If a function can return `nil`, document it explicitly.
- Keep comments in sync with behavior when logic changes.
