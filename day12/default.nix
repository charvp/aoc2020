with builtins; with (import ../util.nix);
let
  input = readFile ./input;
  parsed = map
    (line:
      let sp = elemAt (split "^(.)(.*)$" line) 1;
      in { action = head sp; amount = parseInt (head (tail sp)); })
    (splitNonEmptyLines input);
  turn = coord: amount:
    if amount > 0
    then turn { x = coord.y; y = -coord.x; } (amount - 90)
    else coord;
  baseDiff = { x, y }: diff: amount: { x = x + (diff.x * amount); y = y + (diff.y * amount); };
  actionMap = { D, F }: rec {
    N = D { x = 0; y = 1; };
    E = D { x = 1; y = 0; };
    S = D { x = 0; y = -1; };
    W = D { x = -1; y = 0; };
    R = amount: { pos, dir }: { inherit pos; dir = turn dir amount; };
    L = amount: R (360 - amount);
    inherit F;
  };
  simpleActionMap = actionMap rec {
    D = diff: amount: { pos, dir }: { pos = baseDiff pos diff amount; inherit dir; };
    F = amount: { dir, ... }@state: D dir amount state;
  };
  waypointActionMap = actionMap {
    D = diff: amount: { pos, dir }: { inherit pos; dir = baseDiff dir diff amount; };
    F = amount: { pos, dir }: { pos = baseDiff pos dir amount; inherit dir; };
  };
  endPosForMap = actionMap: startDir: (foldl' (state: action: actionMap.${action.action} action.amount state) { pos = { x = 0; y = 0; }; dir = startDir; } parsed).pos;
  endPosSimple = endPosForMap simpleActionMap { x = 1; y = 0; };
  endPosWaypoint = endPosForMap waypointActionMap { x = 10; y = 1; };
in
{
  day12-1 = (abs endPosSimple.x) + (abs endPosSimple.y);
  day12-2 = (abs endPosWaypoint.x) + (abs endPosWaypoint.y);
}
