# Function 1
#Tells if its a popular show based on its Youtube Views
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `popular`(show_name varchar(128)) RETURNS text CHARSET utf8mb4
BEGIN
DECLARE v1 int;
DECLARE v2 int;
SELECT Views INTO v1 FROM youtube where tv_show_name = show_name;
SELECT avg(Views) INTO v2 from youtube;
IF v1 > v2 THEN
RETURN 'Popular Show';
ELSE
RETURN 'Not as Popular';
END IF;
END$$

# Function 2
#Takes tv show name and judges it based on its ratings

CREATE DEFINER=`root`@`localhost` FUNCTION `rating`(show_name varchar(128)) RETURNS text CHARSET utf8mb4
BEGIN
DECLARE i int;
select imdb_rating into i from tv_show where tv_show_name = show_name;
IF i > 8.5 THEN
RETURN 'One of the best TV Shows';
ELSE
RETURN 'Sorry, TV Show is not cool enough';
END IF;
END$$

#Function 3
# Gives out the description of a TV show or suggests if its not a good show
CREATE DEFINER=`root`@`localhost` FUNCTION `descript`(show_name varchar(128)) RETURNS varchar(5000) CHARSET utf8mb4
BEGIN
DECLARE a1 int;
DECLARE a2 int;
DECLARE t1 varchar(5000);
select avg(imdb_ratings) into a1 from episodes where tv_show_name = show_name group by tv_show_name; #episode avg for that tv_show
select avg(epi_avg_rating) from (select avg(imdb_ratings) as epi_avg_rating from episodes group by tv_show_name) as epi_avg into a2; #average of episode averages
select tv_show_description into t1 from tv_show where tv_show_name = show_name;
IF a1 > a2 THEN
RETURN t1;
ELSE
RETURN 'Can wait for better Shows';
END IF;
END$$

#Function 4
# Gives out Most recent tweet of TV show

CREATE DEFINER=`root`@`localhost` FUNCTION `recent_tweet`(show_name varchar(128)) RETURNS varchar(5000) CHARSET utf8mb4
BEGIN
DECLARE t1 varchar(5000);
select tweet_text into t1 from (select lead(created_at) over (partition by tv_show_name order by created_at) as recent_tweet, t.* from tweets t where tv_show_name = show_name) as recent_tv_show_tweet where recent_tweet is null;
RETURN t1;
END$$

