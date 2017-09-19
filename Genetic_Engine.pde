//Custom datastructure to describe the structure of the neural network. 
//Contain some utility functions to aid other parts of the program accessing the data.
class NNS
{
  int[] numInLayer;
  int totalLayers;
  
  NNS(int[] _numInLayers)
  {  
    totalLayers = _numInLayers.length;
    numInLayer = new int[totalLayers];
    
    for(int i=0; i<totalLayers;i++)
    {
      numInLayer[i] = _numInLayers[i];
    }
  }
  
  int getNumInLayer(int layer)
  {
    return numInLayer[layer];
  }
  
  int getNumWeights()
  {
    int num = 0;
    for(int i=1; i<totalLayers;i++)
    {
      num += numInLayer[i]*numInLayer[i-1];
    }
    return num;
  }
}

class Gene
{
  int score;
  int ID;
  
  NNS nns;
  
  float[][] w01;
  float[][] w12;
  float[][] w23;
  float[][] w34;
  float[][] w45;
  
  float[][][] weights;
  
  Gene(NNS _NNS, int _ID)
  {
    //Initialise variables
    score = 0;
    ID = _ID;
    
    //Initialise the neural network structure
    nns = new NNS(_NNS.numInLayer);
    
    //Initialise the weights matrix
    weights = new float[nns.totalLayers-1][][];
    for(int i=0; i<(nns.totalLayers-1);i++)
    {
      weights[i] = new float[nns.getNumInLayer(i+1)][nns.getNumInLayer(i)];
    }
    generateRandomWeights(3);
  }
  
  //Quick function to return either a or b.
  float binaryChoice(float a, float b)
  {
    int x = (int)random(2);
    if(x==0)
    {
      return a;
    }
      return b;
  }
  
  //Algorithm to aproduce a new gene by averaging the value of two genes
  Gene average(Gene gene1, Gene gene2)
  {
    float[] sequence1 = new float[gene1.nns.getNumWeights()];
    float[] sequence2 = new float[gene1.nns.getNumWeights()];
    int index = 0;
    
    //Turn each gene into a long sequence of code.
    for(int i=0; i<(gene1.nns.totalLayers-1);i++)
    {
      for(int a=0; a<gene1.nns.getNumInLayer(i+1); a++)
      {
        for(int b=0; b<gene1.nns.getNumInLayer(i);b++)
        {
          sequence1[index] = gene1.weights[i][a][b];
          index++;
        }
      }
    }
    
    //reset index
    index = 0;
    
    //Turn each gene into a long sequence of code.
    for(int i=0; i<(gene2.nns.totalLayers-1);i++)
    {
      for(int a=0; a<gene2.nns.getNumInLayer(i+1); a++)
      {
        for(int b=0; b<gene2.nns.getNumInLayer(i);b++)
        {
          sequence2[index] = gene2.weights[i][a][b];
          index++;
        }
      }
    }
    
    //Perform crossover
    for(int i = 0; i<sequence1.length; i++)
    {
      sequence1[i] = (sequence1[i]+sequence2[i])/2;
    }
    
    //Put gene1 back together
    index = 0;
    for(int i=0; i<(gene1.nns.totalLayers-1);i++)
    {
      for(int a=0; a<gene1.nns.getNumInLayer(i+1); a++)
      {
        for(int b=0; b<gene1.nns.getNumInLayer(i);b++)
        {
          gene1.weights[i][a][b] = sequence1[index];
          index++;
        }
      }
    }
    
    return gene1;
  }
  
  
  //Algorithm to perform crossing over
  Gene crossOver(Gene gene1, Gene gene2, int numTimes)
  {
    float[] sequence1 = new float[gene1.nns.getNumWeights()];
    float[] sequence2 = new float[gene1.nns.getNumWeights()];
    int index = 0;
    
    //Turn each gene into a long sequence of code.
    for(int i=0; i<(gene1.nns.totalLayers-1);i++)
    {
      for(int a=0; a<gene1.nns.getNumInLayer(i+1); a++)
      {
        for(int b=0; b<gene1.nns.getNumInLayer(i);b++)
        {
          sequence1[index] = gene1.weights[i][a][b];
          index++;
        }
      }
    }
    
    //reset index
    index = 0;
    
    //Turn each gene into a long sequence of code.
    for(int i=0; i<(gene2.nns.totalLayers-1);i++)
    {
      for(int a=0; a<gene2.nns.getNumInLayer(i+1); a++)
      {
        for(int b=0; b<gene2.nns.getNumInLayer(i);b++)
        {
          sequence2[index] = gene2.weights[i][a][b];
          index++;
        }
      }
    }
      
      for(int j = 0; j<(gene1.nns.totalLayers-1); j++)
      {
        sequence1[j] = (sequence1[j]+sequence2[j])/2;
      }

    //Put gene1 back together
    index = 0;
    for(int i=0; i<(gene1.nns.totalLayers-1);i++)
    {
      for(int a=0; a<gene1.nns.getNumInLayer(i+1); a++)
      {
        for(int b=0; b<gene1.nns.getNumInLayer(i);b++)
        {
          gene1.weights[i][a][b] = sequence1[index];
          index++;
        }
      }
    }
    
    return gene1;
  }
  
  //Gene function to perform mutation
  Gene mutate(Gene gene, int rate, float mag)
  {
    float[] sequence1 = new float[gene.nns.getNumWeights()];
    int index = 0;
    
    //Turn each gene into a long sequence of code.
    for(int i=0; i<(gene.nns.totalLayers-1);i++)
    {
      for(int a=0; a<gene.nns.getNumInLayer(i+1); a++)
      {
        for(int b=0; b<gene.nns.getNumInLayer(i);b++)
        {
          sequence1[index] = gene.weights[i][a][b];
          index++;
        }
      }
    }
  
    //Perform mutation
    for(int i = 0; i<sequence1.length; i++)
    {
      if(random(1, rate) < 1)sequence1[i] = (random(-mag, mag));
    }
    
    //Put gene1 back together
    index = 0;
    for(int i=0; i<(gene.nns.totalLayers-1);i++)
    {
      for(int a=0; a<gene.nns.getNumInLayer(i+1); a++)
      {
        for(int b=0; b<gene.nns.getNumInLayer(i);b++)
        {
          gene.weights[i][a][b] = sequence1[index];
          index++;
        }
      }
    }
    
    return gene;
  }
  
  
  //Algorithm to scan through all the weights in the gene and randomise them 
  void generateRandomWeights(float mag)
  {
    for(int i=0; i<(nns.totalLayers-1);i++)
    {
      for(int a=0; a<nns.getNumInLayer(i+1); a++)
      {
        for(int b=0; b<nns.getNumInLayer(i);b++)
        {
          weights[i][a][b] = random(-mag, mag);
        }
      }
    }
  }
  
  //Algorithm to scan through all the weights in the gene and add a small addition according to the value mag
  void smallChange(Gene gene, float mag)
  {
    for(int i=0; i<(nns.totalLayers-1);i++)
    {
      for(int a=0; a<nns.getNumInLayer(i+1); a++)
      {
        for(int b=0; b<nns.getNumInLayer(i);b++)
        {
          weights[i][a][b] = gene.weights[i][a][b] + random(-mag, mag);
        }
      }
    }
  }
}