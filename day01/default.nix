with builtins;
let
  input = readFile ./input;
  splitLines = filter isString (split "\n" input);
  numbers = map fromJSON (filter (x: x != "") splitLines);
  pairs = list:
    if (length list > 0) then
      let
        y = head list;
        t = tail list;
      in
      (map (x: { sum = x + y; product = x * y; }) t) ++ (pairs t)
    else
      [ ];
  triples = list:
    if (length list > 0) then
      let
        z = head list;
        t = tail list;
        ps = filter (x: x.sum < 2020) (pairs t);
      in
      (map ({ sum, product }: { sum = sum + z; product = product * z; }) ps) ++ (triples t)
    else
      [ ];
  elem = head (filter (x: x.sum == 2020) (pairs numbers));
  elem2 = head (filter (x: x.sum == 2020) (triples numbers));
in
writeFile:
{
  day01-1 = writeFile "day01-1" (toString elem.product);
  day01-2 = writeFile "day01-2" (toString elem2.product);
}
