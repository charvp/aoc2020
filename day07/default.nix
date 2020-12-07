with builtins;
let
  input = readFile ./input;
  lines = filter (x: isString x && x != "") (split "\n" input);
  bagsInLine = line: map head (filter isList (split "([a-z]+ [a-z]+) bags?" line));
  numBagsInLine = line: map head (filter isList (split "([0-9]* ?[a-z]+ [a-z]+) bags?" line));
  attrSetForLineWithNumbers = line:
  let
    bags = numBagsInLine line;
  in
  {
    "${head bags}" = map (x: let
      num = fromJSON (head (match "([0-9]+) .*" x));
      name = head (match "[0-9]+ (.*)" x);
    in
    [ num name ]) (tail bags);
  };
  combined2 = let
    mappedLines = map attrSetForLineWithNumbers (filter (x: isNull (match ".*no other.*" x)) lines);
  in
    foldl' (x: y: x // y) {} mappedLines;
  attrSetForLine = line:
    let
      bags = bagsInLine line;
    in
    listToAttrs (map (x: { value = head bags; name = x; }) (tail bags));
  mappedLines = map attrSetForLine lines;
  combined = foldl'
    (x: y:
      listToAttrs (map
        (name: {
          inherit name; value = x.${name} or [ ] ++ (if hasAttr name y then [ y.${name} ] else [ ]);
        })
        ((attrNames x) ++ (attrNames y)))
    )
    { }
    mappedLines;
  dfs = graph: elem: found:
    let
      toSearch = filter (x: !(hasAttr x found)) (graph.${elem} or []);
    in
    foldl'
      (found2: name:
        let
          found3 = found2 // { "${name}" = 1; };
        in
        found3 // (dfs graph name found3))
      found
      toSearch;
  df2 = graph: elem:
    let
      toSearch = graph.${elem} or [];
    in
    foldl' (x: y: x + (head y) + ((head y) * (df2 graph (elemAt y 1)))) 0 toSearch;
in
{
  day07-1 = length (attrNames (dfs combined "shiny gold" { }));
  day07-2 = df2 combined2 "shiny gold";
}
