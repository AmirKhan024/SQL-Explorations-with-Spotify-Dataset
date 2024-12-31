-- spotify case study 
create database spotify;
use spotify;

-- schema 
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
select * from spotify;
-- 1. Retrieve the names of all tracks that have more than 1 billion streams
SELECT 
    track
FROM
    spotify
WHERE
    stream > 1000000000;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2. List all albums along with their respective artists.
SELECT DISTINCT
    album, artist
FROM
    spotify;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3. Get the total number of comments for tracks where licensed is TRUE.
SELECT 
    SUM(comments)
FROM
    spotify
WHERE
    licensed = 'true';

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 4. Find all tracks that belong to the album type single
SELECT 
    *
FROM
    spotify
WHERE
    album_type = 'single';

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 5. Count the total number of tracks by each artist.
SELECT 
    artist, COUNT(track) AS totalTracks
FROM
    spotify
GROUP BY artist
ORDER BY totalTracks DESC;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 6. Calculate the average danceability of tracks in each album.
SELECT 
    album, ROUND(AVG(danceability), 2)
FROM
    spotify
GROUP BY album;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 7.Find the top 5 tracks with the highest energy values.
SELECT 
    track
FROM
    spotify
ORDER BY energy DESC
LIMIT 5;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 8. List all tracks along with their views and likes where official_video is TRUE
SELECT 
    track, SUM(views) AS total_views, SUM(likes) AS total_likes
FROM
    spotify
    
WHERE
    official_video = 'true'
GROUP BY track;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 9. For each album, calculate the total views of all associated tracks.
SELECT 
    album, track, SUM(views) AS total_views
FROM
    spotify
GROUP BY album , track;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube.
with cte as (
select track, 
	sum(case when most_played_on = 'Spotify' then stream end) as stream_on_spotify,
    sum(case when most_played_on = 'Youtube' then stream end) as stream_on_youtube
from spotify group by track
)
select * from cte where stream_on_spotify > stream_on_youtube;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 11. Find the top 3 tracks based on views for each artist

with cte as (
select artist,track, sum(views) as total_views, rank() over(partition by artist order by sum(views) desc) as rn
 from spotify group by artist,track
 )
 select artist,track,total_views from cte where rn <=3;
 
 -- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 12. Write a query to find tracks where the liveness score is above the average.

SELECT 
    *
FROM
    spotify
WHERE
    liveness > (SELECT 
            AVG(liveness)
        FROM
            spotify);
            
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album
with cte as (
SELECT 
    album,
    MAX(energy) AS highest_energy,
    MIN(energy) AS lowest_energy
FROM
    spotify
GROUP BY album
) 
SELECT 
    album, ROUND((highest_energy - lowest_energy), 2) AS diff
FROM
    cte
ORDER BY diff DESC;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 14. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
SELECT 
    artist,
    track,
    views,
    likes,
    SUM(likes) OVER (ORDER BY views desc) AS cumulative_likes
FROM 
    spotify;