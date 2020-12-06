with builtins;
let
  input = readFile ./input;
  splits = filter (x: x != "") (filter isString (split "\n\n" input));
  parseAnswers = i: listToAttrs (map (l: { value = 1; name = (elemAt l 0); }) (filter isList (split "(.)" i)));
  individuals = g: filter (x: x != "") (filter isString (split "\n" g));
  groups = map (g: map parseAnswers (individuals g)) splits;
  numQuestionsUnique = map (g: length (attrNames (foldl' (x: y: x // y) { } g))) groups;
  numQuestionsAll = map (g: length (attrNames (foldl' intersectAttrs (head g) (tail g)))) groups;
in
{
  day06-1 = foldl' add 0 numQuestionsUnique;
  day06-2 = foldl' add 0 numQuestionsAll;
}
