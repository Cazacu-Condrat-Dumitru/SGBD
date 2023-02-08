CREATE TABLE articole
(
 idarticol INT,
 denarticol VARCHAR(50)
);

INSERT INTO articole (idarticol,denarticol) VALUES
 (1, 'Articol1'),
 (2, 'Articol2'),
 (3, 'Articol3'),
 (4, 'Articol4'),
 (5, 'Articol5');


CREATE TABLE autori (
 IdCercetator INT(11) NOT NULL,
 IdArticol INT(11) NOT NULL, PRIMARY KEY (IdCercetator, IdArticol) 
);

INSERT INTO autori
 (IdCercetator, IdArticol) VALUES 
 (1, 1),
 (2, 2),
 (3, 3),
 (4, 4);


INSERT INTO autori
 (IdCercetator, IdArticol) VALUES 
 (1, 1),
 (2, 2),
 (3, 3),
 (4, 4);


CREATE TABLE universitate (
 iduniversitate INT(11) NOT NULL,
 denuniversitate TINYTEXT NOT NULL, PRIMARY KEY (iduniversitate) 
);


INSERT INTO universitate (iduniversitate, denuniversitate) VALUES 
(1, 'USARB'),
(2, 'USM'),
(3, 'ASEM');

CREATE TABLE cercetatori (
 idcercetator INT(11) NOT NULL,
 numecercetător TINYTEXT NOT NULL,
 iduniversitate INT(11) NOT NULL, PRIMARY KEY (idcercetator) 
);

INSERT INTO cercetatori (idcercetator, numecercetător, iduniversitate) VALUES 
 (1, 'Dodu Petru', 1),
 (2, 'Lungu Vasile', 2),
 (3, 'Vrabie Maria', 1),
 (4, 'Ombun Bogdan', 3);
/* 1.	Creați o procedură care preia id cercetătorului ca parametru și returnează lista articolelor acestui în ordinea alfabetică
-- */


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
CALL proc_lista_articole(4);


 /*2.Creați o procedură care preia id universității ca parametru și returnează lista cercetătorilor împreună cu articolele acestora care activează în universitatea respectivă. 
-- Dacă un cercetător nu are articole el nu trebuie să apară în listă */

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
   
 -- 3.Creați o procedură care preia id universității și returnează lista cercetătorilor împreună 
-- cu articolele acestora care activează în universitatea respectivă. Dacă un cercetător nu 
-- are articole el oricum trebuie să apară în listă, în dreptul lui se va afișa null pentru 
-- denumirea articolului

 delimiter $$   
CREATE PROCEDURE proc_lista_cercet_all (IN id_univ INT)
BEGIN
    select cercetatori.numecercetător, articole.denarticol
    from cercetatori
    inner  join autori on autori.IdCercetator = cercetatori.idcercetator
    left  join articole on articole.idarticol = autori.IdArticol
    where cercetatori.iduniversitate = id_univ;
END;$$
delimiter ;
  
/*4Creați o procedură care va determina pentru fiecare cercetător reitingul general și pe 
universitate. Reitingul general se va determina după formula: numărul de articole a 
cercetătorului/numărul total de articole*100. Reitingul pe universitate se va determina 
după formula: numărul de articole a cercetătorului/numărul total de articole pe 
universitate*100.*/
delimiter $$   
CREATE PROCEDURE proc_raiting ()
BEGIN
    DECLARE num_articole INT DEFAULT 0;
    DECLARE num_articole_univ INT DEFAULT 0;
    
    select count(idarticol) into num_articole from articole;
    
    select cercetatori.numecercetător ,count(autori.IdArticol) / num_articole *100 as 'reitingul general',
     count(autori.IdArticol) /temp.reiting *100 as 'reitingul pe universitate'
    from cercetatori
    inner join autori on autori.IdCercetator = cercetatori.idcercetator
    inner join (
        select iduniversitate, count(iduniversitate) as reiting
        from cercetatori
        inner join autori on autori.IdCercetator = cercetatori.idcercetator
        group by  cercetatori.iduniversitate
    ) as temp on temp.iduniversitate = cercetatori.iduniversitate
    group by cercetatori.idcercetator;
END;$$
delimiter ;

/*5Adăugați în tabelul Cercetători un atribut nou – Calificativ. Creați o procedură care
completa valorile pentru atributul Calificativ în felul următor: „foarte bine” – dacă
numărul de articole este mai mare de 25; „bine” – dacă numărul de articole este în
intervalul 15-25, „suficient” dacă numărul de articole este în intervalul 5-15 și
„insuficient” dacă numărul de articole este mai mic de 5.*/
alter table cercetatori
add column Calificativ VARCHAR(30) default null;
delimiter $$   
CREATE PROCEDURE proc_add_calificativ ()
BEGIN
    delimiter $$   
CREATE PROCEDURE proc_add_calificativ ()
BEGIN
    Declare counter Int default 0;
    Declare i Int default 0;
    Declare cercet Int default 0;
    Declare art_cercet Int default 0;
    select count(idcercetator) into counter
    from cercetatori;
    CREATE TEMPORARY TABLE cercet_articol select count(autori.IdCercetator) as Number, cercetatori.idcercetator
    from autori
    inner join cercetatori on cercetatori.idcercetator = autori.IdCercetator
    group by cercetatori.idcercetator;
    While counter > 0 do
        select Number, idcercetator into art_cercet, cercet  from cercet_articol limit i, 1;
        if art_cercet > 25 then
            update cercetatori
            set cercetatori.Calificativ = 'foarte bine'
            where cercetatori.idcercetator = cercet;
        ELSEIF  art_cercet >= 15 and art_cercet <=25  then
            update cercetatori
            set cercetatori.Calificativ = 'bine'
            where cercetatori.idcercetator = cercet;
        ELSEIF  art_cercet >= 5 and art_cercet <15  then
            update cercetatori
            set cercetatori.Calificativ = 'suficient'
            where cercetatori.idcercetator = cercet;
        else
            update cercetatori
            set cercetatori.Calificativ = 'insuficient'
            where cercetatori.idcercetator = cercet;
        end if;
    End while; 
END;$$
delimiter ;

/*7Creați o funcție care ar returna după id cercetator dat ca parametru denumirea
universității în care activează.*/
delimiter $$   
CREATE FUNCTION func_universitate(
    id_cercet INT
)
RETURNS tinytext
BEGIN
    DECLARE denumire_univers tinytext DEFAULT '';
    select universitate.denuniversitate as Universitate into denumire_univers
    from cercetatori
    inner join universitate on cercetatori.iduniversitate = universitate.iduniversitate
    where cercetatori.idcercetator = id_cercet;
    return denumire_univers;
END;$$
delimiter ;

/*8Creați o funcție care ar returna după id cercetator dat ca parametru calificativul
acestuia.*/
delimiter $$   
CREATE FUNCTION func_calificativ(
    id_cercet INT
)
RETURNS varchar(30)
BEGIN
    DECLARE state varchar(30) DEFAULT '';
    select Calificativ into state
    from cercetatori
    where idcercetator = id_cercet;
    return state;
END;$$
delimiter ;

/*9. Creați o funcție care ar returna după denumirea universității date ca parametru numărul
de cercetători care activează în universitatea dată.*/
delimiter $$   
CREATE FUNCTION func_num_lucr(
    den_univ tinytext
)
RETURNS int
BEGIN
    DECLARE workers int DEFAULT 0;
    select  count(universitate.iduniversitate) as 'Numarul cercetatori' into workers
    from cercetatori
    inner join universitate on universitate.iduniversitate = cercetatori.iduniversitate
    where universitate.denuniversitate = den_univ
    group by universitate.iduniversitate;
    return workers;
END;$$
delimiter ;

/* 10Creați o funcție care ar returna după id universității date ca parametru numărul de
articole scrise de colaboratorii acestei universități.*/
delimiter $$   
CREATE FUNCTION func_num_articol(
    id_univ int
)
RETURNS int
BEGIN
    DECLARE works int DEFAULT 0;
    select  count(autori.IdCercetator) as 'Numarul de articole'  into works
    from cercetatori
    inner join universitate on universitate.iduniversitate = cercetatori.iduniversitate
    inner join autori on autori.IdCercetator = cercetatori.idcercetator
    where universitate.iduniversitate = id_univ
    group by universitate.iduniversitate;
    return works;
END;$$
delimiter ;

/* 11Creați o funcție care ar returna după numele cercetatorului dat ca parametru numărul
de articole scrise de el.*/
delimiter $$   
CREATE FUNCTION func_num_articol_by_cerc(
    cercet tinytext
)
RETURNS int
BEGIN
    DECLARE works int DEFAULT 0;
    select  count(autori.IdCercetator) as 'Numarul de articole'  into works
    from cercetatori
    inner join autori on autori.IdCercetator = cercetatori.idcercetator
    where cercetatori.numecercetător like  CONCAT('%',cercet,'%');
    return works;
END;$$
delimiter ;

/*12. Creați o funcție care returnează True sau False în dependență de faptul dacă un
cercetător (numele și prenumele) lucrează în universitatea dată (id universitate) date ca
parametri*/
delimiter $$   
CREATE FUNCTION func_cercet_lucr_univ(
    cercet tinytext,
    univ int
)
RETURNS bool
BEGIN
    DECLARE result  bool DEFAULT 0;
    SELECT IF( EXISTS(
             SELECT *
             FROM universitate
            inner join cercetatori on cercetatori.iduniversitate = universitate.iduniversitate
             WHERE universitate.iduniversitate =  univ and cercetatori. numecercetător like CONCAT('%',cercet,'%')), true, false) into result;
    return result;
END;$$
delimiter ;
