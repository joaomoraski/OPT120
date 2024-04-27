import express from "express";
import ActivityController from "../controllers/activityController.js";

const activityRoutes = express.Router();

const activityController = new ActivityController();

activityRoutes.get('/', async (req, res) => {
    await activityController.getActivities(req, res)
});

activityRoutes.get('/:id', async (req, res) => {
    const activityId = req.params.id; // Pega o id da request
    await activityController.getActivity(activityId, req, res)
});

activityRoutes.post('/', async (req, res) => {
    await activityController.create(req, res)
    res.send()
});

activityRoutes.put('/:id', async (req, res) => {
    const activityId = req.params.id;
    const updatedActivityData = req.body; // Pega os dados que serao atualizados da request
    await activityController.updateActivity(activityId, updatedActivityData, req, res);
});

activityRoutes.delete('/:id', async (req, res) => {
    const activityId = req.params.id; // Pega o id da request
    await activityController.deleteActivity(activityId, req, res);
    res.send();
});

export default activityRoutes