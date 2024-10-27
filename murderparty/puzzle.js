var rows = 5;
var columns = 5;
var index = 0;

var currTile;
var otherTile;
let correspondance = [1, 15, 14, 5, 3, 12, 9, 20, 8, 17, 4, 24, 23, 21, 11, 2, 19, 6, 13, 22, 10, 16, 0, 18, 7];


window.onload = function() {
    //initialize the 5x5 board
    for (let r = 0; r < rows; r++) {
        for (let c = 0; c < columns; c++) {
            //<img>
            let tile = document.createElement("img");
            tile.id = index
            tile.src = "./images/blank.jpg";
            tile.draggable = true

            //DRAG FUNCTIONALITY
            tile.addEventListener("dragstart", dragStart); //click on image to drag
            tile.addEventListener("dragover", dragOver);   //drag an image
            tile.addEventListener("dragenter", dragEnter); //dragging an image into another one
            tile.addEventListener("dragleave", dragLeave); //dragging an image away from another one
            tile.addEventListener("drop", dragDrop);       //drop an image onto another one
            tile.addEventListener("dragend", dragEnd);      //after you completed dragDrop

            document.getElementById("board").append(tile);
            index++ ;
        }
    }

    //pieces
    let pieces = [];
    for (let i=0; i < rows*columns; i++) {
        pieces.push(i.toString()); //put "1" to "25" into the array (puzzle images names)
    }
    pieces.reverse();
    for (let i =0; i < pieces.length; i++) {
        let j = Math.floor(Math.random() * pieces.length);

        //swap
        let tmp = pieces[i];
        pieces[i] = pieces[j];
        pieces[j] = tmp;
    }

    for (let i = 0; i < pieces.length; i++) {
        let tile = document.createElement("img");
        tile.src = "./images/" + pieces[i] + ".png";
        tile.draggable = true

        //DRAG FUNCTIONALITY
        tile.addEventListener("dragstart", dragStart); //click on image to drag
        tile.addEventListener("dragover", dragOver);   //drag an image
        tile.addEventListener("dragenter", dragEnter); //dragging an image into another one
        tile.addEventListener("dragleave", dragLeave); //dragging an image away from another one
        tile.addEventListener("drop", dragDrop);       //drop an image onto another one
        tile.addEventListener("dragend", dragEnd);      //after you completed dragDrop

        document.getElementById("pieces").append(tile);
    }
}
function checkTiles(){
    let solution = true
    let allTilesBoard = document.querySelectorAll("#board img")
    allTilesBoard.forEach(tile => {
        if(correspondance.indexOf(parseInt(tile.src.replace(/.*images\/(.*)\.png/,"$1"))) != tile.id){
            solution = false
        }
    })

    if(solution){
        document.querySelector("#solution").classList.remove("revel")
        let floues = [6, 21, 23]
        for(let i = 0 ; i < floues.length ; i++) {
            document.getElementById(correspondance.indexOf(floues[i])).src = "./images/" + floues[i] + "_clair.png"
        }
    }
}
//DRAG TILES
function dragStart() {
    currTile = this; //this refers to image that was clicked on for dragging
}

function dragOver(e) {
    e.preventDefault();
}

function dragEnter(e) {
    e.preventDefault();
}

function dragLeave() {

}

function dragDrop() {
    otherTile = this; //this refers to image that is being dropped on
}

function dragEnd() {
    if (currTile.src.includes("blank")) {
        return;
    }
    let currImg = currTile.src;
    let otherImg = otherTile.src;
    currTile.src = otherImg;
    otherTile.src = currImg;
    console.log(otherTile.id, otherTile.src.replace(/.*images\/(.*)\.png/,"$1"), correspondance.indexOf(parseInt(otherTile.src.replace(/.*images\/(.*)\.png/,"$1"))), correspondance)
    checkTiles()
}
