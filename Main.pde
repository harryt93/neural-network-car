//Declare system wide objects
Neural_Net nn;
Controller c;
Menu menu;
NNS programNNS;

PImage logo;
PVector mouseClick;

String fileToLoad;
float trackData[][];
int numLines;
boolean menuActive;
boolean placeActive;

int mode;//1 = train, 2 = race

int neuralNetworkIndex;
float timeThisRun;

float[] timeSinceLastRun;

void setup() 
{
  //Initialise system wide objects
  menu = new Menu();

  //Setup graphical bit and pieces
  logo = new PImage();
  logo = loadImage("logo.png");
  size(1250,700);
 
  //Initialise all utility variables used throughout the file.
  mouseClick = new PVector(10, 10);
  timeSinceLastRun = new float[100];
  neuralNetworkIndex = 0;
  
  //Set switches
  menuActive = true;
  placeActive = false;

}

//When the user clicks, it is always to pick a starting point. Therefore, switch off the placeActive switch to tell the program to start running.
//Record the click position and call the investigateNeuralNetwork function to create the neural network.
void mouseClicked() {
  if(placeActive)
  {
    placeActive = false;
    mouseClick.x = mouseX;
    mouseClick.y = mouseY;
    createNetwork();
  }
}

//Create a new neural network, if the switch for structure investigation is set, then use a switch to iterate through a variety of structures.
//Create the controller that will supervise the cars.
void createNetwork()
{
  programNNS = new NNS(new int[]{5,3,2});
  c = new Controller(programNNS);
  nn = new Neural_Net(programNNS);
  neuralNetworkIndex++;
  timeThisRun = millis();
}

//in Processing, the draw function also acts like the update function. It is called every frame and form the basis of the program loop.
void draw() 
{ 
  //If the menu is active, display the menu, let the object determine what to display.
  if(menuActive)
  {
    background(100, 100, 100);
    fill(255, 255, 255);
    menu.display();
  }
  
  // if place switch is active, show the track and tell the user to pick a starting point but don't start.
  if(placeActive)
  {
    background(100, 100, 100);
    showTrack();
    fill(255, 255, 255);
    textSize(14);
    text("Click anywhere on the track to spawn the cars at that location.", 600, 50);
    text("During simulation, press '0' at any time to return to the main menu.", 600, 75);
    text("To train effectively, you need to start in a black area.", 600, 100);
  }
  
  //if neither menu or place switches are active, then the program should run, display the track, the cars and the net.
  if(!menuActive&&!placeActive)
  {
    background(100, 100, 100);
    stroke(255, 255, 255);
  
    //Check for the user pressing '0' to escape back to main menu
    if (keyPressed) 
    {
      if (key == '0') 
      {
        if(mode==1)
        {
          c.saveGene(c.cars[NUMBER_OF_GENES_IN_GENE_POOL-1].gene);
        }
          menuActive = true;
          menu.state = 0;
      }
    }
          
    //Draw the track, update all cars and display them. Update and display the neural network.
    showTrack();
    c.update();
    c.display();
    nn.display(c.getBestGene());
  }
}

//Load track from memory.
void loadTrack(String path)
{
  //Load file into string array
  String lines[] = loadStrings(path);
  
  //Create a matrix to hold the data with an extra column for a polygon value.
  trackData = new float[lines.length][5];
  numLines = lines.length;
  
  //Loop through all lines in the file, split into the four values and add them to the matrix
  for(int i=0;i<lines.length;i++)
  {
    String[] line = split(lines[i], ' ');
    for(int j=0; j<4; j++)
    {
      trackData[i][j] = float(line[j]);
    }
    
    //Perform shifting and scaling to get the track in the right place. 
    trackData[i][1] *= -1;
    trackData[i][3] *= -1;
    trackData[i][0] += 275;
    trackData[i][1] += 275;
    trackData[i][2] += 275;
    trackData[i][3] += 275;
    trackData[i][4] = i+10;
  }
}

void showTrack()
{
  //Draw a darker rectangle in the top left to hold the track
  fill(50, 50, 50);
  rect(0,0,550,550);
 
  //Draw all polygons defined in the matrix, colour them according to the score they were given if its in training mode.
  for(int i=1;i<numLines;i++)
  {
    //If training mode, draw the polygon a shade of blue proportional to the value given to it when it was loaded.
    int col = int((trackData[i-1][4])*1.1);
    if(col >255)col = 255;
    fill(0, 0, col);
    stroke(0, 0, col);
    
    //If race mode, draw all in black.
    if(mode==2)
    {
      fill(0,0,0);
      stroke(0,0,0);
    }
    //Draw the polygon
    beginShape();
    vertex(trackData[i-1][0], trackData[i-1][1]);
    vertex(trackData[i][0], trackData[i][1]);
    vertex(trackData[i][2], trackData[i][3]);
    vertex(trackData[i-1][2], trackData[i-1][3]);
    endShape(CLOSE);
  }
  
  //if training mode, draw a start and finish line to prevent cars going backwards and also record successful finishes.
  if(mode==1)
  {
    stroke(0, 255, 0);
    line(trackData[0][0], trackData[0][1], trackData[0][2], trackData[0][3]);
    stroke(0, 0, 255);
    line(trackData[0][0], trackData[0][1]+6, trackData[0][2], trackData[0][3]+6);
    stroke(255, 255, 255);
  }
}



 