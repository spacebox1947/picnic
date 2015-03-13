/*
*
*  picnic_v1 for Processing v2.0 or greater
*
*  Coded and conceived by Andrew Israelsen for 'Picnic: for the Number of Man'
*  Composed and Programmed between September 2014 - February 2015 and still going strong.
*  
*
*  Notes on Use:
*
*  Notes on void setup() and general use
*  Coded for Processing in Java mode.
*  All user controlled parameters are in void setup().
*    These values control certain variables that manipulate how picnic_v1 will render images.
*    picnic_v1 has been programmed with low end limits if certain parameters are set too low, such as number of blocks or decay iterations.
*    Setting values too high may give bad results. Suggested value ranges are given in void setup() for each variable.
*    I have done my best to group variables together in their respective tabs, so as to reduce clutter in this main sketch.
*
*    The user is able to set the total number of images to produce. The sketch automatically limits the minimum saved files to 256.
*
*    Even though the user can set the values for Filters and Rotation, not all methods in a class execute for every rendered image.
*    
*    IMPORTANT: It is highly suggested that the user set testImageArrayNames = true to make sure their computer will properly find images to load into Processing.
*      This is the default state of the sketch. The sketch will fail when run if Processing cannot find the /data/ directory in the sketch folder.
*        If the images fail to load, make sure you have the images in /draw and /text folders within /data in the sketch folder.
*        Go to the 'utilities' tab and type a verbose path (from C:/ or root) to the data folder. 
*        An example is provided.
*      If the images are succesfully found, the sketch will automatically set testImageArrayNames = false and render images based on void setup().
*      This can be disabled by removing the // from in front of noLoop();
*
*
*  Notes on void draw() method
*    draw() takes care of the rendering order and determining variables.
*    Once a total number of images is set, draw() will run until it is complete.
*    If you set the total number of images very high, it will take a considerable amount of time.
*    
*    IMPORTANT: Please do not change order of filters/blocking/rotation or how variables are assigned, or picnic_v1 will not work properly.
*    You CAN modify order and such, but will have to rewrite certain methods in that respective tab to keep this sketch working.
*    Feel free to add rendering and manipulation capabilities, but understand that it will take understanding of how this sketch communicates with itself.
*    
*    Future additions to picnic_v1 include the ability to render either PDF or other image types (.tiff, etc) as supported by Processing 2.0 and its libraries.
*    There is GUI in development to reduce need to change code in sketch.
*    Further interests include more flexibility in rendering order and flexibility of certain parts of the program such as using more than one scanned image in a rendered save file.
*    
*/



/*
*
*  Main Parameter Declarations
*  Constants and control parameters
*
*/



//Canvas and Display Parameters passed to classes
int sqrSize = 720;  //canvas size
int numBlocks;  //number of block in gridGen / scale of image
int numImages;  //number of images to display
float checkBlocks; //constant floor for number of blocks per image
int rotMul;    // Number to divide 180deg by



//Image Parameters
PImage img;
float xImg, yImg;
boolean gridDraw;
float textBlockScale; //variable for scale of image for the first image of a text scan save file
int textBlocks; //holds a constant value of blocks for each layer of a rendered text scan
int locXone, locYone; //place holder for location of first image of a rendered text scan
int locY, locX, iterLocY, iterLocX;
float rotVal;
boolean mirror;
int finalY, finalX;
int pstScl;
float tntScl;
int dScl;
boolean testImageArrayNames;  //DEBUG: print all image names in PATH
int billy; // iteration value holder for main method
int imgPerFile; //max possible images per a file. sent to returnNumImage(); in utilities
int totalImages; //number of images to render

//USER variables. Please adjust these in void setup() if you desire different results.
int rotationValue;
int tintColorValue;
int decayLoopValue;
int pictureColorValue;
int max; //max number of save files to generate


//saveFile() variables
boolean textBool = false;
//place holder to track wehter the score page is a description page or a regular page
int sigilVal;  //place holder for sigil Index
boolean saveBool;



/*
*
Main Method
*
*/

//setup
void setup() {
  size(sqrSize, sqrSize);
  imageMode(CENTER);
  //DEBUG: Draw a grid to show location of X, Y blocks.
  //NOT suggested when producing score files.
  //fairly useful for debugging class Blocking
  gridDraw = false;
  
  /* 
  USER CONTROLLED VARIABLES
  out of range variables will be constrained.
  */
  
  //testImageArrayNames = true;
  //comment out upper line, and remove // from line below to skip listing the image names
  testImageArrayNames = false; 

  //setting saveBool to 'true' saves each image rendered during void draw() to the picnic_v1 folder
  //you probably want this 'true' if you are rendering images!
  saveBool = true;
  
  //How Many Images total to Save to file
  //Larger numbers dramatically increases processing time.
  //picnic_v1 assumes a formula of max * totalSourceImages = totalImages.
  //see imageListArrays for totalSourceImages
  totalImages = 256;
  
  //How many times to render each scanned image as a new score page. min 1. 
  max = 1;
  
  //value sent to returnRotation(int)
  //suggested range 1 - 30. Min 1, max 30.
  //constrained value image can rotate by (eg. 1, 2, 3.. or 15, 30, 45, 60, etc.)
  rotationValue = 20;
  
  //value sent to returnTint(int)
  //suggested range even values of 2 - 124; minimum 2,  maximum 124.
  //tint picks scales of grey (not white or black)
  tintColorValue = 14;
  
  //value sent to returnDecay(int)
  //max number of DILATE or ERODE loops in class filters.
  //Suggested range 2 - 8. Minimum 1, max 10.
  //class Filters picks between DILATE or ERODE, either increasing light or dark areas respectively.
  decayLoopValue = 5;
  
  //value sent to returnPosterScale(int)
  //Renders the image into the selected number of colors.
  //Suggested range 3 - 16. Minimum 3, max 32.
  pictureColorValue = 5;
  
  //Maximum number of images per rendered file. Suggested 7 - 15
  //minimum : 1
  imgPerFile = 12;
}



//draw!
void draw() {
  //DEBUG:
  //List all image names to ensure Processing can find /data/$
  if (testImageArrayNames == true) {
    listImageArrays();
    noLoop();
  }
  //RENDER:
  //This is where the fun happens.
  //Fun.
  else {
    billy = 0;
    if (totalImages != (max * totalSourceImages)) {
      totalImages = max * totalSourceImages;
      println("Total Images not a multiple of max * source images. Reappropriating.");
      println("New Total = " + totalImages);
    }
    println("Generating " + max + " images per scanned image for rendering and saving.");
    println("Saving " + totalImages + " images total.");
    
    //main loop for rendering unique images to a save file
    //totalSourceImages
    while (billy < totalSourceImages) {
      /*
      Send current iteration of While loop and text or draw mode to fileNamer()
      Returns PImage, and int X x Y from loaded image.
      */
      if (billy == drawList.length) {
        textBool = true;
      }
      
      fileNamer(billy, textBool);
      img = imgReturn();
      xImg = imgXReturn();
      yImg = imgYReturn();
      imagePrint();
      
      //iterate billy to avoid infinity. billy is mortal!
      billy = billy + 1;
      
      for (int x = 0; x < (max + 1); x++) {
        if (x < (max)) {
          //local variables
          float locYTemp, locXTemp; //values to hold location of image for text images
          
          background(255);
          println();
          println("Image number: " + (x+1) + " of " + max);
          println();
          
          //Set upper limit for max number of possible images
          numImages = returnNumImage(imgPerFile);
          
          for (int i = 0; i < numImages; i ++) {
            picnicSetUpVar(i);
            //get rotation degrees (float)
            rotMul = returnRotation(rotationValue, textBool);
            //get poster scale (int)
            pstScl = returnPosterScale(pictureColorValue);
            //get tint scale (float)
            tntScl = returnTintScale(tintColorValue);
            //get decay scale (int)
            dScl =  returnDecayScale(decayLoopValue);
            
            //perform Filter class methods to manipulate image!
            Filters f;
            /*
            int posterScale = number of colors to posterize by (3 to Var)
            float tintScale = number of divisions of 255 for grey scale
            int imgForNumber = conditional control for images over 1 in final render
            int decayMaximum = control value for number of Dilate/Erode (min 3)
            */
            f = new Filters(pstScl, textBool, tntScl, i, dScl);
            
            //perform Blocking class methods to scale and size final image!
            Blocking b;
            /*
            int sqrSize = canvas X, Y values
            int numBlocks = number of blocks (rows or columns) to segment canvas by
            int checkBlocks value between 0 - 99 for weigted probability to pick size of image in blocks
            float rotMul = number to divide 180deg by 
            boolean: turn gridGen() method on/off
            */
            b = new Blocking(sqrSize, numImages, numBlocks, checkBlocks, gridDraw, textBool, i);
            
            //perform Rotation class methods and turn, turn, turn!
            Rotation r;
            /*
            float rotMul = constant to divide 180 by
            boolean pageBool = is it text or image?
            */
            r = new Rotation(rotMul, textBool);
            
            //run class Filters methods
            f.getImage(img);
            f.posterImage();
            f.thresholdImage();
            f.invertImage();
            f.alphaImage();
            f.blurImage();
            f.tintImage();
            f.decayImage();
            
            //run class Blocking methods
            b.blockingSetup(xImg, yImg);
            b.gridGen();
        
            if (textBool == false) {
              b.getBlocksXYpage();
            }
            else if (textBool == true) {
              if (i == 0) {
                b.getBlocksXYpage();
                textBlockScale = b.scaleInBlocks();
              }
              else {
                float tempTBS = textBlockScale * random(.95, 1.05);
                b.setScaleInBlocks(tempTBS);
              }
            }
            
            b.scaleImage(xImg, yImg);
            
            if (textBool == false) {
              b.transLation();
              locX = b.locX();
              locY = b.locY();
            }
            else if (textBool == true) {
              if (i == 0) {
                b.transLation();
                locX = b.locX();
                locY = b.locY();
                iterLocX = locX;
                iterLocY = locY;
              }
              else {
                locX = iterLocX + b.blockSizeRandom();
                locY = iterLocY + b.blockSizeRandom();
              }
            }
            
            finalX = b.scaledX();
            finalY =  b.scaledY();
              
            //perform rotation and mirroring
            println();
            println("Determining Rotation and Mirroring of Image.");
            println();
            r.rotation();
            mirror = r.mirrorImg();
            rotVal = r.rotVal();
              
            //print and process image!
            b.printSclXY();
            b.printLocXY();
            pushMatrix();
            f.displayImage(rotVal, locX, locY, finalX, finalY, mirror);
            popMatrix();
            
            println();
            println();
            println();
    
          }
          
          saveImage(part, saveBool); 
      
        }
        
        else {
          println();
          println("FINISHED.");
        }
      }
    }
    noLoop();
  }
//END draw() method
}



void picnicSetUpVar(int renderIter) {
  //int numBlocks : set number of blocks in X : Y grid
  //return number = random(input) + 6
  //keep a constant numBlocks for text images
  if (textBool == false) {
    numBlocks = numberBlocks(18) + 6;
  }
  else if (textBool == true && renderIter == 0) {
    numBlocks = numberBlocks(22);
    textBlocks = numBlocks;
  }
  else if (textBool == true && renderIter > 0) {
    numBlocks = textBlocks;
    println("Number of Blocks: " + numBlocks);
  }
}
