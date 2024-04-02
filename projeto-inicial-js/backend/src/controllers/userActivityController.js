import pool from '../connection.js'

class UserActivityController {

    async create(request, response) {
        const {
            titulo,
            descricao,
            nota,
            dataLimite
        } = request.body;

        if (!titulo || !descricao || !nota || !dataLimite) {
            return response.status(400).json({message: 'Bota os campo certo ai'});
        }

        try {
            const connection = await pool.getConnection();
            await connection.beginTransaction();

            const [result] = await connection.query('INSERT INTO atividade (titulo, descricao, nota, dataLimite) VALUES (?, ?, ?, ?)', [titulo, descricao, nota, dataLimite]);

            await connection.commit();

            return response.status(201).json({ message: 'Atividade criado com sucesso.' });
        } catch (error) {
            console.error(error);
            return response.status(500).json({ message: 'Ocorreu um erro ao criar o usuário.' });
        }
    };


    async getUserActivities(request, response) {
        try {
            const userActivitiesList =
                await pool.query(
                    'SELECT ua.id, u.nome, a.titulo, ua.entrega, ua.nota FROM usuario_atividade ua ' +
                    'inner join usuario u on u.id = ua.usuario_id ' +
                    'inner join atividade a on a.id = ua.atividade_id');

            return response.status(200).send(userActivitiesList[0]);
        } catch (error) {
            console.error(error);
            return response.status(500).json({ message: 'Ocorreu um erro ao executar a listagem.' });
        }
    };


    async getActivity(activityId, request, response) {
        try {
            const connection = await pool.getConnection();
            const [rows] = await connection.query('SELECT * FROM atividade WHERE id = ?', [activityId]);
            connection.release(); // Fecha conexão depois da query

            if (rows.length === 0) {
                throw new Error("NotFoundError")
            }
            const activity = rows[0];

            return response.status(200).json(activity);
        } catch (error) {
            console.error(error);
            if (error.message === "NotFoundError") {
                return response.status(404).json({ message: 'Ativdade não encontrado.' });
            } else {
                return response.status(404).json({ message: 'Aconteceu algum erro ai.' });
            }
        }
    };


    async updateActivity(activityId, data, request, response) {
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
            const queryString = `UPDATE atividade
                                 SET ${updateFields}
                                 WHERE id = ?`;

            await connection.query(queryString, [...updateValues, activityId]);
            await connection.commit();
            connection.release();

            return response.status(200).json({ message: 'Atividade atualizado com sucesso' });
        } catch (error) {
            console.error(error);
            await connection.rollback(); // Rollback para caso tenha dado erro na atualização
            if (error.name === 'NotFoundError') {
                return response.status(404).json({ message: 'Atividade não encontrado.' });
            } else if (error.name === 'ValidationError') {
                return response.status(404).json({ message: error.message });
            } else {
                return response.status(500).json({ message: 'Erro ao atualizar a atividade'} );
            }
        }
    };

    async deleteActivity(activityId, request, response) {
        try {
            const connection = await pool.getConnection();
            await connection.beginTransaction();

            await connection.query('DELETE FROM atividade WHERE id = ?', [activityId]);
            await connection.commit();
            connection.release();

            return response.status(200).send();
        } catch (error) {
            console.error(error);
            await connection.rollback(); // Rollback para caso tenha dado erro na atualização
            if (error.name === 'NotFoundError') {
                return response.status(404).json({ message: 'Atividade não encontrada.' });
            } else {
                return response.status(500).json({ message: 'Erro ao atualizar a atividade.' });
            }
        }
    };
}

export default UserActivityController