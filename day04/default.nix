with builtins; with (import ../util.nix);
let
  input = readFile ./input;
  parsePassport = s:
    let
      parsed = filter isList (split "([^ \n]*):([^ \n]*)" s);
    in
    listToAttrs (map (e: { name = (head e); value = (elemAt e 1); }) parsed);
  passports = map parsePassport (splitNonEmptyBlocks input);
  isPart1Valid = hasAttrs [ "byr" "iyr" "eyr" "hgt" "hcl" "ecl" "pid" ];
  validPart1 = filter isPart1Valid passports;
  isPart2Valid = elem:
    let
      byr = (fromJSON elem.byr) >= 1920 && (fromJSON elem.byr) <= 2002;
      iyr = (fromJSON elem.iyr) >= 2010 && (fromJSON elem.iyr) <= 2020;
      eyr = (fromJSON elem.eyr) >= 2020 && (fromJSON elem.eyr) <= 2030;
      hgt = !(isNull (match "1[5-8][0-9]cm|19[0-3]cm|59in|6[0-9]in|7[0-6]in" elem.hgt));
      hcl = !(isNull (match "#[0-9a-f]{6}" elem.hcl));
      ecl = !(isNull (match "amb|blu|brn|gry|grn|hzl|oth" elem.ecl));
      pid = !(isNull (match "[0-9]{9}" elem.pid));
    in
    byr && iyr && eyr && hgt && hcl && ecl && pid;
  validPart2 = filter isPart2Valid validPart1;
in
{
  day04-1 = length validPart1;
  day04-2 = length validPart2;
}
