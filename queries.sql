4.
select COUNT(customer_id) as customers_count
from customers;
//запрос, который считает общее количество покупателей из таблицы customers.

5.
Отчёт 1.
select 
	concat(employees.first_name, employees.last_name) as seller,
	count(sales.sales_person_id) as operations,
	ROUND(SUM(products.price*sales.quantity)) as income
from employees
inner join sales 
on employee_id = sales_person_id
inner join products 
on products.product_id = sales.product_id
group by concat(employees.first_name, employees.last_name)
order by income desc
limit 10;
//запрос, в котором происходит объединение трех таблиц employees, sales, producrs через INNER JOIN;
	подсчет кол-ва проделанных сделок через COUNT; подсчет выручки через SUM и произведения цены и кол-ва товвара, 
	который был продан, округление через ROUND; группировка по имени и фамилии через GROUP BY; 
	сортировка по убыванию выручки через ORDER BY; вывод первых 10 строк через LIMIT.

Отчёт 2.
select 
	concat(employees.first_name, employees.last_name) as seller,
	FLOOR(avg(products.price*sales.quantity)) as average_income
from employees
inner join sales 
on employee_id = sales_person_id
inner join products 
on products.product_id = sales.product_id
group by concat(employees.first_name, employees.last_name)
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
    concat(employees.first_name, employees.last_name) as seller,
    to_char(sale_date,'Day') as day_of_week,
    round(SUM(products.price*sales.quantity)) as income
from employees
inner join sales 
on employee_id = sales_person_id
inner join products 
on products.product_id = sales.product_id
group by concat(employees.first_name, employees.last_name), 
	 to_char(sale_date,'Day'), 
	 sales.sale_date 
order by extract(DOW from sales.sale_date), 
	 seller;
//запрос, в котором происходит объединение трех таблиц employees, sales, producrs через INNER JOIN; извлечение и преобразование даты в день недели через 
	функцию TO_CHAR; подсчет выручки через SUM и произведения цены и кол-ва товвара, который был продан, округление через ROUND; группировка через GROUP BY; 
	сортировка через ORDER BY, чтобы сортировка была не в алфавитном порядке по дню недели, используется функция EXTRACT.

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
	sum(count) as count
from tab1
group by age_category
order by age_category;
//с помощью оператора WITH создаем временную таблицу, с помощью оператора CASE выводим возрастные категории, с помощью функции COUNT подсчитываем количество 
	человек в каждой возрастной группе, далее в основном запросе считаем суммарное количество человек в каждой группе, группируем и сортируем по возрастной группе.

Отчёт 2.
select
	to_char(sales.sale_date,'YYYY-MM') as date,
	count(distinct(customer_id)) as total_customers,
	round(sum(quantity)*sum(price),2) as income
from sales 
inner join products 
on sales.product_id=products.product_id 
group by to_char(sales.sale_date,'YYYY-MM')
order by to_char(sales.sale_date,'YYYY-MM');
//преобразование даты в формат год-месяц с помощью функции to_char, подсчет уникальных покупателей с помощью count и distinct, подсчет выручки от покупателей через 
	суммирование количества умноженное на суммирование цены, выручка округляется через round до двуз цифр  после запятойб группировка и сортировка по дате.

Отчёт 3.
with prod as(
	select
		products.product_id,
		price*quantity as sal
	from products
	inner join sales
	on products.product_id=sales.product_id)
select distinct on(customers.first_name, customers.last_name, employees.first_name, employees.last_name)
	concat(customers.first_name, customers.last_name) as customer,
	sale_date,
	concat(employees.first_name, employees.last_name) as seller
from sales	
inner join customers
on customers.customer_id=sales.customer_id 
inner join employees
on employee_id = sales_person_id
inner join prod 
on prod.product_id=sales.product_id 
where prod.sal = 0;
//в подзапросе расчитывается выручка умножением цены на количество по каждому продукту, далее в основном запросе с помощью distinct on выбираются уникальные покупатели
	и продавцы, с помощью concat объединяются фамилии и имена покупателей и продавцов, с помощью inner join объединяются таблицы, с помощью where идет выборка покупателей, 
	которые купили акционный товар и продавцы, которые продали акционный товар.


