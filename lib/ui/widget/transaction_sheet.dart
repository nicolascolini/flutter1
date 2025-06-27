import 'package:financial_tracker/common/errors/errors_classes.dart';
import 'package:financial_tracker/common/patterns/command.dart';
import 'package:financial_tracker/domain/entity/transaction_entity.dart';
import 'package:flutter/material.dart';

import 'transaction_form.dart';

/// Bottom sheet para adicionar transações de receita ou despesa
class TransactionSheet extends StatelessWidget {
  /// Tipo da transação (receita ou despesa)
  final TransactionType type;

  /// Comando que deve ser observado o estado de execução
  /// e o resultado da execução
  final Command1<void, Failure, TransactionEntity> submitCommand;

  /// Função callback quando a transação é submetida
  final Function(TransactionEntity newTransaction) onSubmit;

  const TransactionSheet({
    super.key,
    required this.type,
    required this.onSubmit,
    required this.submitCommand,
  });

  /// Método auxiliar para exibir o bottom sheet como um modal
  static Future<void> show({
    required BuildContext context,
    required TransactionType type,
    required Function(TransactionEntity newTransaction) onSubmit,
    required Command1<void, Failure, TransactionEntity> submitCommand,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite expandir até o topo
      backgroundColor: Colors.transparent,
      builder:
          (context) => TransactionSheet(
            type: type,
            onSubmit: onSubmit,
            submitCommand: submitCommand,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isIncome = type == TransactionType.income;
    final color = isIncome ? colorScheme.primary : colorScheme.secondary;
    final formTitle = type.nameSingular; // Retorna 'Receita' ou 'Despesa'

    // Altura disponível para o bottom sheet (75% da altura da tela)
    final availableHeight = MediaQuery.of(context).size.height * 0.75;

    return Container(
      height: availableHeight,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabeçalho e "alça" do sheet
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Alça para indicar que o sheet pode ser arrastado
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Título do cabeçalho
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isIncome ? Icons.trending_up : Icons.trending_down,
                        color: colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Adicionar $formTitle',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Formulário para inserir a transação
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  // Aplica um padding inferior para evitar que o teclado cubra os campos
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: TransactionForm(
                  type: type,
                  color: color,
                  submitCommand: submitCommand,
                  onSubmit: (newTransaction) {
                    onSubmit(newTransaction);
                    Navigator.pop(context); // Fecha o bottom sheet
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
