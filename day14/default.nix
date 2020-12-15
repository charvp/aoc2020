with builtins; with (import ../util.nix);
let
  input = readFile ./input;
  parseLine = line:
    let
      spl = filter isString (split "\\[|]? = " line);
      fst = head spl;
      snd = head (tail spl);
      thd = head (tail (tail spl));
    in
    if fst == "mask" then
      {
        action = "mask";
        mask = {
          and = replaceStrings [ "1" "X" ] [ "0" "1" ] snd;
          or = replaceStrings [ "X" ] [ "0" ] snd;
        };
      }
    else
      { action = "mem"; loc = parseInt snd; val = parseInt thd; };
  actions = map parseLine (splitNonEmptyLines input);
  doActionsValMask = { mask, store }: actions:
    let
      cur = head actions;
      newMask =
        if cur.action == "mask"
        then {
          or = parseBin cur.mask.or;
          and = parseBin cur.mask.and;
        }
        else mask;
      newStore =
        if cur.action == "mem"
        then store // { "${toString cur.loc}" = (bitOr mask.or (bitAnd mask.and cur.val)); }
        else store;
    in
    if length actions == 0
    then store
    else doActionsValMask { mask = newMask; store = newStore; } (tail actions);
  applyMask = f:
    let
      mappedTail = applyMask (tail f);
    in
    if length f == 0
    then [ "" ]
    else if head f == "0"
    then map (x: "0" + x) mappedTail
    else (map (x: "0" + x) mappedTail) ++ (map (x: "1" + x) mappedTail);
  doActionsMemMask = { mask, store }: actions:
    let
      cur = head actions;
      newMask =
        if cur.action == "mask"
        then {
          or = parseBin cur.mask.or;
          nand = parseBin (replaceStrings [ "0" "1" ] [ "1" "0" ] cur.mask.and);
          masks = map parseBin (applyMask (stringToList cur.mask.and));
        }
        else mask;
      base = bitAnd mask.nand (bitOr mask.or cur.loc);
      newStore =
        if cur.action == "mem"
        then foldl' (store: mask: store // { "${toString (bitOr base mask)}" = cur.val; }) store mask.masks
        else store;
    in
    if length actions == 0
    then store
    else deepSeq newStore (doActionsMemMask { mask = newMask; store = newStore; } (tail actions));
in
{
  day14-1 = sum (attrValues (doActionsValMask { mask = null; store = { }; } actions));
  day14-2 = sum (attrValues (doActionsMemMask { mask = null; store = { }; } actions));
}
