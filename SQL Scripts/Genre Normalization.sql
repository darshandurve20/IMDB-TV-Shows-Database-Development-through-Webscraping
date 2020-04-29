#Create genre table
use tvdb;
create table genre(
tv_show_name varchar(128),
genres varchar(32),
FOREIGN KEY (tv_show_name) REFERENCES tv_show(tv_show_name)
);

#Insert into genre table after separating from tv_show table
insert into genre
WITH recursive gen(tv_show_name, genres, genre) AS
(
    SELECT
        tv_show_name,
        LEFT(genre, Locate(',', concat(genre ,',')) - 1),
        Insert(genre, 1, Locate(',', concat(genre ,',')), '')
    FROM tv_show
    UNION all

    SELECT
        tv_show_name,
        LEFT(genre, Locate(',', concat(genre ,',')) - 1),
        Insert(genre, 1, Locate(',', concat(genre ,',')), '')
    FROM gen
    WHERE
        genre>''
)
SELECT
    tv_show_name,
    genres
FROM gen
ORDER BY tv_show_name;

#Cleaning out white spaces
UPDATE genre SET genres = REPLACE(genres, ' ', '');

#Deleting Genre from TV Show table 
ALTER TABLE tv_show
DROP COLUMN genre;