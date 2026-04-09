# Citizen Functions

## Rule

- Prefer aliases over the `Citizen.` prefix where aliases exist.

## Example

```lua
-- Don't
Citizen.CreateThread(function()
  Citizen.Wait(1000)
end)

-- Do
CreateThread(function()
  Wait(1000)
end)
```

## Allowed Without Prefix

- `CreateThread`
- `Wait`
- `SetTimeout`
- `RconPrint`

## Alias Reference

| Original | Alias |
|----------------------|------------------|
| Citizen.CreateThread | CreateThread     |
| Citizen.Wait         | Wait             |
| Citizen.SetTimeout   | SetTimeout       |
| Citizen.Trace        | separate debugPrint function |
