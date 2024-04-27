import express from "express";
import routes from "../routes.js";

const authRoutes = express.Router();

// Rota para autenticação
const authController = new AuthController();

routes.post('/login', authController.login);


const authMiddleware = new AuthMiddleware();

// Rota protegida que requer autenticação
routes.get('/protected', authMiddleware.verifyToken, (req, res) => {
    res.json({message: 'Protected route accessed successfully'});
});

module.exports = {
    authRoutes
}