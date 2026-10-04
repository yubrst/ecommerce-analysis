# Расчет выручки с отмененных заказов, расчет всей выручки

SELECT SUM(ABS(Quantity * UnitPrice)) as Потерянная_выручка,  
(SELECT sum(Quantity * UnitPrice) 
FROM data WHERE Quantity > 0) as Выручка
WHERE Quantity < 0 or InvoiceNo LIKE 'C%' 

# Сегментация клиентов по частоте покупок и по сумме покупок
 
SELECT 
    CustomerID as Клиент, 
    MAX(InvoiceDate) AS Последняя_дата,
    COUNT(DISTINCT InvoiceNo) AS Количество_заказов,
    SUM(Quantity * UnitPrice) AS Выручка,
    (CASE WHEN COUNT(DISTINCT InvoiceNo)>=5 THEN 'Активный'
    WHEN COUNT(DISTINCT InvoiceNo) BETWEEN 2 AND 4 THEN 'Средний'
    ELSE 'Одноразовый' END )  as Сегментация_заказов,
    (CASE WHEN SUM(Quantity * UnitPrice)>=10000 THEN 'Оптовый'
    WHEN SUM(Quantity * UnitPrice) BETWEEN 1 AND 9999 THEN 'Лояльный'
    ELSE 'Низкий' END) as Сегментация_деньги
    FROM data
WHERE Quantity > 0  AND CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY Выручка DESC

# Выручка по странам

SELECT 
    Country AS Страна,
    COUNT(DISTINCT CustomerID) AS Клиентов,
    ROUND(SUM(Quantity * UnitPrice), 2) AS Выручка,
    ROUND(SUM(Quantity * UnitPrice) / COUNT(DISTINCT CustomerID), 2) AS Выручка_на_клиента
FROM data
WHERE Quantity > 0 AND CustomerID IS NOT NULL
GROUP BY Country
ORDER BY Выручка DESC;

# Топ-10 товаров

SELECT 
    Description AS Товар,
    SUM(Quantity) AS Продано_штук,
    ROUND(SUM(Quantity * UnitPrice), 2) AS Выручка
FROM data
WHERE Quantity > 0
  AND Description NOT IN ('DOTCOM POSTAGE', 'POSTAGE', 'Manual')
GROUP BY Description
ORDER BY Выручка DESC
LIMIT 10;