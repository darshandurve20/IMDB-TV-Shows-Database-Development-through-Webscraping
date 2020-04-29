#Separating Actors from Tv Show table for Normalisation
insert into actors
WITH recursive tmp(tv_show_name, actor, star_cast) AS
(
    SELECT
        tv_show_name,
        LEFT(star_cast, Locate(',', concat(star_cast ,',')) - 1),
        Insert(star_cast, 1, Locate(',', concat(star_cast ,',')), '')
    FROM tv_show
    UNION all

    SELECT
        tv_show_name,
        LEFT(star_cast, Locate(',', concat(star_cast ,',')) - 1),
        Insert(star_cast, 1, Locate(',', concat(star_cast ,',')), '')
    FROM tmp
    WHERE
        star_cast>''
)
SELECT
    tv_show_name,
    actor
FROM tmp
ORDER BY tv_show_name;

#Deleting Star Cast from TV Show table 
ALTER TABLE tv_show
DROP COLUMN star_cast;
