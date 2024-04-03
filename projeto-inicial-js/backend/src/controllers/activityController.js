import pool from '../connection.js'

class ActivityController {

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


    async getActivities(request, response) {
        try {
            const activitiesList = await pool.query('SELECT * FROM atividade');

            return response.status(200).send(activitiesList[0]);
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
        const connection = await pool.getConnection();
        try {
            await connection.beginTransaction();

            const [rows, fields] = await connection.query("select count(id) from usuario_atividade where atividade_id = ?", [activityId])

            if (rows[0]['count(id)'] > 0) {
                await connection.commit();
                connection.release();
                return response.status(403).json({ message: 'Você não pode apagar uma atividade relacionada a algum usuário.' });
            }

            await connection.query('DELETE FROM atividade WHERE id = ?', [activityId]);
            await connection.commit();
            connection.release();

            return response.status(200).send();
        } catch (error) {
            console.error(error);
            await connection.rollback(); // Rollback para caso tenha dado erro na atualização
            return response.status(500).json({ message: 'Erro ao atualizar a atividade.' });
        }
    };
}

export default ActivityController