import express from "express";
import UsersController from "../controllers/usersController.js";
import routes from "../routes.js";

const userRoutes = express.Router();

const usersController = new UsersController();

routes.get('/users', async (req, res) => {
    await usersController.getUsers(req, res)
});

routes.get('/users/:id', async (req, res) => {
    const userId = req.params.id; // Pega o id da request
    await usersController.getUser(userId, req, res)
});

routes.post('/users/create', async (req, res) => {
    await usersController.create(req, res)
    res.send()
});

routes.put('/users/:id', async (req, res) => {
    const userId = req.params.id;
    const updatedUserData = req.body; // Pega os dados que serao atualizados da request
    await usersController.updateUser(userId, updatedUserData, req, res);
    res.send();
});

routes.delete('/users/:id', async (req, res) => {
    const userId = req.params.id; // Pega o id da request
    await usersController.deleteUser(userId, req, res);
});

module.exports = {
    userRoutes
}