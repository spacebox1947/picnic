class Rotation {
  /*
  Determines the number of degrees to allow an incoming image to rotate.
  Has checks to see if the image is a drawing or a text scan.
  There are no cats here.
  */
  
  
  
  //Class Variables
  //FLOATS
  float rotDeg;      //Var for number of degrees for (180 / rotConst)
  float rotVal;      //Var to hold degrees of rotation!
  float tempRand;
  //INTS
  int rotConst;    //Constant to get number of divisions of 180deg for rotation
  //GHOSTS
  boolean textType;  //boolean for if the image has text (true)
  boolean mirrored;



//Constructor
//Lets spin, spin, spin!
Rotation (int checkRot, boolean pageType) {
  rotConst = checkRot; //get the rotation constant in degrees
  textType = pageType; //get type of image (true = text)
}



  void rotation() {
    //Rotate an image by a ratio of (float *180deg)
    //if image is not a text type image
    if (textType == false) {
      rotDeg = rotLoops();
      tempRand = random(100);
      if (tempRand < 39) {
        tempRand = float(int(random(5)));
        if (tempRand < 3) {
          rotVal = 0;
        }
        else if (tempRand >= 3) {
          rotVal = 180;
        }
      }
      else {
        tempRand = float(int(random(rotConst)));
        rotVal = (float(rotConst) * (1 + tempRand));
      }
    }
    //if image is textType, constrain possible rotations to ripe angels.
    else if (textType == true) {
      tempRand = random(100);
      println("Image is text. Rotating 0 or 90 or 180deg");
      if (tempRand < 34) {
        rotVal = 0;
      }
      else if (tempRand >= 34 && tempRand < 66) {
        rotVal = 90.0;
      }
      else rotVal = 180.0;
    }
    println("Rotation Value in Degrees: " + rotVal);
  //END rotation method
  }
  
  
  float rotLoops() {
    //return the number of loops to generate rotation angles in degrees less than 180
    float floatDeg;
    float loopTo180 = 180 / float(rotConst);
    if (loopTo180 < floor(loopTo180)) {
      floatDeg = floor(loopTo180);
    }
    else {
      floatDeg = loopTo180;
    }
    return floatDeg;
  }
  
  
  
  float rotVal() {
    //Pass rotVal var to main method!
    return rotVal;
  }
  
  
  
  boolean mirrorImg() {
    //50% chance to mirror image horizontally
    tempRand = random(100);
    if (tempRand < 49.0) {
      mirrored = true;
    }
    else mirrored = false;
    println("Image will be mirrored: " + mirrored);
    return mirrored;
    //END mirrorImg() function
  }
  
  
 
//END Rotation() class 
//Stare at something that isn't moving.
}
