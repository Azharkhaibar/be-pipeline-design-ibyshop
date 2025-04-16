import { sql } from "drizzle-orm";
import { varchar, mysqlTable, text, timestamp, boolean, int,decimal, json } from "drizzle-orm/mysql-core";
import { CustomerTable } from "./sc_customers";
import { OrderTable } from "./sc_orders";


export const SalesTable = mysqlTable("sales", {
    id: int("sales_id").primaryKey().notNull().autoincrement(),
    customerId: int("customer_id").notNull().references(() => CustomerTable.id),
    orderId: int("order_id").notNull().references(() => OrderTable.orderId),
    saleDate: timestamp("sale_date").defaultNow().notNull(),
    amount: decimal("amount", { precision: 10, scale: 2 }).notNull(),
    productDetails: json("product_details"),  // Ensuring this column handles JSON correctly
  });
  