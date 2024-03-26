import pool from '../connection.js'
import bcrypt from 'bcrypt';

class UsersController {
    async create(request, response){
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
            return response.status(400).json({ message: 'Email num ta valido nao' });
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
        
            return response.status(201).json({ message: 'Usuário criado com sucesso, apesar de ser UM BACKEND EM JS'});
          } catch (error) {
            console.error(error);
            return response.status(500).json({ message: 'Erro muito foda, esperava o que, é um BACKEND EM JS' });
          }
    };

    async getUsers(request, response){
        try {
            const connection = await pool.getConnection();
            await connection.beginTransaction(); 
        
            const usersList = await connection.query('SELECT id, nome, email FROM usuario');
        
            await connection.commit(); 
        
            return response.status(201).json({ message: 'Listagem feita com sucesso', data: usersList});
          } catch (error) {
            console.error(error);
            return response.status(500).json({ message: 'Erro muito foda, esperava o que, é um BACKEND EM JS' });
          }
    };

}

export default UsersController