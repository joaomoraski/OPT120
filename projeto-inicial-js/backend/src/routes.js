import express from 'express';
import UsersController from './controllers/usersController.js'
import pool from "./connection.js";


const routes = express.Router();

routes.get('/', (req,res) => {
    res.send("Home do projeto");
});

const usersController = new UsersController();

routes.post('/register', async (req,res) => {
    await usersController.create(req, res)
    res.send()
});

routes.get('/users', async (req,res) => {
    await usersController.getUsers(req, res)
});

routes.get('/users/:id', async (req,res) => {
    const userId = req.params.id; // Pega o id da request
    await usersController.getUser(userId, req, res)
    res.send()
});

routes.delete('/users/:id', async (req, res) => {
      const userId = req.params.id; // Pega o id da request
      await usersController.deleteUser(userId, req, res);
      res.send();
   
  });
  
  routes.put('/users/:id', async (req, res) => {
      const userId = req.params.id;
      const updatedUserData = req.body; // Pega os dados que serao atualizados da request
      await usersController.updateUser(userId, updatedUserData, req, res);
      res.send();
  });


export default routes;