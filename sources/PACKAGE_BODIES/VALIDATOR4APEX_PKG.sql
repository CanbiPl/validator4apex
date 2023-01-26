--------------------------------------------------------
--  DDL for Package Body VALIDATOR4APEX_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "VALIDATOR4APEX_PKG" as
	function f_val ( pi_item	in varchar2	) return boolean
	is v_result	boolean;
	begin
	 if nvl(pi_item,'0') = '1' then v_result := true;
	 else v_result := false;
	 end if;
	 return v_result;
	end f_val;

	procedure p_proc ( pi_item	in varchar2)
	is  v_error	boolean := false;
	begin
	 if not f_val(pi_item) then raise_application_error(-20001, 'Wrong parameter.');
	 end if;
	end p_proc;

	procedure p_proc_add_error_1 ( pi_item_1	in varchar2, pi_item_2	in varchar2	)
	is
	begin
	 if not f_val(pi_item_1) then apex_error.add_error( p_message => 'Wrong parameter nr 1.', p_display_location	=> apex_error.c_inline_in_notification);
	end if;

	 if not f_val(pi_item_2) then apex_error.add_error( p_message => 'Wrong parameter nr 2.', p_display_location	=> apex_error.c_inline_in_notification);
	 end if;
	end p_proc_add_error_1;

	procedure p_proc_add_error_2 ( pi_item_1 in varchar2, pi_item_2 in varchar2, pi_page_item_name	in varchar2 default apex_error.c_inline_with_field_and_notif	)
	is
	begin
	 if pi_page_item_name in (apex_error.c_inline_with_field_and_notif, apex_error.c_inline_with_field) then
	 if not f_val(pi_item_1) then  apex_error.add_error( p_message => 'Wrong parameter nr 1.',	  p_display_location=> pi_page_item_name, p_page_item_name	=> 'P' || v('APP_PAGE_ID') || '_ITEM_1'	);
	 end if;

	 if not f_val(pi_item_2) then
	  apex_error.add_error(	  p_message => 'Wrong parameter nr 2.',p_display_location=> pi_page_item_name,p_page_item_name=> 'P' || v('APP_PAGE_ID') || '_ITEM_2');
	 end if;
	 else  apex_error.add_error(	  p_message => 'Wrong parameter pi_page_item_name.',	  p_display_location	=> apex_error.c_on_error_page	 );
	 end if;
	end p_proc_add_error_2;

	procedure p_proc_add_error_3 ( pi_ename	in emp.ename%type	)
	is v_emp_count	number;
	begin
		select count(*) into v_emp_count from emp where lower(ename) = lower(pi_ename);
	 if v_emp_count = 0 then  apex_error.add_error(	  p_error_code => 'APEX_ERROR_ADD_ERROR_3_EMP_NOT_FOUND', p0  => pi_ename, p_display_location	=>apex_error.c_inline_with_field_and_notif,  p_page_item_name	=> 'P' || v('APP_PAGE_ID') || '_ENAME'	 );
	 end if;	
	end p_proc_add_error_3;

end;

/
