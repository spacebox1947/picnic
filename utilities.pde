/*
  utilities contains a bunch of functions that don't necessitate their own class.
  mostly just bits and pieces of code for raising self esteem and making candles.
*/




//various stuff and things
float tempRand;
int numImg = 0;
float iMaxMul;
boolean totalLess; //false means total # of images to produce is >= num images 

//save file parameters
int day;
int hour;
String fileType = ".png";

String part;

String[] sigil = {
  "Exortation", "Hexation", "Fixation", 
  "Obfuscation", "Sigil", "Declaration", 
  "Curse", "Incantation", "Vestige",
  "Edifice" 
};

//image parameters
PImage imgAssigner;
int xSize, ySize;
String fileString;



/*
  METHODS AND FUNCTIONS
*/

void fileNamer(int iter, boolean typer) {
  //IMAGE FILE SETUP and NAME GRABBER
  //assign name of img to fieString to image and print
  // processed file name:
  // is the file coming from the text or drawing lists?
  if (typer == false) {
    fileString = drawList[iter];
    part = "d";
  }
  else {
    fileString = textList[iter - drawList.length];
    part = "t";
  }
}



PImage imgReturn() {
  //load a .png image from the data folder as assigned by fileNamer()
  //return the PImage to main sketch
  imgAssigner = loadImage(fileString, "png");
  return imgAssigner;
}



int imgXReturn() {
  //Assign Width of loaded image to xImg
  xSize= img.width;
  return xSize;
}  



int imgYReturn() {
  //Assign Height of loaded image to yImg
  ySize = img.height;
  return ySize;
}



void imagePrint() {
  //Print loaded image file and its original X x Y size in pixels
  println();
  println("Image Loaded: " + fileString);
  println("Image W x H: " + xSize, ySize);
}



int returnRotation(int valueIn, boolean textCase) {
  //takes user set rotation divisor maximum and returns a random value.
  //returns 2 on text images
  if (textCase == false) {
    if (valueIn < 2 || valueIn > 180) {
      println("Rotation Value exceeds min/max values. Constraining to nearest min/max value.");
    }
    valueIn = constrain(valueIn, 2, 180);
    println("Rotation Divisor is: " + valueIn);
    return valueIn;
  }
  else {
    println("Image is text. Ignoring Rotation Divisor assignment. Setting rotMul to 2");
    return 2;
  }
}



int returnPosterScale(int valueIn) {
  //takes user set max poster colors and returns a value.
  //minimum 2 colors
  if (valueIn < 3 || valueIn > 32) {
    valueIn = constrain(valueIn, 3, 32);
    println("Poster Color Value exceed min/max range. Constraining to nearest value");
  }
  println("Number of colors for posterization: " + valueIn);
  return valueIn;
}



float returnTintScale(int valueIn) {
  //takes user set max tint shades and returns a value.
  //Minimum tint shades 2
  if (valueIn < 2 || valueIn > 124) {
    valueIn = constrain(valueIn, 2, 124);
    println("Tint Color Scale exceeds min/max values, constraining to nearest min/max value.");
  }
  println("Number of scales of grey for tinting: " + valueIn);
  return valueIn;
}



int returnDecayScale(int valueIn) {
  //takes user set max decay loops and returns a random value.
  //minimum 1 decay loop
  if (valueIn < 1 || valueIn > 10) {
    valueIn = constrain(valueIn, 1, 10);
    println("Number of Decay loops exceeds min/max values. Constraining value between 1 and 10.");
  }
  println("Number of possible decays (dilation OR erosion): " + valueIn);
  return valueIn;
}



void listImageArrays() {
  //DEBUG: Print all images in order from /data/$ folder
  println("Printing numbered list of all scanned images.");
  println("No images will be produced or rendered.");
  println();
  println("Loading array drawList[]: " + drawList.length + " files.");
  println();
  println("Printing File Names in drawList[].");
  
  //display all drawList files with order number
  for (int i = 0; i < drawList.length; i++) {
    println(i + ": " + drawList[i]);
  }
  println();
  println("Loading array textList[]: " + textList.length + " files.");
  println();
  println("Printing File Names in textList[].");
  
  //display all textList files with order number
  for (int i = 0; i < textList.length; i++) {
    println(i + ": " + textList[i]);
  }
  println();
  println("Total number of scanned images: " + (textList.length + drawList.length));
  println();
  println("Listing of all images in /data/draw and /data/text succesful.");
  println("Set testImageArrayNames = false in void setup() to skip this test and render images.");
}



int returnNumImage (int imgMaximum) {
  //weighted probability to return a maximum number of images per render.
  //50% 1 - 3 images
  //25% 4 - 6 images
  //25% 7+ images
  println("Maximum number of images: " + imgMaximum);
  
  tempRand = random(100);
  /*
  50% chance for 3 or fewer images
  25% chance for 4 - 6 images
  25% for more than 6 images
  */
  if (tempRand < 49) {
    //3 or fewer images
    tempRand = random(300);
    if (tempRand > 199) {
      numImg = 3;
    }
    else if (tempRand > 99 && tempRand < 199) {
      numImg = 2;
    }
    else numImg = 1;
  }
  else {
    tempRand = random(100);
    if (tempRand < 49) {
      //4-6 or fewer images
      tempRand = random(300);
      if (tempRand > 199) {
        numImg = 6;
      }
      else if (tempRand > 99 && tempRand < 199) {
        numImg = 5;
      }
      else numImg = 4;
    }
    else {
      //6 -> imgMaximum images;
      iMaxMul = 100 / (imgMaximum - 6);
      println("Probability per # of images over 6: " + iMaxMul);
      tempRand = random(100);
      println(tempRand);
      for (int i = 0; i < (imgMaximum - 6); i++) {
        //println("i = " + i);
        //println((iMaxMul*i)+iMaxMul);
        if (((iMaxMul*i)+iMaxMul) > tempRand) {
          numImg = i + 6;
          break;
        }
      }
    }
  }
  println("Number of Images: " + numImg);
  return numImg;
}

int numberBlocks(int temp) {
  //takes user set max # of blocks and returns a value. Min 6 blocks.
  tempRand = int(random(temp)) + 6;
  println("Number of Blocks: " + tempRand);
  return int(tempRand);
}



void saveImage(String partType, boolean saveOn) {
  //Save the file dingus.
  //only if uWubMe == true
  println();
  println("Generating filename to save image as .png");
  println();
  day = day();
  hour = hour();
  println("Day and Hour: " + day + "-" + hour);
  
  String stringer = partType + "_" +
    sigil[int(random(sigil.length))] + "_" + 
    day + "-" + hour + "_" + 
    int(random(10000)) + int(random(10000)) + 
    fileType;
    
  println("Image Name: " + stringer);
  if (saveOn == true) {
     println("Saving Image.");
     save(stringer);
  }
  println();
  println();
  println();
  println();
}


//end of utilities. The bill is in the mail.
//#kashmoney
