import mysql from 'mysql2/promise';

const pool = mysql.createPool({
    host: 'localhost',
    port: '3306',
    user: 'root',
    password: 'root',
    database: 'opt120'
});

//   host: process.env.DATABASE_HOST,
//   port: process.env.DATABASE_PORT,
//   user: process.env.DATABASE_USER,
//   password: process.env.DATABASE_PASSWORD,
//   database: process.env.DATABASE_NAME
export default pool