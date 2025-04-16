CREATE TABLE `customer_details` (
	`customer_detail_id` int AUTO_INCREMENT NOT NULL,
	`customer_id` int NOT NULL,
	`alamat` varchar(255),
	`kelurahan` varchar(100),
	`kecamatan` varchar(100),
	`kota` varchar(100),
	`provinsi` varchar(100),
	`kode_pos` varchar(10),
	CONSTRAINT `customer_details_customer_detail_id` PRIMARY KEY(`customer_detail_id`)
);
--> statement-breakpoint

CREATE TABLE `tb_users_default` (
	`id` int AUTO_INCREMENT NOT NULL,
	`user_id` int NOT NULL,
	`user_secure_id` int NOT NULL,
	`create_at` timestamp NOT NULL DEFAULT (now()),
	`update_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
	`delete_at` timestamp,
	CONSTRAINT `tb_users_default_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `users_secure` (
	`user_secure_id` int AUTO_INCREMENT NOT NULL,
	`user_id` int NOT NULL,
	`email` varchar(255) NOT NULL,
	`password` varchar(255) NOT NULL,
	`last_login_at` timestamp,
	`created_at` timestamp NOT NULL DEFAULT (now()),
	`updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
	`deleted_at` timestamp,
	CONSTRAINT `users_secure_user_secure_id` PRIMARY KEY(`user_secure_id`),
	CONSTRAINT `users_secure_email_unique` UNIQUE(`email`)
);
--> statement-breakpoint
CREATE TABLE `users` (
	`user_id` int AUTO_INCREMENT NOT NULL,
	`nama_depan` varchar(100),
	`nama_belakang` varchar(100),
	`fullname` varchar(255) NOT NULL,
	`email` varchar(255) NOT NULL,
	`password` varchar(255) NOT NULL,
	`last_login_at` timestamp,
	`created_at` timestamp NOT NULL DEFAULT (now()),
	`updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
	`deleted_at` timestamp,
	CONSTRAINT `users_user_id` PRIMARY KEY(`user_id`),
	CONSTRAINT `users_email_unique` UNIQUE(`email`)
);
--> statement-breakpoint
DROP TABLE `tb_users`;--> statement-breakpoint
ALTER TABLE `activities` RENAME COLUMN `id` TO `activity_customer_id`;--> statement-breakpoint
ALTER TABLE `contacts` RENAME COLUMN `id` TO `contact_id`;--> statement-breakpoint
ALTER TABLE `customers` RENAME COLUMN `id` TO `customer_id`;--> statement-breakpoint
ALTER TABLE `order_items` RENAME COLUMN `id` TO `order_item_id`;--> statement-breakpoint
ALTER TABLE `orders` RENAME COLUMN `id` TO `order_id`;--> statement-breakpoint
ALTER TABLE `cart_item` RENAME COLUMN `added_at` TO `created_at`;--> statement-breakpoint
ALTER TABLE `category` RENAME COLUMN `id` TO `category_id`;--> statement-breakpoint
ALTER TABLE `product` RENAME COLUMN `id` TO `product_id`;--> statement-breakpoint
ALTER TABLE `reviews` RENAME COLUMN `id` TO `review_id`;--> statement-breakpoint
ALTER TABLE `sales` RENAME COLUMN `id` TO `sales_id`;--> statement-breakpoint
ALTER TABLE `vendors` RENAME COLUMN `id` TO `vendor_id`;--> statement-breakpoint
ALTER TABLE `contacts` DROP FOREIGN KEY `contacts_customer_id_customers_id_fk`;
--> statement-breakpoint
ALTER TABLE `order_items` DROP FOREIGN KEY `order_items_order_id_orders_id_fk`;
--> statement-breakpoint
ALTER TABLE `order_items` DROP FOREIGN KEY `order_items_product_id_product_id_fk`;
--> statement-breakpoint
ALTER TABLE `orders` DROP FOREIGN KEY `orders_customer_id_customers_id_fk`;
--> statement-breakpoint
ALTER TABLE `payments` DROP FOREIGN KEY `payments_order_id_orders_id_fk`;
--> statement-breakpoint
ALTER TABLE `cart_item` DROP FOREIGN KEY `cart_item_customer_id_customers_id_fk`;
--> statement-breakpoint
ALTER TABLE `cart_item` DROP FOREIGN KEY `cart_item_product_id_product_id_fk`;
--> statement-breakpoint
ALTER TABLE `product` DROP FOREIGN KEY `product_fkcategory_category_id_fk`;
--> statement-breakpoint
ALTER TABLE `reviews` DROP FOREIGN KEY `reviews_product_id_product_id_fk`;
--> statement-breakpoint
ALTER TABLE `reviews` DROP FOREIGN KEY `reviews_customer_id_customers_id_fk`;
--> statement-breakpoint
ALTER TABLE `sales` DROP FOREIGN KEY `sales_customer_id_customers_id_fk`;
--> statement-breakpoint
ALTER TABLE `sales` DROP FOREIGN KEY `sales_order_id_orders_id_fk`;
--> statement-breakpoint
ALTER TABLE `activities` DROP PRIMARY KEY;--> statement-breakpoint
ALTER TABLE `contacts` DROP PRIMARY KEY;--> statement-breakpoint
ALTER TABLE `customers` DROP PRIMARY KEY;--> statement-breakpoint
ALTER TABLE `order_items` DROP PRIMARY KEY;--> statement-breakpoint
ALTER TABLE `orders` DROP PRIMARY KEY;--> statement-breakpoint
ALTER TABLE `category` DROP PRIMARY KEY;--> statement-breakpoint
ALTER TABLE `product` DROP PRIMARY KEY;--> statement-breakpoint
ALTER TABLE `reviews` DROP PRIMARY KEY;--> statement-breakpoint
ALTER TABLE `sales` DROP PRIMARY KEY;--> statement-breakpoint
ALTER TABLE `vendors` DROP PRIMARY KEY;--> statement-breakpoint
ALTER TABLE `activities` MODIFY COLUMN `activity_customer_id` int AUTO_INCREMENT NOT NULL;--> statement-breakpoint
ALTER TABLE `contacts` MODIFY COLUMN `contact_id` int AUTO_INCREMENT NOT NULL;--> statement-breakpoint
ALTER TABLE `customers` MODIFY COLUMN `customer_id` int AUTO_INCREMENT NOT NULL;--> statement-breakpoint
ALTER TABLE `customers` MODIFY COLUMN `status` enum('active','inactive') DEFAULT 'active';--> statement-breakpoint
ALTER TABLE `order_items` MODIFY COLUMN `order_item_id` int AUTO_INCREMENT NOT NULL;--> statement-breakpoint
ALTER TABLE `order_items` MODIFY COLUMN `order_id` int NOT NULL;--> statement-breakpoint
ALTER TABLE `order_items` MODIFY COLUMN `product_id` int NOT NULL;--> statement-breakpoint
ALTER TABLE `orders` MODIFY COLUMN `order_id` int AUTO_INCREMENT NOT NULL;--> statement-breakpoint
ALTER TABLE `payments` MODIFY COLUMN `payment_id` int AUTO_INCREMENT NOT NULL;--> statement-breakpoint
ALTER TABLE `payments` MODIFY COLUMN `order_id` int NOT NULL;--> statement-breakpoint
ALTER TABLE `cart_item` MODIFY COLUMN `cart_item_id` int AUTO_INCREMENT NOT NULL;--> statement-breakpoint
ALTER TABLE `cart_item` MODIFY COLUMN `customer_id` int NOT NULL;--> statement-breakpoint
ALTER TABLE `cart_item` MODIFY COLUMN `product_id` int NOT NULL;--> statement-breakpoint
ALTER TABLE `category` MODIFY COLUMN `category_id` int AUTO_INCREMENT NOT NULL;--> statement-breakpoint
ALTER TABLE `product` MODIFY COLUMN `product_id` int AUTO_INCREMENT NOT NULL;--> statement-breakpoint
ALTER TABLE `reviews` MODIFY COLUMN `review_id` int AUTO_INCREMENT NOT NULL;--> statement-breakpoint
ALTER TABLE `reviews` MODIFY COLUMN `product_id` int NOT NULL;--> statement-breakpoint
ALTER TABLE `reviews` MODIFY COLUMN `customer_id` int NOT NULL;--> statement-breakpoint
ALTER TABLE `sales` MODIFY COLUMN `sales_id` int AUTO_INCREMENT NOT NULL;--> statement-breakpoint
ALTER TABLE `sales` MODIFY COLUMN `customer_id` int NOT NULL;--> statement-breakpoint
ALTER TABLE `sales` MODIFY COLUMN `order_id` int NOT NULL;--> statement-breakpoint
ALTER TABLE `vendors` MODIFY COLUMN `vendor_id` int AUTO_INCREMENT NOT NULL;--> statement-breakpoint
ALTER TABLE `activities` ADD PRIMARY KEY(`activity_customer_id`);--> statement-breakpoint
ALTER TABLE `contacts` ADD PRIMARY KEY(`contact_id`);--> statement-breakpoint
ALTER TABLE `customers` ADD PRIMARY KEY(`customer_id`);--> statement-breakpoint
ALTER TABLE `order_items` ADD PRIMARY KEY(`order_item_id`);--> statement-breakpoint
ALTER TABLE `orders` ADD PRIMARY KEY(`order_id`);--> statement-breakpoint
ALTER TABLE `category` ADD PRIMARY KEY(`category_id`);--> statement-breakpoint
ALTER TABLE `product` ADD PRIMARY KEY(`product_id`);--> statement-breakpoint
ALTER TABLE `reviews` ADD PRIMARY KEY(`review_id`);--> statement-breakpoint
ALTER TABLE `sales` ADD PRIMARY KEY(`sales_id`);--> statement-breakpoint
ALTER TABLE `vendors` ADD PRIMARY KEY(`vendor_id`);--> statement-breakpoint
ALTER TABLE `cart_item` ADD `deleted_at` timestamp;--> statement-breakpoint
ALTER TABLE `customer_details` ADD CONSTRAINT `customer_details_customer_id_customers_customer_id_fk` FOREIGN KEY (`customer_id`) REFERENCES `customers`(`customer_id`) ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `tb_users_default` ADD CONSTRAINT `tb_users_default_user_id_users_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `tb_users_default` ADD CONSTRAINT `tb_users_default_user_secure_id_users_secure_user_secure_id_fk` FOREIGN KEY (`user_secure_id`) REFERENCES `users_secure`(`user_secure_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `users_secure` ADD CONSTRAINT `users_secure_user_id_users_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `contacts` ADD CONSTRAINT `contacts_customer_id_customers_customer_id_fk` FOREIGN KEY (`customer_id`) REFERENCES `customers`(`customer_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `order_items` ADD CONSTRAINT `order_items_order_id_orders_order_id_fk` FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `order_items` ADD CONSTRAINT `order_items_product_id_product_product_id_fk` FOREIGN KEY (`product_id`) REFERENCES `product`(`product_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `orders` ADD CONSTRAINT `orders_customer_id_customers_customer_id_fk` FOREIGN KEY (`customer_id`) REFERENCES `customers`(`customer_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `payments` ADD CONSTRAINT `payments_order_id_orders_order_id_fk` FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`) ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `cart_item` ADD CONSTRAINT `cart_item_customer_id_customers_customer_id_fk` FOREIGN KEY (`customer_id`) REFERENCES `customers`(`customer_id`) ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `cart_item` ADD CONSTRAINT `cart_item_product_id_product_product_id_fk` FOREIGN KEY (`product_id`) REFERENCES `product`(`product_id`) ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `product` ADD CONSTRAINT `product_fkcategory_category_category_id_fk` FOREIGN KEY (`fkcategory`) REFERENCES `category`(`category_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `reviews` ADD CONSTRAINT `reviews_product_id_product_product_id_fk` FOREIGN KEY (`product_id`) REFERENCES `product`(`product_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `reviews` ADD CONSTRAINT `reviews_customer_id_customers_customer_id_fk` FOREIGN KEY (`customer_id`) REFERENCES `customers`(`customer_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `sales` ADD CONSTRAINT `sales_customer_id_customers_customer_id_fk` FOREIGN KEY (`customer_id`) REFERENCES `customers`(`customer_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `sales` ADD CONSTRAINT `sales_order_id_orders_order_id_fk` FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `customers` DROP COLUMN `alamat`;--> statement-breakpoint
ALTER TABLE `customers` DROP COLUMN `customer_type`;