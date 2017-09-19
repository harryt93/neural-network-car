//Neural network class, primary purpose is to generate a graphical network on screen when given a set of weights.
//The class also computes the outputs of the network using feedforward algorithms since these conveniently result in useful outputs to generate the graphical structure.
class Neural_Net
{
  //Data structures to describe the network structure.
  NNS nns;
  Neurons[][] neurons;
  
  float[][] outputs;
  int IDofBestGene;
  
  Neural_Net(NNS _NNS)
  {
    nns = new NNS(_NNS.numInLayer);
    
    neurons = new Neurons[nns.totalLayers][];
    outputs = new float[nns.totalLayers][];
    
    for(int i=0; i < nns.totalLayers; i++)
    {
      neurons[i] = new Neurons[nns.getNumInLayer(i)];
    }
    
    for(int i=0;i<nns.totalLayers;i++)
    {
      for(int j=0;j<neurons[i].length;j++){neurons[i][j] = new Neurons(600+100*i, 100*j+50);}
    }
    
    for(int i=0; i<nns.totalLayers; i++)
    {
      outputs[i] = new float[neurons[i].length];
    }
    
  }
  
  float[] calculateOutputs(float[] inputLayer, Gene gene)
  {
    float[][] result = new float[gene.nns.totalLayers][];
    result[0] = new float[inputLayer.length];
    result[0] = inputLayer;
    
    if(gene.ID == IDofBestGene)
    {
      outputs = result;
    }
    
    for(int i=0; i<(gene.nns.totalLayers-1);i++)
    {
      result[i+1] = new float[nns.getNumInLayer(i+1)];
      for(int a = 0; a < nns.getNumInLayer(i+1); a++)
      {
        float sum = 0;
        for(int b=0; b<result[i].length;b++)
        {
          sum += result[i][b]*gene.weights[i][a][b];
        }
        result[i+1][a] = 1/(1+exp(-sum));
      }
    }
    return result[gene.nns.totalLayers-1];
  }
  
  void display(Gene _gene)
  {
    IDofBestGene = _gene.ID;
    
    stroke(255);
    
    for(int i=1; i<nns.totalLayers;i++)
    {
        for(int j=0;j<neurons[i].length;j++){neurons[i][j].makeLinks(neurons[i-1], _gene.weights[i-1][j]);}
    }
    
    for(int i=0; i<nns.totalLayers;i++)
    {
        for(int j=0;j<neurons[i].length;j++){neurons[i][j].display(outputs[i][j]);}
    }
  }
}

class Neurons
{
  PVector location;
  Neurons(int x, int y)
  {
    location = new PVector(x, y);
  }
  void display(float value)
  {
    fill(0, 0, 0);
    ellipse(location.x, location.y, 40, 40);
    fill(255, 255, 255);
    text(value, location.x-20, location.y+5);
  }
  
  void makeLinks(Neurons[] previousLayer, float[] weightInformation)
  {
    for(int i=0;i<previousLayer.length;i++)
    {
      stroke(150, 150, 150);
      line(location.x, location.y, previousLayer[i].location.x, previousLayer[i].location.y);
      PVector link = location.get();
      link.sub(previousLayer[i].location);
      link.mult(0.2);
      textSize(9);
      fill(255, 255, 255);
      fill(150, 150, 150);
    }
  }
  void manualLabel(String message, int xOff, int yOff)
  {
    textSize(10);
      fill(255, 255, 255);
      text(message, location.x+xOff, location.y+yOff);
      fill(150, 150, 150);
  }
}