import { Hono } from 'hono';
import { createServer } from 'http';
import { router_product } from './controllers/products/product.controller';
import { router_category_product } from './controllers/products/categoryProduct.controller';
import { authUsers } from './controllers/routes/user.route';
import { router_users } from './controllers/auth/auth.controller';
import { verifyToken } from './middleware/authmiddleware';

export const app = new Hono();

app.route('/product', router_product);
app.route('/category_product', router_category_product);
app.route('/auth', authUsers);
app.route('/users', router_users);

router_users.get("/protected-route", verifyToken, async (c) => {
  return c.json({ message: "This is a protected route", user: c.req.user });
});

const startServer = (port = 3000) => {
  const server = createServer((req, res) => {
    Promise.resolve(app.fetch(req as any, req as any)).then((resp: Response) => {
      res.writeHead(resp.status, Object.fromEntries(resp.headers.entries()));
      resp.body?.getReader().read().then(({ value }: { value?: Uint8Array }) => {
        if (value) res.end(Buffer.from(value));
        else res.end();
      });
    });
  });

  server.listen(port, () => {
    console.log(`Server running on port ${port}`);
  });

  return server;
};

export { startServer };
