{
  description = "Advent of Code 2020";
  inputs = { };
  outputs = { self }:
    builtins.foldl' (a: b: a // b) { } (map (day: import day) [
      ./day01
      ./day02
      ./day03
      ./day04
      ./day05
      ./day06
      ./day07
      ./day08
      ./day09
    ]);
}
