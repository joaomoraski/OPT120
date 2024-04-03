import 'package:flutter/material.dart';
import 'package:frontend/components/custom_data_table.dart';
import 'package:frontend/services/activityService.dart';
import 'package:frontend/services/userActivitiesService.dart';
import 'package:frontend/services/userService.dart';

class UsuarioAtividadesScreen extends StatefulWidget {
  const UsuarioAtividadesScreen({super.key});

  @override
  _UsuarioAtividadesScreenState createState() =>
      _UsuarioAtividadesScreenState();
}

class _UsuarioAtividadesScreenState extends State<UsuarioAtividadesScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _usuarioAtividades = [];
  List<Map<String, dynamic>> _usuarios = [];
  List<Map<String, dynamic>> _atividades = [];

  @override
  void initState() {
    super.initState();
    _fetchUsuariosFromAtividade();
  }

  Future<List<Map<String, dynamic>>> _fetchUsuarios() async {
    List<Map<String, dynamic>> users = await UserService.fetchUsers();
    return users;
  }

  Future<List<Map<String, dynamic>>> _fetchAtividades() async {
    List<Map<String, dynamic>> atividades =
        await ActivityService.fetchActivities();
    return atividades;
  }

  Future<void> _fetchUsuariosFromAtividade() async {
    List<Map<String, dynamic>> userActivities =
        await UserActivitiesService.fetchUsuariosFromAtividade();
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
        columnNames: const [
          "Id",
          "Nome usuário",
          "Título da tarefa",
          "Data de entrega",
          "Nota"
        ],
        onEdit: (index) async {
          _mostrarDialogAdicionarUsuarioAtividade(context,
              usuarioAtividade:
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
          _mostrarDialogAdicionarUsuarioAtividade(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _mostrarDialogAdicionarUsuarioAtividade(BuildContext context,
      {Map<String, dynamic>? usuarioAtividade}) async {
    List<Map<String, dynamic>> usuarios = await _fetchUsuarios();
    List<Map<String, dynamic>> atividades = await _fetchAtividades();
    List<Map<String, dynamic>> usuariosSelecionados = [];
    Map<String, dynamic>? atividadeSelecionada;

    TextEditingController notaController = TextEditingController(
        text: usuarioAtividade != null
            ? usuarioAtividade['nota'].toString()
            : '');
    DateTime? selectedDate =
        usuarioAtividade != null && usuarioAtividade['entrega'] != null
            ? DateTime.parse(usuarioAtividade['entrega'])
            : null;

    // TextEditingController nomeController =
    //     TextEditingController(text: usuarioAtividade != null ? usuarioAtividade['nome'] : '');
    // TextEditingController emailController =
    //     TextEditingController(text: usuarioAtividade != null ? usuarioAtividade['email'] : '');
    // TextEditingController senhaController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(usuarioAtividade != null
              ? 'Editar Usuário'
              : 'Adicionar Usuário'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Selecione uma atividade: ',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  DropdownButton<Map<String, dynamic>>(
                      isExpanded: true,
                      value: atividadeSelecionada,
                      onChanged: (Map<String, dynamic>? newValue) {
                        setState(() {
                          atividadeSelecionada = newValue;
                        });
                      },
                      items: atividades
                          .map<DropdownMenuItem<Map<String, dynamic>>>(
                              (atividade) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: atividade,
                          child: Text(atividade['titulo']),
                        );
                      }).toList()),
                  DropdownButton<Map<String, dynamic>>(
                    isExpanded: true,
                    value: null,
                    onChanged: (Map<String, dynamic>? newValue) {
                      if (newValue != null) {
                        setState(() {
                          usuariosSelecionados.add(newValue);
                        });
                      }
                    },
                    items: usuarios
                        .map<DropdownMenuItem<Map<String, dynamic>>>((usuario) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: usuario,
                        child: Text(usuario['nome']),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    controller: notaController,
                    decoration: const InputDecoration(labelText: 'Nota'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma nota';
                      }
                      final double nota = double.tryParse(value)!;
                      if (nota < 0 || nota > 10) {
                        return 'A nota deve estar entre 0 e 10';
                      }
                      return null;
                    },
                  ),
                  ListTile(
                    title: selectedDate != null
                        ? Text(selectedDate.toString())
                        : null,
                    subtitle: Text('Data de entrega'),
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 10),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
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
                  double nota = double.tryParse(notaController.text) ?? 0;
                  DateTime dataEntrega = selectedDate ?? DateTime.now();

                  try {
                    // Chama o método createUser do UserService
                    await UserActivitiesService.createUserActivity(
                        usuariosSelecionados,
                        atividadeSelecionada,
                        nota,
                        dataEntrega);
                    // Atualiza a lista de usuários
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Usuário e atividade relacionados com sucesso'),
                        backgroundColor: Colors.green,
                      ),
                    );
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
