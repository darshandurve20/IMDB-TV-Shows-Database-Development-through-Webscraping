/*Loading tv_show table*/
select * from tv_show;
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

select * from stage_tv_show;
desc stage_tv_show;

select * from tv_show;
#delete from tv_show where tv_show_id is not null;

#SET SQL_SAFE_UPDATES = 0;

#inserting records into episodes
desc stage_episode;
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

#truncate table episodes;

select * from episodes;
desc stage_episode;
select * from episodes;
select distinct tv_show_name from stage_episode where tv_show_name not in (select tv_show_name from tv_show);
select * from tweets;
select * from stage_tweets;
desc stage_tweets;

select count(*) from  stage_tweets st join tv_show ts on 
#st.text=ts.tv_show_name;
INSTR(st.text, replace(ts.tv_show_name,' ',''));

select substring(created_at,12,8) from stage_tweets;
SELECT DATE_FORMAT("2017-06-15", "%b");


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
 #4207 row(s) affected
 #Records: 4207  Duplicates: 0  Warnings: 0	0.719 sec
 select count(*) from stage_tweets;
 
 select * from netflix_ratings;
 desc netflix_ratings;
 
 desc stage_youtube;
 
 insert into youtube
 select
 views
 ,Video_title
 ,video_id
 ,Video_Duration
 ,tv_show_name
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
 from stage_youtube order by video_id desc limit 10;
 
 select video_duration, INSTR(video_duration,'M') from stage_youtube;
 
 select  REGEXP_SUBSTR(left(video_duration, INSTR(video_duration,'H')),'[0-9]') from stage_youtube;
 SELECT REGEXP_SUBSTR('abc def ghi', '[a-z]+');
 select video_duration from stage_youtube;
 
#truncate table youtube;
#delete from youtube;
#truncate table youtube_comments;
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
 where tv_show_name in (select tv_show_name from tv_show)
 ;
 #order by video_id desc limit 10;
 
 select * from stage_youtube where tv_show_name not in (select tv_show_name from tv_show);
 
 select * from tv_show order by tv_show_name;


 select left(video_duration, INSTR(video_duration,'M'))
,REGEXP_SUBSTR(left(video_duration,INSTR(video_duration,'M')),'[0-9]') 
from stage_youtube;
 
 select 
 
 SELECT REGEXP_REPLACE('Stackoverflow','[A-Zf]','-',1,0,'c'); 
 select * from youtube;
 
 select * from stage_youtube;
 
 DESCRIBE youtube;
 
 select * from stage_youtube where tv_show_name not in (select tv_show_name from tv_show);
 select * from tv_show ;

 select * from stage_tv_show where tv_show_name='the punisher';
 
 select * from youtube;

 select * from stage_youtube_comments;

insert into youtube_comments
select YC.VideoID,YC.COMMENTS from stage_youtube_comments YC
JOIN YOUTUBE Y ON ltrim(rtrim(Y.VIDEO_ID))=ltrim(rtrim(YC.VIDEOID))
;

select * from stage_youtube_comments where videoid not in (select video_id from youtube);

select video_Id FROM YOUTUBE;

select YC.VideoID,YC.COMMENTS from stage_youtube_comments YC
JOIN YOUTUBE Y ON ltrim(rtrim(Y.VIDEO_ID))=ltrim(rtrim(YC.VIDEOID));

select * from tv_show;
select * from episodes;
select * from tweets;
select * from youtube;
select * from youtube_comments;

SHOW VARIABLES LIKE "secure_file_priv";

/* loading stage tables using SQL command*/
LOAD DATA INFILE 'tweets.csv' 
INTO TABLE stage_tweets 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
