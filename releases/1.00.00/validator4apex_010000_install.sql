DECLARE V_EXISTS NUMBER DEFAULT 0;V_SQL VARCHAR2(2000) DEFAULT 'SELECT * FROM DUAL';
BEGIN
    SELECT COUNT(*) INTO V_EXISTS FROM USER_TABLES WHERE TABLE_NAME='ACTUALIZATION_LOG';
    IF V_EXISTS=0 THEN 
            V_SQL:='CREATE TABLE ACTUALIZATION_LOG(INSERT_DATE DATE DEFAULT SYSDATE,APP_VERSION VARCHAR2(20),DB_VERSION VARCHAR2(20),SCRIPT VARCHAR2(200), STATUS NUMBER DEFAULT 0)';
            EXECUTE IMMEDIATE V_SQL;
	END IF;
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
INSERT INTO ACTUALIZATION_LOG(DB_VERSION,STATUS,SCRIPT)VALUES('1.00.00',0,'validator4apex_010000_install.sql');
/
DECLARE V_EXISTS NUMBER DEFAULT 0;V_SQL VARCHAR2(2000) DEFAULT 'SELECT * FROM DUAL';
BEGIN
    SELECT COUNT(*) INTO V_EXISTS FROM USER_TABLES WHERE TABLE_NAME='EMP';
    IF V_EXISTS=0 THEN 
            V_SQL:='CREATE TABLE EMP("EMPNO" NUMBER(4,0) NOT NULL ENABLE,"ENAME" VARCHAR2(10 BYTE),"JOB" VARCHAR2(9 BYTE),"MGR" NUMBER(4,0),"HIREDATE" DATE,"SAL" NUMBER(7,2),"COMM" NUMBER(7,2), "DEPTNO" NUMBER(2,0),PRIMARY KEY ("EMPNO"))';
            EXECUTE IMMEDIATE V_SQL;
	END IF;
    COMMIT;
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
DECLARE V_EXISTS NUMBER DEFAULT 0;V_SQL VARCHAR2(2000) DEFAULT 'SELECT * FROM DUAL';
BEGIN
    SELECT COUNT(*) INTO V_EXISTS FROM USER_TABLES WHERE TABLE_NAME='EMP';
    IF V_EXISTS=1 THEN 
            Insert into EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values (1,'KING','PRESIDENT',null,to_date('81/11/17','RR/MM/DD'),'5000',null,'10');
            Insert into EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values (2,'BLAKE','MANAGER','7839',to_date('81/05/01','RR/MM/DD'),'2850',null,'30');
            Insert into EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values (3,'CLARK','MANAGER','7839',to_date('81/06/09','RR/MM/DD'),'2450',null,'10');
            Insert into EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values (4,'JONES','MANAGER','7839',to_date('81/04/02','RR/MM/DD'),'2975',null,'20');
            Insert into EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values (5,'SCOTT','ANALYST','7566',to_date('82/12/09','RR/MM/DD'),'3000',null,'20');
            Insert into EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values (6,'FORD','ANALYST','7566',to_date('81/12/03','RR/MM/DD'),'3000',null,'20');
	END IF;
    COMMIT;
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
create or replace package validator4apex_pkg as
	function f_val (pi_item	in varchar2	) return boolean;
	procedure p_proc (pi_item	in varchar2);
	procedure p_proc_add_error_1 ( pi_item_1	in varchar2, pi_item_2	in varchar2	);
	procedure p_proc_add_error_2 ( pi_item_1 	in varchar2, pi_item_2 in varchar2,pi_page_item_name	in varchar2 default apex_error.c_inline_with_field_and_notif);
	procedure p_proc_add_error_3 (pi_ename	in emp.ename%type);
end;
/
create or replace package body validator4apex_pkg as
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
UPDATE ACTUALIZATION_LOG set STATUS=1 WHERE DB_VERSION='1.00.00' AND SCRIPT='validator4apex_010000_install.sql';
/
