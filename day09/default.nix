with builtins; with (import ../util.nix);
let
  input = readFile ./input;
  numbers = map parseInt (splitNonEmptyLines input);
  windows = numbers: curRange:
    let
      correctSums = filter (p: (head numbers) == p.sum) (pairs curRange);
      newNumbers = tail numbers;
      newRange = (tail curRange) ++ [ (head numbers) ];
    in
    if length correctSums == 0 then head numbers else windows newNumbers newRange;
  contiguous = numbers: toFind: curRange: curSum:
    let
      added = curSum + (head numbers);
      newSum =
        if added <= toFind
        then added
        else curSum - (head curRange);
      newNumbers = if added <= toFind then (tail numbers) else numbers;
      newRange = if added <= toFind then curRange ++ [ (head numbers) ] else tail curRange;
    in
    if added == toFind then newRange else contiguous newNumbers toFind newRange newSum;
in
rec {
  day09-1 = windows (dropN 25 numbers) (takeN 25 numbers);
  day09-2 =
    let
      range = contiguous numbers day09-1 [ ] 0;
    in
    (min range) + (max range);
}
