int numLines = 60; // Número total de líneas por nivel
float[] secondsLevels, minutesLevels, hoursLevels; // Altura de los tres niveles
color[] secondsColors, minutesColors, hoursColors; // Colores de los tres niveles
int baseRadius = 100; // Radio base
float rotationSpeed = 0.01; // Aceleración para el giro
float currentAngleSeconds = 0; // Ángulo actual de los segundos
float currentAngleMinutes = 0; // Ángulo actual de los minutos
float currentAngleHours = 0; // Ángulo actual de las horas

void setup() {
  size(800, 800);
  frameRate(60);

  // Inicializar niveles y colores
  secondsLevels = new float[numLines];
  minutesLevels = new float[numLines];
  hoursLevels = new float[numLines];
  secondsColors = new color[numLines];
  minutesColors = new color[numLines];
  hoursColors = new color[numLines];
  
  for (int i = 0; i < numLines; i++) {
    secondsLevels[i] = 0; // Alturas iniciales
    minutesLevels[i] = 0;
    hoursLevels[i] = 0;
    secondsColors[i] = color(255); // Blanco por defecto
    minutesColors[i] = color(255);
    hoursColors[i] = color(255);
  }
}

void draw() {
  background(20);
  translate(width / 2, height / 2);

  // Incremento constante para rotación (giro más rápido)
  currentAngleSeconds += rotationSpeed;
  currentAngleMinutes += rotationSpeed;
  currentAngleHours += rotationSpeed;

  // Dibujar los tres anillos
  drawRing(secondsLevels, secondsColors, baseRadius + 50, currentAngleSeconds, 50, true, 2);  // Aro exterior (Segundos)
  drawRing(minutesLevels, minutesColors, baseRadius + 100, currentAngleMinutes, 30, true, 1.5); // Aro intermedio (Minutos)
  drawRing(hoursLevels, hoursColors, baseRadius + 150, currentAngleHours, 20, false, 1); // Aro interior (Horas)
}

void drawRing(float[] levels, color[] colors, int radius, float currentAngle, float growthFactor, boolean growOutwards, float thickness) {
  for (int i = 0; i < numLines; i++) {
    float angle = TWO_PI / numLines * i + currentAngle;
    float x1 = cos(angle) * radius;
    float y1 = sin(angle) * radius;
    
    // Modificación del crecimiento de las barras
    float x2, y2;
    if (growOutwards) {
      // Barras externas (segundos y minutos) crecen hacia fuera
      x2 = cos(angle) * (radius + levels[i] * growthFactor);
      y2 = sin(angle) * (radius + levels[i] * growthFactor);
    } else {
      // Barras internas (horas) crecen hacia dentro
      x2 = cos(angle) * (radius - levels[i] * growthFactor);
      y2 = sin(angle) * (radius - levels[i] * growthFactor);
    }
    
    // Determinar el color basado en el nivel de interacción
    colors[i] = getColorForLevel(levels[i]);

    stroke(colors[i]);
    strokeWeight(thickness); // Grosor de las líneas
    line(x1, y1, x2, y2);
  }
}

// Función para asignar un color según el nivel de interacción
color getColorForLevel(float level) {
  if (level < 0.1) {
    return color(255); // Blanco para interacción baja
  } else if (level < 0.4) {
    return color(0, 0, 255); // Azul para interacción media
  } else {
    return color(255, 0, 0); // Rojo para interacción alta
  }
}

// Interacción con clic del mouse (Segundos)
void mousePressed() {
  int index = getActiveIndex();
  secondsLevels[index] = constrain(secondsLevels[index] + 0.5, 0, 1); // Incremento rápido
}

// Interacción con el teclado (Minutos y Horas)
void keyPressed() {
  int index = getActiveIndex();

  if (keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT) {
    minutesLevels[index] = constrain(minutesLevels[index] + 0.4, 0, 1); // Incremento rápido para minutos
  } else {
    hoursLevels[index] = constrain(hoursLevels[index] + 0.3, 0, 1); // Incremento rápido para horas
  }
}

// Calcula la barra activa en función de la rotación actual
int getActiveIndex() {
  float anglePerLine = TWO_PI / numLines;
  int index = int((currentAngleSeconds / anglePerLine) % numLines);
  return index;
}
