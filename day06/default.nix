with builtins; with (import ../util.nix);
let
  input = readFile ./input;
  parseAnswers = i: listToAttrs (map (c: { value = 1; name = c; }) (stringToList i));
  groups = map (g: map parseAnswers (splitNonEmptyLines g)) (splitNonEmptyBlocks input);
  numQuestionsUnique = map (g: length (attrNames (union g))) groups;
  numQuestionsAll = map (g: length (attrNames (foldl' intersectAttrs (head g) (tail g)))) groups;
in
{
  day06-1 = foldl' add 0 numQuestionsUnique;
  day06-2 = foldl' add 0 numQuestionsAll;
}
