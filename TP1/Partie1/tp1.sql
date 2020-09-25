

set serveroutput on;/

ALTER TABLE DEPT ADD CONSTRAINT pk_dept PRIMARY KEY (N_DEPT);

ALTER TABLE EMP ADD CONSTRAINT pk_emp PRIMARY KEY (NUM);

SELECT DISTINCT(n_dept) from EMP;

SELECT n_dept from DEPT;

INSERT INTO DEPT VALUES
        (100,'informatique','ALGERIE');


ALTER TABLE EMP ADD CONSTRAINT fk_dept FOREIGN KEY (N_DEPT) REFERENCES DEPT (N_DEPT) 
ON DELETE CASCADE;

ALTER TABLE EMP ADD CONSTRAINT fk_num_emp FOREIGN KEY (N_SUP) REFERENCES EMP (NUM) 
ON DELETE CASCADE;


        
 
-- TRIGGER 3.1       
CREATE OR REPLACE TRIGGER salaire_positif 
BEFORE INSERT OR UPDATE 
OF salaire ON EMP 
FOR EACH ROW
BEGIN
	IF ( :NEW.salaire < 0) THEN
        	RAISE_APPLICATION_ERROR(-20022,'Le salaire ne peut être négatif');
    	END IF;
END;


--Test du trigger avec cette commande d'insertion
INSERT INTO EMP VALUES
        ('ALEXY',1200,'chef',16712,'23-may-90',-5000,NULL,30);




-- TRIGGER 3.2     
CREATE OR REPLACE TRIGGER salaire_rennes
BEFORE INSERT OR UPDATE 
OF salaire ON EMP 
FOR EACH ROW
DECLARE lieu_departement NUMBER(3);
BEGIN
	SELECT N_DEPT into lieu_departement FROM DEPT WHERE LIEU='Rennes';
	IF ( :NEW.salaire < 1000 AND :NEW.N_DEPT = lieu_departement) THEN
        	RAISE_APPLICATION_ERROR(-20022,'Le salaire ne peut Inférieur à 1000 pour un employé sur RENNES');
    	END IF;
END;



INSERT INTO EMP VALUES
        ('ALEXY',1200,'chef',16712,'23-may-90',900,NULL,10);




--3.3
CREATE OR REPLACE PROCEDURE JoursEtHeuresOuvrables
is
BEGIN
	dbms_output.put_line(to_char(sysdate,'DAY'));
	IF trim(to_char(sysdate,'DY')) = 'SAT' OR to_char(sysdate,'DY') = 'SUN' THEN
		RAISE_APPLICATION_ERROR(-20010,'IMPOSSIBLE EN WEEKEND'||to_char(sysdate,'DAY'));
	END IF;
END;




CREATE OR REPLACE TRIGGER ouvrable_emp
BEFORE DELETE ON EMP
FOR EACH ROW
BEGIN
	JoursEtHeuresOuvrables;
END;




INSERT INTO EMP VALUES
	('TOTO',15345,'compta', 16712,NULL,2800,NULL,30);

DELETE FROM EMP WHERE nom = 'TOTO';

--3.4 TRIGGER d'INSTANCE
CREATE TABLE historique(
	dateOperation DATE,
	nomUsager VARCHAR(15),
	typeOperation VARCHAR(15)
);




CREATE OR REPLACE TRIGGER monitor_historique AFTER INSERT OR DELETE OR UPDATE ON emp 
FOR EACH ROW 
DECLARE typeOp varchar(15);
sysdateOp varchar(15);
userOp varchar(15);
BEGIN 
	SELECT sysdate into sysdateOp FROM dual;
	SELECT user into userOp FROM dual;
	IF INSERTING THEN typeOp := 'Insertion';
	ELSIF UPDATING THEN typeOp := 'Modification';
	ELSIF DELETING THEN typeOp := 'Suppression';
	END IF;
	INSERT INTO historique VALUES (sysdateOp, userOp, typeOp);
END;
/


INSERT INTO EMP VALUES
        ('RYADH',45122,'Videur',16712,'01-may-96',20000,NULL,30);



--3.5 THE LAST

CREATE OR REPLACE TRIGGER cascadeTrig BEFORE UPDATE OR DELETE OF n_dept ON dept
FOR EACH ROW
BEGIN
	IF UPDATING THEN
		UPDATE emp set emp.N_DEPT = :NEW.n_dept WHERE emp.N_DEPT = :OLD.n_dept;
	ELSIF DELETING THEN
		DELETE FROM emp WHERE emp.N_DEPT = :OLD.n_dept;
	END IF;
END;
/
		



INSERT INTO DEPT VALUES
        (34,'Info','Montpellier');


INSERT INTO EMP VALUES
        ('MOMOMO',16777,'directeur',25717,'23-may-90',20000,NULL,34);


UPDATE DEPT SET n_dept = 37 WHERE n_dept = 34;

DELETE FROM dept WHERE n_dept = 37;




--Exercice 4:

CREATE OR REPLACE TRIGGER alerteCreation AFTER INSERT ON EMP
BEGIN
	dbms_output.put_line('INSERTION');
END;
/





INSERT INTO EMP VALUES
        ('LEFEVRE',16770,'ménage',25717,'23-may-90',20000,NULL,34);




--EXERCICE 5:
















/
