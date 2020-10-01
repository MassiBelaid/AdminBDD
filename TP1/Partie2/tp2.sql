set serveroutput on;
/


--SELECT ALL TRIGGERS
SELECT trigger_name from USER_triggers;



CREATE OR REPLACE PROCEDURE deletTriggers 
IS
BEGIN
	--EXECUTE IMMEDIATE 'DROP TRIGGERS';
	FOR i in (select trigger_name,owner 
		from dba_triggers ) LOOP  
		EXECUTE IMMEDIATE 'DROP TRIGGER '||i.owner||'.'||i.trigger_name;  
 	END LOOP; 
END;







--3.3.1

CREATE OR REPLACE PROCEDURE EmployesDuDepartement(numDep IN NUMBER, emps OUT VARCHAR) IS
	CURSOR emps_curseur IS
	SELECT num, nom, fonction FROM emp WHERE N_DEPT = numDep;
	departement NUMBER;
BEGIN
	SELECT n_dept INTO departement FROM dept WHERE N_DEPT = numDep;
	IF (departement = NULL) THEN 
		RAISE_APPLICATION_ERROR(-20022,'Le département nexiste pas');
	END IF;
	emps := '';
	FOR emp_l IN emps_curseur
	LOOP
		emps := emps||'                     '||emp_l.num||' '||emp_l.nom||' '||emp_l.fonction;
	END LOOP; 
END;
/

--Prog pricipale pour cette procedure
DECLARE
	emps VARCHAR(1000);
BEGIN
	EmployesDuDepartement(10,emps);
	dbms_output.put_line(emps);
END;



--3.1.2

CREATE OR REPLACE FUNCTION coutSalaireDepartement (numDept IN NUMBER) RETURN NUMBER
IS
	CURSOR emps_curseur IS
	SELECT salaire FROM emp WHERE N_DEPT = numDept;
	departement NUMBER;
	coutSalaire NUMBER;
BEGIN
	SELECT n_dept INTO departement FROM dept WHERE N_DEPT = numDept;
	IF (departement = NULL) THEN 
		RAISE_APPLICATION_ERROR(-20022,'Le département nexiste pas');
	END IF;
	coutSalaire := 0;
	FOR emp_l IN emps_curseur
	LOOP
		coutSalaire := coutSalaire + emp_l.salaire;
	END LOOP; 
	RETURN(coutSalaire);
END;
/

--Test de la fonction dans une selection

SELECT nom, coutSalaireDepartement(n_dept) from dept;



--Prog pricipale pour cette fonction
DECLARE
	salairesTotal NUMBER;
BEGIN
	salairesTotal := coutSalaireDepartement(10);
	dbms_output.put_line('TOTAL DES SALAIRE DU DEPARTEMENT : '||salairesTotal||' EUROS');
END;



































EXECUTE ANY TYPE
select privilege from dba_sys_privs;
