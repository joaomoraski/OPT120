import 'package:flutter/material.dart';
import 'package:frontend/components/custom_data_table.dart';
import 'package:frontend/services/activityService.dart';

class AtividadesScreen extends StatefulWidget {
  const AtividadesScreen({Key? key}) : super(key: key);

  @override
  _AtividadesScreenState createState() => _AtividadesScreenState();
}

class _AtividadesScreenState extends State<AtividadesScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _atividades = [];

  @override
  void initState() {
    super.initState();
    _fetchAtividades();
  }

  Future<void> _fetchAtividades() async {
    List<Map<String, dynamic>> activities =
        await ActivityService.fetchActivities();
    setState(() {
      _atividades = activities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomDataTable(
        data: _atividades,
        title: 'Lista de Atividades',
        columnNames: ["Id", "Titulo", "Descrição", "Nota", "Data Limite"],
        onEdit: (index) async {
          _mostrarDialogoAdicionarAtividade(context, atividade: await ActivityService.getActivity(index));
          print("ado ado");
        },
        onDelete: (index) {
          print("nada");
          // _mostrarDialogoAdicionarAtividade(context);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogoAdicionarAtividade(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _mostrarDialogoAdicionarAtividade(BuildContext context,
      {Map<String, dynamic>? atividade}) async {
    TextEditingController tituloController = TextEditingController(
        text: atividade != null ? atividade['titulo'] : '');
    TextEditingController descricaoController = TextEditingController(
        text: atividade != null ? atividade['descricao'] : '');
    TextEditingController notaController = TextEditingController(
        text: atividade != null ? atividade['nota'].toString() : '');
    DateTime? selectedDate =
        atividade != null && atividade['dataLimite'] != null
            ? DateTime.parse(atividade['dataLimite'])
            : null;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              atividade != null ? 'Editar Atividade' : 'Adicionar Atividade'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: tituloController,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um título';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: descricaoController,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma descrição';
                      }
                      return null;
                    },
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
                    title: const Text('Data Limite'),
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
                  String titulo = tituloController.text;
                  String descricao = descricaoController.text;
                  double nota = double.tryParse(notaController.text) ?? 0;
                  DateTime dataLimite = selectedDate ?? DateTime.now();

                  try {
                    if (atividade != null) {
                      // Chama o método updateActivity do ActivityService
                      await ActivityService.updateActivity(
                          atividade['id'], titulo, descricao, nota, dataLimite);
                      // Exibe um SnackBar de sucesso
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Atividade atualizada com sucesso'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      // Chama o método createActivity do ActivityService
                      await ActivityService.createActivity(
                          titulo, descricao, nota, dataLimite);
                      // Exibe um SnackBar de sucesso
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Atividade criada com sucesso'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                    // Atualiza a lista de atividades
                    await _fetchAtividades();
                  } catch (e) {
                    print('Erro ao criar/atualizar atividade: $e');
                    // Exibe um SnackBar de erro
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao criar/atualizar atividade: $e'),
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
}
