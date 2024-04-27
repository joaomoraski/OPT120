import express from 'express';
import userRoutes from "./routes/user.js";
import authRoutes from "./routes/auth.js";
import activityRoutes from "./routes/activity.js";
import userActivityRoutes from "./routes/userActivity.js";
import cors from 'cors';
import * as dotenv from 'dotenv';
import bodyParser from "body-parser";
import AuthMiddleware from "./middleware/authMiddleware.js";

dotenv.config()

const middleware = new AuthMiddleware();

// Deu erro de definição de tipos
const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use(express.json());
app.use("/auth", authRoutes);
app.use("/users", middleware.verifyToken, userRoutes);
app.use("/activity", middleware.verifyToken, activityRoutes);
app.use("/userActivity", middleware.verifyToken, userActivityRoutes);

app.listen(3333, () => {console.log("Api iniciada no endereço 3333")});