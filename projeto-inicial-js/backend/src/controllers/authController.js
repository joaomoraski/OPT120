import bcrypt from 'bcrypt';
import jwt from "jsonwebtoken";
import pool from "../connection.js";

class AuthController {

    async findUserByEmail(email) {
        const connection = await pool.getConnection();

        await connection.beginTransaction();
        const [existingUser] = await connection.query('SELECT * FROM usuario WHERE email = ?', [email]);

        return existingUser[0];
    }

    async login(request, response) {
        try {
            const {email, password} = request.body;
            const connection = await pool.getConnection();
            await connection.beginTransaction();
            const users = await connection.query('SELECT * FROM usuario WHERE email = ?', [email]);
            const user = users[0];
            if (!user) {
                return response.status(401).json({error: 'Authentication failed'});
            }
            const passwordMatch = await bcrypt.compare(password, user[0].password);
            if (!passwordMatch) {
                return response.status(401).json({error: 'Authentication failed'});
            }
            const token = jwt.sign({userId: user.id}, 'your-secret-key', {
                expiresIn: '1h',
            });
            response.status(200).json({token});
        } catch (error) {
            response.status(500).json({error: 'Login failed'});
        }
    }


    async register(request, response) {
        const {
            name,
            email,
            password
        } = request.body;

        const saltRounds = 10; // Adjust salt rounds as needed

        if (!name || !email || !password) {
            return response.status(400).json({ message: 'Bota os campo certo ai' });
        }


        if (!(email.includes('@') && email.includes('.'))) {
            console.log(request.body)
            return response.status(400).json({ message: 'Email num ta valido não' });
        }


        try {
            const connection = await pool.getConnection();
            await connection.beginTransaction();

            const [existingUser] = await connection.query('SELECT * FROM usuario WHERE email = ?', [email]);
            if (existingUser.length > 0) {
                await connection.rollback();
                return response.status(409).json({ message: 'Já existe esse email ai parceirage' });
            }

            const hashedPassword = await bcrypt.hash(password, saltRounds);

            const [result] = await connection.query('INSERT INTO usuario (nome, email, password) VALUES (?, ?, ?)', [name, email, hashedPassword]);

            await connection.commit();

            return response.status(201).json({ message: 'Usuário criado com sucesso.' });
        } catch (error) {
            console.error(error);
            return response.status(500).json({ message: 'Ocorreu um erro ao criar o usuário.' });
        }
    }
}

export default AuthController

