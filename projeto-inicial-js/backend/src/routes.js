import express from 'express';
import UsersController from './controllers/usersController.js'
import ActivityController from "./controllers/activityController.js";
import UserActivityController from "./controllers/userActivityController.js";


const routes = express.Router();

routes.get('/', (req, res) => {
    res.send("Home do projeto");
});

const usersController = new UsersController();

routes.post('/users/create', async (req, res) => {
    await usersController.create(req, res)
    res.send()
});

routes.get('/users', async (req, res) => {
    await usersController.getUsers(req, res)
});

routes.get('/users/:id', async (req, res) => {
    const userId = req.params.id; // Pega o id da request
    await usersController.getUser(userId, req, res)
});

routes.delete('/users/:id', async (req, res) => {
    const userId = req.params.id; // Pega o id da request
    await usersController.deleteUser(userId, req, res);
});

routes.put('/users/:id', async (req, res) => {
    const userId = req.params.id;
    const updatedUserData = req.body; // Pega os dados que serao atualizados da request
    await usersController.updateUser(userId, updatedUserData, req, res);
    res.send();
});


///////////////////////////////////////////////////////////////////////////////////////////////////////

const activityController = new ActivityController();

routes.post('/activity/create', async (req,res) => {
    await activityController.create(req, res)
    res.send()
});

routes.get('/activity', async (req,res) => {
    await activityController.getActivities(req, res)
});

routes.get('/activity/:id', async (req,res) => {
    const activityId = req.params.id; // Pega o id da request
    await activityController.getActivity(activityId, req, res)
});

routes.delete('/activity/:id', async (req, res) => {
    const activityId = req.params.id; // Pega o id da request
    await activityController.deleteActivity(activityId, req, res);
    res.send();
});

routes.put('/activity/:id', async (req, res) => {
    const activityId = req.params.id;
    const updatedActivityData = req.body; // Pega os dados que serao atualizados da request
    await activityController.updateActivity(activityId, updatedActivityData, req, res);
});

const userActivityController = new UserActivityController();

routes.get('/userActivity', async (req,res) => {
    await userActivityController.getUserActivities(req, res)
});


export default routes;