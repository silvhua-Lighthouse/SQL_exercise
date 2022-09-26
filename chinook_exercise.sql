/* SQL Exercise
====================================================================
We will be working with database chinook.db
You can download it here: https://drive.google.com/file/d/0Bz9_0VdXvv9bWUtqM0NBYzhKZ3c/view?usp=sharing&resourcekey=0-7zGUhDz0APEfX58SA8UKog

 The Chinook Database is about an imaginary video and music store. Each track is stored using one of the digital formats and has a genre. 
 The store has also some playlists, where a single track can be part of several playlists. Orders are recorded for customers, but are called invoices. 
 Every customer is assigned a support employee, and Employees report to other employees.
*/


-- MAKE YOURSELF FAIMLIAR WITH THE DATABASE AND TABLES HERE
/*
SELECT Name, Title FROM artists
    JOIN albums
    ON artists.ArtistId = albums.ArtistId
    WHERE title IS NULL;

SELECT Name, Title FROM artists
    JOIN albums
    ON artists.ArtistId = albums.ArtistId
    WHERE title IS NOT NULL;
*/



--==================================================================
/* TASK I
Which artists did not make any albums at all? Include their names in your answer.
*/
-- list of artists with null albums
SELECT Name, Title FROM artists
    LEFT OUTER JOIN albums
    ON artists.ArtistId = albums.ArtistId
    WHERE title IS NULL
    ORDER BY artists.Name; 

-- Sum of artists with null albums:  71
SELECT Name, Title,COUNT(Name) FROM artists
    LEFT OUTER JOIN albums
    ON artists.ArtistId = albums.ArtistId
    WHERE title IS NULL;


/* TASK II
Which artists recorded any tracks of the Latin genre?
*/
/* Showing my work
SELECT * FROM tracks;
SELECT artists.Name, albums.Title, genres.Name AS 'album name' FROM artists
    JOIN albums
    ON artists.ArtistId = albums.ArtistId
    JOIN tracks
    ON tracks.AlbumId = albums.AlbumId
    JOIN genres
    ON genres.GenreId = tracks.GenreId
*/
SELECT DISTINCT artists.Name FROM artists
    JOIN albums
    ON artists.ArtistId = albums.ArtistId
    JOIN tracks
    ON tracks.AlbumId = albums.AlbumId
    JOIN genres
    ON genres.GenreId = tracks.GenreId
    WHERE genres.Name = 'Latin'
/* ANSWER: 28 total artists:
Caetano Veloso
Chico Buarque
Chico Science & Nação Zumbi
Cláudio Zoli
Marcos Valle
Antônio Carlos Jobim
Gonzaguinha
Various Artists
Ed Motta
Cássia Eller
Djavan
Elis Regina
Falamansa
Funk Como Le Gusta
Gilberto Gil
Eric Clapton
Jorge Ben
Jota Quest
Legião Urbana
Lulu Santos
Marisa Monte
Milton Nascimento
Olodum
Os Paralamas Do Sucesso
Tim Maia
Vinícius De Moraes
Zeca Pagodinho
Luciana Souza/Romero Lubambo
*/

/* TASK III
Which video track has the longest length?
*/
-- Tables: tracks, media_types
SELECT MediaTypeId, Milliseconds FROM tracks;
SELECT Name FROM media_types; -- lists types of media file, including '%video%'
SELECT Name FROM tracks; -- lists track title

SELECT tracks.Name, media_types.Name,tracks.Milliseconds FROM tracks
    JOIN media_types
    ON tracks.MediaTypeId = media_types.MediaTypeId
    WHERE media_types.Name LIKE '%video%'
    ORDER BY tracks.Milliseconds DESC
-- ANSWER: "Occupation / Precipice"

/* TASK IV
Find the names of customers who live in the same city as the top employee (The one not managed by anyone).
*/
-- Preview data in these tables: employees, customers
SELECT * FROM employees; -- One employee reports to NULL and is in Edmonton

-- list more details to confirm the query is correct
SELECT customers.FirstName, customers.LastName, customers.City, employees.City,employees.ReportsTo from customers
    LEFT OUTER JOIN employees
    ON customers.City = employees.City
    WHERE (employees.ReportsTo IS NULL) AND (employees.City IS NOT NULL);

-- Confirm that the above query is correct
SELECT customers.FirstName, customers.LastName, customers.City from customers
    WHERE customers.City = 'Edmonton'

--Final answer: Mark Philips
SELECT customers.FirstName, customers.LastName from customers
    LEFT OUTER JOIN employees
    ON customers.City = employees.City
    WHERE (employees.ReportsTo IS NULL) AND (employees.City IS NOT NULL);


/* TASK V
Find the managers of employees supporting Brazilian customers.
*/
-- Relevant tables: employees, customers. ManagerID is linked to EmployerID. Join and self-join needed.
SELECT SupportRepId FROM customers; -- this matches employeeId in employees

SELECT EmployeeId,FirstName, ReportsTo FROM employees;

SELECT manager.EmployeeId AS 'manager ID', manager.FirstName AS manager, emp.EmployeeId AS 'employee id', emp.FirstName AS employee FROM customers
    LEFT OUTER JOIN employees emp
    ON SupportRepId = emp.EmployeeId
    LEFT OUTER JOIN employees manager
    ON emp.ReportsTo = manager.EmployeeId
    WHERE customers.Country = 'Brazil'
    GROUP BY manager.FirstName;

-- ANSWER: Manager named Nancy
SELECT manager.FirstName AS manager, customers.Country AS customersCountry FROM customers
    LEFT OUTER JOIN employees emp
    ON SupportRepId = emp.EmployeeId
    LEFT OUTER JOIN employees manager
    ON emp.ReportsTo = manager.EmployeeId
    WHERE customers.Country = 'Brazil'
    GROUP BY manager.FirstName;

-- (Confirm above by listing all customers from Brazil)
SELECT customers.FirstName,SupportRepId,ReportsTo FROM customers
    JOIN employees
    ON SupportRepId = EmployeeId
    WHERE customers.Country LIKE '%Brazil%'


/* TASK VI
Which playlists have no Latin tracks?
*/
-- Required tables: genres, playlists, playlist_track, tracks
SELECT * FROM playlist_track; -- lists track ID
SELECT * FROM playlists; -- playlists table just has title of playlist.

-- Do required joins
SELECT playlists.Name AS playlistName, playlist_track.TrackId, genres.Name as genreName, tracks.Name FROM playlists
    JOIN playlist_track
    ON playlists.PlaylistId = playlist_track.PlaylistId -- match track to playlist
    JOIN tracks
    ON tracks.TrackId = playlist_track.TrackId -- match track ID to song
    JOIN genres
    ON genres.GenreId = tracks.GenreId; -- match track to genre

-- FINAL ANSWER Filter irrelevant playlists
SELECT DISTINCT playlists.Name FROM playlists
    JOIN playlist_track
    ON playlists.PlaylistId = playlist_track.PlaylistId -- match track to playlist
    JOIN tracks
    ON tracks.TrackId = playlist_track.TrackId -- match track ID to song
    JOIN genres
    ON genres.GenreId = tracks.GenreId -- match track to genre
    WHERE genres.Name <> 'Latin';
/* ANSWER: Playlist names:
Music
Heavy Metal Classic
90’s Music
Grunge
On-The-Go 1
Classical
Classical 101 - Deep Cuts
TV Shows
Music Videos
Classical 101 - The Basics
Classical 101 - Next Steps
*/