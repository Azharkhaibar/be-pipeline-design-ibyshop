import { Hono } from "hono";
import { z } from "zod";
import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import { zValidator } from "@hono/zod-validator";
import { usersTable, usersSecureTable } from "../../db/schema/sc_users";
import { like, eq, asc, desc, count } from "drizzle-orm";
import { DBConnection } from "../../db/database/dbIndex";
export const router_users = new Hono();
router_users.get(
    "/",
    zValidator(
        "query",
        z.object({
            page: z.number().optional(),
            limit: z.number().optional(),
            sort: z.enum(["asc", "desc"]).optional(),
            search: z.string().optional(),
            searchBy: z.enum(["namaDepan", "namaBelakang", "email", "fullname"]).optional(),
        })
    ),
    async (c) => {
        const {
            page = 0,
            limit = 20,
            sort = "asc",
            search,
            searchBy,
        } = c.req.valid("query");

        try {
            const DBusr = await DBConnection();
            const searchColumn = searchBy ? usersTable[searchBy] : usersTable.fullname;
            const filtered = search ? DBusr.select().from(usersTable).where(like(searchColumn, `%${search}%`))
                : DBusr.select().from(usersTable);
            const [{ total }] = await DBusr.select({ total: count() })
                .from(filtered.as("filtered_users"));
            const data = await (
                search ? DBusr.select().from(usersTable)
                    .where(like(searchColumn, `%${search}%`)) : DBusr.select().from(usersTable)
            )
                .orderBy(sort === "desc" ? desc(searchColumn) : asc(searchColumn))
                .limit(limit)
                .offset(page * limit);

            return c.json({
                data,
                pagination: {
                    page,
                    limit,
                    total,
                    totalPages: Math.ceil(total / limit),
                },
                message: "OK",
                status: 200,
                success: true,
                error: null,
            });
        } catch (err) {
            console.error("Error fetching users:", err);
            return c.json({ error: "Internal Server Error" }, 500);
        }
    }
);

router_users.post(
    "/register",
    zValidator("json",
        z.object({
            namaDepan: z.string().min(1, "Nama depan tidak boleh kosong"),
            namaBelakang: z.string().min(1, "Nama belakang tidak boleh kosong"),
            fullname: z.string().min(1, "Full name tidak boleh kosong"),
            email: z.string().email("Email tidak valid"),
            password: z.string().min(6, "Password minimal 6 karakter"),
        })
    ),
    async (c) => {
        try {
            const DBControllerInput = c.req.valid("json");
            const DBConnect = await DBConnection()
            const ENormalized = DBControllerInput.email.toLowerCase();
            const EmailValidation = await DBConnect.select().from(usersTable)
                .where(eq(usersTable.email, ENormalized.toLowerCase()));
            if (EmailValidation.length > 0) {
                return c.json({ error: "Email sudah terdaftar" }, 400);
            }
            const hashedPassword = await bcrypt.hash(DBControllerInput.password, 10);
            DBConnect.insert(usersTable).values({
                namaDepan: DBControllerInput.namaDepan,
                namaBelakang: DBControllerInput.namaBelakang,
                fullname: DBControllerInput.fullname,
                email: ENormalized,
                password: hashedPassword,
                lastLoginAt: null,
                createdAt: new Date(),
                updatedAt: new Date(),
            })
                .$returningId()
                .then((ID) => {
                    return c.json({
                        message: "User berhasil ditambahkan",
                        userId: ID
                    }, 201);
                })
                .catch((error) => {
                    console.error("Error during user creation:", error);
                    return c.json({ error: "Internal Server Error" }, 500);
                });

        } catch (error) {
            console.error("Error during user creation:", error);
            return c.json({ error: "Internal Server Error" }, 500);
        }
    }
);

router_users.post(
    "/login",
    zValidator(
        "json",
        z.object({
            email: z.string().email("Email tidak valid"),
            password: z.string().min(1, "Password tidak boleh kosong"),
        })
    ),
    async (c) => {
        const { email, password } = c.req.valid("json");
        const db = await DBConnection();

        try {
            const [userLogin] = await db.select().from(usersTable)
                .where(eq(usersTable.email, email.toLowerCase()));
            if (!userLogin) {
                return c.json({
                    status: 404,
                    message: "ga ada",
                    data: null,
                    success: false
                });
            }

            const passwordMatch = await bcrypt.compare(password, userLogin.password);
            if (!passwordMatch) {
                return c.json({
                    status: 401,
                    message: "ga ada",
                    data: null,
                    success: false
                });
            }

            // Check JWT_SECRET
            const jwtSecret = process.env.JWT_SECRET;
            if (!jwtSecret) {
                console.error("JWT_SECRET not set in environment variables");
                return c.json({ error: "Internal Server Error" }, 500);
            }
            
            // Generate JWT
            const token = jwt.sign({
                userId: userLogin.userId, email: userLogin.email
            }, jwtSecret, {
                expiresIn: "1d"
            });

            console.log(token);
            return c.json({
                message: "Login berhasil",
                token,
                user: {
                    userId: userLogin.userId,
                    email: userLogin.email,
                    fullname: userLogin.fullname,
                },
            });

        } catch (err) {
            console.error("Error during login:", err);
            return c.json({ error: "Internal Server Error" }, 500);
        }
    }
);



// router_users.patch('/update',
//     zValidator('param',
//         z.object({
//             id: z.coerce.number(),
//         })
//     ), async (c) => {
//         const { id } = c.req.valid('param');
//         return DBConnection().then((DBupdate) => {
//             return DBupdate.select().from(usersTable)
//         })

//     }
// )

