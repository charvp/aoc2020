with builtins; with (import ../util.nix);
let
  input = readFile ./input;
  numbers = map parseInt (splitNonEmptyLines input);
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
  p2020 = head (filter (x: x.sum == 2020) (pairs numbers));
  t2020 = head (filter (x: x.sum == 2020) (triples numbers));
in
{
  day01-1 = p2020.product;
  day01-2 = t2020.product;
}
