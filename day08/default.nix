with builtins; with (import ../util.nix);
let
  input = readFile ./input;
  parseInstruction = line:
    let
      parse = match "^([a-z]*) \\+?(.*)" line;
    in
    {
      op = head parse;
      arg = parseInt (elemAt parse 1);
    };
  parsed = map parseInstruction (splitNonEmptyLines input);
  execUntil = insts: inp: acc: visited:
    let
      inst = elemAt insts inp;
      newInp = if inst.op == "jmp" then inp + inst.arg else inp + 1;
      newAcc = if inst.op == "acc" then acc + inst.arg else acc;
      newVisited = visited // { "${toString inp}" = 1; };
    in
    if hasAttr (toString inp) visited || inp > length insts then { value = acc; clean = false; }
    else if inp == length insts then { value = acc; clean = true; }
    else execUntil insts newInp newAcc newVisited;
in
{
  day08-1 = (execUntil parsed 0 0 { }).value;
  day08-2 =
    let
      positionsToChange = filter
        (i:
          let
            inst = elemAt parsed i;
          in
          inst.op == "jmp" || inst.op == "nop")
        (genList (i: i) (length parsed));
      changedInstructions = map
        (i: genList
          (j:
            let
              inst = elemAt parsed j;
              newInst =
                if i != j then inst
                else if inst.op == "jmp" then { op = "nop"; arg = inst.arg; }
                else if inst.op == "nop" then { op = "jmp"; arg = inst.arg; }
                else inst;
            in
            newInst)
          (length parsed))
        positionsToChange;
      result = head (filter (insts: (execUntil insts 0 0 { }).clean) changedInstructions);
    in
    (execUntil result 0 0 { }).value;
}
