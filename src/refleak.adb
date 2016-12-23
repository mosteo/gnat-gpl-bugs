procedure Refleak is

--  To be run with valgrind --leak-check=full --show-leak-kinds=all
--  It highlights a memory leak in the secondary stack
--  Every call to Ref leaks memory until program termination, which can be highly troublesome in long-lived
--  programs.

   -- Relevant output in valgrind:

--  ==18636== 160,500,000 bytes in 15,625 blocks are still reachable in loss record 2 of 2
--  ==18636==    at 0x4C2DB8F: malloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
--  ==18636==    by 0x40D5BC: __gnat_malloc (in /home/jano/local/gnat-gpl-bugs/obj/refleak)
--  ==18636==    by 0x410378: system__secondary_stack__ss_allocate (in /home/jano/local/gnat-gpl-bugs/obj/refleak)
--  ==18636==    by 0x402D82: refleak__p__ref.3532 (in /home/jano/local/gnat-gpl-bugs/obj/refleak)
--  ==18636==    by 0x402E44: refleak__long_lived.3537 (in /home/jano/local/gnat-gpl-bugs/obj/refleak)
--  ==18636==    by 0x402970: _ada_refleak (in /home/jano/local/gnat-gpl-bugs/obj/refleak)
--  ==18636==    by 0x40318A: main (in /home/jano/local/gnat-gpl-bugs/obj/refleak)
--  ==18636==
--  ==18636== LEAK SUMMARY:
--  ==18636==    definitely lost: 0 bytes in 0 blocks
--  ==18636==    indirectly lost: 0 bytes in 0 blocks
--  ==18636==      possibly lost: 0 bytes in 0 blocks
--  ==18636==    still reachable: 160,500,012 bytes in 15,626 blocks
--  ==18636==         suppressed: 0 bytes in 0 blocks

   package P is

      type Str_Holder is tagged private;
      -- IRL this would be a controlled type with proper allocation/deallocation of the held type

      function Create (S : String) return Str_Holder;

      type Reference (S : access String) is limited null record
        with Implicit_Dereference => S;

      function Ref (Str : Str_Holder) return Reference;

   private

      type Str_Ptr is access String;

      type Str_Holder is tagged record
         Ptr : Str_Ptr;
      end record;

      function Create (S : String) return Str_Holder is (Ptr => new String'(S));

      function Ref (Str : Str_Holder) return Reference is (Reference'(S => Str.Ptr));

   end P;

   S : constant P.Str_Holder := P.Create ("WTF");

   procedure Long_Lived is
   begin
      for I in 1 .. 9_999_999 loop
         exit when S.Ref = "XXX";
      end loop;
   end Long_Lived;

begin
   Long_Lived;
end Refleak;
