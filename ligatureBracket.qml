import QtQuick 2.0
import MuseScore 3.0
MuseScore {
    menuPath: "Plugins.LigatureBracket"
    description: "Format a Note Anchored Line as a horizontal bracket above the staff to identify ligatures."
    version: "1.1"
    
	//4.4 title: "LigatureBracket"
    //4.4 categoryCode: "composing-arranging-tools"
    Component.onCompleted : {
        if (mscoreMajorVersion >= 4 && mscoreMinorVersion <= 3) {
           title = qsTr("LigatureBracket") ;
           // thumbnailName = ".png";
           categoryCode = "composing-arranging-tools";
        }
    }
    
    function makeBracket(line) {
      var hookHeight = 1; //desired height of line hook

      //apply beginning and ending hooks
      line.beginHookType = 1; //90 degrees
      line.endHookType = 1; //90 degrees
      line.beginHookHeight = hookHeight;
      line.endHookHeight = hookHeight;
      
      //reset user offsets
      line.offsetX = 0;
      line.offsetY = 0;
      
      //todo: make this work over linebreaks without running twice
      var targetLine = -2; // -2 is two ledger lines above staff
      var origLine = line.posY.toPrecision(2) //Y of start point where 0 is top staff line
      
      var targetOffsetY;
      if(origLine<0) { //avoid collision when first note is high on the staff
            targetOffsetY = -2;
      } else {
            targetOffsetY = (targetLine-origLine);
      }
      line.offsetY = targetOffsetY;
      

      //todo: make this work if user adjusts points after running once
      var endPointOffset;
      if (Math.abs(line.bbox.y) == line.lineWidth) { //if line is already flat
            if(line.bbox.height == (line.lineWidth+hookHeight)
               && line.userOff2.y != 0) { //if line has already been processed
                 endPointOffset = Qt.point(0,line.userOff2.y);
            }
      } else if (line.bbox.y<0) { //if line ascends 
            endPointOffset = Qt.point(0,line.bbox.height+line.userOff2.y);
      } else { // if line descends
            endPointOffset = Qt.point (0,-line.bbox.height+line.userOff2.y);
      }     
      line.userOff2 = endPointOffset; //flatten the line
    
    } //end makeBracket function
    
    onRun: {
    
       curScore.startCmd();
       
        var elementsList = curScore.selection.elements;
        //Make sure something is selected.
        if (elementsList.length==0) {
            console.log("No selection. Please add a Note Anchored Line and select it.");
        } else {
            for (var i=0; i<elementsList.length; i++) {
                  if (elementsList[i].name != "TextLineSegment") {
                        console.log("Element",i,"is",elementsList[i].name,"type, so we do nothing.");
                  } else {
                        console.log("Processing Element",i,"in selection.");
                        makeBracket(elementsList[i]);
                  }
            } //end element list loop
        }
        
         curScore.endCmd();
         
        (typeof(quit) === 'undefined' ? Qt.quit : quit)()
    } //end onRun
}
