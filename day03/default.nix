with builtins;
let
  input = readFile ./input;
  splitLines = filter (x: x != "") (filter isString (split "\n" input));
  stringToChars = s: map (x: elemAt x 0) (filter isList (split "(.)" s));
  apply = c: f: e: if c == 0 then e else f (apply (c - 1) f e);
  goDown = right: down: pos: remainder:
    let
      cur = head remainder;
      l = stringToChars cur;
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
