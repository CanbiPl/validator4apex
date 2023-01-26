--------------------------------------------------------
--  DDL for Package VALIDATOR4APEX_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "VALIDATOR4APEX_PKG" as
	function f_val (pi_item	in varchar2	) return boolean;
	procedure p_proc (pi_item	in varchar2);
	procedure p_proc_add_error_1 ( pi_item_1	in varchar2, pi_item_2	in varchar2	);
	procedure p_proc_add_error_2 ( pi_item_1 	in varchar2, pi_item_2 in varchar2,pi_page_item_name	in varchar2 default apex_error.c_inline_with_field_and_notif);
	procedure p_proc_add_error_3 (pi_ename	in emp.ename%type);
end;

/
