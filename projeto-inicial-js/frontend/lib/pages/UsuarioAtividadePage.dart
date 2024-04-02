import 'package:flutter/material.dart';
import 'package:frontend/components/custom_data_table.dart';
import 'package:frontend/services/userActivitiesService.dart';
import 'package:frontend/services/userService.dart';

class UsuarioAtividadesScreen extends StatefulWidget {
  const UsuarioAtividadesScreen({super.key});

  @override
  _UsuarioAtividadesScreenState createState() => _UsuarioAtividadesScreenState();
}

class _UsuarioAtividadesScreenState extends State<UsuarioAtividadesScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _usuarioAtividades = [];

  @override
  void initState() {
    super.initState();
    _fetchUsuariosFromAtividade();
  }

  Future<void> _fetchUsuariosFromAtividade() async {
    List<Map<String, dynamic>> userActivities = await UserActivitiesService.fetchUsuariosFromAtividade();
    setState(() {
      _usuarioAtividades = userActivities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomDataTable(
        data: _usuarioAtividades,
        title: 'Lista de Atividades do Usuário',
        columnNames: const ["Id", "Nome usuário", "Título da tarefa", "Data de entrega", "Nota"],
        onEdit: (index) async {
          _mostrarDialogoAdicionarUsuario(context,
              usuario:
                  await UserService.getUser(_usuarioAtividades[index]['id']));
        },
        onDelete: (index) async {
          _mostrarDialogExcluirUsuario(context,
              usuario:
                  await UserService.getUser(_usuarioAtividades[index]['id']));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogoAdicionarUsuario(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _mostrarDialogoAdicionarUsuario(BuildContext context,
      {Map<String, dynamic>? usuario}) async {
    TextEditingController nomeController =
        TextEditingController(text: usuario != null ? usuario['nome'] : '');
    TextEditingController emailController =
        TextEditingController(text: usuario != null ? usuario['email'] : '');
    TextEditingController senhaController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(usuario != null ? 'Editar Usuário' : 'Adicionar Usuário'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um nome';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um e-mail';
                      } else if (!value.contains('@') || !value.contains('.')) {
                        return 'Por favor, insira um e-mail valido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: senhaController,
                    decoration: const InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma senha';
                      } else if (value.length < 4) {
                        return 'Por favor, insira uma senha com 4 ou mais caracteres.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String nome = nomeController.text;
                  String email = emailController.text;
                  String senha = senhaController.text;

                  try {
                    if (usuario != null) {
                      // Chama o método updateActivity do ActivityService
                      await UserService.updateUser(
                          usuario['id'], nome, email, senha);
                      // Exibe um SnackBar de sucesso
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Usuário atualizado com sucesso!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      // Chama o método createUser do UserService
                      await UserService.createUser(nome, email, senha);
                      // Atualiza a lista de usuários
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Usuário criado com sucesso: $nome'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                    await _fetchUsuariosFromAtividade();
                  } catch (e) {
                    print('Erro ao criar/editar usuário: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao criar/editar usuário: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }

                  Navigator.of(context).pop();
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _mostrarDialogExcluirUsuario(BuildContext context,
      {Map<String, dynamic>? usuario}) async {
    final id = usuario?['id'];
    final nome = usuario?['nome'];
    final email = usuario?['email'];

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deletar Usuário'),
          content: Form(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Id: $id"),
                  Text("Nome: $nome"),
                  Text("E-mail: $email"),
                  const SizedBox(width: 10),
                  const Text("Tem certeza que deseja deletar este usuário?",
                      style: TextStyle(color: Colors.red))
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  if (usuario != null) {
                    // Chama o método updateActivity do ActivityService
                    await UserService.deleteUser(usuario['id']);
                    // Exibe um SnackBar de sucesso
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Usuário excluido com sucesso'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  // Atualiza a lista de usuários
                  await _fetchUsuariosFromAtividade();
                } catch (e) {
                  print('Erro ao deletar usuário: $e');
                  // Exibe um SnackBar de erro
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao deletar usuário: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );
  }
}
