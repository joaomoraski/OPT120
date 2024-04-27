import express from "express";
import UsersController from "../controllers/usersController.js";

const userRoutes = express.Router();

const usersController = new UsersController();

userRoutes.get('/', async (req, res) => {
    await usersController.getUsers(req, res)
});

userRoutes.get('/:id', async (req, res) => {
    const userId = req.params.id; // Pega o id da request
    await usersController.getUser(userId, req, res)
});

userRoutes.post('/', async (req, res) => {
    await usersController.create(req, res)
    res.send()
});

userRoutes.put('/:id', async (req, res) => {
    const userId = req.params.id;
    const updatedUserData = req.body; // Pega os dados que serao atualizados da request
    await usersController.updateUser(userId, updatedUserData, req, res);
    res.send();
});

userRoutes.delete('/:id', async (req, res) => {
    const userId = req.params.id; // Pega o id da request
    await usersController.deleteUser(userId, req, res);
});


export default userRoutes
