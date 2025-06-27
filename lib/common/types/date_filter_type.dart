import 'package:flutter/material.dart';

/// Enum que representa os tipos de filtro de data disponíveis.
enum DateFilterType { today, week, month, custom, all }

/// Extensão para adicionar funcionalidades ao enum DateFilterType,
/// especialmente para calcular o intervalo de datas baseado no filtro.
extension DateFilterTypeExtension on DateFilterType {
  /// Retorna o intervalo de datas (`DateTimeRange`) correspondente ao filtro.
  ///
  /// [now] é a data atual usada como base.
  /// [customStart] e [customEnd] são usados apenas quando o filtro for `custom`.
  /// Retorna `null` para o filtro `all` (sem restrição de datas).
  DateTimeRange? resolveRange(
    DateTime now,
    DateTime? customStart,
    DateTime? customEnd,
  ) {
    switch (this) {
      case DateFilterType.today:
        return DateTimeRange(
          start: DateTime(now.year, now.month, now.day),
          end: DateTime(now.year, now.month, now.day, 23, 59, 59),
        );

      case DateFilterType.week:
        final start = DateTime(now.year, now.month, now.day - now.weekday + 1);
        final end = DateTime(
          now.year,
          now.month,
          now.day + (7 - now.weekday),
          23,
          59,
          59,
        );
        return DateTimeRange(start: start, end: end);

      case DateFilterType.month:
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return DateTimeRange(start: start, end: end);

      case DateFilterType.custom:
        final start = customStart ?? DateTime(now.year, now.month, 1);
        final end =
            customEnd ?? DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return DateTimeRange(start: start, end: end);

      case DateFilterType.all:
        return null;
    }
  }
}

/// Extensão auxiliar para garantir que um intervalo de datas
/// não ultrapasse uma data final máxima (`maxDate`).
extension SafeRangeExtension on DateTimeRange {
  /// Garante que o `end` não seja posterior a `maxDate`.
  DateTimeRange cappedAt(DateTime maxDate) {
    final newEnd = end.isAfter(maxDate) ? maxDate : end;
    return DateTimeRange(start: start, end: newEnd);
  }
}
