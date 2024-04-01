import express from 'express';
import routes from './routes.js';
import cors from 'cors';
import * as dotenv from 'dotenv';
dotenv.config()

// Deu erro de definição de tipos
const app = express();
app.use(express.json());
app.use(routes);
app.use(cors());

app.listen(3333, () => {console.log("Api iniciada no endereço 3333")});