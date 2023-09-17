use ig_clone;
-- 1. Find 5 oldest users from the database 
SELECT 
    username, created_at
FROM
    users
ORDER BY created_at
LIMIT 5;

-- 2.Find the users who have never posted a single photo
SELECT 
    *
FROM
    users u
        LEFT JOIN
    photos p ON p.user_id = u.id
WHERE
    p.image_url IS NULL
ORDER BY u.username;

-- 3.Identify the winner of the contest and provide their details 
SELECT 
    likes.photo_id,
    users.username,
    COUNT(likes.user_id) AS noflikes
FROM
    likes
        INNER JOIN
    photos ON likes.photo_id = photos.id
        INNER JOIN
    users ON photos.user_id = users.id
GROUP BY likes.photo_id , users.username
ORDER BY noflikes DESC;

-- 4.Identify and suggest  the top 5 most commonly used hashtags on the platform
SELECT 
    t.tag_name, COUNT(p.photo_id) AS ht
FROM
    photo_tags p
        INNER JOIN
    tags t ON t.id = p.tag_id
GROUP BY tag_name
ORDER BY ht DESC limit 5;

-- 5. What day of th week do most users register on ,provide insights on when to schedule an ad campaign
select date_format((created_at),'%W') as d,count(username) from users group by 1 order by 2 desc;

-- 6.provide how many times an average user posts on instagram .Also provide the total photos per user
with refer as (
SELECT 
    u.id AS userid, COUNT(p.id) AS photoid
FROM
    users u
        LEFT JOIN
    photos p ON p.user_id = u.id
GROUP BY u.id)
SELECT 
    SUM(photoid) AS totalphotos,
    COUNT(userid) AS total_users,
    SUM(photoid) / COUNT(userid) AS photoperuser
FROM
    refer;
    
-- 7.Provide data on users(bots) who have liked every single photo on the site (since normaluser would not be able to do this)
with refer as (
SELECT 
    u.username, COUNT(l.photo_id) AS likess
FROM
    likes l
        INNER JOIN
    users u ON u.id = l.user_id
GROUP BY u.username)
SELECT 
    username, likess
FROM
    refer
WHERE
    likess = (SELECT 
                 COUNT(*)
              FROM
			     photos)
ORDER BY username;