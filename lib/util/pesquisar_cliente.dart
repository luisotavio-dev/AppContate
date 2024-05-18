import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lancamento_contatos/model/cliente_model.dart';
import 'package:lancamento_contatos/theme.dart';
import 'package:lancamento_contatos/util.dart';

abrirPesquisaClientes({required BuildContext context, dynamic Function(List<SelectedListItem>)? selectedItems}) {
  try {
    // Pesquisa os clientes cadastrados
    List<SelectedListItem> clientes = [];
    Box<Cliente> box = Hive.box<Cliente>('clientes');

    // Constrói os itens do combobox
    for (var i = 0; i < box.length; i++) {
      SelectedListItem item = SelectedListItem(
        name: box.getAt(i)?.conta != null
            ? '${box.getAt(i)!.nome!} - Conta ${box.getAt(i)?.conta!}'
            : box.getAt(i)!.nome!,
        value: box.getAt(i)!.idCliente!,
      );
      clientes.add(item);
    }

    clientes.sort((a, b) => a.name.compareTo(b.name));

    DropDownState(
      DropDown(
        dropDownBackgroundColor: backgroundColor,
        searchHintText: 'Digite o nome desejado',
        bottomSheetTitle: const Text(
          'Pesquisar Cliente',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        data: clientes,
        selectedItems: selectedItems,
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  } catch (e) {
    Util.buildSnackMessage(e.toString(), context);
  }
}
