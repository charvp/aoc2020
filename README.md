To get the result for a specific (part of a) day:

```
> nix-build -A packages.x86_64-linux.day$day-$part default.nix
```
Or, on a system with flakes:
```
> nix build .#day$day-$part
```

`cat result` to actually see the result.
