To get the result for a specific (part of a) day:

```
$ nix-instantiate --eval -A day$day-$part
```
Or, on a system with flakes:
```
$ nix eval .#day$day-$part
```
