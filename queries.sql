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


