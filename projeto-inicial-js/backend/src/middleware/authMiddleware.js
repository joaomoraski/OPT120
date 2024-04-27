// middleware/authMiddleware.js
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';

dotenv.config();

const authMiddleware = (req, res, next) => {
    const token = req.header('Authorization');
    console.log('Token:', token); // Adiciona este log para verificar o token recebido

    if (!token) return res.status(401).json({ message: 'Token not provided' });

    try {
        const decoded = jwt.verify(token, 'mouras');
        console.log('Decoded:', decoded); // Adiciona este log para verificar o payload decodificado

        if (!decoded || !decoded.user) throw new Error('Invalid token');

        req.user = decoded.user;
        next();
    } catch (error) {
        console.log(error);
        res.status(401).json({ message: 'Invalid token' });
    }
};

export default authMiddleware;
