import { sql } from "drizzle-orm";
import { varchar, json, timestamp, decimal, int, mysqlTable } from "drizzle-orm/mysql-core";
import { CustomerTable } from "./sc_customers";
import { productTable } from "./sc_product";

// Menyesuaikan tipe data untuk customerId yang seharusnya UUID
export const OrderTable = mysqlTable("orders", {
  orderId: int("order_id")
    .primaryKey()
    .notNull()
    .autoincrement(),
  customerId: varchar("customer_id", { length: 36 })
    .notNull()
    .references(() => CustomerTable.id),  // memastikan tipe data konsisten
  totalPrice: decimal("total_price", { precision: 10, scale: 2 }).notNull(),
  paymentMethod: varchar("payment_method", { length: 50 }).notNull(),
  status: varchar("status", { length: 50 }).default("pending"),
  notes: varchar("notes", { length: 255 }),
  orderDate: timestamp("order_date").defaultNow().notNull(),
  paymentStatus: varchar("payment_status", { length: 50 }).default("unpaid"),
  paymentDate: timestamp("payment_date").defaultNow(),
});

  