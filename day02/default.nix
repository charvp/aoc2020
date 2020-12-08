with builtins; with (import ../util.nix);
let
  input = readFile ./input;
  parseLine = line:
    let
      parsed = elemAt (split "([0-9]*)-([0-9]*) (.): (.*)" line) 1;
      min = parseInt (elemAt parsed 0);
      max = parseInt (elemAt parsed 1);
      char = elemAt parsed 2;
      password = elemAt parsed 3;
    in
    { inherit min max char password; };
  parsed = map parseLine (splitNonEmptyLines input);
  isPart1Valid = elem:
    let
      count = length (filter (x: x == elem.char) (stringToList elem.password));
    in
    count >= elem.min && count <= elem.max;
  validPart1 = filter isPart1Valid parsed;
  isPart2Valid = elem:
    let
      first = elemAt (stringToList elem.password) (elem.min - 1);
      second = elemAt (stringToList elem.password) (elem.max - 1);
    in
    (first == elem.char) != (second == elem.char);
  validPart2 = filter isPart2Valid parsed;
in
{
  day02-1 = length validPart1;
  day02-2 = length validPart2;
}
