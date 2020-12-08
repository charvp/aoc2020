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
}