#Procedure 1

DELIMITER $$
USE `tvdb`$$
CREATE PROCEDURE tv_show_proc ()
BEGIN
insert into 
	tv_show
select
	tv_show_name,
    tv_show_id,
    imdb_rating,
    votes,
    tv_show_description,
    runtime,
    genre,
    star_cast,
    CAST(start_year as UNSIGNED)
    ,CAST((case when ltrim(rtrim(end_year))='' then null else end_year end) as UNSIGNED)
from stage_tv_show;
END$$

#Procedure 2
CREATE PROCEDURE `epi_proc` ()
BEGIN
insert into episodes
select 
episode_name
,tv_show_name
,(case when imdb_ratings REGEXP '[0-9]' then imdb_ratings else NULL end) #using implicit conversion here from varchar to float
,runtime_in_mins
,director
,cast(ltrim(rtrim(substring(season,instr(season,'|')-2,2))) as unsigned) as 'season_num'
,cast(ltrim(rtrim(substring(season,LENGTH(season)-1,2))) as unsigned) as 'episode_num'
from stage_episode
where tv_show_name in (select tv_show_name from tv_show);
END$$

#Procedure 3
CREATE PROCEDURE `tweets_proc` ()
BEGIN
insert into tweets
select
tv_show_name
,text
,cast(CONCAT(RIGHT(created_at,4),'-'
,case 
	when substring(created_at,5,3) = 'Jan' then '01'
    when substring(created_at,5,3) = 'Feb' then '02'
    when substring(created_at,5,3) = 'Mar' then '03'
    when substring(created_at,5,3) = 'Apr' then '04'
    when substring(created_at,5,3) = 'May' then '05'
    when substring(created_at,5,3) = 'Jun' then '06'
    when substring(created_at,5,3) = 'Jul' then '07'
    when substring(created_at,5,3) = 'Aug' then '08'
    when substring(created_at,5,3) = 'Sep' then '09'
    when substring(created_at,5,3) = 'Oct' then '10'
    when substring(created_at,5,3) = 'Nov' then '11'
    when substring(created_at,5,3) = 'Dec' then '12'
end #as 'month'
,'-',SUBSTRING(created_at,9,2), ' ', substring(created_at,12,8)) as datetime)
,favourites_count
,screen_name
,location
from stage_tweets st join tv_show ts on INSTR(st.text, replace(ts.tv_show_name,' ',''));
END$$

#Procedure 4
CREATE PROCEDURE `youtube_proc` ()
BEGIN
insert into youtube
 select
tv_show_name
,LTRIM(RTRIM(video_id))
,Video_title
,description
,views
,likes
,dislikes
 ,CASE 
WHEN REGEXP_SUBSTR(left(video_duration, INSTR(video_duration,'H')), '[0-9]+') IS NOT NULL 
THEN CAST(REGEXP_SUBSTR(left(video_duration, INSTR(video_duration,'H')), '[0-9]+') AS UNSIGNED)*3600
ELSE 0
END 
+
CASE 
		WHEN INSTR(video_duration, 'H') > 0
			THEN CASE 
					WHEN REGEXP_SUBSTR(SUBSTRING(video_duration, INSTR(video_duration, 'H') + 1, INSTR(video_duration, 'M') - 1), '[0-9]+') IS NOT NULL
						THEN CAST(REGEXP_SUBSTR(SUBSTRING(video_duration, INSTR(video_duration, 'H') + 1, INSTR(video_duration, 'M') - 1), '[0-9]+') AS UNSIGNED) * 60
					ELSE 0
					END 
		ELSE CASE 
				WHEN REGEXP_SUBSTR(SUBSTRING(video_duration, INSTR(video_duration, 'PT') + 1, INSTR(video_duration, 'M') - 1), '[0-9]+') IS NOT NULL
					THEN CAST(REGEXP_SUBSTR(SUBSTRING(video_duration, INSTR(video_duration, 'PT') + 1, INSTR(video_duration, 'M') - 1), '[0-9]+') AS UNSIGNED) * 60
				ELSE 0
				END
		END 
+

CASE 
		WHEN INSTR(video_duration, 'M') > 0
			THEN CASE 
					WHEN REGEXP_SUBSTR(SUBSTRING(video_duration, INSTR(video_duration, 'M') + 1, INSTR(video_duration, 'S') - 1), '[0-9]+') IS NOT NULL
						THEN CAST(REGEXP_SUBSTR(SUBSTRING(video_duration, INSTR(video_duration, 'M') + 1, INSTR(video_duration, 'S') - 1), '[0-9]+') AS UNSIGNED)
					ELSE 0
					END 
		ELSE CASE 
				WHEN REGEXP_SUBSTR(SUBSTRING(video_duration, INSTR(video_duration, 'PT') + 1, INSTR(video_duration, 'S') - 1), '[0-9]+') IS NOT NULL
					THEN CAST(REGEXP_SUBSTR(SUBSTRING(video_duration, INSTR(video_duration, 'PT') + 1, INSTR(video_duration, 'S') - 1), '[0-9]+') AS UNSIGNED)
				ELSE 0
				END
END 'SECONDS'
 from stage_youtube 
 where tv_show_name in (select tv_show_name from tv_show);
END$$

#Procedure 5

CREATE PROCEDURE `youtube_comments_proc` ()
BEGIN
insert into youtube_comments
select YC.VideoID,YC.COMMENTS from stage_youtube_comments YC
JOIN YOUTUBE Y ON ltrim(rtrim(Y.VIDEO_ID))=ltrim(rtrim(YC.VIDEOID));
END$$

#Procedure 6
CREATE PROCEDURE `actors_proc` ()
BEGIN
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

UPDATE actors 
   SET actors = TRIM(BOTH '[' FROM actors);
UPDATE actors 
   SET actors = TRIM(BOTH ']' FROM actors);
UPDATE actors 
   SET actors = TRIM(BOTH '''' FROM actors);

#Deleting Star Cast from TV Show table 
ALTER TABLE tv_show
DROP COLUMN star_cast;
END$$

#Procedure 7

CREATE PROCEDURE `genre` ()
BEGIN
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
END$$

#Procedure 8
CREATE DEFINER=`root`@`localhost` PROCEDURE `genre_of_tv_show`(gen varchar(32))
BEGIN
select tv_show_name from genre where genres = gen;
END$$

#Procedure 9
#Actors of a tv show
CREATE DEFINER=`root`@`localhost` PROCEDURE `star_cast`(show_name varchar(32))
BEGIN
select actors from actors where tv_show_name = show_name;
END$$

#Procedure 10
#User Names and Location who tweeted about a tv show
CREATE DEFINER=`root`@`localhost` PROCEDURE `twitter_users`(show_name varchar(32))
BEGIN
select screen_name, location from tweets where tv_show_name = show_name;
END$$


