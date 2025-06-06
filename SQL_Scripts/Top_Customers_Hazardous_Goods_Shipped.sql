-- Top Customers who shipped Hazardous Goods by the weight of goods shipped

SELECT 
    INITCAP(c.customer_name) AS customer,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    COUNT(g.goods_id) AS total_goods,
    SUM(g.weight) AS total_weight_kg,
    ROUND(AVG(g.weight), 2) AS avg_weight_kg,
    MIN(g.weight) AS lightest_shipment,
    MAX(g.weight) AS heaviest_shipment,
    ROUND(SUM(g.volume), 2) AS total_volume_m3
FROM customer c
JOIN booking b ON c.customer_id = b.customer_id
JOIN goods g ON b.container_id = g.container_id
JOIN goods_type gt ON g.goods_type_id = gt.goods_type_id
WHERE g.weight BETWEEN 500 AND 15000
  AND LOWER(gt.goods_type_name) IN (
      'bulk liquids', 'compressed gas', 'flammable'
  )
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(b.booking_id) > 1 AND SUM(g.weight) > 10000
ORDER BY total_weight_kg DESC;