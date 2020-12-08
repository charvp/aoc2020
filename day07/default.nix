with builtins; with (import ../util.nix);
let
  input = readFile ./input;
  lines = splitNonEmptyLines input;
  bagsInLine = line: map head (filter isList (split "([0-9]* ?[a-z]+ [a-z]+) bags?" line));
in
{
  day07-1 =
    let
      attrSetForLine = line:
        let
          bags = bagsInLine line;
        in
        listToAttrs (map (x: { value = head bags; name = head (match "[0-9]* (.*)" x); }) (tail bags));
      bottomUp =
        let
          mappedLines = map attrSetForLine lines;
        in
        foldl'
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
          toSearch = filter (x: !(hasAttr x found)) (graph.${elem} or [ ]);
        in
        foldl'
          (found': name:
            let
              found'' = found' // { "${name}" = 1; };
            in
            found'' // (dfs graph name found''))
          found
          toSearch;
    in
    length (attrNames (dfs bottomUp "shiny gold" { }));
  day07-2 =
    let
      attrSetForLineWithNumbers = line:
        let
          bags = bagsInLine line;
        in
        {
          "${head bags}" = map
            (x:
              let
                num = parseInt (head (match "([0-9]+) .*" x));
                name = head (match "[0-9]+ (.*)" x);
              in
              [ num name ])
            (tail bags);
        };
      topDown =
        let
          mappedLines = map attrSetForLineWithNumbers (filter (x: isNull (match ".*no other.*" x)) lines);
        in
        union mappedLines;
      dfs = graph: elem:
        let
          toSearch = graph.${elem} or [ ];
        in
        foldl' (x: y: x + (head y) + ((head y) * (dfs graph (elemAt y 1)))) 0 toSearch;
    in
    dfs topDown "shiny gold";
}
