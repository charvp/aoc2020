with builtins;
let
  input = readFile ./input;
  splitLines = filter (x: x != "") (filter isString (split "\n" input));
  stringToChars = s: map (x: elemAt x 0) (filter isList (split "(.)" s));
  pow = n: x: if n == 0 then 1 else x * (pow (n - 1) x);
  bin2dec = l:
    let
      cur = head l;
      num = if cur == "B" || cur == "R" then pow ((length l) - 1) 2 else 0;
      rest = bin2dec (tail l);
    in
    if l == [ ] then 0 else num + rest;
  sorted = sort (x: y: x > y) (map bin2dec (map stringToChars splitLines));
  skipped = l:
    if elemAt l 0 == (elemAt l 1) + 1 then
      skipped (tail l) else
      (elemAt l 0) - 1;
in
writeFile:
{
  day05-1 = writeFile "day05-1" (toString (head sorted));
  day05-2 = writeFile "day05-2" (toString (skipped sorted));
}
