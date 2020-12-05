with builtins;
let
  input = readFile ./input;
  splitLines = filter (x: x != "") (filter isString (split "\n" input));
  parseLine = line:
    let
      parsed = elemAt (split "([0-9]*)-([0-9]*) (.): (.*)" line) 1;
      min = fromJSON (elemAt parsed 0);
      max = fromJSON (elemAt parsed 1);
      char = elemAt parsed 2;
      password = elemAt parsed 3;
    in
    { inherit min max char password; };
  parsed = map parseLine splitLines;
  stringToChars = s: map (x: elemAt x 0) (filter isList (split "(.)" s));
  isPart1Valid = elem:
    let
      count = length (filter (x: x == elem.char) (stringToChars elem.password));
    in
    count >= elem.min && count <= elem.max;
  validPart1 = filter isPart1Valid parsed;
  isPart2Valid = elem:
    let
      first = elemAt (stringToChars elem.password) (elem.min - 1);
      second = elemAt (stringToChars elem.password) (elem.max - 1);
    in
    (first == elem.char) != (second == elem.char);
  validPart2 = filter isPart2Valid parsed;
in
writeFile:
{
  day02-1 = writeFile "day02-1" (toString (length validPart1));
  day02-2 = writeFile "day02-2" (toString (length validPart2));
}
