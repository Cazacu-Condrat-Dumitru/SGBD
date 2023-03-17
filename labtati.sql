/* table 1 articole

create table articole
(
   idarticol INT,
   denarticol VARCHAR(50),
   PRIMARY KEY (idarticol)
)
insert into articole  (idarticol,denarticol)
	VALUES
 (1, 'Articol1'),
 (2, 'Articol2'),
 (3, 'Articol3'),
 (4, 'Articol4'),
 (5, 'Articol5');
*/

/* table 2 universitate
CREATE TABLE universitate (
      iduniversitate INT(11) NOT NULL,
      denuniversitate TINYTEXT NOT NULL,
   PRIMARY KEY (iduniversitate)
   )

 INSERT INTO universitate (iduniversitate, denuniversitate) 
VALUES 
   (5, 'ARB'),
   (6, 'UTM'),
   (7, 'Asem');

*/

/* table 3 cercetatori
CREATE TABLE cercetatori (
      idcercetator INT(11) NOT NULL,
      numecercetător TINYTEXT NOT NULL,
      iduniversitate INT(11) NOT NULL,
   PRIMARY KEY (idcercetator)  )
  
INSERT INTO cercetatori (idcercetator, numecercetător, iduniversitate) 
 VALUES 	
(1, 'Dodu Petru', 1),
(2, 'Lungu Vasile', 2),
(3, 'Vrabie Maria', 1),
(4, 'Ombun Bogdan', 3);
 
*/

/* table 4 autori
CREATE TABLE autori (
      IdCercetator INT(11) NOT NULL,
      IdArticol INT(11) NOT NULL  	  
   );

INSERT INTO autori
   (IdCercetator, IdArticol) 
   VALUES 
   (1, 1),
   (2, 2),
   (3, 3),
   (4, 4);
   
   
<--Proceduri si functii----
*/
/* proced 1
delimiter $$   
CREATE PROCEDURE proc_lista_articole1 (IN id_cerc_param INT)
BEGIN
SELECT denarticol
FROM articole INNER JOIN autori
ON articole.idarticol = autori.idarticol
WHERE idcercetator = id_cerc_param
order by articole.denarticol;
END;$$
delimiter ;

CALL proc_lista_articole1(4);

*/


/* proced 2 
delimiter $$ 
 CREATE PROCEDURE proc_lista_cercet (IN id_univ INT)
 BEGIN
 	select cercetatori.numecercetător, articole.denarticol
 	from cercetatori
 	inner  join autori on autori.IdCercetator = cercetatori.idcercetator
 	inner  join articole on articole.idarticol = autori.IdArticol
 	where cercetatori.iduniversitate = id_univ;
 END;$$
 delimiter ;   

CALL proc_lista_cercet(1);

*/




/* proced 3

delimiter $$ 
 CREATE PROCEDURE proc_cerc_art ( id_univ INT)
 BEGIN
 	select cercetatori.numecercetător, articole.denarticol
 	from articole
   	INNER join autori on articole.idarticol = autori.IdArticol
	   RIGHT join cercetatori on autori.IdCercetator = cercetatori.idcercetator
 	WHERE cercetatori.iduniversitate = id_univ;
 END;$$
 delimiter;   
 



CALL proc_cerc_art(2);

*/



/* procedure 4




delimiter $$   
CREATE PROCEDURE proc_raiting ()
BEGIN
    DECLARE num_articole INT DEFAULT 0;
    DECLARE num_articole_univ INT DEFAULT 0;
    
    select cercetatori.numecercetător ,count(autori.IdArticol) / num_articole *100 as 'reitingul general',
     count(autori.IdArticol) /temp.reiting *100 as 'reitingul pe universitate'
    from cercetatori
    LEFT join autori on autori.IdCercetator = cercetatori.idcercetator
    inner join (
        select iduniversitate, count(iduniversitate) as reiting
        from cercetatori
        inner join autori on autori.IdCercetator = cercetatori.idcercetator
        group by  cercetatori.iduniversitate
    ) as temp on temp.iduniversitate = cercetatori.iduniversitate
    group by cercetatori.idcercetator;
END;$$
delimiter;


CALL proc_raiting()



*/
  

/*
-- procd 5
alter table cercetatori
-- DROP COLUMN calificativ
add column Calificativ VARCHAR(30) default NULL;
delimiter $$   
CREATE PROCEDURE proc_calificativ ()
BEGIN
    Declare counter Int;
    Declare art_cercet Int;
    select count(idcercetator) into counter
    from cercetatori;
    While counter > 0 DO
    SELECT count(idcercetator) INTO art_cercet
    from autori
	 WHERE idcercetator = counter;
        if art_cercet > 25 then
            update cercetatori
            set cercetatori.Calificativ = 'foarte bine'
            where cercetatori.idcercetator = counter;
            set counter = counter-1;
        ELSEIF  art_cercet >= 15 and art_cercet <=25  then
            update cercetatori
            set cercetatori.Calificativ = 'bine'
            where cercetatori.idcercetator = counter;
            set counter = counter-1;
        ELSEIF  art_cercet >= 5 and art_cercet <15  then
            update cercetatori
            set cercetatori.Calificativ = 'suficient'
            where cercetatori.idcercetator = counter;
            set counter = counter-1;
        else
            update cercetatori
            set cercetatori.Calificativ = 'insuficient'
            where cercetatori.idcercetator = counter;
            set counter = counter-1;
        end if;
    End while; 

END;$$
delimiter ;

CALL proc_calificativ();

*/


/*
delimiter $$   
CREATE PROCEDURE proc_stergere(n_cerc VARCHAR(20))
BEGIN
    DECLARE v_rez VARCHAR(70);
     SELECT IF(EXISTS(
     SELECT numecercetător,idcercetator
     FROM cercetatori
     WHERE n_cerc = numecercetător AND idcercetator NOT IN (SELECT idcercetator FROM autori)  
	  ),true ,"Nu exista asa cercetator sau sunt articole legate cu el" ) INTO v_rez;
END;$$
delimiter;


CALL proc_stergere("Dodu Petru");

*/

/*
prod 6
    

delimiter $$   
CREATE FUNCTION func_c_in_univ(v_cercet VARCHAR(50), v_univ INT)
RETURNS BOOL
DETERMINISTIC
BEGIN
    DECLARE v_rez  BOOL DEFAULT FALSE;
    SELECT IF(EXISTS(
             SELECT *
             FROM universitate
             inner join cercetatori on cercetatori.iduniversitate = universitate.iduniversitate
             WHERE universitate.iduniversitate = v_univ and cercetatori.numecercetător = v_cercet), true, false) into v_rez;
    return v_rez;
END;$$
delimiter;

select func_c_in_univ("Dodu Petru",1);

    
*/



/* procedura incercare 
delimiter $$   
CREATE PROCEDURE prod_incerc ()
BEGIN
  Declare counter Int DEFAULT 0;
   count(idcercetator) into counter
    from cercetatori;
END;$$
delimiter;
 
 
CALL prod_incerc ();

 */

-- ---------------------------Functii-------------------------------

/* functia ex 7

delimiter $$   
CREATE FUNCTION func_un(
    p_idcercet INT
)
RETURNS VARCHAR(20)
DETERMINISTIC 
BEGIN 
DECLARE v_denumire VARCHAR(20);
	SELECT denuniversitate INTO v_denumire
	FROM universitate AS U INNER JOIN cercetatori AS C ON U.iduniversitate = C.idcercetator
	WHERE cercetatori.idcercetator = p_idcercet;
	RETURN v_denumire;
END; $$
delimiter;

SELECT func_un(1);
*/

/*
-- funct 8

DELIMITER $$
CREATE FUNCTION func_id_calif (p_id_cerc INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
	DECLARE v_calif VARCHAR(20);
	SELECT calificativ INTO v_calif
	FROM cercetatori
	WHERE idcercetator = p_id_cerc;
	RETURN v_calif;
END;$$
DELIMITER;

SELECT func_id_calif(1)
*/


/*
-- funct ex 9


DELIMITER $$
CREATE FUNCTION func_by_denuniversitate (p_denuniver VARCHAR(20))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE v_totalCercet INT;
	SELECT COUNT(cercetatori.iduniversitate) AS num_cercetatori INTO v_totalCercet
	FROM cercetatori INNER JOIN universitate ON cercetatori.iduniversitate = universitate.iduniversitate
	WHERE denuniversitate = p_denuniver;
	RETURN v_totalCercet;
END;$$
DELIMITER;


SELECT func_by_denuniversitate("USARB")

	SELECT cercetatori.iduniversitate AS num_cercetatori , idcercetator
	FROM cercetatori INNER JOIN universitate ON cercetatori.iduniversitate = universitate.iduniversitate
	WHERE denuniversitate = "USARB"
*/
/*
-- funct ex 10



DELIMITER $$
CREATE FUNCTION func_total_articole(p_iduniver INT)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE v_totalArticole INT;
	SELECT COUNT(autori.idarticol) AS num_articole INTO v_totalArticole
	FROM cercetatori INNER JOIN autori ON cercetatori.idcercetator = autori.idcercetator INNER JOIN universitate ON universitate.iduniversitate = cercetatori.iduniversitate
	WHERE universitate.iduniversitate = p_iduniver;
	RETURN v_totalArticole;
END;$$
DELIMITER;

SELECT func_total_articole(3);

*/

/*
-- funct ex 11
DELIMITER $$
CREATE FUNCTION func_articole_by_cercetator(p_numcercet VARCHAR(100))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE v_totalArticole INT;
	SELECT COUNT(autori.idarticol) AS num_articole INTO v_totalArticole
	FROM cercetatori INNER JOIN autori ON cercetatori.idcercetator = autori.idcercetator
	WHERE cercetatori.numecercetător = p_numcercet;
	RETURN v_totalArticole;
END;$$
DELIMITER;

SELECT func_articole_by_cercetator("Dodu Petru");

*/

/*
-- func ex 12


delimiter $$   
CREATE FUNCTION func_c_in_univ(v_cercet VARCHAR(50), v_univ INT)
RETURNS BOOL
DETERMINISTIC
BEGIN
    DECLARE v_rez  BOOL DEFAULT FALSE;
    SELECT IF(EXISTS(
             SELECT *
             FROM universitate
             inner join cercetatori on cercetatori.iduniversitate = universitate.iduniversitate
             WHERE universitate.iduniversitate = v_univ and cercetatori.numecercetător = v_cercet), true, false) into v_rez;
    return v_rez;
END;$$
delimiter;

select func_c_in_univ("Dodu Petru",3);

*/



-- End lab 3

/* -------------------------LAB6 -------------------------------------------------------------
ex1

CREATE TABLE cercetatori_copy LIKE cercetatori;
INSERT INTO cercetatori_copy SELECT * FROM cercetatori;
SELECT * FROM cercetatori_copy



delimiter $$ 
CREATE PROCEDURE p_cursor1 (p_iduniv INT) 
BEGIN  
 DECLARE finisare INT DEFAULT 0; 
 DECLARE v_idcerc INT ; 
 DECLARE contor INT DEFAULT 0; 
 DECLARE c_stergere CURSOR for 
  SELECT idcercetator  
  FROM cercetatori_copy 
  WHERE iduniversitate = p_iduniv; 
   
 DECLARE CONTINUE handler 
 FOR NOT FOUND SET finisare = 1; 
  
 OPEN c_stergere; 
 et1: loop  
  fetch c_stergere INTO v_idcerc; 
  if finisare  = 1 then 
   leave et1; 
  END if; 
  DELETE FROM cercetatori_copy  
   WHERE idcercetator = v_idcerc; 
  SET contor = contor + 1; 
 END loop et1; 
 close c_stergere; 
 SELECT contor; 
END;$$ 
delimiter; 

-- sterge cercetatori dupa id universitate
call p_cursor1(1);
 */
 
 
 
 
/*

ex1

delimiter $$ 
CREATE PROCEDURE p_cursor1 (p_iduniv INT) 
BEGIN  
 DECLARE finisare INT DEFAULT 0; 
 DECLARE v_idcerc INT ; 
 DECLARE contor INT DEFAULT 0; 
 DECLARE c_stergere CURSOR for 
  SELECT idcercetator  
  FROM cercetatori_copy 
  WHERE iduniversitate = p_iduniv; 
   
 DECLARE CONTINUE handler 
 FOR NOT FOUND SET finisare = 1; 
  
 OPEN c_stergere; 
 et1: loop  
  fetch c_stergere INTO v_idcerc; 
  if finisare  = 1 then 
   leave et1; 
  END if; 
  DELETE FROM cercetatori_copy  
   WHERE idcercetator = v_idcerc; 
  SET contor = contor + 1; 
 END loop et1; 
 close c_stergere; 
 SELECT contor; 
END;$$ 
delimiter; 
 
CALL p_cursor1(1);
*/





/* crearea cursor_2

creem tabel temporar pentru datele ce vor 
CREATE TABLE tab_temp(
nume VARCHAR(50),
univers VARCHAR(50)
)

-- Definim cursorul pentru cercetatorii care au cel putin doua articole
DROP PROCEDURE IF EXISTS curs_2;

DELIMITER $$

CREATE PROCEDURE curs_2()
BEGIN
    DECLARE Nume VARCHAR(255);
    DECLARE Univers VARCHAR(255);
    DECLARE done bool DEFAULT FALSE;
    
    -- Definim cursorul pentru cercetatorii care au cel putin doua articole
    DECLARE cursor_articole CURSOR FOR 
    SELECT c.`numecercetător`, u.denuniversitate
    FROM Cercetatori C
    left JOIN Autori A ON C.idcercetator = A.idcercetator
    LEFT JOIN Universitate U ON C.iduniversitate = U.iduniversitate
    GROUP BY C.`numecercetător`, U.denuniversitate
    HAVING COUNT(A.idarticol) >= 2;
    
    
    -- Definim cursorul pentru cercetatorii care au un articol
    DECLARE cursor_un_articol CURSOR FOR 
    SELECT c.`numecercetător`, u.denuniversitate
    FROM Cercetatori C
    left JOIN Autori A ON C.idcercetator = A.idcercetator
    LEFT JOIN Universitate U ON C.iduniversitate = U.iduniversitate
    GROUP BY C.`numecercetător`, U.denuniversitate
    HAVING COUNT(A.idarticol) = 1;
    
    DECLARE CONTINUE handler 
    FOR NOT FOUND SET done = 1; 
    -- Afisam antetul pentru primul cursor
    INSERT INTO tab_temp SELECT 'Cercetatori ','cu cel putin doua articole:';
    
    -- Deschidem primul cursor si afisam rezultatele
    
    OPEN cursor_articole;
    read_loop: LOOP
        FETCH cursor_articole INTO Nume, Univers;
        IF done THEN
            LEAVE read_loop;
        END IF;
		  INSERT INTO tab_temp SELECT Nume, Univers ;
    END LOOP;
    CLOSE cursor_articole;
    
    -- Afisam o linie intre cele doua antete
    
   	INSERT INTO tab_temp SELECT '----------------------------','------------------------';
    
    -- Afisam antetul pentru al doilea cursor
    
    	  INSERT INTO tab_temp SELECT 'Cercetatori',' cu un singur articol:';
    
    set done = FALSE;
    -- Deschidem al doilea cursor si afisam rezultatele
    OPEN cursor_un_articol;
    read_loop: LOOP
        FETCH cursor_un_articol INTO Nume, Univers;
        IF done THEN
            LEAVE read_loop;
        END IF;
		  INSERT INTO tab_temp SELECT Nume, Univers ;
    END LOOP;
    CLOSE cursor_un_articol;
END;$$

DELIMITER ;

-- Apelam procedura
CALL curs_2;

-- afisam datele din tabel temporar
SELECT * FROM tab_temp

-- stergem datele din tabel 
DELETE FROM tab_temp

*/



/*
DROP PROCEDURE IF EXISTS curs_3;

DELIMITER $$
CREATE PROCEDURE curs_3()
BEGIN
    DECLARE nume1 VARCHAR(255) DEFAULT '';
    DECLARE nume2 VARCHAR(255) DEFAULT '';
    DECLARE nume3 VARCHAR(255) DEFAULT '';
    DECLARE done BOOL DEFAULT false;
    
    -- Definim cursorul pentru primele nume a cercetatorilor ordonati crescator
    DECLARE curs_cercetatori CURSOR FOR 
    SELECT `numecercetător` 
    FROM Cercetatori 
    ORDER BY `numecercetător` ASC 
    LIMIT 3;
    
    DECLARE CONTINUE HANDLER 
	 FOR NOT FOUND SET done = 1; 
    
    -- Deschidem cursorul și afișăm numele cercetătorilor
    OPEN curs_cercetatori;
    read_loop: LOOP
        FETCH curs_cercetatori INTO nume1;
        IF done THEN
            LEAVE read_loop;
        END IF;
        FETCH curs_cercetatori INTO nume2;
        IF done THEN
            LEAVE read_loop;
        END IF;
        FETCH curs_cercetatori INTO nume3;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Afisam mesajele insoțite de numele cercetatorilor
        SELECT CONCAT('primul nume = ', nume1) union
        SELECT CONCAT('al doilea nume = ', nume2) union
        SELECT CONCAT('al treilea nume = ', nume3);
    END LOOP;
    CLOSE curs_cercetatori;
    
END$$
DELIMITER ;

CALL curs_3;

*/


/* cursor_4
creem tabel temporar pentru datele temp

CREATE TABLE tab_temp4(
nume VARCHAR(250)
)



DROP PROCEDURE IF EXISTS curs_4;

DELIMITER $$

CREATE PROCEDURE curs_4()
BEGIN
    DECLARE done BOOL DEFAULT false;
    DECLARE nume_cercetator VARCHAR(255);
    DECLARE prenume_cercetator VARCHAR(255);
    DECLARE numar_articole INT;
    DECLARE rezultat VARCHAR(255);
    
    -- Definim cursorul pentru fiecare cercetător
    DECLARE curs_cercetator CURSOR FOR 
    SELECT SUBSTRING_INDEX(`numecercetător`, ' ', 1),
       SUBSTRING_INDEX(`numecercetător`, ' ', -1),
       COUNT(autori.idarticol)
		FROM cercetatori
	 RIGHT JOIN autori ON autori.IdCercetator = cercetatori.idcercetator
	 GROUP BY numecercetător;           
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
    
    -- Deschidem cursorul și afișăm numărul de articole pentru fiecare cercetător
    OPEN curs_cercetator;
    read_loop: LOOP
        FETCH curs_cercetator INTO nume_cercetator, prenume_cercetator, numar_articole;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- Afisam informatiile despre cercetator si numarul de articole
        INSERT INTO tab_temp4 SELECT CONCAT('Nume - ', nume_cercetator, ', prenume - ', prenume_cercetator, ', articole - ', numar_articole);
		  
    END LOOP;
    CLOSE curs_cercetator;
    
END$$

DELIMITER ;

-- Apelam cursor
CALL curs_4;

-- afisam datele din tabel temporar
SELECT * FROM tab_temp4

-- stergem datele din tabel 
DELETE FROM tab_temp4
	
*/


/*
cursor_5
creem tabel temporar pentru datele temp

CREATE TABLE tab_temp5(
nume VARCHAR(250)
)

DROP PROCEDURE IF EXISTS curs_5;
DELIMITER $$

CREATE PROCEDURE curs_5()
BEGIN
    DECLARE done BOOL DEFAULT false;
    DECLARE nume_cercetator VARCHAR(255);
    DECLARE nume_articol VARCHAR(255);
    
    -- Definim cursorul pentru fiecare cercetător
    DECLARE curs_articole CURSOR FOR 
    SELECT denarticol, `numecercetător`
	 FROM autori
	 INNER JOIN articole ON articole.idarticol = autori.IdArticol
	 INNER JOIN cercetatori ON cercetatori.idcercetator = autori.IdCercetator;
         
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
    
    -- Deschidem cursorul și afișăm numărul de articole pentru fiecare cercetător
    OPEN curs_articole;
    read_loop: LOOP
        FETCH curs_articole INTO nume_cercetator, nume_articol;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- Afisam informatiile despre cercetator si numarul de articole
        INSERT INTO tab_temp5 SELECT CONCAT('Denumirea articolului - ',  nume_cercetator  , ', autori - ', nume_articol);
		  
    END LOOP;
    CLOSE curs_articole;
    
END$$

DELIMITER ;

  
-- Apelam cursor

CALL curs_5;

-- afisam datele din tabel temporar

SELECT * FROM tab_temp5

-- stergem datele din tabel 

DELETE FROM tab_temp5


*/

#-------------Lab-------------Nr 4 ------------------------------------------------

#----Tab persoane
CREATE TABLE Persoane (
	idPersoana INT,
	Nume VARCHAR(50),
	Varsta INT 
)

INSERT INTO Persoane (idPersoana, Nume, Varsta) VALUES 
(1,'Elvi',19),
(2,'Farouk',19),
(3,'Sam',19),
(4,'Tiany',19),
(5,'Nadia',14),
(6,'Chris',12),
(7,'kris',10),
(8,'Bethany',16),
(9,'Louis',17),
(10,'Austin',22),
(11,'Gabriel',21),
(12,'Jessica',20),
(13,'John',16),
(14,'Alfred',19),
(15,'Samantha',17),
(16,'Craig',17);

SELECT * FROM Persoane

#----------Tab rude

CREATE TABLE Rude (
	idPersoana1 INT,
	idPersoana2 INT 
)


INSERT INTO Rude (idPersoana1, idPersoana2) VALUES 
(4,6),
(2,4),
(9,7),
(7,8),
(11,9),
(13,10),
(14,5),
(12,13)

SELECT * FROM rude 


#----------Tab Amici

CREATE TABLE Amici (
	idPersoana1 INT,
	idPersoana2 INT 
)


INSERT INTO Amici (idPersoana1, idPersoana2) VALUES
(1,2),
(1,3),
(2,4),
(2,6),
(3,9),
(4,9),
(7,5),
(5,8),
(6,10),
(13,6),
(7,6),
(8,7),
(9,11),
(12,9),
(10,15),
(12,11),
(12,15),
(13,16),
(15,13),
(16,14)


SELECT * FROM amici 


# Ex 1 --------


 delimiter $$
 CREATE TRIGGER trig1
 AFTER INSERT 
 	ON persoane
 	FOR EACH row
 BEGIN
 INSERT INTO amici(idpersoana1, idpersoana2)
 	VALUES (NEW.idPersoana, (SELECT persoane.idPersoana 
 									FROM persoane 
 									WHERE persoane.Nume = "Elvi"));
 END $$
 delimiter ;



INSERT INTO persoane VALUES (19, 'Alex', 21);

SELECT * FROM persoane

SELECT * FROM amici




#Ex 2 ----------

DELIMITER $$
CREATE TRIGGER trig2
before INSERT ON persoane
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT * FROM persoane WHERE Nume = NEW.Nume
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Atenție! Așa persoană există!';
    END IF;
END $$
DELIMITER ;


INSERT INTO persoane VALUES (18, 'Alin', 21);

SELECT * FROM persoane


# Ex 3 -------------------

DELIMITER $$
CREATE TRIGGER trig3
AFTER INSERT   
	ON rude 
	FOR EACH ROW
BEGIN
	IF EXISTS (
    SELECT *
    FROM rude r
    LEFT JOIN amici a ON (r.idPersoana1 = a.idPersoana1 AND r.idPersoana2 = a.idPersoana2)
    WHERE (r.idPersoana1 = NEW.idPersoana1 AND r.idPersoana2 = NEW.idPersoana2)
       OR (r.idPersoana1 = NEW.idPersoana2 AND r.idPersoana2 = NEW.idPersoana1)
       OR (a.idPersoana1 = NEW.idPersoana1 AND a.idPersoana2 = NEW.idPersoana2)
       OR (a.idPersoana1 = NEW.idPersoana2 AND a.idPersoana2 = NEW.idPersoana1)) 
	 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Asa pereche exista.';
ELSE
    INSERT INTO amici (idPersoana1, idPersoana2) VALUES (NEW.idPersoana1, NEW.idPersoana2);
END IF;
END $$
DELIMITER;

SELECT * FROM rude;
SELECT * FROM amici;

INSERT INTO rude VALUES (2,4);


#Ex 4 ----------------------

delimiter $$
CREATE TRIGGER trig4
AFTER DELETE 
ON rude
FOR EACH ROW
BEGIN
	DELETE FROM amici
	WHERE (amici.idpersoana1 = OLD.idpersoana1 AND amici.idpersoana2 = OLD.idpersoana1)
		OR (amici.idpersoana1 = OLD.idpersoana2 AND amici.idpersoana2 = OLD.idpersoana1);
END $$
delimiter ;
 
DELETE FROM rude WHERE idpersoana1 = 17 AND idpersoana2 = 18;
 






