-- Lister l'ensemble des vues dynamiques
SELECT name FROM v$fixed_table WHERE name LIKE 'V$%';


-- Lister l'ensemble des vues statiques
SELECT table_name, comments FROM dictionary WHERE table_name LIKE 'DBA_%' ORDER BY table_name;


--Exercice 1

CREATE OR REPLACE PACKAGE ArchiOracle
	FUNCTION getTimeStarted RETURN DATE;
	FUNCTION getHostName RETURN VARCHAR2;
	FUNCTION getDataBaseName RETURN VARCHAR2;
	FUNCTION getVersion RETURN VARCHAR2;
end ArchiOracle;
/ 


CREATE OR REPLACE FUNCTION getTimeStarted RETURN DATE
IS
	dateSTart DATE;
BEGIN
	SELECT STARTUP_TIME into dateSTart FROM v$instance;
	RETURN(dateSTart);
END;
/


CREATE OR REPLACE FUNCTION getHostName RETURN VARCHAR2
IS
	host_name VARCHAR2(100);
BEGIN
	SELECT HOST_NAME into host_name FROM v$instance;
	RETURN(host_name);
END;
/


CREATE OR REPLACE FUNCTION getDataBaseName RETURN VARCHAR2
IS
	name VARCHAR2(100);
BEGIN
	SELECT name into name FROM v$database;
	RETURN(name);
END;
/

--Les options dont nous disposon
SELECT parameter FROM v$option WHERE value = 'TRUE';



CREATE OR REPLACE PROCEDURE getVersion2
IS
	CURSOR version_curseur IS
	SELECT banner FROM v$version;
BEGIN
	FOR ver in version_curseur
	LOOP
		dbms_output.put_line(ver.banner);
	END LOOP; 
END;
/


--Programe pour tester

BEGIN 
	dbms_output.put_line('Démarée depuis : '||getTimeStarted);
	dbms_output.put_line('Host Name : '||getHostName);
	dbms_output.put_line('Nom bdd : '||getDataBaseName);
	getVersion2;
END;
/


--SELECTIONS UTILISEES
SELECT INSTANCE_NAME FROM v$instance;
SELECT STARTUP_TIME FROM v$instance;
SELECT remote_archive FROM v$database;
SELECT parameter FROM v$option WHERE value = 'TRUE';
SELECT * FROM v$version;

