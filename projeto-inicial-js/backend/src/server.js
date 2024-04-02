import express from 'express';
import routes from './routes.js';
import cors from 'cors';
import * as dotenv from 'dotenv';
import bodyParser from "body-parser";
dotenv.config()

// Deu erro de definição de tipos
const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use(express.json());
app.use(routes);

app.listen(3333, () => {console.log("Api iniciada no endereço 3333")});