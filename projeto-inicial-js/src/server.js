import express from 'express';
import routes from './routes.js';
import * as dotenv from 'dotenv';
dotenv.config()

// Deu erro de definição de tipos
const app = express();
app.use(express.json());
app.use(routes);

app.listen(3333, () => {console.log("lixo de api em node iniciada em 3333")});