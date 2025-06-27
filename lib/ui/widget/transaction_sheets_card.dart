import '../../common/utils/formatter.dart';
import '../../domain/entity/transaction_entity.dart';
import 'package:flutter/material.dart';

/// widget que exibe uma lista de transações de receitas e despesas
class TransactionCardSheets extends StatefulWidget {
  final List<TransactionEntity>
  incomeTransactions; // Lista de transações de receitas
  final List<TransactionEntity>
  expenseTransactions; // Lista de transações de despesas
  final Function(String id)
  onDelete; // Callback para deletar uma transação pelo ID
  final Function(TransactionEntity transaction)
  undoDelete; // Callback para desfazer exclusão
  final BuildContext
  scaffoldContext; // Contexto do Scaffold para exibir SnackBars

  const TransactionCardSheets({
    super.key,
    required this.incomeTransactions,
    required this.expenseTransactions,
    required this.onDelete,
    required this.undoDelete,
    required this.scaffoldContext,
  });

  @override
  State<TransactionCardSheets> createState() => _TransactionCardSheetsState();
}

class _TransactionCardSheetsState extends State<TransactionCardSheets>
    with SingleTickerProviderStateMixin {
  late TabController _tabController; // Controlador para o TabBar e TabBarView

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    ); // 2 abas: Receitas e Despesas
    _tabController.addListener(() {
      if (mounted)
        setState(() {}); // Atualiza o estado quando troca de aba acontece
    });
  }

  @override
  void dispose() {
    _tabController.dispose(); // Limpa o controlador para evitar leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 8, // Elevação do card para sombra
      margin: const EdgeInsets.all(12), // Margem externa do card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ), // Bordas arredondadas
      child: Column(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.tertiary.withValues(
                    alpha: 0.15,
                  ), // Fundo com transparência
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ), // Apenas bordas superiores arredondadas
                ),
                child: TabBar(
                  controller: _tabController, // Controlador das abas
                  tabs: [
                    _buildTab(
                      TransactionType.income.namePlural, // Título da aba
                      Icons.arrow_upward, // Ícone da aba
                      0, // Índice da aba
                      colorScheme.primary, // Cor ativa
                      colorScheme.primary.withValues(alpha: 0.5), // Cor inativa
                    ),
                    _buildTab(
                      TransactionType.expense.namePlural,
                      Icons.arrow_downward,
                      1,
                      colorScheme.secondary,
                      colorScheme.secondary.withValues(alpha: 0.5),
                    ),
                  ],
                  indicatorColor:
                      _tabController.index ==
                              0 // Cor do indicador da aba selecionada
                          ? colorScheme.primary
                          : colorScheme.secondary,
                  indicatorSize:
                      TabBarIndicatorSize
                          .label, // Indicador do tamanho do label
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ), // Arredonda bordas inferiores para combinar com o card
                child: SizedBox(
                  height: 290, // Altura fixa do conteúdo da aba
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTransactionList(
                        context,
                        widget.incomeTransactions, // Lista de receitas
                        colorScheme.primary,
                        TransactionType.income.namePlural,
                      ),
                      _buildTransactionList(
                        context,
                        widget.expenseTransactions, // Lista de despesas
                        colorScheme.secondary,
                        TransactionType.expense.namePlural,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    String title,
    IconData icon,
    int index,
    Color activeColor,
    Color inactiveColor,
  ) {
    final isSelected =
        _tabController.index == index; // Verifica se a aba está selecionada
    final color =
        isSelected ? activeColor : inactiveColor; // Cor ativa ou inativa

    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min, // Tamanho da linha adaptado ao conteúdo
        children: [
          Icon(icon, size: 18, color: color), // Ícone da aba com a cor correta
          const SizedBox(width: 8), // Espaço entre ícone e texto
          Text(
            title, // Texto da aba
            style: TextStyle(
              color: color, // Cor do texto (ativa ou inativa)
              fontWeight:
                  isSelected
                      ? FontWeight.bold
                      : FontWeight.normal, // Negrito se selecionada
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(
    BuildContext context,
    List<TransactionEntity> transactions,
    Color color,
    String title,
  ) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza conteúdo
          children: [
            Icon(
              title == TransactionType.income.namePlural // Receitas
                  ? Icons.savings
                  : Icons.shopping_cart, // Ícone condicional
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              'Sem ${title.toLowerCase()} registradas', // Mensagem de lista vazia
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ), // Estilo e cor do texto
            ),
          ],
        ),
      );
    }

    return Scrollbar(
      thumbVisibility: true, // Mostra a barra de rolagem sempre
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ), // Espaçamento vertical na lista
        itemCount: transactions.length, // Quantidade de itens da lista
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          final undoTransaction =
              transaction.copyWith(); // Cópia para desfazer exclusão

          return Dismissible(
            key: Key(transaction.id), // Chave única para controle do widget
            direction:
                DismissDirection
                    .endToStart, // Permite deslizar da direita para esquerda
            background: Container(
              alignment:
                  Alignment.centerRight, // Ícone aparece alinhado à direita
              padding: const EdgeInsets.only(
                right: 20.0,
              ), // Espaçamento interno
              decoration: BoxDecoration(
                color: Colors.red, // Fundo vermelho para exclusão
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ), // Ícone de exclusão
            ),
            onDismissed: (direction) {
              widget.onDelete(
                transaction.id,
              ); // Chama callback para deletar transação

              ScaffoldMessenger.of(widget.scaffoldContext).clearSnackBars();
              // Limpa snackbars anteriores para evitar sobreposição

              ScaffoldMessenger.of(widget.scaffoldContext).showSnackBar(
                SnackBar(
                  content: Text(
                    '${transaction.title} excluída!!!',
                  ), // Mensagem de exclusão
                  backgroundColor: Colors.redAccent, // Cor do snackbar vermelho
                  action: SnackBarAction(
                    label: 'DESFAZER', // Botão para desfazer
                    textColor: Colors.white,
                    onPressed: () {
                      widget.undoDelete(
                        undoTransaction,
                      ); // Chama callback para desfazer exclusão
                      ScaffoldMessenger.of(widget.scaffoldContext).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${transaction.title} restaurada!',
                          ), // Mensagem de restauração
                          backgroundColor:
                              Colors.green, // Cor do snackbar verde
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 4,
              ), // Margem do card da transação
              elevation: 0, // Sem sombra
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Bordas arredondadas
                side: BorderSide(
                  color: Colors.grey.shade300,
                ), // Borda cinza clara
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ), // Espaçamento interno do item
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: color.withValues(
                    alpha: 0.2,
                  ), // Fundo com transparência
                  child: Icon(
                    title == 'Income' ? Icons.attach_money : Icons.shopping_bag,
                    color: color, // Cor do ícone conforme tipo
                  ),
                ),
                title: Text(
                  transaction.title, // Título da transação
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  Formatter.formatDate(transaction.date), // Data formatada
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Text(
                  Formatter.formatCurrency(
                    transaction.amount,
                  ), // Valor formatado em moeda
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color, // Cor do texto conforme tipo
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
