#index to search tweet_texts
create index tweet_text on tweets(tweet_text);

#Index to help with roll up and drill down on time data in the tweets table using the created_at column
create index tweet_created_at on tweets(created_at);

#creating an index on favorites_count in tweets table to improve view4 performance
create index favourites_count on tweets(favourites_count);

#index to help filter by imdb_rating
create index imdb_rating on tv_show(imdb_rating);

#creating an index on actors to easily retrieve the list of shows actors have starred in
create index actors on actors(actors);

#creating an index to improve view3 performance:
create index dislikes on youtube(dislikes);

#creating index on season number and episode number to improve the performance of the function
create index season_and_ep on episodes(season_num,episode_num);

#creating index to improve the performance of function 'descript'
create index descript on episodes(imdb_ratings,tv_show_name);

#creating an index on netflix_ratings for function that gets the netflix audience rating of shows
create index netflix_aud on netflix_ratings(tv_show_name,rating);

#creating an index on genre table to easily retrieve tv_shows when a user calls a procedure which selects tv_shows based on genre
create index genre_pref on genre(genre,tv_show_name)