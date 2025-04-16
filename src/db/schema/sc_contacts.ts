import { sql } from "drizzle-orm";
import { varchar, mysqlTable, text, timestamp, int, boolean, decimal } from "drizzle-orm/mysql-core";
import { CustomerTable } from "./sc_customers";

export const ContactTable = mysqlTable("contacts", {
    id: int("contact_id").primaryKey().notNull().autoincrement(),
    customer_id: varchar("customer_id", { length: 36 }).notNull().references(() => CustomerTable.id),
    contactDate: timestamp("contact_date").defaultNow().notNull(),
    contactMethod: varchar("contact_method", { length: 50 }),
    subject: varchar("subject", { length: 255 }),
    message: text("message"),
    
  });
  