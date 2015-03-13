class Filters {
  /* 
  A class to process a stand-in "newImg" PImage in various ways.
  */
  
  
  
  //Class Variables
  //PImages
  PImage filtImg;
  PImage alphaImg;
  //INTS
  int imgNum;
  int posterScl;
  int decayMax;
  //FLOATS
  float tempRand;
  float tintScl;
  //GHOSTS
  boolean tinted;
  boolean poster;
  boolean inverted;
  boolean blur;
  boolean decay;
  boolean threshold;
  boolean textPage;
  
  
  
//Constructor
Filters(int posterScale, boolean pageType, float tintScale, int imgForNumber, int decayMaximum) {
  tintScl = tintScale;
  posterScl = posterScale;
  imgNum = imgForNumber;
  decayMax = decayMaximum;
  textPage = pageType;
}



/*
Methods
*/



  void getImage(PImage img) {
    println();
    println("Commencing Image Filter sequence...");
    filtImg = img;
  }
  
  
  
  void posterImage() {
    //Posterize image to a set number of colors at 50% Likelihood
    tempRand = random(100);
    print("Posterizing : ");
    if (tempRand < 49) {
      poster = true;
      println("Image is posterized :" + poster);
      posterScl = int(random(posterScl - 3)) + 3;
      println("Colors in Image: " + posterScl);
      filtImg.filter(POSTERIZE, posterScl);
    }
    else {
      poster = false;
      println("Image is posterized :" + poster);
    }
  //END posterImage method
  }
  
  
  
  void invertImage() {
    //Invert colors at 25% likelihood
    tempRand = random(100);
    if (tempRand < 25) {
      filtImg.filter(INVERT);
      inverted = true;
      println("Inverting Image: " + inverted);
    }
    else {
      inverted = false;
      println("Inverting Image: " + inverted);
    }
  //END invertImage method
  }
  
  
  
  void thresholdImage() {
    //Detect White and Black threshold
    //Apply white and black threshold (0.0 to 1.0 maximum)
    //ONLY if image is not posterized
    //if no posterization and type is a drawing
    if (poster == false && textPage == false) {
      //Create Threshold at 80% likelihood
      threshold = true;
      println("Creating B-W Threshold for image: " + threshold);  
      
      tempRand = random(100);
      //Black favoring threshold
      if (tempRand < 24) {
        println("Applying Threshold in range of 0.175 to 0.375");
        tempRand = (((random(1000) + 1) / 1000) * .2) + .175;
        println("Threshold Value: " + tempRand);
        filtImg.filter(THRESHOLD, tempRand);
      }
      //White favoring threshold
      else if (tempRand >= 74) {
        println("Applying Threshold in range of 0.625 to 0.825");
        tempRand = (((random(1000) + 1) / 1000) * .2) + .625;
        println("Threshold Value: " + tempRand);
        filtImg.filter(THRESHOLD, tempRand);
      }
      //Mid-range threshold (favors white or black equally)
      else {
        println("Applying Threshold in range of .4 to .6");
        tempRand = (((random(1000) + 1) / 1000) * .2) + .4;
        println("Threshold Value: " + tempRand);
        filtImg.filter(THRESHOLD, tempRand);
      }
    }
      
    //if no posterization and is a textPage
    else if (poster == false && textPage == true) {
      //Create Threshold at 100% likelihood
      threshold = true;
      println("Creating B-W Threshold of Text: " + threshold);  

      println("Applying Threshold in range of .38 to .62");
      tempRand = (((random(1000) + 1) / 1000) * .24) + .38;
      println("Threshold Value: " + tempRand);
      filtImg.filter(THRESHOLD, tempRand);
    }
    
    //if is a poster, just say no to thresholds.
    else {
      println("Posterized " + poster + ". Ignoring Threshold detection.");
      threshold = false;
      println("Creating B-W Threshold: " + threshold);
    }
      
  //END thresher() method
  }
  

  
  void alphaImage() {
    //convert all nearly white pixels to see through!
    filtImg.loadPixels();
    alphaImg = createImage(filtImg.width, filtImg.height, ARGB);
    for (int x = 0; x < filtImg.width; x++) {
      for (int y = 0; y < filtImg.height; y++) {
        int i = ((y * filtImg.width) + x);
        if (filtImg.pixels[i] >= color(245, 245, 245)) {
          alphaImg.pixels[i] = color(255, 255, 255, 0);
        }
        else {
          alphaImg.pixels[i] = filtImg.pixels[i];
        }
        alphaImg.updatePixels();
      }
    }
    //END transparent method
  }
  
  
  
  void blurImage() {
    //BLUR method
    //Gaussian BLUR 60% of the time: 60% moderate, 40% intense
    tempRand = random(100);
    if (tempRand < 39) {
      blur = false;
      println("Blurring Image: " + blur);
    }
    else if (tempRand >= 39) {
      blur = true;
      println("Blurring Image: " + blur);
      //Determine Blur intensity
      tempRand = random(100);
      if (tempRand < 59) {
        println("Moderate Blurring.");
        tempRand = random(2);
        println("Blur Intensity: " + tempRand);
        alphaImg.filter(BLUR, tempRand);
      }
      else {
        println("Intense Blurring.");
        tempRand = random(10) + 2;
        println("Blur Intensity: " + tempRand);
        alphaImg.filter(BLUR, tempRand);
      }
    }
  //END BLUR method
  }
  
  
  
  void decayImage() {
    //ERODE and DILATE methods
    //Erode increases diameter of darkest sections of picture
    //Dilate increases diameter of brightest sections of picture
    
    //Poster conditional. 50% chance to Decay
    if (poster == true) {
        tempRand = random(100);
        if (tempRand < 49) {
          decay = false;
          println("Dilating or Eroding Image: " + decay);
        }
        //25% chance to DILATE
        else if (tempRand >= 50 && tempRand < 75) {
          decay = true;
          println("Dilating or Eroding Image: " + decay);
          decayMax = int(random(decayMax)) + 1;
          println("Dilating: " + decayMax + " times.");
          for (int i = 0; i < decayMax; i++) {
            alphaImg.filter(DILATE);
          }
        }
        //25% chance to ERODE
        else if (tempRand >= 74) {
          decay = true;
          println("Dilating or Eroding Image: " + decay);
          decayMax = int(random(decayMax)) + 1;
          println("Eroding: " + decayMax + " times.");
          for (int i = 0; i < decayMax; i++) {
            alphaImg.filter(ERODE);
          }
        }
    //END poster = true conditional for Decay
    }   
    
    //Poster conditional. 50% chance to Decay
    if (poster == false) {
      tempRand = random(100);
      if (tempRand < 32) {
        decay = false;
        println("Dilating or Eroding Image: " + decay);
      }
      //33% chance to DILATE
      else if (tempRand >= 33 && tempRand < 67) {
        decay = true;
        println("Dilating or Eroding Image: " + decay);
        decayMax = int(random(decayMax)) + 1;
        println("Dilating: " + decayMax + " times.");
        for (int i = 0; i < decayMax; i++) {
          alphaImg.filter(DILATE);
        }
      }
      //33% chance to ERODE
      else if (tempRand >= 66) {
        decay = true;
        println("Dilating or Eroding Image: " + decay);
        decayMax = int(random(decayMax)) + 1;
        println("Eroding: " + decayMax + " times.");
        for (int i = 0; i < decayMax; i++) {
          alphaImg.filter(ERODE);
        }
      }
    //END poster = false conditional for Decay
    }
  //END decayImage method
  }
  
  
  
  void tintImage() {
    //Tint image at various scales of grey.
    tempRand = random(100);
    if (tempRand >= 85) {
      //Make Image Red
      tint(255, 0, 0, 255);
      tinted = true;
      println("Tinting Image: " + tinted);
      println("Image Tint: Red");
    }
    else if (tempRand >= 35 && tempRand < 80) {
      //Make Image a shade of translucent Gray
      tempRand = int(random(tintScl - 2) + 1) / tintScl;
      //println(tempRand);
      tempRand = tempRand * 255;
      tint(255, tempRand);
      tinted = true;
      println("Tinting Image: " + tinted);
      println("Image Tint: Grey: " + tempRand);
    }
    else if (tempRand < 35 && imgNum > 0) {
      tinted = true;
      println("Tinting Image: " + tinted);
      println("Converting Black Pixels to White...");
      println("Making any other pixel invisible!!!");
      alphaImg.loadPixels();
      //Make all pixels but black pixels transparent, turn black pixels into white pixels
      for (int x = 0; x < alphaImg.width; x++) {
        for (int y = 0; y < alphaImg.height; y++) {
          int i = ((y * alphaImg.width) + x);
          //Turn all non-black pixels to 100% transparent
          if (alphaImg.pixels[i] <= color(0, 0, 0)) {
            alphaImg.pixels[i] = color(0, 0, 0, 0);
          }
          //Convert black pixels to white pixels at no transparency
          else {
            alphaImg.pixels[i] = color(255, 255, 255, 255);
          }
          alphaImg.updatePixels();
        }
      }
    }
    else {
      tinted = false;
      println("Tinting Image: " + tinted);
      noTint();
    }
  //END tintImage method
  }
  
  
  void displayImage(float rotVal, int locX, int locY, int sclX, int sclY, boolean mirroring) {
    //Collect final image variables and display image to canvas.
    //Makes sure image is not bigger than the canvas.
    int halfX;
    int halfY;
    //Locate the top right corner of the image's canvas and offset, if need be
    translate(locX, locY);
    rotate(radians(rotVal));
    //mirror image conditional (Horizontal flip)
    if (mirroring == true) {
      scale(-1, 1);
    }
    
    if (rotVal == 0 || rotVal == 180) {
      halfX = 0;
      halfY = 0;
    }
    else {
      halfX = int( -.5 * locX);
      halfY = int( -.5 * locY);
    }
    
    if ((locX + abs(halfX)) > width) {
      locX = width - abs(halfX);
      println("Fixing X Location. Too Large.");
    }
    if ((locY + abs(halfY)) > height) {
      locY = height - abs(locY);
      println("Fixing Y Location. Too Large.");
    }
      
    //Display that beautiful work of art.
    image(alphaImg, halfX, halfY, sclX, sclY);
  }





//End Filter class
}
