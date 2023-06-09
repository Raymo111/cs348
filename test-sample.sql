-- Feature 1 (Accounts) --

SELECT * FROM account WHERE username = 'username';



-- Feature 2 (Obtain list of tracks and all relevant information) --

SELECT t.*,
      JSON_AGG(artist.*) as artists,
      JSON_AGG(album.*) as albums,
      JSON_AGG(genre.*) as genres
    FROM track as t
      LEFT OUTER JOIN track_to_artist ON t.id = track_to_artist.track_id
      LEFT OUTER JOIN artist ON track_to_artist.artist_id = artist.id
      LEFT OUTER JOIN track_to_album ON t.id = track_to_album.track_id
      LEFT OUTER JOIN album ON track_to_album.album_id = album.id
      LEFT OUTER JOIN track_to_genre ON t.id = track_to_genre.track_id
      LEFT OUTER JOIN genre ON track_to_genre.genre_id = genre.id
      WHERE t.account_uuid = 'b3837b5a-7b11-47f5-80be-b445febe6f09'
      GROUP BY t.id
      ORDER BY t.name ASC;



-- Feature 3 (Fetch tracks by album, in order) --

SELECT
    t.*,
    track_to_album.position as album_track,
    JSON_AGG(artist.*) as artists,
    JSON_AGG(album.*) as albums,
    JSON_AGG(genre.*) as genres
    FROM track_to_album
    INNER JOIN track as t ON t.id = track_to_album.track_id
    LEFT OUTER JOIN track_to_artist ON t.id = track_to_artist.track_id
    LEFT OUTER JOIN artist ON track_to_artist.artist_id = artist.id
    LEFT OUTER JOIN album ON track_to_album.album_id = album.id
    LEFT OUTER JOIN track_to_genre ON t.id = track_to_genre.track_id
    LEFT OUTER JOIN genre ON track_to_genre.genre_id = genre.id
    WHERE track_to_album.album_id = 20
    GROUP BY t.id, track_to_album.position
    ORDER BY track_to_album.position ASC;



-- Feature 4 (Search tracks) --

SELECT t.*,
     JSON_AGG(artist.*) as artists,
     JSON_AGG(album.*) as albums,
     JSON_AGG(genre.*) as genres
   FROM track as t
     LEFT OUTER JOIN track_to_artist ON t.id = track_to_artist.track_id
     LEFT OUTER JOIN artist ON track_to_artist.artist_id = artist.id
     LEFT OUTER JOIN track_to_album ON t.id = track_to_album.track_id
     LEFT OUTER JOIN album ON track_to_album.album_id = album.id
     LEFT OUTER JOIN track_to_genre ON t.id = track_to_genre.track_id
     LEFT OUTER JOIN genre ON track_to_genre.genre_id = genre.id
     WHERE t.account_uuid = 'b3837b5a-7b11-47f5-80be-b445febe6f09' AND (
       t.name ILIKE '%birb%' OR
       t.artist_display_name ILIKE '%birb%' OR
       t.create_year::text ILIKE '%birb%' OR
       album.name ILIKE '%birb%' OR
       genre.name ILIKE '%birb%'
     )
     GROUP BY t.id
     ORDER BY t.name ASC LIMIT 10;



-- Feature 5 (Playlists) --

SELECT t.*,
  JSON_AGG(artist.*) as artists,
  JSON_AGG(album.*) as albums,
  JSON_AGG(genre.*) as genres
  FROM playlist_tracks as tp
  INNER JOIN track t ON t.id = tp.track_id
  LEFT OUTER JOIN track_to_artist ON t.id = track_to_artist.track_id
  LEFT OUTER JOIN artist ON track_to_artist.artist_id = artist.id
  LEFT OUTER JOIN track_to_album ON t.id = track_to_album.track_id
  LEFT OUTER JOIN album ON track_to_album.album_id = album.id
  LEFT OUTER JOIN track_to_genre ON t.id = track_to_genre.track_id
  LEFT OUTER JOIN genre ON track_to_genre.genre_id = genre.id
  WHERE tp.playlist_id = 1
  GROUP BY t.id, tp.position
  ORDER BY tp.position ASC;



-- Feature 6 (Top Charts) --

SELECT artist.*,
  SUM(track.num_of_times_played) AS total_plays
  FROM track
  INNER JOIN track_to_artist ON track.id = track_to_artist.track_id
  INNER JOIN artist ON track_to_artist.artist_id = artist.id
  WHERE track.account_uuid = 'b3837b5a-7b11-47f5-80be-b445febe6f09'
  GROUP BY artist.id
  ORDER BY total_plays DESC;

