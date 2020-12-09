with builtins; with (import ../util.nix);
let
  input = readFile ./input;
  numbers = map parseInt (splitNonEmptyLines input);
  listForIndex = i: if i < 25 then [ ] else takeN 25 (dropN (i - 25) numbers);
  correctSums = x: filter (p: p.sum == x.val) (pairs (listForIndex x.i));
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
  day09-1 = (head (filter (x: length (correctSums x) == 0) (dropN 25 (eachWithIndex numbers)))).val;
  day09-2 = let range = contiguous numbers day09-1 [ ] 0; in
    (min range) + (max range);
}
