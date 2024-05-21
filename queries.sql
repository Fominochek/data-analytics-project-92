4.
select COUNT(customer_id) as customers_count
from customers;
//запрос, который считает общее количество покупателей из таблицы customers.

5.
Отчёт 1.
select 
	concat(employees.first_name, ' ', employees.last_name) as seller,
	count(sales.sales_person_id) as operations,
	floor(SUM(products.price*sales.quantity)) as income
from employees
inner join sales 
on employee_id = sales_person_id
inner join products 
on products.product_id = sales.product_id
group by concat(employees.first_name, ' ', employees.last_name)
order by income desc
limit 10;
//запрос, в котором происходит объединение трех таблиц employees, sales, producrs через INNER JOIN;
	подсчет кол-ва проделанных сделок через COUNT; подсчет выручки через SUM и произведения цены и кол-ва товвара, 
	который был продан, округление через ROUND; группировка по имени и фамилии через GROUP BY; 
	сортировка по убыванию выручки через ORDER BY; вывод первых 10 строк через LIMIT.

Отчёт 2.
select 
	concat(employees.first_name, ' ', employees.last_name) as seller,
	FLOOR(avg(products.price*sales.quantity)) as average_income
from employees
inner join sales 
on employee_id = sales_person_id
inner join products 
on products.product_id = sales.product_id
group by concat(employees.first_name, ' ', employees.last_name)
having FLOOR(avg(products.price*sales.quantity)) < (select 
							avg(products.price*sales.quantity) 
						    from sales 
						    inner join products 
						    on sales.product_id = products.product_id)
order by average_income;
//запрос, в котором происходит объединение трех таблиц employees, sales, producrs через INNER JOIN; подсчёт среней выручки по каждому продавцу 
	через функцию AVG и округление через FLOOR; для сравнения со средней выручкой по всем продавцам был использован подзапрос в HAVING.

Отчёт 3.
select 
    concat(employees.first_name, ' ', employees.last_name) as seller,
    to_char(sale_date,'Day') as day_of_week,
    round(SUM(products.price*sales.quantity)) as income
from employees
inner join sales 
on employee_id = sales_person_id
inner join products 
on products.product_id = sales.product_id
group by concat(employees.first_name, ' ', employees.last_name), 
	 to_char(sale_date,'Day'), 
	 sales.sale_date 
order by extract(isodow from sale_date), 
	 seller;
//запрос, в котором происходит объединение трех таблиц employees, sales, producrs через INNER JOIN; извлечение и преобразование даты в день недели через 
	функцию TO_CHAR; подсчет выручки через SUM и произведения цены и кол-ва товвара, который был продан, округление через ROUND; группировка через GROUP BY; 
	сортировка через ORDER BY, чтобы сортировка была не в алфавитном порядке по дню недели, используется функция EXTRACT и параметр ISODOW, 
	благодаря которому интервал от 1 (понедельник) до 7 (воскресенье).

6.
Отчёт 1.
with tab1 as(
	select 
		case when age between 16 and 25 then '16-25'
    		 when age between 26 and 40 then '26-40'
    		 when age>40 then '40+' end as age_category,
    		 count(age) as count
	from customers
	group by age)
select
	age_category,
	sum(count) as age_count
from tab1
group by age_category
order by age_category;
//с помощью оператора WITH создаем временную таблицу, с помощью оператора CASE выводим возрастные категории, с помощью функции COUNT подсчитываем количество 
	человек в каждой возрастной группе, далее в основном запросе считаем суммарное количество человек в каждой группе, группируем и сортируем по возрастной группе.

Отчёт 2.
select
	to_char(sales.sale_date,'YYYY-MM') as selling_month,
	count(distinct(customer_id)) as total_customers,
	round(sum(quantity*price)) as income
from sales 
inner join products 
on sales.product_id=products.product_id 
where price > 0
group by to_char(sales.sale_date,'YYYY-MM'), products.price 
order by to_char(sales.sale_date,'YYYY-MM');
//преобразование даты в формат год-месяц с помощью функции to_char, подсчет уникальных покупателей с помощью count и distinct, подсчет выручки от покупателей через 
	суммирование количества умноженное на суммирование цены, выручка округляется через round, объединение двух таблиц через inner join, убираем нулевые значения, 
	через условие where, группировка и сортировка по дате.

Отчёт 3.
with unique_cust as (
	select
		concat(c.first_name, c.last_name) as customer,
		s.sale_date,
		concat(e.first_name, e.last_name) as seller,
		p.name as name,
		p.price as price,
		row_number () over (partition by concat(c.first_name, ' ', c.last_name) order by sale_date) as rn
from sales s
inner join customers c 
on s.customer_id = c.customer_id
inner join employees e 
on s.sales_person_id = e.employee_id
inner join products p 
on s.product_id  = p.product_id
order by sale_date
)
select 
	customer, 
	sale_date, 
	seller
from unique_cust
where price = 0 and rn = 1
order by customer;
//в подзапросе с помощью функции concat объединябтся фамилии и имена покупателей и продавцрв, с помощь row_number нумеруются строки отдельно для каждой уникальной 
	фамилии и уникального имени покупателя, сортируется по дате покупки, с помощью inner join объединяются таблицы, в основном запросе идёт выборка по цене 
	равной нулю и row_number равной единице(так как сортировка идёт по дате).
		


