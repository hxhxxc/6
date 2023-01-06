

int lifetime;  // How long should each generation live

Population population;  // Population

int lifecycle;          // Timer for cycle of generation
int recordtime;         // Fastest time to target

Obstacle target;        // Target position

//int diam = 24;          // Size of target

ArrayList<Obstacle> obstacles;  //an array list to keep track of all the obstacles!
PVector obstacleNew;  //新的障碍物坐标

void setup() {
  size(1000, 500);
  // The number of cycles we will allow a generation to live
  lifetime = 500;

  // Initialize variables
  lifecycle = 0;
  recordtime = lifetime;
  
  target = new Obstacle(width/2-12, 24, 24, 24);
  target.setColorFill( #fc5185 );

  // Create a population with a mutation rate, and population max
  float mutationRate = 0.01;
  population = new Population(mutationRate, 50);

  // Create the obstacle course  
  obstacles = new ArrayList<Obstacle>();
  obstacleNew = new PVector(0,0,0);
  
}

void draw() {
  background(255);

  // Draw the start and target positions
  target.display();


  // If the generation hasn't ended yet
  if (lifecycle < lifetime) {
    population.live(obstacles);
    if ((population.targetReached()) && (lifecycle < recordtime)) {
      recordtime = lifecycle;
    }
    lifecycle++;
    // Otherwise a new generation
  } 
  else {
    lifecycle = 0;
    population.fitness();
    population.selection();
    population.reproduction();
  }

  // Draw the obstacles
  for (Obstacle obs : obstacles) {
    obs.display();
  }
  if( obstacleNew.z == 1 ){
      if( mousePressed ){
         rectMode(CORNER);
         fill(random(0,100));
         rect(obstacleNew.x, obstacleNew.y, mouseX-obstacleNew.x, mouseY-obstacleNew.y);
      }
      else{
        obstacleNew.z = 0;
        obstacles.add(new Obstacle(obstacleNew.x, obstacleNew.y, mouseX-obstacleNew.x, mouseY-obstacleNew.y));
      }
  }

  // Display some info
  fill(0);
  text("Generation #: " + population.getGenerations(), 10, 18);
  text("Cycles left: " + (lifetime-lifecycle), 10, 36);
  text("Record cycles: " + recordtime, 10, 54);
  
  //适应度最高的火箭轨迹
  fill(color(200,50,50));
  noStroke();
  ellipseMode(CENTER);
  for( PVector[] maxTrail : population.getMaxFitnessTrail() ){
    for( PVector one : maxTrail ){
      circle(one.x, one.y, 1);
    }
  }
}

// Move the target if the mouse is pressed
// System will adapt to new target
void mousePressed() {
  if ( mouseButton == LEFT) {
    target.position.x = mouseX;
    target.position.y = mouseY;
    recordtime = lifetime;
  } else if ( mouseButton == RIGHT ) {
    obstacleNew.x = mouseX;
    obstacleNew.y = mouseY;
    obstacleNew.z = 1;
  }
  
}
