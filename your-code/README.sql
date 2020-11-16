-- Lab | Advanced MySQL

-- Challenge 1 - Most Profiting Authors
use publications;

-- Step 1: Calculate the royalty of each sale for each author and the advance for each author and publication
select * from titles;
select * from authors;
select * from sales;
select * from titleauthor;

select ta.title_id, ta.au_id, round(t.advance*ta.royaltyper/100) as advance, round(t.price*s.qty*t.royalty/100 *ta.royaltyper/100) as sales_royalty
from titles t, titleauthor ta, sales s;

-- Step 2: Aggregate the total royalties for each title and author
SELECT title_id, au_id, sum(advance) as total_advance, sum(sales_royalty) as total_sales_royalty from
(select ta.title_id, ta.au_id, round(t.advance*ta.royaltyper/100) as advance, round(t.price*s.qty*t.royalty/100 *ta.royaltyper/100) as sales_royalty
from titles t, titleauthor ta, sales s) total_royalties
GROUP BY title_id, au_id; 


-- Step 3: Calculate the total profits of each author
select au_id, sum(total_sales_royalty) as total_profit from
(SELECT title_id, au_id, sum(advance) as total_advance, sum(sales_royalty) as total_sales_royalty from
(select ta.title_id, ta.au_id, round(t.advance*ta.royaltyper/100) as advance, round(t.price*s.qty*t.royalty/100 *ta.royaltyper/100) as sales_royalty
from titles t, titleauthor ta, sales s) total_royalties
GROUP BY title_id, au_id) total_profits
GROUP BY au_id
ORDER BY total_profit DESC
limit 3;

-- Challenge 2 - Alternative Solution

-- Step 1: Calculate the royalty of each sale for each author and the advance for each author and publication
select * from titles;
select * from authors;
select * from sales;
select * from titleauthor;

select ta.title_id, ta.au_id, round(t.advance*ta.royaltyper/100) as advance, round(t.price*s.qty*t.royalty/100 *ta.royaltyper/100) as sales_royalty
from titles t, titleauthor ta, sales s;

-- Step 2: Aggregate the total royalties for each title and author
CREATE TEMPORARY TABLE total_royalties
(select ta.title_id, ta.au_id, round(t.advance*ta.royaltyper/100) as advance, round(t.price*s.qty*t.royalty/100 *ta.royaltyper/100) as sales_royalty
from titles t, titleauthor ta, sales s);

SELECT title_id, au_id, sum(advance) as total_advance, sum(sales_royalty) as total_sales_royalty from total_royalties
GROUP BY title_id, au_id; 

-- Step 3: Calculate the total profits of each author
CREATE TEMPORARY TABLE total_profits
(SELECT title_id, au_id, sum(advance) as total_advance, sum(sales_royalty) as total_sales_royalty from total_royalties
GROUP BY title_id, au_id);

select au_id, sum(total_sales_royalty) as total_profit from total_profits
GROUP BY au_id
ORDER BY total_profit DESC
limit 3;


-- Challenge 3
CREATE TABLE most_profiting_authors 
(au_id varchar(255),
profits int);

INSERT INTO most_profiting_authors VALUES
("486-29-1786", "26564"),
("998-72-3567", 


