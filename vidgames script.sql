select	*
from vgsales
where name like '%Ã%' and name like '%©%'
;

select *
from vgsales
;




-- view rows that have any other value apart from the four number characters as in year
select * 
from vgsales
where year not regexp '^[0-9]{4}$';

-- set N/A values to null
update vgsales
set year = null 
where year = 'N/A';

-- view rows that have foreign characters
select *
from vgsales
where convert (`name` using ASCII) != `name`
;

update vgsales
set name = replace(name, 'Ã©', 'e')
where name like '%Ã©%';

update vgsales
set name = convert(convert(name using ascii) using utf8)
where name != convert(convert(name using ascii) using utf8);

select *
from vgsales;

select avg(`global_sales`), `name`, `genre`
from vgsales
group by `global_sales`, `name`, `genre`;

select sum(global_sales), sum(NA_Sales)
from vgsales;

-- what genre of game sold most and least globally?
-- answer: Sports (Wii sports)
select `name`, genre, max(Global_Sales), min(Global_Sales)
from vgsales
group by `name`, genre
limit 1
;

select *
from vgsales;

-- calculate total global sales and avg global sales by platform

select platform,
		sum(global_sales) as global_sales,
        avg(global_sales) as avg_global_sales
from vgsales
group by platform;

-- calculate total global sales and avg global sales by genre
select genre, sum(global_sales) as total_global_sales,
				avg(global_sales) as avg_global_sales
from
	(select genre, global_sales
	from vgsales) as query1
group by genre
;


select distinct year
from vgsales
order by year asc;

-- highest sales in each genre
-- used subquery
select genre, max(na_sales)
from
	(select genre, NA_Sales
	from vgsales) as query1
group by genre;
 
 -- or
 
select genre, max(na_sales)
from vgsales
group by genre;


-- which year had most sales globally and continentally?
-- answer: 2006, 2006, 2006, 1994, 2004
select year, 
		max(global_sales) as max_global_sales, 
		max(na_sales) as max_NA_sales, 
        max(eu_sales) as max_EU_sales, 
        max(jp_sales) as max_JP_sales, 
        max(other_sales) as max_other_sales
from vgsales
group by year
order by max_other_sales desc;


-- which genre sold the most in north america?
-- used CTEs
with sum_na_sales
as
	(select genre, NA_Sales
	from vgsales)
select genre, sum(na_sales) as total_NA_sales
from sum_na_sales
group by genre;


-- grouping based on year
select *,
case 
	when year >= '1980' and year < '1990' then '1980s'
	when year >= '1990' and year < '2000' then '1990s'
    when year >= '2000' and year < '2010' then '2000s'
    when year >= '2010' and year < '2020' then '2010s'
	else 'unspecified year'
end as decade
from vgsales;
select *
from
	(select *,
		case 
			when year >= '2010' then '10s'
			when year >= '2000' then '00s'
			when year >= '1990' then '90s'
			when year >= '1980' then '80s'
			else 'unspecified year'
		end as decade
		from vgsales) as year_range
where decade in  ('80s', '90s', '00s', '10s');

select *,
	case 
		when year >= '2010' then '2010s'
		when year >= '2000' then '2000s'
		when year >= '1990' then '1990s'
		when year >= '1980' then '1980s'
		else 'unspecified year'
	end as year_range
	from vgsales;


-- calculate total_sales and avg_sales globally in the 80s, 90s, 00s and 10s
select year_range,
		sum(global_sales) as total_global_sales,
		avg(global_sales) as avg_global_sales
from
	(select *,
	case 
		when year >= '2010' then '10s'
		when year >= '2000' then '00s'
		when year >= '1990' then '90s'
		when year >= '1980' then '80s'
		else 'unspecified year'
	end as year_range
	from vgsales) as year_range
where year_range in  ('80s', '90s', '00s', '10s')
group by year_range
order by year_range desc;

--
select year_range,
		sum(global_sales) as total_global_sales,
		avg(global_sales) as avg_global_sales
from
	(select *,
case 
	when year >= '1980' and year < '1990' then '1980s'
	when year >= '1990' and year < '2000' then '1990s'
    when year >= '2000' and year < '2010' then '2000s'
    when year >= '2010' and year < '2020' then '2010s'
	else 'unspecified year'
end as year_range
from vgsales) as year_range
where year_range in  ('80s', '90s', '00s', '10s')
group by year_range
order by year_range desc;

--
-- compare total_sales & avg_sales by region with the time range
select year_range,
		sum(na_sales) as total_NA_sales,
        sum(eu_sales) as total_EU_sales,
        sum(jp_sales) as total_JP_sales,
        sum(other_sales) as total_other_sales,
        sum(global_sales) as total_global_sales
from
	(select *,
	case 
		when year >= '2010' then '10s'
		when year >= '2000' then '00s'
		when year >= '1990' then '90s'
		when year >= '1980' then '80s'
		else 'unspecified year'
	end as year_range
	from vgsales) as year_range
where year_range in  ('80s', '90s', '00s', '10s')
group by year_range
order by year_range desc;

select *
from vgsales;


-- what genre sold the most globally across the 4 decades?
select genre,
		sum(global_sales) as total_global_sales
from
	(select *,
		case 
			when year >= '2010' then '10s'
			when year >= '2000' then '00s'
			when year >= '1990' then '90s'
			when year >= '1980' then '80s'
			else 'unspecified year'
		end as year_range
	from vgsales) as year_range
group by genre
order by total_global_sales desc;


-- what platform sold most globally across the four decades?
select platform, decade,
		round(sum(global_sales), 2) as total_global_sales
from	
    (select *,
			case 
				when year >= '1980' and year < '1990' then '1980s'
				when year >= '1990' and year < '2000' then '1990s'
				when year >= '2000' and year < '2010' then '2000s'
				when year >= '2010' and year < '2020' then '2010s'
				else 'unspecified year'
			end as decade
		from vgsales) as year_range
group by platform, decade
order by total_global_sales desc;


-- which publisher sold most games across decades?
select publisher, decade,
        round(avg(global_sales), 2) as avg_global_sales
from 		
        (select *,
			case 
				when year >= '1980' and year < '1990' then '1980s'
				when year >= '1990' and year < '2000' then '1990s'
				when year >= '2000' and year < '2010' then '2000s'
				when year >= '2010' and year < '2020' then '2010s'
				else 'unspecified year'
			end as decade
		from vgsales) as year_range
where decade in  ('1980s', '1990s', '2000s', '2010s')
group by publisher, decade
order by avg_global_sales desc;
		

select distinct publisher
from vgsales;

-- check publisher with most games
select publisher, count(publisher) as no_of_games
from vgsales
group by publisher
order by no_of_games desc;

select *
from vgsales;


-- RESEARCH QUESTIONS
-- how do video game sales differ across North America, Europe, Japan and other regions?

select 
	round(sum(na_sales), 2) north_america_sales,
    round(sum(eu_sales), 2) europe_sales,
    round(sum(jp_sales), 2)japan_sales,
    round(sum(other_sales), 2) other_region_sales
from vgsales;

select 
	round(sum(na_sales), 2) north_america_sales,
    round(sum(eu_sales), 2) europe_sales,
    round(sum(jp_sales), 2)japan_sales,
    round(sum(other_sales), 2) other_region_sales
from
(select *,
			case 
				when year >= '1980' and year < '1990' then '1980s'
				when year >= '1990' and year < '2000' then '1990s'
				when year >= '2000' and year < '2010' then '2000s'
				when year >= '2010' and year < '2020' then '2010s'
				else 'unspecified year'
			end as decade
		from vgsales) as year_range
where decade in  ('1980s', '1990s', '2000s', '2010s');


-- what game characteristics are most associated with high sales in each region?
select name, platform, publisher, genre,
	round(sum(na_sales), 2) north_america_sales,
    round(sum(eu_sales), 2) europe_sales,
    round(sum(jp_sales), 2)japan_sales,
    round(sum(other_sales), 2) other_region_sales
from vgsales
group by name, platform, publisher, genre
;

-- least performing games by region
select name,
	round(sum(na_sales), 2) north_america_sales,
    round(sum(eu_sales), 2) europe_sales,
    round(sum(jp_sales), 2)japan_sales,
    round(sum(other_sales), 2) other_region_sales,
    round(sum(global_sales), 2) global_sales
from vgsales
where na_sales > 0 and 
		eu_sales > 0 and
        jp_sales > 0 and
        other_sales > 0 and
        global_sales > 0
group by name
order by global_sales asc
limit 5;


-- how do genre preference vary across regions?
select genre,
	round(sum(na_sales), 2) north_america_sales,
    round(sum(eu_sales), 2) europe_sales,
    round(sum(jp_sales), 2)japan_sales,
    round(sum(other_sales), 2) other_region_sales
from vgsales
group by genre
;

-- how do publisher and platform preference vary across regions?
select publisher, platform,
	round(sum(na_sales), 2) north_america_sales,
    round(sum(eu_sales), 2) europe_sales,
    round(sum(jp_sales), 2)japan_sales,
    round(sum(other_sales), 2) other_region_sales
from vgsales
group by publisher, platform
;
	

-- can regional sales serve as predictors for globals success?
-- need to run a correlation and regression analysis

-- correlation analysis
-- sql cant perform correlate columns directly so we have to calculate using functions manually:
-- finding the pearson correlation between regions and global_sales:

select 
-- na_sales_correlation
	round((count(*) * sum(na_sales * global_sales) - sum(na_sales) * sum(global_sales)) 
								/
	(sqrt(count(*) * sum(power(na_sales, 2)) - power(sum(na_sales), 2))
								*
	sqrt(count(*) * sum(power(global_sales, 2)) - power(sum(global_sales), 2))
    ), 3) as correlation_NA_global,
    
-- eu_sales_correlation
    round((count(*) * sum(eu_sales * global_sales) - sum(eu_sales) * sum(global_sales)) 
								/
	(sqrt(count(*) * sum(power(eu_sales, 2)) - power(sum(eu_sales), 2))
								*
	sqrt(count(*) * sum(power(global_sales, 2)) - power(sum(global_sales), 2))
    ), 3) as correlation_EU_global,
    
-- jp_sales_correlation    
round((count(*) * sum(jp_sales * global_sales) - sum(jp_sales) * sum(global_sales)) 
								/
	(sqrt(count(*) * sum(power(jp_sales, 2)) - power(sum(jp_sales), 2))
								*
	sqrt(count(*) * sum(power(global_sales, 2)) - power(sum(global_sales), 2))
    ), 3) as correlation_JP_global,
    
-- other_sales_correlation    
    round((count(*) * sum(other_sales * global_sales) - sum(other_sales) * sum(global_sales)) 
								/
	(sqrt(count(*) * sum(power(other_sales, 2)) - power(sum(other_sales), 2))
								*
	sqrt(count(*) * sum(power(global_sales, 2)) - power(sum(global_sales), 2))
    ), 3) as correlation_OTHER_global,
    
    round(sum(global_sales), 2) as total_global_sales
    
from vgsales
where na_sales is not null and
		eu_sales is not null and
        jp_sales is not null and
        other_sales is not null and
		global_sales is not null;
        
-- checking for outliers
select *,
		(global_sales - stats.mean_val) / stats.std_dev as z_score
from vgsales,
		(select avg(global_sales) as mean_val,
				stddev(global_sales) as std_dev
		from vgsales) as stats
having abs(z_score) > 3;
	

-- REGRESSION ANALYSIS
-- we wanna predict future sales for the next decade (20s) and possibly (30s)
-- we gotta calculate the slope and the intercept









-- calculate yoy and py

select *
from vgsales;

select year,
		round(sum(global_sales), 2) as total_global_sales
from vgsales
where year is not null
group by year
order by year asc;

-- yoy growth calculation & py
select 
		curr.year,
        curr.total_global_sales as current_year_sales,
        prev.total_global_sales as previous_year_sales,
        round(
			(curr.total_global_sales - prev.total_global_sales) * 100.0 /
nullif(prev.total_global_sales, 0), 2
	) as yoy_growth_percentage
from
(select year,
		round(sum(global_sales), 2) as total_global_sales
from vgsales
where year is not null
group by year
) as curr
left join (
	select year,
		round(sum(global_sales), 2) as total_global_sales
from vgsales
where year is not null
group by year
) as prev
on curr.year = prev.year + 1
order by curr.year
;

select distinct year
from vgsales
order by year;

select sum(na_sales)
from vgsales
where year is  not null;

select count(name)
from
  (select *,
			case 
				when year >= '2010' then '10s'
				when year >= '2000' then '00s'
				when year >= '1990' then '90s'
				when year >= '1980' then '80s'
				else 'unspecified year'
			end as year_range
		from vgsales) as year_range
	where year is not null
    order by name asc;