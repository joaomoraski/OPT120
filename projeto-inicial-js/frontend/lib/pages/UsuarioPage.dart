import 'package:flutter/material.dart';
import 'package:frontend/components/custom_data_table.dart';
import 'package:frontend/services/userService.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({Key? key}) : super(key: key);

  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  List<Map<String, dynamic>> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _fetchUsuarios();
  }

  Future<void> _fetchUsuarios() async {
    List<Map<String, dynamic>> users = await UserService.fetchUsers();
    setState(() {
      _usuarios = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomDataTable(
        data: _usuarios,
        title: 'Lista de Usuários',
        columnNames: ["Id", "Nome", "E-mail"],
        onEdit: (index) {
          print("ado ado");
        },
        onDelete: (index) {
          print("ado ado");
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogoAdicionarUsuario(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _mostrarDialogoAdicionarUsuario(BuildContext context) async {
    TextEditingController nomeController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController senhaController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Usuário'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: nomeController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'E-mail'),
                ),
                TextFormField(
                  controller: senhaController,
                  decoration: InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                String nome = nomeController.text;
                String email = emailController.text;
                String senha = senhaController.text;

                try {
                  // Chama o método createUser do UserService
                  await UserService.createUser(nome, email, senha);
                  // Atualiza a lista de usuários
                  await _fetchUsuarios();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Usuário criado com sucesso: $nome'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  print('Erro ao criar usuário: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao criar usuário: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
