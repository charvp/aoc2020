with builtins; with (import ../util.nix);
let
  input = readFile ./input;
  bin2dec = l:
    let
      cur = head l;
      num = if cur == "B" || cur == "R" then pow ((length l) - 1) 2 else 0;
      rest = bin2dec (tail l);
    in
    if l == [ ] then 0 else num + rest;
  sorted = sort (x: y: x > y) (map bin2dec (map stringToList (splitNonEmptyLines input)));
  skipped = l:
    if head l == (elemAt l 1) + 1 then
      skipped (tail l) else
      (elemAt l 0) - 1;
in
{
  day05-1 = head sorted;
  day05-2 = skipped sorted;
}
