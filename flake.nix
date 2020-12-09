{
  description = "Advent of Code 2020";
  inputs = { };
  outputs = { self }:
    with builtins; with (import ./util.nix);
    foldl'
      (a: b: a // b)
      { }
      (map
        (day: if pathExists day then import day else { })
        (genList (x: ./. + "/day" + (leftPad 2 "0" "${toString (x + 1)}")) 25)
      );
}
