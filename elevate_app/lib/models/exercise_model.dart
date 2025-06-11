import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseModel {
  final String id;
  final String nome;
  final String? descricao;
  final String? categoria;
  final String? carga;
  final int? series;
  final String? imagemexer;
  final DocumentReference treinoRef;
  final DateTime criadoEm;
  final bool concluido;

  ExerciseModel({
    required this.id,
    required this.nome,
    this.descricao,
    this.categoria,
    this.carga,
    this.series,
    this.imagemexer,
    required this.treinoRef,
    required this.criadoEm,
    this.concluido = false,
  });

  factory ExerciseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExerciseModel(
      id: doc.id,
      nome: data['nome'] ?? '',
      descricao: data['descricao'],
      categoria: data['categoria'],
      carga: data['carga'],
      series: data['series'],
      imagemexer: data['imagemexer'],
      treinoRef: data['TreinoRef'] as DocumentReference,
      criadoEm: (data['criado_em'] as Timestamp?)?.toDate() ?? DateTime.now(),
      concluido: data['concluido'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'descricao': descricao,
      'categoria': categoria,
      'carga': carga,
      'series': series,
      'imagemexer': imagemexer,
      'TreinoRef': treinoRef,
      'criado_em': Timestamp.fromDate(criadoEm),
      'concluido': concluido,
    };
  }

  ExerciseModel copyWith({
    String? id,
    String? nome,
    String? descricao,
    String? categoria,
    String? carga,
    int? series,
    String? imagemexer,
    DocumentReference? treinoRef,
    DateTime? criadoEm,
    bool? concluido,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      categoria: categoria ?? this.categoria,
      carga: carga ?? this.carga,
      series: series ?? this.series,
      imagemexer: imagemexer ?? this.imagemexer,
      treinoRef: treinoRef ?? this.treinoRef,
      criadoEm: criadoEm ?? this.criadoEm,
      concluido: concluido ?? this.concluido,
    );
  }
}