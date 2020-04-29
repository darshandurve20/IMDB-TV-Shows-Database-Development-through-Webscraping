#Creation of Views
create view view_1 as
SELECT tv_show_name,sum(favourites_count) FROM tweets group by tv_show_name
ORDER BY sum(favourites_count) DESC LIMIT 10;

create view view_2 as
select 
	t.tv_show_name,views
	,end_year 
from youtube y 
join tv_show t 
	on y.tv_show_name = t.tv_show_name 
order by 
	views desc 
limit 10;

create view view_3 as
select t.tv_show_name
,dislikes
,start_year,end_year 
from youtube y 
join tv_show t 
	on y.tv_show_name = t.tv_show_name 
order by dislikes desc limit 10;


create view view_4 as
select tv.tv_show_name,SUM(favourites_count),COUNT(tw.tweet_text),MAX(imdb_rating)
from tweets tw
join tv_show tv
on tv.tv_show_name=tw.tv_show_name
group by tv.tv_show_name
order by SUM(favourites_count) desc
limit 10;


create view view_5 as
SELECT tv_show_name, user_rating_score
FROM netflix_ratings 
ORDER BY user_rating_score DESC LIMIT 10;

create view view_6 as
SELECT TV.TV_SHOW_NAME,COUNT(DISTINCT TV.SEASON_NUM),SUM(TW.FAVOURITEs_COUNT),COUNT(TW.TWEET_TEXT)
FROM TWEETS TW JOIN EPISODES TV
ON TW.TV_SHOW_NAME=TV.TV_SHOW_NAME
GROUP BY TV.TV_SHOW_NAME;


create view view_7 as
SELECT T.TV_SHOW_NAME, SUM(VIEWS) AS 'VIEWS',COUNT(T.TWEET_TEXT),SUM(FAVOURITES_COUNT)
FROM TWEETS T
JOIN YOUTUBE Y ON T.TV_SHOW_NAME=Y.TV_SHOW_NAME
GROUP BY T.TV_SHOW_NAME
ORDER BY VIEWS DESC;


create view view_8 as
SELECT tv_show_name, views, likes,LIKES*100/VIEWS FROM youtube ORDER BY Views DESC;

create view view_9 as
SELECT location, count(tweet_text) FROM tweets GROUP BY location;

create view view_10 as
SELECT genre, COUNT(tv_show_name) FROM tv_show GROUP BY genre ORDER BY COUNT(tv_show_name) DESC;

create view view_11 as
SELECT tv_show.tv_show_name, tv_show.imdb_rating, USER_rating_SCORE
FROM tv_show JOIN netflix_RATINGS ON tv_show.tv_show_name = netflix_RATINGS.tv_show_name;

#New Use Case
create view view_12 as
select tv_show_name, 
case
	when isnull(end_year) then YEAR(CURDATE())-start_year
	else end_year-start_year
end as total_duration_of_show_in_years
from tv_show;
