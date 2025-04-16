CREATE TABLE `activities` (
	`id` varchar(36) NOT NULL DEFAULT UUID(),
	`customer_id` varchar(36) NOT NULL,
	`activity_date` timestamp NOT NULL DEFAULT (now()),
	`activity_type` varchar(100) NOT NULL,
	`description` text,
	CONSTRAINT `activities_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `contacts` (
	`id` varchar(36) NOT NULL DEFAULT UUID(),
	`customer_id` varchar(36) NOT NULL,
	`contact_date` timestamp NOT NULL DEFAULT (now()),
	`contact_method` varchar(50),
	`subject` varchar(255),
	`message` text,
	CONSTRAINT `contacts_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `customers` (
	`id` varchar(36) NOT NULL DEFAULT UUID(),
	`nama_customer` varchar(100) NOT NULL,
	`alamat` varchar(255),
	`email` varchar(255) NOT NULL,
	`status` varchar(50) DEFAULT 'active',
	`customer_type` varchar(50) DEFAULT 'individual',
	`last_contacted` timestamp,
	`created_at` timestamp NOT NULL DEFAULT (now()),
	`updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT `customers_id` PRIMARY KEY(`id`),
	CONSTRAINT `customers_email_unique` UNIQUE(`email`)
);
--> statement-breakpoint
CREATE TABLE `order_items` (
	`id` varchar(36) NOT NULL DEFAULT UUID(),
	`order_id` varchar(36) NOT NULL,
	`product_id` varchar(36) NOT NULL,
	`quantity` int NOT NULL,
	`unit_price` decimal(10,2) NOT NULL,
	`subtotal` decimal(10,2) NOT NULL,
	CONSTRAINT `order_items_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `orders` (
	`id` varchar(36) NOT NULL DEFAULT UUID(),
	`customer_id` varchar(36) NOT NULL,
	`total_price` decimal(10,2) NOT NULL,
	`payment_method` varchar(50) NOT NULL,
	`status` varchar(50) DEFAULT 'pending',
	`notes` varchar(255),
	`order_date` timestamp NOT NULL DEFAULT (now()),
	`payment_status` varchar(50) DEFAULT 'unpaid',
	`payment_date` timestamp DEFAULT (now()),
	CONSTRAINT `orders_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `payments` (
	`payment_id` varchar(36) NOT NULL DEFAULT UUID(),
	`order_id` varchar(36) NOT NULL,
	`metode_pembayaran` varchar(55) NOT NULL DEFAULT 'cash',
	`jumlah_bayar` decimal(10,2) NOT NULL,
	`status_pembayaran` varchar(30) NOT NULL,
	`payment_date` timestamp NOT NULL DEFAULT (now()),
	CONSTRAINT `payments_payment_id` PRIMARY KEY(`payment_id`)
);
--> statement-breakpoint
CREATE TABLE `cart_item` (
	`cart_item_id` varchar(36) NOT NULL DEFAULT UUID(),
	`customer_id` varchar(36) NOT NULL,
	`product_id` varchar(36) NOT NULL,
	`added_at` timestamp NOT NULL DEFAULT (now()),
	`updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT `cart_item_cart_item_id` PRIMARY KEY(`cart_item_id`)
);
--> statement-breakpoint
CREATE TABLE `category` (
	`id` varchar(36) NOT NULL DEFAULT UUID(),
	`nama_kategori` varchar(100) NOT NULL,
	`deskripsi_kategori` varchar(255) NOT NULL,
	CONSTRAINT `category_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `product` (
	`id` varchar(36) NOT NULL DEFAULT UUID(),
	`nama_produk` varchar(100) NOT NULL,
	`review_produk` varchar(255) NOT NULL,
	`warna_produk` varchar(50) NOT NULL,
	`foto_produk` varchar(255) NOT NULL,
	`deskripsi_produk` text NOT NULL,
	`harga` decimal(10,2) NOT NULL,
	`fkcategory` varchar(36) NOT NULL,
	`created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT `product_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `reviews` (
	`id` varchar(100) NOT NULL DEFAULT UUID(),
	`product_id` varchar(100) NOT NULL,
	`customer_id` varchar(100) NOT NULL,
	`rating` decimal(2,1) NOT NULL,
	`review_text` varchar(500),
	`created_at` timestamp NOT NULL DEFAULT (now()),
	CONSTRAINT `reviews_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `sales` (
	`id` varchar(36) NOT NULL DEFAULT UUID(),
	`customer_id` varchar(36) NOT NULL,
	`order_id` varchar(36) NOT NULL,
	`sale_date` timestamp NOT NULL DEFAULT (now()),
	`amount` decimal(10,2) NOT NULL,
	`product_details` json,
	CONSTRAINT `sales_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `vendors` (
	`id` varchar(36) NOT NULL DEFAULT UUID(),
	`nama_vendor` varchar(100) NOT NULL,
	`kontak_email` varchar(100) NOT NULL,
	`kontak_telepon` varchar(20),
	`address` text,
	`description` text,
	`created_at` timestamp NOT NULL DEFAULT (now()),
	`updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT `vendors_id` PRIMARY KEY(`id`),
	CONSTRAINT `vendors_kontak_email_unique` UNIQUE(`kontak_email`)
);
--> statement-breakpoint
ALTER TABLE `contacts` ADD CONSTRAINT `contacts_customer_id_customers_id_fk` FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `order_items` ADD CONSTRAINT `order_items_order_id_orders_id_fk` FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `order_items` ADD CONSTRAINT `order_items_product_id_product_id_fk` FOREIGN KEY (`product_id`) REFERENCES `product`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `orders` ADD CONSTRAINT `orders_customer_id_customers_id_fk` FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `payments` ADD CONSTRAINT `payments_order_id_orders_id_fk` FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `cart_item` ADD CONSTRAINT `cart_item_customer_id_customers_id_fk` FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`) ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `cart_item` ADD CONSTRAINT `cart_item_product_id_product_id_fk` FOREIGN KEY (`product_id`) REFERENCES `product`(`id`) ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `product` ADD CONSTRAINT `product_fkcategory_category_id_fk` FOREIGN KEY (`fkcategory`) REFERENCES `category`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `reviews` ADD CONSTRAINT `reviews_product_id_product_id_fk` FOREIGN KEY (`product_id`) REFERENCES `product`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `reviews` ADD CONSTRAINT `reviews_customer_id_customers_id_fk` FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `sales` ADD CONSTRAINT `sales_customer_id_customers_id_fk` FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `sales` ADD CONSTRAINT `sales_order_id_orders_id_fk` FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON DELETE no action ON UPDATE no action;