with builtins; with (import ../util.nix);
let
  input = readFile ./input;
  numbers = map parseInt (splitNonEmptyLines input);
  sorted = sort lessThan numbers;
  countDifferences = numbers:
    let
      cur = head numbers;
      next = head (tail numbers);
      diff = { "${toString (next - cur)}" = 1; };
      recur = countDifferences (tail numbers);
    in
    if length numbers >= 2
    then combine recur diff add
    else { };
  countPaths = numbers: prevResults:
    let
      cur = head numbers;
      curTotal = sum (genList (x: prevResults."${toString (cur - x - 1)}" or 0) 3);
      nextResults = prevResults // { "${toString cur}" = curTotal; };
    in
    if length numbers == 1
    then nextResults."${toString cur}"
    else countPaths (tail numbers) nextResults;
in
{
  day10-1 = let result = countDifferences ([ 0 ] ++ sorted ++ [ ((max numbers) + 3) ]); in result."1" * result."3";
  day10-2 = countPaths sorted { "0" = 1; };
}
