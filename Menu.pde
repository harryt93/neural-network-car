//This entire class is dedicated to allowing the user to move through the menus and setup various options.
class Menu
{
  int state;

  void Menu()
  {
    state = 0;
  }
  
  //Switch operator that implements a state machine for the menu. Options are recorded as key presses and allow the user to move through the state machine.
  void display()
  { 
    switch(state)
    {
      case 0:
      {
        if (keyPressed) 
        {
          if (key == '1') 
          {
            state = 1;
          }
          if (key == '2') 
          {
            state = 2;
          }
          if (key == '3') 
          {
            state = 3;
          }
        } 
        image(logo, 40, -40);
        textSize(20);
        text("Welcome to AI Cars! This program simulates virtual cars on a track that are controlled with a neural network.", 100, 200);
        text("The program has the ability to both simulate and train the cars. Please read instructions first.", 100, 225);
        text("Choose an option below by pressing the relevant key on the numberpad.", 100, 275);
        text("(If nothing happens, you may need to click the screen to switch focus to the program, for some reason)", 100, 325);        
        text("1  Instructions (Read First)", 100, 400);
        text("2  Train a Car", 100, 450);
        text("3  Race a Car", 100, 500);
        break;
      }
      case 1:
      {
        if (keyPressed) 
        {
          if (key == '0') 
          {
            state = 0;
          }
        } 
        textSize(28);
        text("Racing a Car", 50, 100);
        textSize(16);
        text("In race mode, you will be given the option to chose a custom set of weights or a pretrained set of weights for the network controlling the car.", 50, 125);
        text("The pretrained weights have been trained for over 3 hours and are considered an optimum solution, they cannot be edited. The custom", 50, 150);
        text("weights may be trained by running the program in training mode. You will be then be given the option to chose a track to race on,", 50, 175);
        text("after this you must select a starting position for the car.", 50, 200);
        
        textSize(28);
        text("Training a Car", 50, 250);
        textSize(16);
        text("In training mode, you may train your own network to control the car. The resulting network is saved in a file called customWeights.txt which", 50, 275);
        text("may be used by selecting the relevant option in race mode. Every time you enter training mode, customWeights.txt is overwritten.", 50, 300);
        text("You will be asked to select a track to train on and then to pick a starting point for the cars.", 50, 325);
        
        textSize(28);
        text("Using your own Tracks", 50, 375);
        textSize(16);
        text("You may use your own tracks for training and racing. In both modes, you will be asked to pick a track from a list that is generated by scanning", 50, 400);
        text("the Tracks folder for .dat files. Simply place your own .dat file into the Tracks folder in the working directory. A valid track file must contain four columns", 50, 425);
        text("of values, where columns 1 and 2 define the coordinate of the inside track and columns 3 and 4 define the coordinates of the outside track.", 50, 450);
        text("The data must also be written in the order in which it progresses around the track.", 50, 475);
        
        textSize(28);
        text("Editing Parameters", 50, 525);
        textSize(16);
        text("You may edit parameters of the car and the Evolutionary Algorithm by editing the code. The areas are highlighted with comments to make it easy to find.", 50, 550);
        text("Parameters for editing the car can be found at the very top of the Car.pde file.", 50, 575);
        text("Parameters for editing the Evolutionary Algorithm can be found near the bottom of Controller.pde", 50, 600);
        
        text("0  Main Menu", 50, 650);
        break;
      }
      case 2:
      {
        mode = 1;
        File theDir = new File(sketchPath("Tracks"));
        String[] theList = theDir.list();
        
        if (keyPressed) 
        {
          if (key == '0') 
          {
            state = 0;
          }
          
          if (key == '3') 
          {
            if(theList.length > 1)
            {
              String p = "Tracks/" + theList[1];
              loadTrack(p);
             menuActive = false;
              placeActive = true;
            }
          }
          
          if (key == '4') 
          {
            if(theList.length > 2)
            {
              String p = "Tracks/" + theList[2];
              loadTrack(p);
            menuActive = false;
              placeActive = true;
            }
          }
          
          if (key == '5') 
          {
            if(theList.length > 3)
            {
              String p = "Tracks/" + theList[3];
              loadTrack(p);
              menuActive = false;
              placeActive = true;
            }
          }
          
          if (key == '6') 
          {
            if(theList.length > 4)
            {
              String p = "Tracks/" + theList[4];
              loadTrack(p);
              menuActive = false;
              placeActive = true;
            }
          }
          
          if (key == '7') 
          {
            if(theList.length > 5)
            {
              String p = "Tracks/" + theList[5];
              loadTrack(p);
              menuActive = false;
              placeActive = true;
            }
          }
          
          if (key == '8') 
          {
            if(theList.length > 6)
            {
              String p = "Tracks/" + theList[6];
              loadTrack(p);
             menuActive = false;
              placeActive = true;
            }
          }
          
        } 
        textSize(28);
        text("Train a Car", 50, 100);
        textSize(16);
        text("Choose a track to train on:", 50, 125);
        
        String message;
        
        for(int i=1; i<theList.length;i++)
        {
              if(theList[i].contains("dat"))
              {
                message = str(i+2) + "    " + theList[i];
                text(message, 100, 175+25*i);
              }
        }
        
        text("0  Main Menu", 50, 575);
        break;
      }
      case 3:
      {
        mode = 2;
        File theDir = new File(sketchPath("Tracks"));
        String[] theList = theDir.list();
        
        if (keyPressed) 
        {
          if (key == '0') 
          {
            state = 0;
          }
          
          if (key == '4') 
          {
            if(theList.length > 1)
            {
              String p = "Tracks/" + theList[1];
              loadTrack(p);
               state = 4;
            }
          }
          
          if (key == '5') 
          {
            if(theList.length > 2)
            {
              String p = "Tracks/" + theList[2];
              loadTrack(p);
             state = 4;
            }
          }
          
          if (key == '6') 
          {
            if(theList.length > 3)
            {
              String p = "Tracks/" + theList[3];
              loadTrack(p);
             state = 4;
            }
          }
          
          if (key == '7') 
          {
            if(theList.length > 4)
            {
              String p = "Tracks/" + theList[4];
              loadTrack(p);
             state = 4;
            }
          }
          
          if (key == '8') 
          {
            if(theList.length > 5)
            {
              String p = "Tracks/" + theList[5];
              loadTrack(p);
             state = 4;
            }
          }
          
          if (key == '9') 
          {
            if(theList.length > 6)
            {
              String p = "Tracks/" + theList[6];
              loadTrack(p);
             state = 4;
            }
          }
          
        } 
        textSize(28);
        text("Race a Car", 50, 100);
        textSize(16);
        text("Choose a track to race on:", 50, 125);
        
        String message;
        
        for(int i=1; i<theList.length;i++)
        {
          if(theList[i].contains("dat"))
              {
              message = str(i+3) + "    " + theList[i];
              text(message, 100, 175+25*i);
              }
        }
        
        text("0  Main Menu", 50, 575);
        break;
      }
      case 4:
      {
        mode = 2;
        File theDir = new File(sketchPath("Weights"));
        String[] theList = theDir.list();
        
        if (keyPressed) 
        {
          if (key == '0') 
          {
            state = 0;
          }
          
          if (key == '1') 
          {
            if(theList.length > 1)
            {
              String p = "Weights/customWeights.txt";
              fileToLoad = p;
              menuActive = false;
              placeActive = true;
            }
          }
          
          if (key == '2') 
          {
            if(theList.length > 2)
            {
             String p = "Weights/finalWeights.txt";
              fileToLoad = p;
               menuActive = false;
                placeActive = true;
            }
          }
          
        } 
        textSize(28);
        text("Race a Car", 50, 100);
        textSize(16);
        text("Choose a set of weights to race on:", 50, 125);
        
        text("1  Custom Weights", 50, 175);
        text("2  Final Weights", 50, 200);
        
        text("0  Main Menu", 50, 575);
        break;
      }
    }
  }
  
}