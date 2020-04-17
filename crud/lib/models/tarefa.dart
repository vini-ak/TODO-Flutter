class Tarefa {

  // Atributos
  String titulo;
  bool concluida;

  // Construtor
  Tarefa(this.titulo, [this.concluida = false]);

  Tarefa.fromJson(Map<String, dynamic> json) {
    titulo = json['titulo'];
    concluida = json['concluida'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titulo'] = this.titulo;
    data['concluida'] = this.concluida;
    return data;
  }
}

void main() {
  Tarefa t1 = new Tarefa("Cozinhar");
  print(t1);
}