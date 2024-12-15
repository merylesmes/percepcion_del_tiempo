int numSegundos = 120;
int numMinutos = 60;
int numHoras = 24;

float radioBase = 100;
float incrementoRadio = 50;
float rotacionSegundos = 0;
float rotacionMinutos = 0;
float rotacionHoras = 0;

float velocidadSegundos = 0.01;
float velocidadMinutos = 0.005;
float velocidadHoras = 0.002;

float[] nivelesSegundos = new float[numSegundos];
float[] nivelesMinutos = new float[numMinutos];
float[] nivelesHoras = new float[numHoras];

ArrayList<int[]> conexiones = new ArrayList<>(); // Lista de conexiones
int contadorInteracciones = 0; // Contador de interacciones

void setup() {
  size(800, 800);
  frameRate(60);
}

void draw() {
  background(20);
  translate(width / 2, height / 2);

  // Actualizar rotaciones según la velocidad
  rotacionSegundos += velocidadSegundos;
  rotacionMinutos += velocidadMinutos;
  rotacionHoras += velocidadHoras;

  // Dibujar conexiones (telarañas)
  stroke(150, 150, 255, 100); // Color de las conexiones
  strokeWeight(1);
  for (int[] conexion : conexiones) {
    float[] punto1 = getCoordenadas(conexion[0], conexion[1]); // Índice y tipo del primer punto
    float[] punto2 = getCoordenadas(conexion[2], conexion[3]); // Índice y tipo del segundo punto
    line(punto1[0], punto1[1], punto2[0], punto2[1]);
  }

  // Dibujar los tres anillos
  dibujarAnillo(numSegundos, radioBase + 2 * incrementoRadio, rotacionSegundos, color(0, 100, 255), nivelesSegundos, true);
  dibujarAnillo(numMinutos, radioBase + incrementoRadio, rotacionMinutos, color(255, 200, 0), nivelesMinutos, true);
  dibujarAnillo(numHoras, radioBase, rotacionHoras, color(255, 50, 50), nivelesHoras, false);

  // Mostrar contador de interacciones
  fill(255);
  textSize(16);
  text("Interacciones: " + contadorInteracciones, -width / 2 + 20, -height / 2 + 30);
}

void dibujarAnillo(int numDivisiones, float radio, float rotacion, color c, float[] niveles, boolean crecerHaciaFuera) {
  strokeWeight(2);
  noFill();
  stroke(c);

  for (int i = 0; i < numDivisiones; i++) {
    float anguloInicio = TWO_PI / numDivisiones * i + rotacion;
    float x1 = cos(anguloInicio) * radio;
    float y1 = sin(anguloInicio) * radio;

    // Control de la altura de cada barra según su nivel
    float radioModificado = crecerHaciaFuera ? radio + niveles[i] * 50 : radio - niveles[i] * 50;
    float x2 = cos(anguloInicio) * radioModificado;
    float y2 = sin(anguloInicio) * radioModificado;

    line(x1, y1, x2, y2);
  }
}

// Añadir interacción con clic del mouse
void mousePressed() {
  if (mouseButton == LEFT) {
    int indice = getIndiceActivo(numSegundos, rotacionSegundos);
    nivelesSegundos[indice] = constrain(nivelesSegundos[indice] + 0.1, 0, 1);
    agregarConexion(indice, 0); // Añadir conexión para segundos
    contadorInteracciones++;
  }
}

// Añadir interacción con teclas
void keyPressed() {
  int indice;
  if (key == 'm') {
    indice = getIndiceActivo(numMinutos, rotacionMinutos);
    nivelesMinutos[indice] = constrain(nivelesMinutos[indice] + 0.1, 0, 1);
    agregarConexion(indice, 1); // Añadir conexión para minutos
    contadorInteracciones++;
  } else if (key == 'h') {
    indice = getIndiceActivo(numHoras, rotacionHoras);
    nivelesHoras[indice] = constrain(nivelesHoras[indice] + 0.1, 0, 1);
    agregarConexion(indice, 2); // Añadir conexión para horas
    contadorInteracciones++;
  }
}

// Obtener el índice activo según el ángulo
int getIndiceActivo(int numDivisiones, float rotacion) {
  float anguloPorDivision = TWO_PI / numDivisiones;
  return int((rotacion / anguloPorDivision) % numDivisiones);
}

// Añadir una conexión entre dos puntos (aleatorio por simplicidad)
void agregarConexion(int indice, int tipo) {
  if (conexiones.size() < 100) { // Límite para evitar exceso de líneas
    int otroIndice = int(random(0, numSegundos));
    int otroTipo = int(random(0, 3)); // 0=segundos, 1=minutos, 2=horas
    conexiones.add(new int[] {indice, tipo, otroIndice, otroTipo});
  }
}

// Obtener coordenadas de un punto basado en su tipo (segundos, minutos, horas)
float[] getCoordenadas(int indice, int tipo) {
  float radio = radioBase + tipo * incrementoRadio;
  float rotacion = tipo == 0 ? rotacionSegundos : tipo == 1 ? rotacionMinutos : rotacionHoras;
  float angulo = TWO_PI / (tipo == 0 ? numSegundos : tipo == 1 ? numMinutos : numHoras) * indice + rotacion;
  return new float[] {cos(angulo) * radio, sin(angulo) * radio};
}
