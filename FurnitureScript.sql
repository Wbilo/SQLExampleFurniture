use master 
GO

-- Her erkl�re og s�tter vi variablen dbname til v�rdien 'WbilosFurnitureShop' 
DECLARE @dbname nvarchar(128) 
SET @dbname = N'WbilosFurnitureShop'  
 
/* Her tjekker vi om der findes en database ved navn 'WbilosFurnitureShop' allerede,
   og hvis dette er tilf�ldet s� dropper vi databasen.        
*/
IF (EXISTS (SELECT name 
FROM master.dbo.sysdatabases   
WHERE ('[' + name + ']' = @dbname 
OR name = @dbname))) 
BEGIN
   PRINT 'Dropping database';
   ALTER DATABASE WbilosFurnitureShop SET SINGLE_USER WITH ROLLBACK IMMEDIATE; 
   drop database WbilosFurnitureShop; 
END    
     
-- skaber databasen
create database WbilosFurnitureShop
GO

use WbilosFurnitureShop 
GO
-- identity(1,1) , det f�rste 1 tal betyder start v�rdien for furn_id og det andet 1 tal er increment v�rdien 
-- DEFAULT betyder standard v�rdi der bliver benyttet, hvis der ikke bliver specificeret noget
-- NOT NULL Betyder der SKAL specificeres en v�rdi ellers opst�r der en fejl, som en sikkerheds foranstaltning
-- Primary key skal v�re en unik v�rdi, der m� ikke v�re to ens primary keys i en tabel
CREATE TABLE furniture(
    furn_id INT identity(1,1) primary key,
    furn_weight int NOT NULL,
	manufacturer VARCHAR(50) DEFAULT 'No manufacturer specified');


-- Foreign key skaber et link til en anden tabel, ved at referere til den tabels primary key 
CREATE TABLE sofa(
    sofa_id INT identity(1,1) primary key,
	furn_id int FOREIGN KEY REFERENCES furniture(furn_id),
    seatSpaceCount int);



CREATE TABLE chair(
    chair_id INT identity(1,1) primary key,
	furn_id int FOREIGN KEY REFERENCES furniture(furn_id),
    legCount int);


-- Insert example (Insert statement inds�tter r�kke) 

	insert into furniture (furn_weight, manufacturer)
values (6, 'Bestar');  



insert into furniture (furn_weight, manufacturer)
values (1, 'Trendway');  

insert into furniture (furn_weight, manufacturer)
values (3, 'Trendway');  

insert into sofa (furn_id, seatSpaceCount)
values (1, 3);  

insert into chair (furn_id, legCount)
values (2, 4);  

insert into chair (furn_id, legCount)
values (3, 4);  

-- Update example (Update statement redigere en r�kke)

UPDATE furniture 
SET furn_weight = 5 
WHERE furn_id = 1; 





 
-- SELECT Examples:

--  LIKE Example:
-- Denne query henter alt info om r�kker i furniture tabellen, hvor manufacturer navnet starter med bogstavet 'T'
SELECT * 
FROM furniture
WHERE manufacturer LIKE 'T%'; 

-- AND Example:
SELECT * 
FROM furniture
WHERE manufacturer = 'Trendway'
AND furn_weight = 3; 

-- OR Example
SELECT * 
FROM furniture
WHERE manufacturer = 'Trendway'
OR manufacturer = 'Bestar'; 

-- DISTINCT Example (fjerner duplikations v�rdier fra det endelige resultat)  
SELECT DISTINCT manufacturer 
FROM furniture;  


-- TOP Example:
-- (Her v�lger vi de to f�rste resultater fra furniture tabellen )
SELECT TOP 2 * 
FROM furniture;

-- CASE Example
SELECT furn_id AS 'ID', manufacturer,
 CASE
  WHEN furn_weight > 3 THEN 'Heavy'
  WHEN furn_weight < 3 THEN 'Light'
  ELSE 'Middleweight'
 END AS 'Weight Class'
FROM furniture
ORDER BY furn_weight;






 --  Aggregate Functions Examples:

 -- COUNT(*) (Udregner m�ngden af rows) 
 SELECT COUNT(*) AS 'Amount of rows:' 
FROM furniture;

-- MAX Example (Finder den r�kke med den h�jste v�rdi, baseret p� GROUP BY i dette tilf�lde)
SELECT MAX(furn_weight) AS 'MAX Weight in kg', manufacturer 
FROM furniture
GROUP BY manufacturer; 

-- MIN Example (Finder den r�kke med den laveste v�rdi, baseret p� GROUP BY i dette tilf�lde)
SELECT MIN(furn_weight) AS 'MIN Weight in kg', manufacturer 
FROM furniture
GROUP BY manufacturer; 

-- AVG Example (Her udregner vi gennemsnitsv�rdien, baseret p� GROUP BY i dette tilf�lde)
-- HAVING (Her benytter vi HAVING til at limit resultatet, s� vi kun udregner gennemsnittet for manufacturers der har mere end 1 furniture)
SELECT AVG(furn_weight) AS 'AVG Weight in kg', manufacturer 
FROM furniture
GROUP BY manufacturer
HAVING COUNT(*) > 1; 

-- SUM Example (Udregner summen)
SELECT SUM(furn_weight) AS 'Sum in kg'
FROM furniture
WHERE manufacturer = 'Trendway';






-- SELECT Queries with multiple tables examples

-- INNER JOIN Example
-- Denne query joiner furniture og chair tabellen (dette er muligt, fordi der eksistere et foreign key relationship mellem de to tabeller)
-- INNER JOIN retunere kun r�kker hvor der er matchene v�rdier ( hvor 'ON furniture.furn_id = chair.furn_id' finder et match) 
SELECT furniture.furn_id, furniture.furn_weight, chair.legCount
FROM furniture
JOIN chair
  ON furniture.furn_id = chair.furn_id; 


-- LEFT JOIN Example 
-- LEFT JOIN retunere r�kker hvor der er matchene v�rdier og inkl. ogs� de resterende r�kker (som ikke matcher) fra tabellen til venstre  (furniture i dette tilf�lde)
SELECT furniture.furn_id, furniture.furn_weight, sofa.seatSpaceCount
FROM furniture
LEFT JOIN sofa
  ON furniture.furn_id = sofa.furn_id;  




