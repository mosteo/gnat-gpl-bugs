with Ada.Containers.Indefinite_Vectors;

procedure Indefvec is

   type Name is new String With
     Dynamic_Predicate => True;

   type Indef (Len : Natural) is record
      Str : Name (1 .. Len);
   end record;

   package Vectors is new Ada.Containers.Indefinite_Vectors (Positive, Indef);

begin
   null;
end Indefvec;
