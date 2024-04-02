import pool from '../connection.js'
import bcrypt from 'bcrypt';

class UsersController {

	async create(request, response) {
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
	};


	async getUsers(request, response) {
		try {
			const usersList = await pool.query('SELECT id, nome, email FROM usuario');

			return response.status(200).json(usersList[0]);
		} catch (error) {
			console.error(error);
			return response.status(500).json({ message: 'Ocorreu um erro ao executar a listagem.' });
		}
	};


	async getUser(userId, request, response) {
		try {
			const connection = await pool.getConnection();
			const [rows] = await connection.query('SELECT id, nome, email FROM usuario WHERE id = ?', [userId]);
			connection.release(); // Fecha conexão depois da query

			if (rows.length == 0) {
				throw new Error("NotFoundError")
			}
			const user = rows[0];

			return response.status(200).json({ message: 'Usuário encontrado.', data: user });
		} catch (error) {
			console.error(error);
			if (error.message === "NotFoundError") {
				return response.status(404).json({ message: 'Usuário não encontrado.' });
			} else {
				return response.status(404).json({ message: 'Aconteceu algum erro ai.' });
			}
		}
	};


	async updateUser(userId, data, request, response) {
		try {
			const connection = await pool.getConnection();
			await connection.beginTransaction();

			// Criando a sql de update dinamicamente baseado nos dados para evitar sql inject

			let updateFields = '';
			const keys = Object.keys(data);
			for (let i = 0; i < keys.length; i++) {
				updateFields += `${keys[i]} = ?`;
				if (i < keys.length - 1) {
					updateFields += ', ';
				}
			}
			const updateValues = Object.values(data);
			const queryString = `UPDATE usuario SET ${updateFields} WHERE id = ?`;

			await connection.query(queryString, [...updateValues, userId]);
			await connection.commit();
			connection.release();

			return response.status(200).json({ message: 'Usuário atualizado com sucesso' });
		} catch (error) {
			console.error(error);
			await connection.rollback(); // Rollback para caso tenha dado erro na atualização
			if (error.name === 'NotFoundError') {
				return response.status(404).json({ message: 'Usuário não encontrado.' });
			} else if (error.name === 'ValidationError') {
				return response.status(404).json({ message: error.message });
			} else {
				return response.status(500).json({ message: 'Erro ao atualizar o usuário' });
			}
		}
	};


	async deleteUser(userId, request, response) {
		try {
			const connection = await pool.getConnection();
			await connection.beginTransaction();

			// TODO criar o safe delete dps
			await connection.query('DELETE FROM usuario WHERE id = ?', [userId]);
			await connection.commit();
			connection.release();

			return response.status(200).json({ message: 'Usuário deletado com sucesso' });
		} catch (error) {
			console.error(error);
			await connection.rollback(); // Rollback para caso tenha dado erro na atualização
			if (error.name === 'NotFoundError') {
				return response.status(404).json({ message: 'Usuário não encontrado.' });
			} else {
				return response.status(500).json({ message: 'Erro ao atualizar o usuário' });
			}
		}
	};

}

export default UsersController