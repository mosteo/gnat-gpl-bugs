procedure Taskiface is

-- 'Terminated cannot be applied to a task interface when a private wrapper exists
-- Symptoms:
-- taskiface.adb:28:15: no selector "_Disp_Get_Task_Id" for type "Some_Task'Class" defined at line 8

   package Inner is

      type Some_Task is task interface;

      type Some_Ptr is access all Some_Task'Class;

      type Wrapper (Ptr : Some_Ptr) is limited private;

   private

      type Wrapper (Ptr : Some_Ptr) is limited null record;

   end Inner;

   task type T is new Inner.Some_Task with end T;

   task body T is
      S : Inner.Some_Ptr := T'Unchecked_Access;
      W : Inner.Wrapper (T'Unchecked_Access);
   begin
      if T'Terminated then null; end if;
  --    if W.Ptr.all'Terminated then null; end if; -- Likewise fails
      if S.all'Terminated then null; end if;
   end T;

begin
   null;
end Taskiface;
