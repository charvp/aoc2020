with builtins; with (import ../util.nix);
let
  input = readFile ./input;
  grid = map stringToList (splitNonEmptyLines input);
  isInBounds = { i, j }: i >= 0 && i < length grid && j >= 0 && j < length (elemAt grid i);
  neighbourGrid =
    genList
      (i: genList
        (j: filter isInBounds [
          { i = (i + 1); j = (j + 1); }
          { i = (i + 1); j = (j - 1); }
          { i = (i + 1); j = j; }
          { i = (i - 1); j = (j + 1); }
          { i = (i - 1); j = (j - 1); }
          { i = (i - 1); j = j; }
          { i = i; j = (j + 1); }
          { i = i; j = (j - 1); }
        ])
        (length (elemAt grid i)))
      (length grid);
  visibleFor = grid: i: j: iDiff: jDiff:
    let
      row = elemAt grid i;
      elem = elemAt row j;
      newI = i + iDiff;
      newJ = j + jDiff;
      newRow = elemAt grid (i + iDiff);
      newElem = elemAt newRow (j + jDiff);
    in
    if newI < 0 || newI >= length grid || newJ < 0 || newJ >= length row
    then null
    else if newElem == "."
    then visibleFor grid newI newJ iDiff jDiff
    else { i = newI; j = newJ; };
  visibilityGrid =
    genList
      (i: genList
        (j: filter isAttrs (map (x: visibleFor grid i j x.i x.j) [
          { i = 1; j = 1; }
          { i = 1; j = -1; }
          { i = 1; j = 0; }
          { i = -1; j = 1; }
          { i = -1; j = -1; }
          { i = -1; j = 0; }
          { i = 0; j = 1; }
          { i = 0; j = -1; }
        ]))
        (length (elemAt grid i)))
      (length grid);
  isFilled = grid: i: j: elemAt (elemAt grid i) j == "#";
  countFilled = checkGrid: grid: i: j:
    length (filter (x: isFilled grid x.i x.j) (elemAt (elemAt checkGrid i) j));
  golIter = checkGrid: numForStateChange: grid:
    genList
      (i:
        let
          row = elemAt grid i;
        in
        genList
          (j:
            let
              elem = elemAt row j;
              filledOthers = countFilled checkGrid grid i j;
            in
            if elem == "L" && filledOthers == 0
            then "#"
            else if elem == "#" && filledOthers >= numForStateChange
            then "L"
            else elem
          )
          (length row)
      )
      (length grid);
  endStateP1 = fix (golIter neighbourGrid 4) grid;
  endStateP2 = fix (golIter visibilityGrid 5) grid;
  occupied = state: sum (map (x: length (filter (y: y == "#") x)) state);
in
{
  day11-1 = occupied endStateP1;
  day11-2 = occupied endStateP2;
}
