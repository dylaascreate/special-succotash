-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Aug 22, 2026 at 01:19 AM
-- Server version: 8.0.30
-- PHP Version: 8.3.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `toy_sales`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_customer_order_details_concat` (IN `p_customer_id` INT)   BEGIN
    SELECT 
        o.customer_id,
        o.order_id,
        o.order_date,
        GROUP_CONCAT(p.product_name SEPARATOR ', ') AS ordered_products,
        fn_order_total(o.order_id) AS total_order_amount  -- Calling total order fx here
    FROM 
        orders o, 
        order_items oi, 
        products p
    WHERE 
        o.order_id = oi.order_id 
        AND oi.product_id = p.product_id
        AND o.customer_id = p_customer_id 
    GROUP BY 
        o.order_id, 
        o.order_date,
        o.customer_id; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_customer_order_details_manual` (IN `p_id` INT)   BEGIN
    SELECT 
        o.order_id,
        o.order_date,
        p.product_name,
        p.price
    FROM 
        orders o, order_items oi, products p
    WHERE 
        o.order_id = oi.order_id 
        AND oi.product_id = p.product_id
        AND o.customer_id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_orders_by_customer` (IN `p_customer_id` INT)   BEGIN
    SELECT
        order_date,
        customer_id,
        order_id
    FROM orders
    WHERE customer_id = p_customer_id;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_order_total` (`p_order_id` INT) RETURNS DECIMAL(10,2) READS SQL DATA BEGIN
    DECLARE v_total DECIMAL(10,2);

    SELECT COALESCE(SUM(quantity * unit_price), 0)
    INTO v_total
    FROM order_items
    WHERE order_id = p_order_id;

    RETURN v_total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_product_stock_value` (`p_product_id` INT) RETURNS DECIMAL(12,2) READS SQL DATA BEGIN
    DECLARE v_stock_value DECIMAL(12,2);

    SELECT COALESCE(price * stock_quantity, 0)
    INTO v_stock_value
    FROM products
    WHERE product_id = p_product_id;

    RETURN v_stock_value;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `customer_id` int NOT NULL,
  `customer_name` varchar(100) NOT NULL,
  `email` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `customer_name`, `email`) VALUES
(1, 'Ali Ahmad', 'ali@example.com'),
(2, 'Siti Aminah', 'siti@example.com'),
(3, 'John Tan', 'john@example.com');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int NOT NULL,
  `customer_id` int NOT NULL,
  `order_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `order_status` varchar(30) DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `customer_id`, `order_date`, `order_status`) VALUES
(1, 1, '2026-08-21 18:34:54', 'Pending');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `order_item_id` int NOT NULL,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`order_item_id`, `order_id`, `product_id`, `quantity`, `unit_price`) VALUES
(5, 1, 1, 2, 89.90),
(6, 1, 4, 1, 25.00),
(7, 1, 2, 3, 49.90);

--
-- Triggers `order_items`
--
DELIMITER $$
CREATE TRIGGER `trg_reduce_stock` AFTER INSERT ON `order_items` FOR EACH ROW BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;

    INSERT INTO stock_audit
    (
        product_id,
        action_type,
        quantity_changed
    )
    VALUES
    (
        NEW.product_id,
        'SALE',
        -NEW.quantity
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock_quantity` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `product_name`, `price`, `stock_quantity`) VALUES
(1, 'Remote Control Car', 89.90, 20),
(2, 'Building Blocks', 49.90, 27),
(3, 'Teddy Bear', 39.90, 15),
(4, 'Puzzle Set', 25.00, 25);

-- --------------------------------------------------------

--
-- Table structure for table `stock_audit`
--

CREATE TABLE `stock_audit` (
  `audit_id` int NOT NULL,
  `product_id` int NOT NULL,
  `action_type` varchar(30) DEFAULT NULL,
  `quantity_changed` int DEFAULT NULL,
  `action_date` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `stock_audit`
--

INSERT INTO `stock_audit` (`audit_id`, `product_id`, `action_type`, `quantity_changed`, `action_date`) VALUES
(1, 2, 'SALE', -3, '2026-08-21 18:40:03');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customer_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `fk_orders_customer` (`customer_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `fk_items_order` (`order_id`),
  ADD KEY `fk_items_product` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `stock_audit`
--
ALTER TABLE `stock_audit`
  ADD PRIMARY KEY (`audit_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `stock_audit`
--
ALTER TABLE `stock_audit`
  MODIFY `audit_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `fk_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
