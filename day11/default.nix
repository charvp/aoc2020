with builtins; with (import ../util.nix);
let
  input = readFile ./input;
  grid = map stringToList (splitNonEmptyLines input);
  isFilled = grid: i: j:
    let
      row = elemAt grid i;
      elem = elemAt row j;
    in
    i >= 0 && i < length grid && j >= 0 && j < length row && elem == "#";
  countFilledNeighbours = grid: i: j:
    length (filter (x: isFilled grid x.i x.j) [
      { i = (i + 1); j = (j + 1); }
      { i = (i + 1); j = (j - 1); }
      { i = (i + 1); j = j; }
      { i = (i - 1); j = (j + 1); }
      { i = (i - 1); j = (j - 1); }
      { i = (i - 1); j = j; }
      { i = i; j = (j + 1); }
      { i = i; j = (j - 1); }
    ]);
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
    then { i = newI; j = newJ; }
    else if newElem == "."
    then visibleFor grid newI newJ iDiff jDiff
    else { i = newI; j = newJ; };
  countFilledVisible = grid: i: j:
    length (filter (x: isFilled grid x.i x.j) (map (x: visibleFor grid i j x.i x.j) [
      { i = 1; j = 1; }
      { i = 1; j = -1; }
      { i = 1; j = 0; }
      { i = -1; j = 1; }
      { i = -1; j = -1; }
      { i = -1; j = 0; }
      { i = 0; j = 1; }
      { i = 0; j = -1; }
    ]));
  golIter = fillCheck: numForStateChange: grid:
    genList
      (i:
        let
          row = elemAt grid i;
        in
        genList
          (j:
            let
              elem = elemAt row j;
              filledOthers = fillCheck grid i j;
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
  endStateP1 = fix (golIter countFilledNeighbours 4) grid;
  endStateP2 = fix (golIter countFilledVisible 5) grid;
  occupied = state: sum (map (x: length (filter (y: y == "#") x)) state);
in
{
  day11-1 = occupied endStateP1;
  day11-2 = occupied endStateP2;
}
