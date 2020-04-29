#Use Cases-
#1)	What are the TOP 10 most talked about TV shows on Twitter?
SELECT tv_show_name,sum(favourites_count) FROM tweets group by tv_show_name
ORDER BY sum(favourites_count) DESC LIMIT 10;

SELECT tv_show_name,COUNT(*) FROM tweets group by tv_show_name
ORDER BY COUNT(*) DESC LIMIT 10;

#Which is the most anticipated TV show on Youtube?
SELECT tv_show_name FROM youtube WHERE views = (SELECT max(views) FROM youtube);

select 
	t.tv_show_name,views
	,end_year 
from youtube y 
join tv_show t 
	on y.tv_show_name = t.tv_show_name 
order by 
	views desc 
limit 10;

#3)	Which are the top 10 most hated (disliked) TV show on Youtube?
SELECT tv_show_name,video_title 

FROM youtube WHERE dislikes = (SELECT max(dislikes) FROM youtube);

select t.tv_show_name
,dislikes
,start_year,end_year 
from youtube y 
join tv_show t 
	on y.tv_show_name = t.tv_show_name 
order by dislikes desc limit 10;

#4)	Are the highest rated movies on IMDB also the most talked about on Twitter?
SELECT tv_show.tv_show_name FROM tv_show 
JOIN tweets 
ON (SELECT tv_show_name FROM tv_show ORDER BY imdb_rating DESC LIMIT 10) =
(SELECT tv_show_name FROM tweets ORDER BY favourites count DESC LIMIT 10); 

select tv.tv_show_name,SUM(favourites_count),COUNT(tw.tweet_text),imdb_rating
from tweets tw
join tv_show tv
on tv.tv_show_name=tw.tv_show_name
group by tv.tv_show_name,favourites_count,imdb_rating
;

select tv.tv_show_name,SUM(favourites_count),COUNT(tw.tweet_text),MAX(imdb_rating)
from tweets tw
join tv_show tv
on tv.tv_show_name=tw.tv_show_name
group by tv.tv_show_name
order by SUM(favourites_count) desc
limit 10
;



select * from tweets where tv_show_name='A Million Little Things';


#5)	Top 10 TV shows by Netflix ratings
SELECT tv_show_name, user_rating_score
FROM netflix_ratings 
ORDER BY user_rating_score DESC LIMIT 10;


select count(*) from netflix_ratings;
select * from netflix_ratings where tv_show_name='13 Reasons Why';

#6)	Is there a correlation between number of seasons and popularity(favorite count)?
SELECT episodes.tv_show_name FROM episodes 
JOIN tweets 
ON (SELECT tv_show_name from episodes GROUP BY tv_show_name) = (SELECT tv_show_name FROM tweets);

SELECT TV.TV_SHOW_NAME,COUNT(DISTINCT TV.SEASON_NUM),SUM(TW.FAVOURITEs_COUNT),COUNT(TW.TWEET_TEXT)
FROM TWEETS TW JOIN EPISODES TV
ON TW.TV_SHOW_NAME=TV.TV_SHOW_NAME
GROUP BY TV.TV_SHOW_NAME;

#7)	 Are most talked about TV shows on Twitter also as popular (most views) on youtube ?
SELECT tweets.tv_show_name 
FROM tweets 
JOIN youtube 
ON (SELECT tv_show_name FROM tweets ORDER BY favourites_count DESC LIMIT 10) = 
(SELECT tv_show_name FROM youtube ORDER BY views DESC LIMIT 10);

SELECT T.TV_SHOW_NAME, SUM(VIEWS) AS 'VIEWS',COUNT(T.TWEET_TEXT),SUM(FAVOURITES_COUNT)
FROM TWEETS T
JOIN YOUTUBE Y ON T.TV_SHOW_NAME=Y.TV_SHOW_NAME
GROUP BY T.TV_SHOW_NAME
ORDER BY VIEWS DESC;
	
#8)	Correlation between Views and Likes for Videos on youtube?
SELECT tv_show_name, views, likes,LIKES*100/VIEWS FROM youtube ORDER BY Views DESC;

#9)	WHERE are the most tweets originating FROM (by TV shows)?
SELECT location, count(tweet_text) FROM tweets GROUP BY location;


#10)	What genres are the most popular?
SELECT genre, COUNT(tv_show_name) FROM tv_show GROUP BY genre ORDER BY COUNT(tv_show_name) DESC;

#11) Compare IMDB ratings and Netflix Ratings
SELECT tv_show.tv_show_name, tv_show.imdb_rating, USER_rating_SCORE
FROM tv_show JOIN netflix_RATINGS ON tv_show.tv_show_name = netflix_RATINGS.tv_show_name;
 

