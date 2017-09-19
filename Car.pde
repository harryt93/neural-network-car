//////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////EDITABLE PARAMETERS///////////////////////////////////////
///////////////////////////////////Car PARAMETERS/////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// The car physics is most realistic with the following parameters: mass=1 inertia = 1 maxThrustForce = 1 steeringForce = 1
float mass = 1;
float inertia = 1;
float r = 5; //Dictates the size of the red triangle in race mode
float maxThrustForce = 1;
float maxSteeringForce = 1;
//////////////////////////////////////////////////////////////////////////////////////////
  
  
// Car Class
// Car Objects are fully capable of updating and displaying themselves.
// Principle actions of the car are to calculate data about itself, use a neural network to compute outputs and use a small physics engine to convert the outputs into motion.
class Car 
{
  //Dynamics data for the car
  PVector location,velocity,acceleration;
  
  //The set of weights describing the neural network for the car
  Gene gene;
  
  //Utility variables used through the script.
  int score,ID,time;
  float distanceToWall;
  
  boolean dead = false;
  
  //Accessor function
  Gene getGene(){return gene;}
  
  //Calculate the 5 inputs, which are the 5 distances to the wall at different angles.
  float[] getInputs()
  {
    float inputs[] = new float[5];
    
    inputs[0] = float(calculateDistanceToWall(0))/100;
    inputs[1] = float(calculateDistanceToWall(0.4))/100;
    inputs[2] = float(calculateDistanceToWall(-0.4))/100;
    inputs[3] = float(calculateDistanceToWall(1.5))/100;
    inputs[4] = float(calculateDistanceToWall(-1.5))/100;
    
    return inputs;
  }

  // Constructor, initialises the ID, assigns the gene
  Car(int _ID, Gene _gene) { ID = _ID;    gene = _gene; }
  
  //REstart the car at the bieginning and set all dynamics back to the start values. Reset score.
  void spawn(){
    location = new PVector(mouseClick.x, mouseClick.y);
    velocity = new PVector(0,-0.1);
    acceleration = new PVector(0,0);
    score = 0;
    time = millis();
  }
 
    
  //Calculate the distance to the wall at the angle given.
  int calculateDistanceToWall(float angle)
  {
    //Get the vector pointing in the required direction
    PVector dir = velocity.get();
    dir.rotate(angle);
    
    //Find the wall y incrementally building the vector until it hits the edge of the map (green vaue bigger than one)
    int a = 0;
    color c = 0;
    do
    {
      a++;
      dir.normalize();
      dir.mult(a);
      c = get((int)(location.x + dir.x), (int)(location.y + dir.y));
    }
    while(green(c) < 30);
    
    //return the size of the vector which is the distance to the wall.
    return a;
  }
  
  void SurvivalFunction()
  {
    //Increase the score
    //Get the colour below the car, if it's bigger than the current score, update the score to this value.
    color a = get((int)(location.x), (int)(location.y ));
    if(score < blue(a)) score = (int)blue(a);
    
    //If it hits the wall, kill
    if(calculateDistanceToWall(0)/5 < 1)c.die(this);
    
    //If the car reaches the finish
    if(score > 250)
    {

      //Update the score to a value much higher than those simply making it around the track, then kill it.
      score = 10000 - ((millis() - time)/100);
      c.die(this);
    }
    
    //if the car takes longer than 5 minutes, kill
    if((millis() - time)>60000){c.die(this);}
    
    //If velocity is too slow, kill
    if(sqrt(pow(velocity.x, 2) + pow(velocity.y, 2)) < 0.1){c.die(this);}
  }
 
  void update(float[] outputsFromNN) 
  {
    if(!dead)
    {
      //Check if car score is better than the neural network fitness, if so, update the fitness
      if(score > gene.score)gene.score = score;
        
      //Receive inputs from the NN and apply to car.
      addThrust(outputsFromNN[0]);
      addSteer((outputsFromNN[1]-0.5));
      
      //Compute new position based on basic physics engine
      velocity.add(acceleration);
      velocity.limit(10);
      location.add(velocity);
      
      //Reset the acceleration
      acceleration.mult(0);
      
      //Test for death and also update score
      SurvivalFunction();
    }
  }
  
  //Function to calcualte the required force to achieve the thrust, simply adds thrust to the car.
  void addThrust(float scaler)
  {
    PVector thrust = velocity.normalize();
    thrust.mult(scaler);
    thrust.mult(maxThrustForce);
    thrust.div(mass);
    applyForce(thrust);
  }
  
  //Function to calculate the required steering force to achieve a certain angle, results in a force being applied to the car.
  void addSteer(float angle) 
  {
    PVector forward = velocity.get();
    PVector newDirection = velocity.get();
    newDirection.normalize();
    newDirection.rotate(angle);

    PVector steer = PVector.sub(newDirection,forward);
    steer.mult(maxSteeringForce);
    steer.div(inertia);
    applyForce(steer);
  }
 
  void display() 
  {
    //If in race mode, draw a red triangle at the correct position, in the correct orientation.
    //If in training mode, siply draw white dots at the correct position.
    if(mode==2)
    {
      stroke(255, 0, 0);
      fill(255, 0, 0);
      pushMatrix();
      translate(location.x,location.y);
      rotate(velocity.heading() + PI/2);
      beginShape();
      vertex(0, -r*2);
      vertex(-r, r*2);
      vertex(r, r*2);
      endShape(CLOSE);
      popMatrix();
    }
    //else
    {
      stroke(255);
      point(location.x, location.y);
    }
  }
  
  //For a given force, divide it by the mass and add it to the acceleration. 
  void applyForce(PVector force) 
  {
    PVector f = force.get();   
    acceleration.add(f);
  }
}