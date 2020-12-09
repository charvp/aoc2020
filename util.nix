with builtins;
rec {
  splitNonEmptyBlocks = str: filter (x: isString x && x != "") (split "\n\n" str);
  splitNonEmptyLines = str: filter (x: isString x && x != "") (split "\n" str);
  parseInt = s:
    let num = fromJSON s; in assert isInt num; num;
  stringToList = s: map head (filter isList (split "(.)" s));
  apply = c: f: e:
    if c == 0
    then e
    else f (apply (c - 1) f e);
  hasAttrs = attrs: elem:
    if attrs == [ ] then
      true else
      (hasAttr (head attrs) elem) && (hasAttrs (tail attrs) elem);
  pow = n: x: if n == 0 then 1 else x * (pow (n - 1) x);
  union = attrSets: foldl' (x: y: x // y) { } attrSets;
  dropN = n: l: if n == 0 then l else dropN (n - 1) (tail l);
  takeN = n: l: if n == 0 then [ ] else [ (head l) ] ++ (takeN (n - 1) (tail l));
  pairs = list:
    if (length list > 0) then
      let
        y = head list;
        t = tail list;
      in
      (map (x: { sum = x + y; product = x * y; }) t) ++ (pairs t)
    else
      [ ];
  eachWithIndex = list: genList (i: { inherit i; val = (elemAt list i); }) (length list);
  sum = list: foldl' add 0 list;
  min = list: foldl' (x: y: if y < x then y else x) (head list) (tail list);
  max = list: foldl' (x: y: if y > x then y else x) (head list) (tail list);
  leftPad = n: p: s: if builtins.stringLength s < n then p + (leftPad (n - 1) p s) else s;
}
