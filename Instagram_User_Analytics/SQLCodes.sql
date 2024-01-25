/* to reward the most loyal users for which they are looking for the oldest users on Instagram. following query to find the 5 oldest users.*/
SELECT * FROM users 
ORDER BY created_at ASC 
LIMIT 5;

/*find the users who have not posted a single time*/
SELECT users.username
FROM users
LEFT JOIN photos ON users.id = photos.user_id
WHERE photos.user_id IS NULL;

/*finding out the user who got the most likes on a single photo*/
SELECT users.username, COUNT(likes.photo_id) AS num_likes
FROM users
JOIN photos ON users.id = photos.user_id
JOIN likes ON photos.id = likes.photo_id
WHERE photos.id = (SELECT photo_id FROM likes GROUP BY photo_id ORDER BY COUNT(*) DESC LIMIT 1)
GROUP BY users.id
ORDER BY num_likes DESC
LIMIT 1;

/*finding out the five most common hashtags*/
SELECT tags.tag_name, COUNT(photo_tags.tag_id) AS tag_count
FROM photo_tags
INNER JOIN tags ON photo_tags.tag_id = tags.id
GROUP BY photo_tags.tag_id
ORDER BY tag_count DESC
LIMIT 5;

/*finding the day of the week on which the most number of users register*/
SELECT DAYNAME(created_at) AS day_of_week, COUNT(*) AS user_count
FROM users
GROUP BY DAYOFWEEK(created_at)
ORDER BY user_count DESC
LIMIT 1;

/*finding the number of posts by an average user, and also total posts per total users*/
SELECT COUNT(*) / COUNT(DISTINCT photos.user_id) AS photos_per_user
FROM photos
INNER JOIN users ON photos.user_id = users.id;

SELECT COUNT(*) / (SELECT COUNT(*) FROM users) AS photos_user_ratio
FROM photos;

/*find out the bots & fake accounts, which can identified on the basis of whether the user has liked all the posts on the platform*/
SELECT username
FROM users
WHERE id IN (
    SELECT user_id
    FROM likes
    GROUP BY user_id
    HAVING COUNT(DISTINCT photo_id) = (
        SELECT COUNT(DISTINCT id) 
        FROM photos 
    )
    AND COUNT(DISTINCT photo_id) > 0
);

/**/
