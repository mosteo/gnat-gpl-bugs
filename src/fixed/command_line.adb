with GNAT.Command_Line; use GNAT.Command_Line;

procedure Command_Line is
   Config : Command_Line_Configuration;
begin
   --  Define_Switch(Config, "-x", Help => "Test switch");
   Getopt (Config);
   Display_Help(Config);
exception
   when Exit_From_Command_Line | Invalid_Switch =>
      null;
end Command_Line;
