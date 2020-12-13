with builtins; with (import ../util.nix);
let
  input = readFile ./input;
  splitLines = splitNonEmptyLines input;
  arrival = parseInt (head splitLines);
  buses = map ({ i, val }: { offset = i; bus = parseInt val; }) (filter ({ val, ... }: val != "x") (eachWithIndex (filter isString (split "," (head (tail splitLines))))));
  waitTimes = arr: map (x: { bus = x.bus; time = x.bus - (mod arr x.bus); }) buses;
  minWait = minWith (x: y: x.time < y.time) (waitTimes arrival);
  extEuclid = r': r: s': s: t': t:
    let
      quot = r' / r;
    in
    if r == 0
    then { m = s'; n = t'; }
    else extEuclid r (r' - quot * r) s (s' - quot * s) t (t' - quot * t);
  mulInv = x: n:
    let
      x' = (extEuclid x n 1 0 0 1).m;
    in
    mod ((mod x' n) + n) n;
  constructCRT = l:
    let
      prod = foldl' (x: y: x * y.bus) 1 l;
      added = foldl' (x: y:
        let p = prod / y.bus; in x + (-y.offset * (mulInv p y.bus) * p)) 0 l;
    in
    mod added prod;
in
{
  day13-1 = minWait.time * minWait.bus;
  day13-2 = constructCRT buses;
}
