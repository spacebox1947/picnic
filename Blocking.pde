class Blocking {
  /*
  A class that holds and calculates information about blocks in the canvas grid,
  ratio of width to height, size of blocks, draws a grid (if needed) and some other stuff.
  cats.
  */
  
  
  
  //Class Variables
  //FLOATS
  float sclX, sclY;  //Final scaled value of x, y to size final image
  float locX, locY;  //Location of image at center
  float ratX, ratY;  //Vars to hold value of ratio (0.0-1.0) of X to Y and Y to X
  float blocksX, blocksY; //Number of blocks for scaled X, Y
  float offsetX, offsetY; //offset for imageMode(CENTER);
  float blockSize, scaleInBlocks;   //Size of block in pixels and scaling factor (0 - 1.0) of final image
  float blockCheck;    //Low end of for loop (full sized image) formula : blockCheck + (5*indx)
  float tempRand;    //Var for random rolls!
  //INTS
  int numBlocks;     //Number of blocks (columns) to place images in
  int sqrSize;       //Size of canvas in pixels
  int maxSideBlocks;     //Number of blocks for largest image side
  int numImages;   //number of images per render, gotten from utilities.
  int iNum;      //track current iteration for text images.
  //GHOSTS!
  boolean drawGrid;  //Controls whether or not gridGen(); does shit.
  boolean typeText;
  
  
  
//Constructor!!
//Blocking the Builder!!
Blocking (int cSize, int numImg, int blocks, float checkBlock, boolean grid, boolean pageText, int iNumber) {
  numBlocks = blocks;
  //Make sure you don't mess up your own program and run 0 or 1 blocks...
  if (numBlocks < 4) {
    numBlocks = 4;
  }
  sqrSize = cSize;
  drawGrid = grid;
  blockCheck = checkBlock;
  numImages = numImg;
  typeText = pageText;
  iNum = iNumber;
  //END constructor
}



/*
Functions and Methods for displaying image, grid, rotation, and such
*/



  void blockingSetup(float imgX, float imgY) {
    //Set up the primary variables for Blocking class.
    //collect what is necessary to feel better about yourself.
    println();
    println("Sizing Image and Determining Location.");
    println();
    
    //Return float value of blockSize in pixels
    blockSize = getBlockSize();
    
    //First get ratio of X to Y and Y to X so image can retain scale of WxH within size();
    getRatioXY(imgX, imgY);
    
  //END blockingSetup() method
  }



  void gridGen() {
    //DEBUG method
    //Draw an X Y grid based on blockSize
    println("Drawing Grid: " + drawGrid);
    
    //drawGrid conditional
    if (drawGrid == true) {
      //Draw X grid
      for (float i = 1.0; i < numBlocks; i++) {
        strokeWeight(2);
        stroke(0);
        line(i*blockSize, 0, i*blockSize, sqrSize);
      }
      //Draw Y grid
      for (float i = 1.0; i < numBlocks; i++) {
        strokeWeight(2);
        stroke(0);
        line(0, i*blockSize, sqrSize, i*blockSize);
      }
    }
    
  //END gridGen() method
  }
  
  

  void scaleImage(float imgX, float imgY) {
    //Determines the size of the image (scaled to the canvas) in blocks
    //Corrects for imageMode(CENTER)
    //Gets final scale value in blocks (0 - 1.0) for the image
    //text images do not call this method after the first image is processed
    println();
    //Convert imgX to scale of canvas
    sclX = (imgX / sqrSize);
    println("X axis to Canvas X axis = " + sclX);
    sclX = ((imgX / sclX) * ratX) * scaleInBlocks;
    println("X axis scaled to " + sclX + " Pixels.");
    
    //Convert imgY to scale of canvas
    sclY = (imgY / sqrSize);
    println("Y axis to Canvas Y axis = " + sclY);
    sclY = ((imgY / sclY) * ratY) * scaleInBlocks;
    println("Y axis scaled to " + sclY + " Pixels.");
    
    //determine size of scaled image in WHOLE blocks
    blocksX = numBlocksX();
    blocksY = numBlocksY();
    println("Size of image in Blocks (X, Y): " + blocksX, blocksY);
    
    //determine the offset values of X and Y
    offsetX = offset(sclX);
    offsetY = offset(sclY);
    println("Offset for imageMode(CENTER) (X, Y): " + offsetX, offsetY);
    
  //END scaleImage() method
  }
    
  
  
  void getBlocksXYpage() {
    //Weights the average size in blocks of the rendered image.
    if (numImages <= 6) {
      tempRand = random(100);
      if (tempRand < 39) {
        println("Image Will be weighted to a large size.");
        tempRand = numBlocks - int(random(.25 * numBlocks));
        scaleInBlocks = tempRand / float(numBlocks);
        println("Scale in Blocks W||H * (0 - 1): " + scaleInBlocks);
      }
      else {
        println("Image Will be weighted to a medium size.");
        tempRand = int(.75 * numBlocks) - int(random(.5 * numBlocks));
        scaleInBlocks = tempRand / float(numBlocks);
      }
    }
    else {
      tempRand = random(100);
      if (tempRand < 39) {
        println("Image Will be weighted to a small size.");
        tempRand = int(.75 * numBlocks) - int(random(.75 * numBlocks));
        scaleInBlocks = tempRand / float(numBlocks);
      }
      else {
        println("Image Will be weighted to a very small size.");
        tempRand = int(random(.9 * numBlocks)) + 1;
        scaleInBlocks = tempRand / float(numBlocks);
      }
    }
    println("Scale in Blocks W||H * (0 - 1): " + scaleInBlocks);
  //END getBlocksXY method
  }
  
  
  
  void setScaleInBlocks(float textBlockScaleConstant) {
    //sets scaleInBlocks for images after i = 0 in a text scan save file
    scaleInBlocks = textBlockScaleConstant;
    println("Base scaled block size for text images after i = 0: " + scaleInBlocks);
  }
  
  
  
  void getRatioXY(float imgX, float imgY) {
    //Calculate the ratio of X to Y, setting the larger of the two as 1.0.
    if (imgX >= imgY) {
      ratX = 1.0;
      ratY = imgY / imgX;
    }
    else {
      ratX = imgX / imgY;
      ratY = 1.0;
    }
    println("Determing which is Greater, X or Y.");
    println("X, Y relative size (0.0 - 1.0 range): " + ratX, ratY);
    
  //END getRatioXY method.
  }
  
  
  
  void transLation() {
    //sets the upper right corner of the image for location.
    //text images ignore this method after the first iteration
    println("Determining Location for non-text OR first text Pages.");
    //get possible X locations
    int tempLoc = numBlocks - int(blocksX);
    println("Possible Locations for X: " + tempLoc);
    tempRand = int(random(tempLoc));
    println("Location in blocks X : " + tempRand);
    locX = tempRand * blockSize;
    
    //get possible Y locations
    tempLoc = numBlocks - int(blocksY);
    println("Possible Locations for Y: " + tempLoc);
    tempRand = int(random(tempLoc));
    println("Location in blocks Y : " + tempRand);
    locY = tempRand * blockSize;
    
    //END translation method
  }

  
  
  void printSclXY() {
    //Print the final image size.
    //Much excite.
    println();
    println("Final Image size X x Y: " + int(sclX), int(sclY));
  }
  
  
  
  void printLocXY() {
    //print the final image location for TL corner
    //Really, so excite.
    println("Center of Image: " + int(locX), int(locY));
  }
  
  
  
/*
Start of functions!
*/
  
  
  
  float getBlockSize() {
    //collects the blocks size as a ratio of the canvas size to the number of blocks requested
    blockSize = float(sqrSize) / float(numBlocks);
    println("Size of 1x1 Block in Pixels = " + blockSize);
    return blockSize;
  }
  
  
  
  float scaleInBlocks() {
    //holds scaleInBlocks for non 0 iterations of text images
    return scaleInBlocks;
  }
  
  
  
  float offset(float scaleIn) {
    //get the offset of a Y or X side of image. keen
    float offset = .5 * scaleIn;
    return offset;
  }
  
  
  
  int blockSizeRandom() {
    //an additional offset of the block location for text images
    int tempVal = int(random(.25 * blockSize)) - int(.125 * blockSize);
    println("Additional offset in pixels: " + tempVal);
    return tempVal;
  }
  
  
  
  float numBlocksX() {
    //Figure out how many blocks are in the X axis scaled to canvas
    float temp = sclX % blockSize; //rounded down scale in blocks
    //println("sclX % blockSize = " + temp);
    temp = sclX - temp;
    //println("Floor rounding of sclX to next lowest block size: " + temp);
    float pixBlocksX = temp + blockSize;
    //println("Round up sclX to block size in pixels: " + pixBlocksX);
    float blocksInX = pixBlocksX / blockSize;
    println("Number of blocks in X: " + blocksInX);
    return blocksInX;
  }
  
  
  
  float numBlocksY() {
    //Figure out how many blocks are in the Y axis scaled to canvas
    float temp = sclY % blockSize; //rounded down scale in blocks
    //println("sclY % blockSize = " + temp);
    temp = sclY - temp;
    //println("Floor rounding of sclY to next lowest block size: " + temp);
    float pixBlocksY = temp + blockSize;
    println("Round up sclY to block size in pixels: " + pixBlocksY);
    float blocksInY = pixBlocksY / blockSize;
    println("Number of blocks in Y: " + blocksInY);
    return blocksInY;
  }
  
  
  
  int scaledX() {
    //return the final int form of the scaled X axis to the main method
    return int(sclX);
  }
  
  
  
  int scaledY() {
    //return the final int form of the scaled Y axis to the main method
    return int(sclY);
  }
  
  
  
  
  int locX() {
    //return the translation value for X in the main method
    if (iNum > 0 && typeText == true) {
      tempRand = random(-1.25, 1.25) * offsetX;
      locX = locX + offsetX + tempRand;
    }
    else locX = locX + offsetX;
    return int(locX);
  }
  
  
  
  int locY() {
    //return the translation value for Y in the main method
    if (iNum > 0 && typeText == true) {
      tempRand = random(-1.25, 1.25) * offsetY;
      locY = locY + offsetY + tempRand;
    }
    else locY = locY + offsetY;
    return int(locY);
  }

  
  
  
//END Blocking() class and methods.
//Puppies.
}
