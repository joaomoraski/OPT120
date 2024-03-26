import express from 'express';
import UsersController from './controllers/usersController.js'


const routes = express.Router();

routes.get('/', (req,res) => {
    res.send("odeio java script");
});

const usersController = new UsersController();

routes.post('/register', async (req,res) => {
    await usersController.create(req, res)
    res.send()
});

routes.get('/users', async (req,res) => {
    await usersController.getUsers(req, res)
    res.send()
});

export default routes;