with builtins; with (import ../util.nix);
let
  input = readFile ./input;
  splitLines = splitNonEmptyLines input;
  goDown = right: down: pos: remainder:
    let
      cur = head remainder;
      l = stringToList cur;
      char = elemAt l pos;
      extra = if char == "#" then 1 else 0;
      newPos =
        if (pos + right) >= (length l) then
          pos + right - (length l) else
          pos + right;
      rest =
        if length remainder > down then
          goDown right down newPos (apply down tail remainder) else
          0;
    in
    if remainder == [ ] then 0 else
    extra + rest;
  slopes = [ [ 1 1 ] [ 3 1 ] [ 5 1 ] [ 7 1 ] [ 1 2 ] ];
  counts = map (s: goDown (elemAt s 0) (elemAt s 1) 0 splitLines) slopes;
in
{
  day03-1 = goDown 3 1 0 splitLines;
  day03-2 = foldl' mul 1 counts;
}
