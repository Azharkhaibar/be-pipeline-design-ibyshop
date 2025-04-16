ALTER TABLE `cart_item` MODIFY COLUMN `deleted_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP;--> statement-breakpoint
ALTER TABLE `activities` ADD `user_id` int NOT NULL;--> statement-breakpoint
ALTER TABLE `payments` ADD `customer_id` int NOT NULL;--> statement-breakpoint
ALTER TABLE `product` ADD `fkVendor` varchar(36) NOT NULL;--> statement-breakpoint
ALTER TABLE `activities` ADD CONSTRAINT `activities_user_id_users_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `payments` ADD CONSTRAINT `payments_customer_id_customers_customer_id_fk` FOREIGN KEY (`customer_id`) REFERENCES `customers`(`customer_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `product` ADD CONSTRAINT `product_fkVendor_vendors_vendor_id_fk` FOREIGN KEY (`fkVendor`) REFERENCES `vendors`(`vendor_id`) ON DELETE no action ON UPDATE no action;