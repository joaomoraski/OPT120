import express from "express";
import UserActivityController from "../controllers/userActivityController.js";

const userActivityRoutes = express.Router();

const userActivityController = new UserActivityController();

userActivityRoutes.post('/', async (req, res) => {
    await userActivityController.create(req, res)
    res.send()
});

userActivityRoutes.get('/', async (req, res) => {
    await userActivityController.getUserActivities(req, res)
});

userActivityRoutes.get('/:id', async (req, res) => {
    const activityId = req.params.id; // Pega o id da request
    await userActivityController.getUserActivity(activityId, req, res)
});

userActivityRoutes.put('/:id', async (req, res) => {
    const userActivityId = req.params.id;
    const updatedUserData = req.body; // Pega os dados que serao atualizados da request
    await userActivityController.updateActivity(userActivityId, updatedUserData, req, res);
    res.send();
});

userActivityRoutes.delete('/:id', async (req, res) => {
    const userActivityId = req.params.id; // Pega o id da request
    await userActivityController.deleteUserActivity(userActivityId, req, res);
    res.send();
});

export default userActivityRoutes