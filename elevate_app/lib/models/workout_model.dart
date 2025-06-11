import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutModel {
  final String id;
  final String titulo;
  final String? descricao;
  final String? imagemtrei;
  final DocumentReference usuarioRef;
  final DateTime criadoEm;
  final bool concluido;

  WorkoutModel({
    required this.id,
    required this.titulo,
    this.descricao,
    this.imagemtrei,
    required this.usuarioRef,
    required this.criadoEm,
    this.concluido = false,
  });

  factory WorkoutModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WorkoutModel(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      descricao: data['descricao'],
      imagemtrei: data['imagemtrei'],
      usuarioRef: data['usuarioRef'] as DocumentReference,
      criadoEm: (data['criado_em'] as Timestamp?)?.toDate() ?? DateTime.now(),
      concluido: data['concluido'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'imagemtrei': imagemtrei,
      'usuarioRef': usuarioRef,
      'criado_em': Timestamp.fromDate(criadoEm),
      'concluido': concluido,
    };
  }

  WorkoutModel copyWith({
    String? id,
    String? titulo,
    String? descricao,
    String? imagemtrei,
    DocumentReference? usuarioRef,
    DateTime? criadoEm,
    bool? concluido,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      imagemtrei: imagemtrei ?? this.imagemtrei,
      usuarioRef: usuarioRef ?? this.usuarioRef,
      criadoEm: criadoEm ?? this.criadoEm,
      concluido: concluido ?? this.concluido,
    );
  }
}