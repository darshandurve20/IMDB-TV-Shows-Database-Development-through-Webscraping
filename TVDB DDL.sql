
CREATE DATABASE TVDB;
USE TVDB;
DROP TABLE TV_SHOW;
CREATE TABLE TV_SHOW(
tv_show_name varchar(128) PRIMARY KEY,
tv_show_id varchar(32),
imdb_rating double,
votes double,
tv_show_description varchar(5000),
runtime int,
genre varchar(512),
star_cast varchar(5000),
start_year int,
end_year int
);
drop table episodes;
CREATE TABLE EPISODES(
episode_name varchar(512),
tv_show_name varchar(128) ,
imdb_ratings double,
runtime_in_mins int,
director varchar(512),
season_num int,
episode_num int,
FOREIGN KEY (tv_show_name) REFERENCES tv_show(tv_show_name)
#,PRIMARY KEY(episode_name,tv_show_name) #because episode names can be the same across two shows
);
#alter table episodes add column episode_num int;
#ALTER TABLE episodes CHANGE COLUMN `season` `season_num` int;

drop table netflix_ratings;
CREATE TABLE NETFLIX_RATINGS(
	tv_show_name varchar(128),
	rating varchar(16),
	rating_Level int,
	rating_Description varchar(512),
	release_year int,
	user_rating_score double,
	user_rating_size int
    #FOREIGN KEY (tv_show_name) REFERENCES tv_show(tv_show_name)
    );

use tvdb;
drop table youtube;

CREATE TABLE YOUTUBE(
tv_show_name varchar(128),
video_id varchar(32) PRIMARY KEY,
video_title varchar(256),
video_description varchar(5000),
views double,
likes double,
dislikes double,
video_duration varchar(64),
FOREIGN KEY (tv_show_name) REFERENCES tv_show(tv_show_name)
);


drop table youtube_comments;

CREATE TABLE youtube_comments(
video_id varchar(32),
comments varchar(5000),
FOREIGN KEY (video_id) REFERENCES youtube(video_id)
);

use tvdb;

drop table tweets;

CREATE TABLE tweets(
tv_show_name varchar(128),
text varchar(5000),
created_date varchar(64),
favourites_count double,
screen_name varchar(128),
location varchar(128),
FOREIGN KEY (tv_show_name) REFERENCES tv_show(tv_show_name)
);

use tvdb;
CREATE TABLE stage_episode(
episode_name varchar(128),
tv_show_name varchar(128),
imdb_ratings float,
runtime_in_mins int,
director varchar(128),
season varchar(64)
);

create table stage_tv_show(
tv_show_name varchar(128),
tv_show_id varchar(32),
imdb_rating double,
votes int,
tv_show_description varchar(256),
runtime int,
genre varchar(64),
star_cast varchar(1024),
start_year int,
end_year int
);

#alter table stage_episode modify column imdb_ratings varchar(4);
#alter table netflix_ratings drop foreign key 'tv_show_name';
#drop table stage_youtube;
create table stage_youtube(
tv_show_name varchar(128),
Video_ID varchar(32),
Video_title varchar(128),
Description varchar(4096),
Views bigint,
Likes int,
Dislikes int,
Video_Duration varchar(32)
);
describe youtube;
describe youtube_comments;
select * from stage_youtube;

create table stage_youtube_comments(
VideoID varchar(32),
comments varchar(8192)
);

drop table tweets;
create table tweets(
tv_show_name varchar(128)
,tweet_text varchar(256)
,created_at datetime
,favourites_count int
,screen_name varchar(128)
,location varchar(256)
,FOREIGN KEY (tv_show_name) REFERENCES tv_show(tv_show_name)
);

drop table youtube;
CREATE TABLE `youtube` (
  `tv_show_name` varchar(128) DEFAULT NULL,
  `Video_ID` varchar(512) PRIMARY KEY,
  `Video_title` varchar(128) DEFAULT NULL,
  `Description` varchar(4096) DEFAULT NULL,
  `Views` bigint(20) DEFAULT NULL,
  `Likes` int(11) DEFAULT NULL,
  `Dislikes` int(11) DEFAULT NULL,
  `Video_Duration_in_seconds` int DEFAULT NULL,
  FOREIGN KEY (tv_show_name) REFERENCES tv_show(tv_show_name)
) ;

desc youtube;
 create table youtube_comments
 (
 video_id varchar(512)
 ,comments varchar(5000)
 ,FOREIGN KEY (video_id) REFERENCES youtube(video_id)
 );



desc tv_show;
desc episodes;
desc tweets;
desc youtube;
desc youtube_comments;
desc netflix_ratings;

