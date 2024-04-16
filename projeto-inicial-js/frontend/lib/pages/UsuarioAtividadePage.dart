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
              usuarioAtividade: await UserActivitiesService.getUserActivity(
                  _usuarioAtividades[index]['id']));
        },
        onDelete: (index) async {
          _mostrarDialogExcluirRelacaoUsuarioAtividade(context,
              usuarioAtividade: await UserActivitiesService.getUserActivity(
                  _usuarioAtividades[index]['id']));
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
    String usuariosSelecionadosText = '';
    Map<String, dynamic>? atividadeSelecionada;

    TextEditingController notaController = TextEditingController(
        text: usuarioAtividade != null
            ? usuarioAtividade['nota'].toString()
            : '');
    DateTime? selectedDate =
        usuarioAtividade != null && usuarioAtividade['entrega'] != null
            ? DateTime.parse(usuarioAtividade['entrega'])
            : null;

    if (usuarioAtividade != null) {
      for (var usuario in usuarios) {
        if (usuario['id'] == usuarioAtividade['usuario_id']) {
          usuariosSelecionados.add(usuario);
        }
      }
    }

    String getNomesUsuariosSelecionados() {
      List<String> nomesUsuarios = usuariosSelecionados.map((usuario) {
        return usuario['nome'] as String; // Extrai o nome do usuário do mapa
      }).toList();
      return nomesUsuarios.join(', ');
    }

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  title: Text(usuarioAtividade != null
                      ? 'Editar Relação'
                      : 'Adicionar Relação'),
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
                          const Text('Selecione um usuário: ',
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 10),
                          DropdownButton<Map<String, dynamic>>(
                            isExpanded: true,
                            value: null,
                            onChanged: (Map<String, dynamic>? newValue) {
                              if (newValue != null) {
                                int novoUsuario = newValue['id'];
                                bool usuarioJaSelecionado =
                                    usuariosSelecionados.any((usuario) =>
                                        usuario['id'] == novoUsuario);
                                if (!usuarioJaSelecionado) {
                                  setState(() {
                                    usuariosSelecionados.add(newValue);
                                  });
                                }
                              }
                            },
                            items: usuarios
                                .map<DropdownMenuItem<Map<String, dynamic>>>(
                                    (usuario) {
                              return DropdownMenuItem<Map<String, dynamic>>(
                                value: usuario,
                                child: Text(usuario['nome']),
                              );
                            }).toList(),
                          ),
                          Text(getNomesUsuariosSelecionados()),
                          TextFormField(
                            controller: notaController,
                            decoration:
                                const InputDecoration(labelText: 'Nota'),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
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
                            title: const Text('Data de entrega'),
                            subtitle: selectedDate != null
                                ? Text(selectedDate.toString())
                                : null,
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
                          double nota =
                              double.tryParse(notaController.text) ?? 0;
                          DateTime dataEntrega = selectedDate ?? DateTime.now();

                          try {
                            if (usuarioAtividade != null) {
                              // Chama o método updateActivity do ActivityService
                              await UserActivitiesService.updateUserActivity(
                                  usuarioAtividade['id'],
                                  usuariosSelecionados,
                                  atividadeSelecionada,
                                  nota,
                                  dataEntrega);
                              // Exibe um SnackBar de sucesso
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Usuário atualizado com sucesso!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              await UserActivitiesService.createUserActivity(
                                  usuariosSelecionados,
                                  atividadeSelecionada,
                                  nota,
                                  dataEntrega);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Usuário e atividade relacionados com sucesso'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                            await _fetchUsuariosFromAtividade();
                          } catch (e) {
                            print(
                                'Erro ao criar/editar relação de usuarios e atividades: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Erro ao criar/editar relação de usuarios e atividades: $e'),
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
                ));
      },
    );
  }

  Future<void> _mostrarDialogExcluirRelacaoUsuarioAtividade(
      BuildContext context,
      {Map<String, dynamic>? usuarioAtividade}) async {
    final id = usuarioAtividade?['id'];
    final nome = usuarioAtividade?['nome'];
    final titulo = usuarioAtividade?['titulo'];
    final entrega = usuarioAtividade?['entrega'];
    final nota = usuarioAtividade?['nota'];

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
                  Text("Nome usuário: $nome"),
                  Text("Titulo tarefa: $titulo"),
                  Text("Data de Entrega: $entrega"),
                  Text("Nome: $nota"),
                  const SizedBox(width: 10),
                  const Text("Tem certeza que deseja deletar esta relação?",
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
                  if (usuarioAtividade != null) {
                    // Chama o método updateActivity do ActivityService
                    await UserActivitiesService.deleteUserActivity(
                        usuarioAtividade['id']);
                    // Exibe um SnackBar de sucesso
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Relação excluida com sucesso'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  // Atualiza a lista de usuários
                  await _fetchUsuariosFromAtividade();
                } catch (e) {
                  print('Erro ao deletar relação: $e');
                  // Exibe um SnackBar de erro
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao deletar relação: $e'),
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
