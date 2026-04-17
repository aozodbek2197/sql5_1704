-- 1-mashq
DELETE FROM person
WHERE id NOT IN (
    SELECT MIN(id)
    FROM person
    GROUP BY email
);
-- 2-mashq
WITH hacker_challenges AS (
    SELECT 
        h.hacker_id,
        h.name,
        COUNT(c.challenge_id) AS challenge_count
    FROM hackers h
    JOIN challenges c ON h.hacker_id = c.hacker_id
    GROUP BY h.hacker_id, h.name
),
max_count AS (
    SELECT MAX(challenge_count) AS max_c FROM hacker_challenges
)
SELECT hacker_id, name, challenge_count
FROM hacker_challenges
WHERE challenge_count = (SELECT max_c FROM max_count)
   OR challenge_count IN (
       SELECT challenge_count 
       FROM hacker_challenges 
       GROUP BY challenge_count 
       HAVING COUNT(*) = 1
   )
ORDER BY challenge_count DESC, hacker_id;
