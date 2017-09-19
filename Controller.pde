int NUMBER_OF_GENES_IN_GENE_POOL;

class Controller
{
  int count;
  
  //Array of car objects
  Car[] cars;
  
  Controller(NNS _nns)
  { 
    //Create 2000 cars if in training mode, otherwise, just 1
    NUMBER_OF_GENES_IN_GENE_POOL = 1000;
    if(mode==2)
    {
      NUMBER_OF_GENES_IN_GENE_POOL = 1;
    }
    count = 0;
    
    //Create the fleet of cars as an array
    cars = new Car[NUMBER_OF_GENES_IN_GENE_POOL];
    
    //Create and spawn all car obects in the fleet.
    for(int i = 0; i<NUMBER_OF_GENES_IN_GENE_POOL;i++)
    {
      //If in training mode, generate random cars.
      if(mode==1)
      {
        cars[i] = new Car(i+1, new Gene(_nns, (i+1)));
      }
      
      //if in racing mode, load the gene of the file chosen earlier.
      if(mode==2)
      {
        cars[i] = new Car(i+1, loadGene(i+1));
      }
      
      //Spawn them all
      cars[i].spawn();
      count++;
    }
  }
  
  Gene getBestGene()
  { 
    return cars[NUMBER_OF_GENES_IN_GENE_POOL-1].gene;
  }
  
  //Loop through all the cars in the fleet and update their positions based on the neural network controller
  void update()
  {
    for(int i = 0; i<NUMBER_OF_GENES_IN_GENE_POOL;i++)
    {
      if(cars[i]!=null)
      {
        cars[i].update(nn.calculateOutputs(cars[i].getInputs(), cars[i].getGene()));
      }
    }
  }
  
  //Display cars and text on the screen
  void display()
  {
    //Display all the cars
    for(int i = 0; i<NUMBER_OF_GENES_IN_GENE_POOL;i++)
    {
      if(cars[i]!=null)
      {
         cars[i].display();
      }
    }
    
    //Display Text on the screen, information about the top cars in the list
    String message;
    textSize(9);
    fill(220, 255, 220);
    
    message = "Number of spawns: " + count;
    text(message, 1100, 50);
    
    message = "Top 50 Cars: ";
    text(message, 1000, 30);
    message = "ID:Fitness ";
    text(message, 1000, 40);
    
    for(int i=1950 ; i<((NUMBER_OF_GENES_IN_GENE_POOL)); i++)
    {
      message = "Car: " + cars[i].ID + " : " + cars[i].gene.score;
      text(message, 1000, 50+(i-1950)*8);
    }
  }
  
  //Rearranges the array of genes so that the genes with the best score are at the start. Implements the Quicksort Algorithm
  void quickSortGenePool(int low, int high)
  {
    // pick the pivot
    int middle = low + (high - low) / 2;
    int pivot = cars[middle].gene.score;
 
    // make left < pivot and right > pivot
    int i = low, j = high;
    while (i <= j) {
      while (cars[i].gene.score < pivot) {
        i++;
      }
 
      while (cars[j].gene.score > pivot) {
        j--;
      }
 
      if (i <= j) {
        Car temp = cars[i];
        cars[i] = cars[j];
        cars[j] = temp;
        i++;
        j--;
      }
    }
 
    // recursively sort two sub parts
    if (low < j)
      quickSortGenePool(low, j);
 
    if (high > i)
      quickSortGenePool(i, high);
  }
  
  //This function takes in a gene and saves the genetic code to file.
  void saveGene(Gene geneToSave)
  {
    int numOfLayers = geneToSave.nns.totalLayers;
    int numOfWeights = geneToSave.nns.getNumWeights();
    
    String[] lines = new String[numOfWeights+numOfLayers+2];
    
    lines[0] = str(geneToSave.score);
    lines[1] = str(numOfLayers);
    
    for(int i=0; i<(numOfLayers); i++)
    {
      lines[i+2] = str(geneToSave.nns.numInLayer[i]);
    }
    
    int index = 2 + numOfLayers;
    
    for(int i=0; i<(geneToSave.nns.totalLayers-1);i++)
    {
      for(int a=0; a<geneToSave.nns.getNumInLayer(i+1); a++)
      {
        for(int b=0; b<geneToSave.nns.getNumInLayer(i);b++)
        {
          lines[index] = str(geneToSave.weights[i][a][b]);
          index++;
        }
      }
    }

    // Writes the strings to a file, each on a separate line
    saveStrings("Weights/customWeights.txt", lines);
    
  }
  
  //This function loads the genetic code from a file into the best gene.
  Gene loadGene(int ID)
  {
    String lines[] = loadStrings(fileToLoad);
    
    int score = 50;
    int numOfLayers = Integer.parseInt(lines[1]);
    int numInLayer[] = new int[numOfLayers];
    
    for(int i=0;i<numOfLayers;i++)
    {
      numInLayer[i] = Integer.parseInt(lines[i+2]);
    }
    
    Gene geneToLoad = new Gene(new NNS(numInLayer), ID);
    geneToLoad.score = score;
 
    int index = numOfLayers+1;
    
    for(int i=0; i<(geneToLoad.nns.totalLayers-1);i++)
    {
      for(int a=0; a<geneToLoad.nns.getNumInLayer(i+1); a++)
      {
        for(int b=0; b<geneToLoad.nns.getNumInLayer(i);b++)
        {
          index++;
          geneToLoad.weights[i][a][b] = float(lines[index]);
        }
      }
    } 
    return geneToLoad;
  }
  
  void die(Car deadCar)
  {
    //If the car scored higher than before, update the genes score
    if(deadCar.score > deadCar.gene.score)
    {
        deadCar.gene.score = deadCar.score;
    }
    
    //Sort the genepool to find the new worst and best genes
    quickSortGenePool(0, (NUMBER_OF_GENES_IN_GENE_POOL-1));
    
    //////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////EDITABLE PARAMETERS///////////////////////////////////////
    /////////////////////////////////Genetic Algorithm////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    //Between this comment head and the one below, is the space where genetic algorithms may be experimented with by the user.
    
    //You have a number of genetic algorithms at your disposal. 
    
    //All algorithms require access to the ranked list of cars, this can be accessed as follows.
    //cars[x] where x is the index. Cars at index 0 are the worst, cars at the other end are the best.
    //THe best car can be accessed with (NUMBER_OF_GENES_IN_GENE_POOL-1)
    
    //Variation - Most successful algorithm
    //deadCar.gene.smallChange(Gene gene, float mag);
    //Takes two parameters, a single parent and a mag. The parent should be the best car so far. The mag can be anything, but around 0.1 works well. 0.01 for very fine tuning.
    
    //Mutation
    //deadCar.gene.mutate(Gene gene, int rate, float mag);
    //Takes three parameters, a single parent a rate and a mag. The parent should be the best car so far. The rate is how often a weight is mutated, 0.01 is reasonable. mag is the amount to mutate.
    
    //Cross Over
    //deadCar.gene.crossOver(Gene gene1, Gene gene2, int numTimes)
    //Takes three parameters, two parents genes and the number of times to cross over. Cross over position is random.
    
    //Averaging
    //deadCar.gene. average(Gene gene1, Gene gene2)
    //Takes two parents and blends the weights by averaging them. 
    
    // In the case provided upon submission of this code, all of the cars are given new neural networks based on a variation of the best car. Some are given small variations, some are given larger variations.
    if(deadCar != cars[NUMBER_OF_GENES_IN_GENE_POOL-1])
    {
      deadCar.gene.smallChange(cars[NUMBER_OF_GENES_IN_GENE_POOL-1].gene, 2);
      
      if(deadCar.ID < 400)
      {
        //deadCar.gene.smallChange(cars[NUMBER_OF_GENES_IN_GENE_POOL-1].gene, 1);
      }
      else if(deadCar.ID < 800)
      {
        //deadCar.gene.smallChange(cars[NUMBER_OF_GENES_IN_GENE_POOL-1].gene, 0.08);
      }
      else if(deadCar.ID < 1200)
      {
        //deadCar.gene.smallChange(cars[NUMBER_OF_GENES_IN_GENE_POOL-1].gene, 0.06);
      }
      else if(deadCar.ID < 1600)
      {
        //deadCar.gene.smallChange(cars[NUMBER_OF_GENES_IN_GENE_POOL-1].gene, 0.04);
      }
      else
      {
        //deadCar.gene.smallChange(cars[NUMBER_OF_GENES_IN_GENE_POOL-1].gene, 0.02);
      }
    }
    
   
    ////////////////////////////////End Genetic Algorithm/////////////////////////////////////    
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    
    //Spawn the dead car with a new gene generated using the best gene in the gene pool
    deadCar.spawn();   
    count++;
  }
  
  Gene pickFromGenePool()
  {
   int sum = 0;
   for(int i=0; i<NUMBER_OF_GENES_IN_GENE_POOL; i++)
   {
     sum += (i+1);
   }
   
   Gene[] selectionArray = new Gene[sum];
   int index = 0;
   
   for(int i=0; i<NUMBER_OF_GENES_IN_GENE_POOL; i++)
   {
     for(int j=0; j<(i+1); j++)
     {
       selectionArray[index] = cars[i].gene;
       index++;
     }
   }
   
   int select = int(random(1, selectionArray.length));
   return selectionArray[select];
  }
}
  
  
  