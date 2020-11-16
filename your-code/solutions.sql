use publications;

-- Challenge 1 - Most Profiting Authors

-- Step 1: Calculate the royalty of each sale for each author and the advance for each author and publication

SELECT ta.title_id, ta.au_id, round(t.advance*ta.royaltyper/100) as advance, round(t.price*s.qty*t.royalty/100*ta.royaltyper/100) as sales_royalty
FROM titleauthor AS ta
JOIN titles AS t
ON ta.title_id = t.title_id
JOIN sales AS s
ON ta.title_id = s.title_id;

-- Step 2: Aggregate the total royalties for each title and author

SELECT title_id, au_id, advance, sum(sales_royalty) AS total_royalties from
(SELECT ta.title_id, ta.au_id, round(t.advance*ta.royaltyper/100) as advance, round(t.price*s.qty*t.royalty/100*ta.royaltyper/100) as sales_royalty
FROM titleauthor AS ta
JOIN titles AS t
ON ta.title_id = t.title_id
JOIN sales AS s
ON ta.title_id = s.title_id) aggr_royalties
GROUP BY title_id, au_id;


-- Step 3: Calculate the total profits of each author

select au_id, sum(advance + total_royalties) as profit from
(SELECT title_id, au_id, advance, sum(sales_royalty) AS total_royalties from
(SELECT ta.title_id, ta.au_id, round(t.advance*ta.royaltyper/100) as advance, round(t.price*s.qty*t.royalty/100*ta.royaltyper/100) as sales_royalty
FROM titleauthor AS ta
JOIN titles AS t
ON ta.title_id = t.title_id
JOIN sales AS s
ON ta.title_id = s.title_id) aggr_royalties
GROUP BY title_id, au_id) total_profits
GROUP BY au_id
ORDER BY profit DESC
limit 3;


-- Challenge 2 - Alternative Solution

-- Step 1: Calculate the royalty of each sale for each author and the advance for each author and publication

SELECT ta.title_id, ta.au_id, round(t.advance*ta.royaltyper/100) as advance, round(t.price*s.qty*t.royalty/100*ta.royaltyper/100) as sales_royalty
FROM titleauthor AS ta
JOIN titles AS t
ON ta.title_id = t.title_id
JOIN sales AS s
ON ta.title_id = s.title_id;

-- Step 2: Aggregate the total royalties for each title and author

CREATE TEMPORARY TABLE total_royalty
(SELECT ta.title_id, ta.au_id, round(t.advance*ta.royaltyper/100) as advance, round(t.price*s.qty*t.royalty/100*ta.royaltyper/100) as sales_royalty
FROM titleauthor AS ta
JOIN titles AS t
ON ta.title_id = t.title_id
JOIN sales AS s
ON ta.title_id = s.title_id);

SELECT title_id, au_id, sum(advance) as total_advance, sum(sales_royalty) AS total_royalties 
from total_royalty
GROUP BY title_id, au_id;

-- Step 3: Calculate the total profits of each author
CREATE TEMPORARY TABLE total_profits
(SELECT title_id, au_id, sum(advance) as total_advance, sum(sales_royalty) AS total_royalties 
from total_royalty
GROUP BY title_id, au_id);

SELECT au_id, sum(total_advance + total_royalties) as profit 
from total_profits
GROUP BY au_id
ORDER BY profit DESC
limit 3;



-- Challenge 3

CREATE TABLE most_profiting_authors 
(au_id varchar(255),
profits int);

INSERT INTO most_profiting_authors VALUES
('722-51-5454', '22521'),
('213-46-8915', '14162'),
('899-46-2035', '12130');




