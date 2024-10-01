--Table customer_service_KPI
CREATE TABLE `customer_service_kpi` (
    `customer_service_KPI_timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `customer_service_KPI_average_waiting_time_minutes` INT NOT NULL,
    PRIMARY KEY (`customer_service_KPI_timestamp`)
);
-- CREATE EVN_average_customer_waiting_time_every_1_hour
DELIMITER //

CREATE EVENT `EVN_average_customer_waiting_time_every_1_hour`
ON SCHEDULE EVERY 1 HOUR
DO
BEGIN
    INSERT INTO `customer_service_kpi` (customer_service_KPI_average_waiting_time_minutes)
    SELECT 
        AVG(TIMESTAMPDIFF(MINUTE, `created_at`, `resolved_at`)) AS average_waiting_time
    FROM 
        `customer_service_ticket`
    WHERE 
        `created_at` >= NOW() - INTERVAL 1 HOUR
        AND `resolved_at` IS NOT NULL; -- Only consider tickets that have been resolved
END; //

DELIMITER ;

