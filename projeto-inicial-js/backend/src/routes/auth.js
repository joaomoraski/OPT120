import express from "express";
import userRoutes from "./user.js";
import AuthController from "../controllers/authController.js";
import AuthMiddleware from "../middleware/authMiddleware.js";

const authRoutes = express.Router();

// Rota para autenticação
const authController = new AuthController();

authRoutes.post('/login', authController.login);

authRoutes.post('/register', authController.register);

export default authRoutes
