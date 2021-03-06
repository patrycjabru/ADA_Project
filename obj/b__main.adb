pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__main.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__main.adb");
pragma Suppress (Overflow_Check);

with System.Restrictions;
with Ada.Exceptions;

package body ada_main is

   E072 : Short_Integer; pragma Import (Ada, E072, "system__os_lib_E");
   E013 : Short_Integer; pragma Import (Ada, E013, "system__soft_links_E");
   E025 : Short_Integer; pragma Import (Ada, E025, "system__exception_table_E");
   E068 : Short_Integer; pragma Import (Ada, E068, "ada__io_exceptions_E");
   E052 : Short_Integer; pragma Import (Ada, E052, "ada__strings_E");
   E040 : Short_Integer; pragma Import (Ada, E040, "ada__containers_E");
   E027 : Short_Integer; pragma Import (Ada, E027, "system__exceptions_E");
   E078 : Short_Integer; pragma Import (Ada, E078, "interfaces__c_E");
   E054 : Short_Integer; pragma Import (Ada, E054, "ada__strings__maps_E");
   E058 : Short_Integer; pragma Import (Ada, E058, "ada__strings__maps__constants_E");
   E021 : Short_Integer; pragma Import (Ada, E021, "system__soft_links__initialize_E");
   E080 : Short_Integer; pragma Import (Ada, E080, "system__object_reader_E");
   E047 : Short_Integer; pragma Import (Ada, E047, "system__dwarf_lines_E");
   E039 : Short_Integer; pragma Import (Ada, E039, "system__traceback__symbolic_E");
   E204 : Short_Integer; pragma Import (Ada, E204, "ada__numerics_E");
   E103 : Short_Integer; pragma Import (Ada, E103, "ada__tags_E");
   E101 : Short_Integer; pragma Import (Ada, E101, "ada__streams_E");
   E157 : Short_Integer; pragma Import (Ada, E157, "interfaces__c__strings_E");
   E115 : Short_Integer; pragma Import (Ada, E115, "system__file_control_block_E");
   E114 : Short_Integer; pragma Import (Ada, E114, "system__finalization_root_E");
   E112 : Short_Integer; pragma Import (Ada, E112, "ada__finalization_E");
   E111 : Short_Integer; pragma Import (Ada, E111, "system__file_io_E");
   E149 : Short_Integer; pragma Import (Ada, E149, "ada__streams__stream_io_E");
   E215 : Short_Integer; pragma Import (Ada, E215, "system__storage_pools_E");
   E219 : Short_Integer; pragma Import (Ada, E219, "system__finalization_masters_E");
   E217 : Short_Integer; pragma Import (Ada, E217, "system__storage_pools__subpools_E");
   E165 : Short_Integer; pragma Import (Ada, E165, "system__task_info_E");
   E138 : Short_Integer; pragma Import (Ada, E138, "ada__calendar_E");
   E136 : Short_Integer; pragma Import (Ada, E136, "ada__calendar__delays_E");
   E245 : Short_Integer; pragma Import (Ada, E245, "ada__real_time_E");
   E099 : Short_Integer; pragma Import (Ada, E099, "ada__text_io_E");
   E197 : Short_Integer; pragma Import (Ada, E197, "ada__text_io__text_streams_E");
   E211 : Short_Integer; pragma Import (Ada, E211, "system__pool_global_E");
   E181 : Short_Integer; pragma Import (Ada, E181, "system__tasking__initialization_E");
   E191 : Short_Integer; pragma Import (Ada, E191, "system__tasking__protected_objects_E");
   E193 : Short_Integer; pragma Import (Ada, E193, "system__tasking__protected_objects__entries_E");
   E189 : Short_Integer; pragma Import (Ada, E189, "system__tasking__queuing_E");
   E243 : Short_Integer; pragma Import (Ada, E243, "system__tasking__stages_E");
   E199 : Short_Integer; pragma Import (Ada, E199, "fifo_E");
   E203 : Short_Integer; pragma Import (Ada, E203, "jewl_E");
   E229 : Short_Integer; pragma Import (Ada, E229, "jewl__win32_interface_E");
   E227 : Short_Integer; pragma Import (Ada, E227, "jewl__canvas_implementation_E");
   E247 : Short_Integer; pragma Import (Ada, E247, "jewl__window_implementation_E");
   E233 : Short_Integer; pragma Import (Ada, E233, "jewl__message_handling_E");
   E249 : Short_Integer; pragma Import (Ada, E249, "jewl__windows_E");
   E134 : Short_Integer; pragma Import (Ada, E134, "factory_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      declare
         procedure F1;
         pragma Import (Ada, F1, "factory__finalize_body");
      begin
         E134 := E134 - 1;
         F1;
      end;
      E247 := E247 - 1;
      E233 := E233 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "jewl__message_handling__finalize_spec");
      begin
         F2;
      end;
      declare
         procedure F3;
         pragma Import (Ada, F3, "jewl__window_implementation__finalize_spec");
      begin
         F3;
      end;
      E227 := E227 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "jewl__canvas_implementation__finalize_spec");
      begin
         F4;
      end;
      E203 := E203 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "jewl__finalize_spec");
      begin
         F5;
      end;
      E193 := E193 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "system__tasking__protected_objects__entries__finalize_spec");
      begin
         F6;
      end;
      E211 := E211 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "system__pool_global__finalize_spec");
      begin
         F7;
      end;
      E099 := E099 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "ada__text_io__finalize_spec");
      begin
         F8;
      end;
      E217 := E217 - 1;
      declare
         procedure F9;
         pragma Import (Ada, F9, "system__storage_pools__subpools__finalize_spec");
      begin
         F9;
      end;
      E219 := E219 - 1;
      declare
         procedure F10;
         pragma Import (Ada, F10, "system__finalization_masters__finalize_spec");
      begin
         F10;
      end;
      E149 := E149 - 1;
      declare
         procedure F11;
         pragma Import (Ada, F11, "ada__streams__stream_io__finalize_spec");
      begin
         F11;
      end;
      declare
         procedure F12;
         pragma Import (Ada, F12, "system__file_io__finalize_body");
      begin
         E111 := E111 - 1;
         F12;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (C, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Default_Secondary_Stack_Size : System.Parameters.Size_Type;
      pragma Import (C, Default_Secondary_Stack_Size, "__gnat_default_ss_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");
      Bind_Env_Addr : System.Address;
      pragma Import (C, Bind_Env_Addr, "__gl_bind_env_addr");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
      Binder_Sec_Stacks_Count : Natural;
      pragma Import (Ada, Binder_Sec_Stacks_Count, "__gnat_binder_ss_count");
      Default_Sized_SS_Pool : System.Address;
      pragma Import (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");

   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      System.Restrictions.Run_Time_Restrictions :=
        (Set =>
          (False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, True, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False),
         Value => (0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
         Violated =>
          (True, False, False, False, True, True, False, False, 
           False, False, False, True, True, True, True, False, 
           False, False, True, False, True, True, False, True, 
           True, False, True, True, True, True, False, True, 
           False, False, False, True, False, True, True, False, 
           True, True, True, True, False, True, False, True, 
           True, False, False, True, False, True, False, False, 
           False, False, False, True, True, True, True, True, 
           False, False, True, False, True, True, True, False, 
           True, True, False, True, True, True, True, False, 
           False, True, False, False, False, True, True, True, 
           True, False, True, False),
         Count => (0, 0, 0, 1, 4, 5, 6, 0, 4, 0),
         Unknown => (False, False, False, False, False, False, False, False, True, False));
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      ada_main'Elab_Body;
      Default_Secondary_Stack_Size := System.Parameters.Runtime_Default_Sec_Stack_Size;
      Binder_Sec_Stacks_Count := 1;
      Default_Sized_SS_Pool := Sec_Default_Sized_Stacks'Address;

      Runtime_Initialize (1);

      Finalize_Library_Objects := finalize_library'access;

      System.Soft_Links'Elab_Spec;
      System.Exception_Table'Elab_Body;
      E025 := E025 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E068 := E068 + 1;
      Ada.Strings'Elab_Spec;
      E052 := E052 + 1;
      Ada.Containers'Elab_Spec;
      E040 := E040 + 1;
      System.Exceptions'Elab_Spec;
      E027 := E027 + 1;
      Interfaces.C'Elab_Spec;
      System.Os_Lib'Elab_Body;
      E072 := E072 + 1;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E058 := E058 + 1;
      System.Soft_Links.Initialize'Elab_Body;
      E021 := E021 + 1;
      E013 := E013 + 1;
      System.Object_Reader'Elab_Spec;
      System.Dwarf_Lines'Elab_Spec;
      E047 := E047 + 1;
      E078 := E078 + 1;
      E054 := E054 + 1;
      System.Traceback.Symbolic'Elab_Body;
      E039 := E039 + 1;
      E080 := E080 + 1;
      Ada.Numerics'Elab_Spec;
      E204 := E204 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Tags'Elab_Body;
      E103 := E103 + 1;
      Ada.Streams'Elab_Spec;
      E101 := E101 + 1;
      Interfaces.C.Strings'Elab_Spec;
      E157 := E157 + 1;
      System.File_Control_Block'Elab_Spec;
      E115 := E115 + 1;
      System.Finalization_Root'Elab_Spec;
      E114 := E114 + 1;
      Ada.Finalization'Elab_Spec;
      E112 := E112 + 1;
      System.File_Io'Elab_Body;
      E111 := E111 + 1;
      Ada.Streams.Stream_Io'Elab_Spec;
      E149 := E149 + 1;
      System.Storage_Pools'Elab_Spec;
      E215 := E215 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E219 := E219 + 1;
      System.Storage_Pools.Subpools'Elab_Spec;
      E217 := E217 + 1;
      System.Task_Info'Elab_Spec;
      E165 := E165 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E138 := E138 + 1;
      Ada.Calendar.Delays'Elab_Body;
      E136 := E136 + 1;
      Ada.Real_Time'Elab_Spec;
      Ada.Real_Time'Elab_Body;
      E245 := E245 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E099 := E099 + 1;
      Ada.Text_Io.Text_Streams'Elab_Spec;
      E197 := E197 + 1;
      System.Pool_Global'Elab_Spec;
      E211 := E211 + 1;
      System.Tasking.Initialization'Elab_Body;
      E181 := E181 + 1;
      System.Tasking.Protected_Objects'Elab_Body;
      E191 := E191 + 1;
      System.Tasking.Protected_Objects.Entries'Elab_Spec;
      E193 := E193 + 1;
      System.Tasking.Queuing'Elab_Body;
      E189 := E189 + 1;
      System.Tasking.Stages'Elab_Body;
      E243 := E243 + 1;
      E199 := E199 + 1;
      JEWL'ELAB_SPEC;
      JEWL'ELAB_BODY;
      E203 := E203 + 1;
      E229 := E229 + 1;
      JEWL.CANVAS_IMPLEMENTATION'ELAB_SPEC;
      JEWL.CANVAS_IMPLEMENTATION'ELAB_BODY;
      E227 := E227 + 1;
      JEWL.WINDOW_IMPLEMENTATION'ELAB_SPEC;
      JEWL.MESSAGE_HANDLING'ELAB_SPEC;
      JEWL.MESSAGE_HANDLING'ELAB_BODY;
      E233 := E233 + 1;
      JEWL.WINDOW_IMPLEMENTATION'ELAB_BODY;
      E247 := E247 + 1;
      E249 := E249 + 1;
      Factory'Elab_Spec;
      Factory'Elab_Body;
      E134 := E134 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_main");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      gnat_argc := argc;
      gnat_argv := argv;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   D:\aSTUDIA\ADA_project\obj\fifo.o
   --   D:\aSTUDIA\ADA_project\obj\jewl.o
   --   D:\aSTUDIA\ADA_project\obj\jewl-win32_interface.o
   --   D:\aSTUDIA\ADA_project\obj\jewl-canvas_implementation.o
   --   D:\aSTUDIA\ADA_project\obj\jewl-message_handling.o
   --   D:\aSTUDIA\ADA_project\obj\jewl-window_implementation.o
   --   D:\aSTUDIA\ADA_project\obj\jewl-windows.o
   --   D:\aSTUDIA\ADA_project\obj\factory.o
   --   D:\aSTUDIA\ADA_project\obj\main.o
   --   -LD:\aSTUDIA\ADA_project\obj\
   --   -LD:\aSTUDIA\ADA_project\obj\
   --   -LD:/programy/gnat/2018/lib/gcc/x86_64-pc-mingw32/7.3.1/adalib/
   --   -static
   --   -luser32
   --   -lgdi32
   --   -lcomdlg32
   --   -lwinmm
   --   -lgnarl
   --   -lgnat
   --   -Xlinker
   --   --stack=0x200000,0x1000
   --   -mthreads
   --   -Wl,--stack=0x2000000
--  END Object file/option list   

end ada_main;
