SELECT * FROM kaggle_db.df_orders;
/*find top 10 highest revenue generating products*/

select product_id, sum(sale_price) as sales
from df_orders
group by product_id
order by sales desc limit 10;

/*find top 5 highest selling products in each region*/

with cte1 as(select region, product_id, sum(sale_price) as sales
from df_orders
group by region, product_id), 
cte2 as(
select *,
row_number() over(partition by region order by sales desc) as rn
from cte1
)
select * from cte2
where rn<=5;


/*find month over month growth comparision for 2022 and 2023 sales: eg Jan 2022 VS Jan 2023*/
with cte3 as( 
SELECT MONTH(order_date) as month, YEAR(order_date) as year, SUM(sale_price) as sales
FROM df_orders
GROUP BY MONTH(order_date), YEAR(order_date)
ORDER BY MONTH(order_date), YEAR(order_date)
)
select month,
MAX(CASE WHEN year="2022" THEN sales ELSE 0 END) as 2022_sales,
MAX(CASE WHEN year="2023" THEN sales ELSE 0 END) as 2023_sales
from cte3
GROUP BY month;

/*for each category, which month had highest sales*/
with cte4 as (
select MONTH(order_date) as month, year(order_date) as year, category, sum(sale_price) as sales 
from df_orders
GROUP BY MONTH(order_date), year(order_date), category
order by MONTH(order_date), year(order_date), category
), cte5 as (
select *,
row_number() over (partition by category order by sales desc) as rn
from cte4)
select *
from cte5
where rn=1 



