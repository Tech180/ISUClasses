var FONT_SIZE_Y = 30; //the font size is the height
var FONT_SIZE_X = FONT_SIZE_Y / 1.5; //width of a character is less than height
var CANVAS_WIDTH = 1000;
var CANVAS_HEIGHT = 600;

var canvas = document.getElementById("canvas"); //canvas from html
var ctx = canvas.getContext('2d'); //set to 2d
var charGrid = new Array(); //2d array
var cloneArray;

var layer2 = document.getElementById("layer2"); //canvas from html
var ctx2 = layer2.getContext('2d'); //set to 2d

ctx.font = '30px monospace'; //font size and name, can be changed
ctx.rect(FONT_SIZE_X,0,FONT_SIZE_Y, canvas.height); //rect size that character is it, not visable till filled

var ascii = ' ';
var isDrawing;
var gridDisplayed = false;
var isEyeDropping = false;
var darkMode = false;
//BU stands for Button Up
var drawBU = true;
var eraseBU = true;
var eyedropBU = true;
var clearBU = true;
var gridBU = true;
var sizeBU = true;
var darkBU = true;
//setup/initialize charGrid. This function should probably be moved to an onLoad function for the sake of professionalism.
for (var i = 0; i < CANVAS_WIDTH / FONT_SIZE_X; i++) { 
    charGrid[i] = new Array; 
} 

for (var i = 0; i < CANVAS_WIDTH / FONT_SIZE_X; i++) { 
	for (var j = 0; j <= CANVAS_HEIGHT / FONT_SIZE_Y; j++) { 
		charGrid[i][j] = ' '; 
	} 

} 
//initialize canvas size display to correct size
displayCurrentCanvasSize()
displayCurrentChar()

function characterMenu() {

	//display character within a submenu
	document.getElementById("advanced").innerHTML = "";
	allButtonsUp();
	if(darkMode)
	{
		document.getElementById("number").src = "images/D_DrawDown.png";
	}
	else
	{
		document.getElementById("number").src = "images/DrawDown.png";
	}
	drawBU = false;
    let displayOptions = (

                          "<div id = \"clearCanvasWarning\" ><\div>"

                          + "<br>"
                          + "<br>"


                          +  "<label for \"clearCanvasWarning\">A-Z &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp a-z &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Numbers&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbspExtras</label>"
                          + "<br>"
                          + "<br>"

                          /*Sector 1*/

                          //Alphabet "Upper Case" p1
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"A\" onClick = \"characterSelect('A')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"B\" onClick = \"characterSelect('B')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"C\" onClick = \"characterSelect('C')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"D\" onClick = \"characterSelect('D')\" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp" //whitespace = &nbsp

                          //Alphebet "Lower Case" p1
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"a\" onClick = \"characterSelect('a')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"b\" onClick = \"characterSelect('b')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"c\" onClick = \"characterSelect('c')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"d\" onClick = \"characterSelect('d')\" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"

                          //Numbers p1
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"0\" onClick = \"characterSelect('zero')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"1\" onClick = \"characterSelect('one')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"2\" onClick = \"characterSelect('two')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"3\" onClick = \"characterSelect('three')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"4\" onClick = \"characterSelect('four')\" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"

                          //Extras p1
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"#\" onClick = \"characterSelect('number')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"!\" onClick = \"characterSelect('exclaim')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"?\" onClick = \"characterSelect('question')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"&\" onClick = \"characterSelect('and')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"'\" onClick = \"characterSelect('apostrophe')\" />"

                          /**/

                          + "<br>"

                          /*Sector 2*/
                          //Alphebet "Upper Case" p2
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"E\" onClick = \"characterSelect('E')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"F\" onClick = \"characterSelect('F')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"G\" onClick = \"characterSelect('G')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"H\" onClick = \"characterSelect('H')\" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"

                          //Alphabet "Lower Case" p2
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"e\" onClick = \"characterSelect('e')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"f\" onClick = \"characterSelect('f')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"g\" onClick = \"characterSelect('g')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"h\" onClick = \"characterSelect('h')\" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"

                          //Numbers p2
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"5\" onClick = \"characterSelect('five')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"6\" onClick = \"characterSelect('six')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"7\" onClick = \"characterSelect('seven')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"8\" onClick = \"characterSelect('eight')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"9\" onClick = \"characterSelect('nine')\" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"

                          //Extras p2
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"(\" onClick = \"characterSelect('parenth1')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \")\" onClick = \"characterSelect('parenth2')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \",\" onClick = \"characterSelect('comma')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"/\" onClick = \"characterSelect('bslash')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \";\" onClick = \"characterSelect('semicolon')\" />"

                          /**/

                          +"<br>"

                          /*Sector 3*/
                          //Alphabet "Upper Case" p3
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"I\" onClick = \"characterSelect('I')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"J\" onClick = \"characterSelect('J')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"K\" onClick = \"characterSelect('K')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"L\" onClick = \"characterSelect('L')\" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"

                          //Alphabet "Lower Case" p3
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"i\" onClick = \"characterSelect('i')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"j\" onClick = \"characterSelect('j')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"k\" onClick = \"characterSelect('k')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"l\" onClick = \"characterSelect('l')\" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"

                          //Extras p3
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"<\" onClick = \"characterSelect('sbrace')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \">\" onClick = \"characterSelect('ebrace')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"[\" onClick = \"characterSelect('sbracket')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"]\" onClick = \"characterSelect('ebracket')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"|\" onClick = \"characterSelect('vbar')\" />"


                          /* */

                          + "<br>"

                          /*Sector 4*/
                          //Alphabet "Upper Case" p4
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"M\" onClick = \"characterSelect('M')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"N\" onClick = \"characterSelect('N')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"O\" onClick = \"characterSelect('O')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"P\" onClick = \"characterSelect('P')\" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"

                          //Alphabet "Lower Case" p4
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"m\" onClick = \"characterSelect('m')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"n\" onClick = \"characterSelect('n')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"o\" onClick = \"characterSelect('o')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"p\" onClick = \"characterSelect('p')\" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"

                          //Math Label
                          +"<label for \"Math\">Math&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</label>"

                          //Extras p4
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"{\" onClick = \"characterSelect('scbracket')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"}\" onClick = \"characterSelect('ecbracket')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"`\" onClick = \"characterSelect('backtick')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"~\" onClick = \"characterSelect('squiggle')\" />"

                          /**/

                          + "<br>"

                          /*Sector 5*/
                          //Alphabet "Upper Case" p5
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"Q\" onClick = \"characterSelect('Q')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"R\" onClick = \"characterSelect('R')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"S\" onClick = \"characterSelect('S')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"T\" onClick = \"characterSelect('T')\" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"

                          //Alphabet "Lower Case" p5
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"q\" onClick = \"characterSelect('q')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"r\" onClick = \"characterSelect('r')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"s\" onClick = \"characterSelect('s')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"t\" onClick = \"characterSelect('t')\" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"

						  //Extras  p5
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"\\\" onClick = \"characterSelect('backslash')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"_\" onClick = \"characterSelect('_')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \".\" onClick = \"characterSelect('.')\" />"
                      
                          /**/

                          + "<br>"

                          /*Sector 6*/
                          //Alphabet "Upper Case" p6
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"U\" onClick = \"characterSelect('U')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"V\" onClick = \"characterSelect('V')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"W\" onClick = \"characterSelect('W')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"X\" onClick = \"characterSelect('X')\" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"

                          //Alphabet "Lower Case" p6
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"u\" onClick = \"characterSelect('u')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"v\" onClick = \"characterSelect('v')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"w\" onClick = \"characterSelect('w')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"x\" onClick = \"characterSelect('x')\" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"

                          //Math Symbols p1
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"$\" onClick = \"characterSelect('money')\" />"
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"%\" onClick = \"characterSelect('percent')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"*\" onClick = \"characterSelect('star')\" />"
                          /**/

                          + "<br>"

                          /*Sector 7*/
                          //Alphabet "Upper Case" p7
						  + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"Y\" onClick = \"characterSelect('Y')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"Z\" onClick = \"characterSelect('Z')\" />"

                          //whitespace
                          + "&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"

                          //Alphabet "Lower Case" p7
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"y\" onClick = \"characterSelect('y')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"z\" onClick = \"characterSelect('z')\" />"

                          //whitespace
                          + "&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"

                          //Math Symbols p2
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"+\" onClick = \"characterSelect('plus')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"=\" onClick = \"characterSelect('equal')\" />"
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"^\" onClick = \"characterSelect('carot')\" />"

                          /**/

                          /*
                          + "<input id = \"clearCanvasWarning\" type = \"button\" value = \"\\" onClick = \"characterSelect('backslash')\" />"
                          */
    );

    document.getElementById("advanced").innerHTML = displayOptions;

}

//Sorts though buttons to find the one you're looking for through a search bar
function searchList(){

    var input, sort, a, list, c, i, v;

    input = document.getElementById("advanced").innerHTML;
    sort = input.value.toUpperCase();
    a = document.getElementById("searchBar");
    list = a.getElementByTagName("list");

    for (i = 0; i < list.length; i++){

        c = list[i].getElementByTagName("list")[0];
        v = c.textContext || c.innerText;

        if (v.toUpperCase().indexOf(sort) > -1){
            list[i].style.display = "";
        }
        else {
            list[i].style.display = "none";
        }
    }

}



//select the ascii character based on button press
function characterSelect(action){
	cloneArray = JSON.parse(JSON.stringify(charGrid));
	
	console.log(action); //take the button select
	

	
	if(darkMode)
	{
		document.getElementById("eyeDrop").src =("images/D_EyedropperUp.png");
	}
	else
	{
		document.getElementById("eyeDrop").src =("images/EyedropperUp.png");
	}
	isEyeDropping = false;
	eyedropBU = true;
	
    if(action == 'characters') {
       characterMenu();
    }

    window.addEventListener('mousedown', mouseDown, false);
    window.addEventListener('mousemove', draw, false);
    window.addEventListener('mouseup', mouseUp, false);

    switch(action) {

        //extras
        case 'number':
            ascii = '#';
            break;
        case 'exclaim':
            ascii = '!';
            break;
        case 'question':
            ascii = '?';
            break;
        case 'space':
            ascii = ' ';
			if(darkMode)
			{
				document.getElementById("erase").src = "images/D_EraseDown.png";
			}
			else
			{
				document.getElementById("erase").src = "images/EraseDown.png";
			}
			eraseBU = false;
            break;
        case 'and':
            ascii = '&';
            break;
        case 'apostrophe':
            ascii = "'";
            break;
        case 'parenth1':
            ascii = '(';
            break;
        case 'parenth2':
            ascii = ')';
            break;
        case 'comma':
            ascii = ',';
            break;
        case 'bslash':
            ascii = '/';
            break;
        case 'semicolon':
            ascii = ';';
            break;
        case 'sbrace':
            ascii = '<';
            break;
        case 'ebrace':
            ascii = '>';
            break;
        case 'sbracket':
            ascii = '[';
            break;
        case 'ebracket':
            ascii = ']';
            break;
        case 'vbar':
            ascii = '|';
            break;
        case 'scbracket':
            ascii = '{';
            break;
        case 'ecbracket':
            ascii = '}';
            break;
        case 'backtick':
            ascii = '`';
            break;
        case 'squiggle':
            ascii = '~';
            break;
		 case 'backslash':
            ascii = '\\';
            break;
		 case '.':
            ascii = '.';
            break;
		 case '_':
            ascii = '_';
            break;

        //Alphabet "Upper Case"
        case 'A':
            ascii = 'A';
            break;
        case 'B':
            ascii = 'B';
            break;
        case 'C':
            ascii = 'C';
            break;
        case 'D':
            ascii = 'D';
            break;
        case 'E':
            ascii = 'E';
            break;
        case 'F':
            ascii = 'F';
            break;
        case 'G':
            ascii = 'G';
            break;
        case 'H':
            ascii = 'H';
            break;
        case 'I':
            ascii = 'I';
            break;
        case 'J':
            ascii = 'J';
            break;
        case 'K':
            ascii = 'K';
            break;
        case 'L':
            ascii = 'L';
            break;
        case 'M':
            ascii = 'M';
            break;
        case 'N':
            ascii = 'N';
            break;
        case 'O':
            ascii = 'O';
            break;
        case 'P':
            ascii = 'P';
            break;
        case 'Q':
            ascii = 'Q';
            break;
        case 'R':
            ascii = 'R';
            break;
        case 'S':
            ascii = 'S';
            break;
        case 'T':
            ascii = 'T';
            break;
        case 'U':
            ascii = 'U';
            break;
        case 'V':
            ascii = 'V';
            break;
        case 'W':
            ascii = 'W';
            break;
        case 'X':
            ascii = 'X';
            break;
        case 'Y':
            ascii = 'Y';
            break;
        case 'Z':
            ascii = 'Z';
            break;

        //Alphabet "Lower Case"
        case 'a':
            ascii = 'a';
            break;
        case 'b':
            ascii = 'b';
            break;
        case 'c':
            ascii = 'c';
            break;
        case 'd':
            ascii = 'd';
            break;
        case 'e':
            ascii = 'e';
            break;
        case 'f':
            ascii = 'f';
            break;
        case 'g':
            ascii = 'g';
            break;
        case 'h':
            ascii = 'h';
            break;
        case 'i':
            ascii = 'i';
            break;
        case 'j':
            ascii = 'j';
            break;
        case 'k':
            ascii = 'k';
            break;
        case 'l':
            ascii = 'l';
            break;
        case 'm':
            ascii = 'm';
            break;
        case 'n':
            ascii = 'n';
            break;
        case 'o':
            ascii = 'o';
            break;
        case 'p':
            ascii = 'p';
            break;
        case 'q':
            ascii = 'q';
            break;
        case 'r':
            ascii = 'r';
            break;
        case 's':
            ascii = 's';
            break;
        case 't':
            ascii = 't';
            break;
        case 'u':
            ascii = 'u';
            break;
        case 'v':
            ascii = 'v';
            break;
        case 'w':
            ascii = 'w';
            break;
        case 'x':
            ascii = 'x';
            break;
        case 'y':
            ascii = 'y';
            break;
        case 'z':
            ascii = 'z';
            break;

        //Numbers
        case 'zero':
            ascii = '0';
            break;
        case 'one':
            ascii = '1';
            break;
        case 'two':
            ascii = '2';
            break;
        case 'three':
            ascii = '3';
            break;
        case 'four':
            ascii = '4';
            break;
        case 'five':
            ascii = '5';
            break;
        case 'six':
            ascii = '6';
            break;
        case 'seven':
            ascii = '7';
            break;
        case 'eight':
            ascii = '8';
            break;
        case 'nine':
            ascii = '9';
            break;

        //Math
        case 'money':
            ascii = '$';
            break;
        case 'percent':
            ascii = '%';
            break;
        case 'star':
            ascii = '*';
            break;
        case 'plus':
            ascii = '+';
            break;
        case 'equal':
            ascii = '=';
            break;
        case 'carot':
            ascii = '^';
            break;

        //clear the canvas
        case 'clear':
            clear();
            break;

        case 'searchBar':
            searchList();
            break;
    }

	//...more ascii characters
	if(ascii != ' ')
	{
		if(darkMode)
			{
				document.getElementById("erase").src = "images/D_EraseUp.png";
			}
			else
			{
				document.getElementById("erase").src = "images/EraseUp.png";
			}
		eraseBU = true;
	}
	
	displayCurrentChar()
}


//displays the stored grid as one long string and uses an alert to show it.
//depreciated
/*
function displayGrid()
{
	var totalString = "";
	for (var j = 0; j < CANVAS_HEIGHT / FONT_SIZE_Y; j++)  
	{ 
		for (var i = 0; i < CANVAS_WIDTH / FONT_SIZE_X; i++) 
		{ 
			totalString += (charGrid[i][j]); //build a string out of the grid
		}
		totalString += ('\n');
	} 
	alert("Current work:\n" + totalString);
}
*/


function clearWarning(){
	//alert("Foo");
	//clear advanced before working
	document.getElementById("advanced").innerHTML = "";
	allButtonsUp();
	if(darkMode)
	{
		document.getElementById("confirmClear").src = "images/D_ClearDown.png";
	}
	else
	{
		document.getElementById("confirmClear").src = "images/ClearDown.png";	
	}
	clearBU = false;
	let clearOptions = ("<label for \"clearCanvasWarning\">Are you sure you want to delete your work? </label><input id = \"clearCanvasWarning\" type = \"button\" value = \"Clear All\" onClick = \"redirectToClear()\" />");
	document.getElementById("advanced").innerHTML = clearOptions;

}

//exists only because the clear button wont work if I ask it to onClick="clear()", but it works with whatever function I want other than that. Alternative solutions welcome.
function redirectToClear()
{
	clear();
}

//clear canvas
function clear()
{
	ctx.clearRect(0,0,canvas.width, canvas.height);
	for (var i = 0; i < CANVAS_WIDTH / FONT_SIZE_X; i++) 
	{ 
		for (var j = 0; j < CANVAS_HEIGHT / FONT_SIZE_Y; j++) 
		{ 
			charGrid[i][j] = ' '; //clear the grid
		} 
	} 
	//rebuild array
	charGrid = new Array();
	for (var i = 0; i < CANVAS_WIDTH / FONT_SIZE_X; i++) { 
		charGrid[i] = new Array; 
	} 

	for (var i = 0; i < CANVAS_WIDTH / FONT_SIZE_X; i++) { 
		for (var j = 0; j <= CANVAS_HEIGHT / FONT_SIZE_Y; j++) { 
			charGrid[i][j] = ' '; 
		} 

	} 
	//alert("Clearing work!");
	allButtonsUp();
}

function mouseDown(e){
	isDrawing = true;
}

function mouseUp(e){
	isDrawing = false;
}


function draw(e) {
	if(isDrawing === true && isEyeDropping == false){
		var pos = getMousePos(canvas, e); //call getMousePos function on the canvas
		posx = approximatePositionX(pos.x);
		posy = approximatePositionY(pos.y);
		
		ctx.clearRect(posx, posy - FONT_SIZE_Y, FONT_SIZE_X, FONT_SIZE_Y); //clear existing chracter
		if(darkMode)
		{
			ctx.fillStyle = "White";
		}
		else
		{
			ctx.fillStyle = "Black";
		}
		if(posx <= CANVAS_WIDTH && posy <= CANVAS_HEIGHT && posy > 0)
		{
		ctx.fillText(ascii, posx, posy);
		console.log(posx + ", " + posy);
		charGrid[posx / FONT_SIZE_X][posy / FONT_SIZE_Y] = ascii;
		}
	}
}

function approximatePositionX(pos)
{
	//pos += FONT_SIZE_X; //offsets the position of the mouse to account for the way fillText places chracters
	let offset = pos % FONT_SIZE_X;
	pos -= offset;
	//let distToHigher = 
	return pos;
}

function approximatePositionY(pos)
{
	pos += FONT_SIZE_Y; //offsets the position of the mouse to account for the way fillText places chracters
	let offset = pos % FONT_SIZE_Y;
	pos -= offset;
	return pos;
}

//get current mouse pos inside of the canvas
function getMousePos(canvas, evt) {
    var rect = canvas.getBoundingClientRect();
    return {
        x: (evt.clientX - rect.left) / (rect.right - rect.left) * canvas.width,
        y: (evt.clientY - rect.top) / (rect.bottom - rect.top) * canvas.height
    };
}

//called when the 'visible brid' button is checked. Displays or hides the grid accordingly.
function toggleGrid()
{
	if(!gridDisplayed)//if grid is off, trun it on
	{
		showGridlines();
		gridDisplayed = true;
		if(darkMode)
		{
			document.getElementById("gridlines").src = "images/D_ShowGridDown.png";
		}
		else
		{
			document.getElementById("gridlines").src = "images/ShowGridDown.png";
		}
		gridBU = false;
	}
	else//if grid is on, turn it off
	{
		hideGrid();
		gridDisplayed = false;
		if(darkMode)
		{
			document.getElementById("gridlines").src = "images/D_ShowGridUp.png";
		}
		else
		{
			document.getElementById("gridlines").src = "images/ShowGridUp.png";
		}
		gridBU = true;
	}
}

//shows the optional grid
function showGridlines()
{
	if(darkMode)
	{
		ctx2.strokeStyle = 'White';
	}
	else
	{
		ctx2.strokeStyle = 'Black';
	}
	ctx2.beginPath();
	ctx2.clearRect(0, 0, canvas.width, canvas.height);
	ctx2.lineWidth = 1;
	var i;
	for(i = 0; i < CANVAS_WIDTH; i+= FONT_SIZE_X)
	{
		
		ctx2.moveTo(i, 0);
		ctx2.lineTo(i, CANVAS_HEIGHT);
		ctx2.stroke();
	}
	var j;
	for(j = 0; j < CANVAS_HEIGHT; j += FONT_SIZE_Y)
	{
	
		ctx2.moveTo(0, j);
		ctx2.lineTo(CANVAS_WIDTH, j);
		ctx2.stroke();
		
	}
}

//hides the optional grid
function hideGrid()
{
	ctx2.clearRect(0, 0, canvas.width, canvas.height);
}

//initiates the Change Canvas Size advanced path.
//uses 'advanced' to create three buttons, width, height, and confirm. Changing the vlaue of width and height and then hitting confirm will change the value of the canvas
function changeCanvasSize()
{
	allButtonsUp();
	if(darkMode)
	{
		document.getElementById("changeSize").src = "images/D_ResizeDown.png";
	}
	else
	{
		document.getElementById("changeSize").src = "images/ResizeDown.png";
	}
	sizeBU = false;
	document.getElementById("advanced").innerHTML = "";
	let XWIDTH = CANVAS_WIDTH / FONT_SIZE_X;
	let YHEIGHT = CANVAS_HEIGHT/ FONT_SIZE_Y;
	//add changeX, changeY, and confirm changes button
	//the pluses allow us to have readable code without putting newlines in the HTML where they don't belong.
	let canvasSizeOptions = ("<label for \"xSize\">Canvas Width<\label><input id = \"xSize\" type = \"number\" value = \"1\"/>"
						  + "<br>"
						  + "<label for \"ySize\">Canvas Height<\label><input id = \"ySize\" type = \"number\" value = \"1\"/>"
						  + "<br>"
						  + "<label for \"confirmSizeChange\">Warning: changing the canvas size will clear your current work</label><input id = \"confirmSizeChange\" onClick = \"setCanvasSize()\" type = \"button\" value = \"Confirm Changes\"/>"
							);
	document.getElementById("advanced").innerHTML = canvasSizeOptions;
	document.getElementById("xSize").value = XWIDTH;
	document.getElementById("ySize").value = YHEIGHT;
}

//uses the valuse set in changeCanvasSize to actually change the size of the canvas. Clears up advanced division
function setCanvasSize()
{
	//clear array, set new canvas size
	clear();
	CANVAS_WIDTH = document.getElementById("xSize").value * FONT_SIZE_X
	ctx.canvas.width = CANVAS_WIDTH;
	ctx2.canvas.width = CANVAS_WIDTH; //don't forget the second canvas.
	CANVAS_HEIGHT = document.getElementById("ySize").value * FONT_SIZE_Y
	ctx.canvas.height = CANVAS_HEIGHT;
	ctx2.canvas.height = CANVAS_HEIGHT;
	
	
	//re-establish font. Without this, the font goes really tiny and I don't know why, but this fixes it.
	ctx.font = "30px monospace";
	
	//clear advanced
	document.getElementById("advanced").innerHTML = "";
	displayCurrentCanvasSize()
}

function displayCurrentCanvasSize()
{
	document.getElementById("canvasSizeMarker").innerHTML = "canvas size: " + CANVAS_WIDTH / FONT_SIZE_X + " x " + CANVAS_HEIGHT/ FONT_SIZE_Y;
}
function displayCurrentChar()
{
	document.getElementById("currentChar").innerHTML = "current character: " + ascii;
}


//puts all buttons that induce changes to <advanced> to the up position
function allButtonsUp()
{
	document.getElementById("confirmClear").src = "images/ClearUp.png";
	clearBU = true;
	document.getElementById("changeSize").src = "images/ResizeUp.png";
	sizeBU = true;
	document.getElementById("number").src = "images/DrawUp.png";
	drawBU = true;
	refreshButtons();
}

//copies contents of the array to clipboard
function copyArray()
{
	var i;
	var j;
	var str = '';
	for(i =0; i < charGrid[0].length; i++)
	{
		for(j = 0; j < charGrid.length; j++)
		{
			
			str = str.concat(charGrid[j][i]);
		}
		str = str.concat('\n');
	}
	navigator.clipboard.writeText(str);
}

function saveAsTxt()
{
	var i;
	var j;
	var str = '';
	for(i =0; i < charGrid[0].length; i++)
	{
		for(j = 0; j < charGrid.length; j++)
		{
			
			str = str.concat(charGrid[j][i]);
			
	
		}
		str = str.concat('\n');
	}
	var txt = document.getElementById("txt");
	var file = new Blob([str], {type: 'text/plain'});
	var url = window.URL.createObjectURL(file);
	txt.href = url;
	txt.download = 'saveWork.txt';

	txt.click();
}

function isDrop(event){
	isEyeDropping = true;
}
function dropMove(event){
	if(isEyeDropping == true){
		var pos = getMousePos(canvas, event); //call getMousePos function on the canvas
		posx = approximatePositionX(pos.x);
		posy = approximatePositionY(pos.y);
		//allButtonsUp();
		if(darkMode)
		{
			document.getElementById("eyeDrop").src = ("images/D_EyedropperUp.png");
		}
		else
		{
			document.getElementById("eyeDrop").src = ("images/EyedropperUp.png");
		}
		edropBU = true;
		if(charGrid[posx / FONT_SIZE_X][posy / FONT_SIZE_Y] == ' '){
			return;
		}
		ascii = charGrid[posx / FONT_SIZE_X][posy / FONT_SIZE_Y];
		isEyeDropping = false;
		displayCurrentChar();
	}
}
function dropUp(event){
	isEyeDropping = false;
	window.removeEventListener('mousedown', isDrop, false);
	window.removeEventListener('mousemove', dropMove, false);
	window.removeEventListener('mouseup', dropUp, false);
}

function eyeDropper(){
	isDrawing = false;
	//allButtonsUp();
	if(darkMode)
	{
			document.getElementById("eyeDrop").src = ("images/D_EyedropperDown.png");
	}
	else
	{
		document.getElementById("eyeDrop").src = ("images/EyedropperDown.png");
	}
	eyedropBU = false;
	if(darkMode)
	{
			document.getElementById("erase").src = ("images/D_EraseUp.png");
	}
	else
	{
		document.getElementById("erase").src = ("images/EraseUp.png");
	}
	eraseBU = true;
	window.addEventListener('mousedown', isDrop, false);
	window.addEventListener('mousemove', dropMove, false);
	window.addEventListener('mouseup', dropUp, false);
	
}

function toggleDarkMode() //fully toggle dark mode
{
	if(!darkMode)//activate dark mode
	{
		darkMode = true;
		document.body.style.background = 'DimGrey'; //change bg
		document.body.style.color = 'White'; //change font color
		document.getElementById("darkModeToggle").src = "images/D_DarkModeDown.png";
		document.getElementById("layer2").style = "position: absolute; left: 7px; top: 5000; z-index: 0; border:3px solid #FFFFFF";
		drakBU = false;
	}
	else//deactivate dark mode
	{
		darkMode = false;
		document.body.style.background = 'White'; //change bg
		document.body.style.color = 'Black'; //change font color
		document.getElementById("darkModeToggle").src = "images/DarkModeUp.png";
		document.getElementById("layer2").style = "position: absolute; left: 7px; top: 5000; z-index: 0; border:3px solid #000000";
		darkBU = true;
	}
	refreshGrid();
	refreshButtons();
}

function refreshButtons() //check the positions of all buttons and make sure theyre all the right color
{
	//console.log(document.getElementById("number").src);
	if(darkMode) //toggle all to dark mode
	{
		//draw button
		if(drawBU)
		{
			document.getElementById("number").src = "images/D_DrawUp.png";
		}
		else
		{
			document.getElementById("number").src = "images/D_DrawDown.png";
		}
		//erase button
		if(eraseBU)
		{
			document.getElementById("erase").src = "images/D_EraseUp.png";
		}
		else
		{
			document.getElementById("erase").src = "images/D_EraseDown.png";
		}
		//grid button
		if(gridBU)
		{
			document.getElementById("gridlines").src = "images/D_ShowGridUp.png";
		}
		else
		{
			document.getElementById("gridlines").src = "images/D_ShowGridDown.png";
		}
		//eyedrop button
		if(eyedropBU)
		{
			document.getElementById("eyeDrop").src = "images/D_EyedropperUp.png";
		}
		else
		{
			document.getElementById("eyeDrop").src = "images/D_EyedropperDown.png";
		}
		//clear button
		if(clearBU)
		{
			document.getElementById("confirmClear").src = "images/D_ClearUp.png";
		}
		else
		{
			document.getElementById("confirmClear").src = "images/D_ClearDown.png";
		}
		//resize button
		if(sizeBU)
		{
			document.getElementById("changeSize").src = "images/D_ResizeUp.png";
		}
		else
		{
			document.getElementById("changeSize").src = "images/D_ResizeDown.png";
		}
		//others
		document.getElementById("copyGrid").src = "images/D_CopyToClipboardUp.png";
		document.getElementById("downloadGrid").src = "images/D_downloadUp.png";
		document.getElementById("undoButton").src = "images/D_UndoUp.png";
		//document.getElementById("redoButton").src = "images/D_RedoUp.png";
		document.getElementById("refresh").src = "images/D_RefreshUp.png";
		document.getElementById("info").src = "images/D_InfoUp.png";
	}
	else
	{
		//draw button
		if(drawBU)
		{
			document.getElementById("number").src = "images/DrawUp.png";
		}
		else
		{
			document.getElementById("number").src = "images/DrawDown.png";
		}
		//erase button
		if(eraseBU)
		{
			document.getElementById("erase").src = "images/EraseUp.png";
		}
		else
		{
			document.getElementById("erase").src = "images/EraseDown.png";
		}
		//grid button
		if(gridBU)
		{
			document.getElementById("gridlines").src = "images/ShowGridUp.png";
		}
		else
		{
			document.getElementById("gridlines").src = "images/ShowGridDown.png";
		}
		//eyedrop button
		if(eyedropBU)
		{
			document.getElementById("eyeDrop").src = "images/EyedropperUp.png";
		}
		else
		{
			document.getElementById("eyeDrop").src = "images/EyedropperDown.png";
		}
		//clear button
		if(clearBU)
		{
			document.getElementById("confirmClear").src = "images/ClearUp.png";
		}
		else
		{
			document.getElementById("confirmClear").src = "images/ClearDown.png";
		}
		//resize button
		if(sizeBU)
		{
			document.getElementById("changeSize").src = "images/ResizeUp.png";
		}
		else
		{
			document.getElementById("changeSize").src = "images/ResizeDown.png";
		}
		//others
		document.getElementById("copyGrid").src = "images/CopyToClipboardUp.png";
		document.getElementById("downloadGrid").src = "images/downloadUp.png";
		document.getElementById("undoButton").src = "images/UndoUp.png";
		//document.getElementById("redoButton").src = "images/RedoUp.png";
		document.getElementById("refresh").src = "images/RefreshUp.png";
		document.getElementById("info").src = "images/InfoUp.png";
	}
	//document.getElementById("confirmClear").src = "images/ClearUp.png";
	//document.getElementById("changeSize").src = "images/ResizeUp.png";
	//document.getElementById("number").src = "images/DrawUp.png";
}

function refreshGrid() //delete and remake the grid, ensuring to rebuild it with the correct color.
{
	ctx.clearRect(0, 0, canvas.width, canvas.height);//clear canvas;
	if(darkMode)
	{
		ctx.fillStyle = "White";
	}
	else
	{
		ctx.fillStyle = "Black";
	}
	for(var y = 0; y <= CANVAS_HEIGHT; y += FONT_SIZE_Y)
	{
		for(var x = 0; x <= CANVAS_WIDTH - FONT_SIZE_X; x += FONT_SIZE_X)
		{
			ctx.fillText(charGrid[x / FONT_SIZE_X][y / FONT_SIZE_Y], x, y);
			//console.log(x + " " + y);
		}
	}
	if(gridDisplayed)
	{
		showGridlines();
	}
}

function undoText(){
	
	charGrid = cloneArray;
	refreshGrid();
	
}

function showHelp()
{
	alert("Welcome to asciicanvas.com! This website allows you to create artwork using any ascii character you'd like.\nThere are a few functions that you may need help with, so we'll cover that here.");
	alert("The first image you see in the row of buttons allows you to choose an ascii character to use. Once you select one, you can draw on the canvas with it.\n\nThe second button is for the 'Erase' function. Once you select this you will be able to erase any happy accidents you may have made.\n\nThe third button is for the Eyedropper tool. Once you click this, you'll be able to select a character you have already used by clicking it on the canvas.\n\nThe fourth button is the 'Clear' function. This will let you clear the canvas, but it will ask you beforehand to make sure you really want to clear it.\n\nThe next button allows you to toggle a grid overlay on the grid. Clicking it will turn the gridlines on and off with no effect on your work.\n\nThe sixth button lets you resize the canvas, so you can make artwork at whatever size you would like. Resizing the canvas will clear the canvas, so make sure you save whatever work you have before changing the size.");
	alert("The next button refreshes the grid. If you are experiencing any visual anomalies in the canvas, click this to make them go away.\n\n\nAfter that is the 'Undo' button. Pressing this will revert your canvas to how it was when you last changed characters.\n\n\nThe third to last button is for 'Dark Mode'. This changes the background of the site from white to dark grey, so you can work in a less bright environment.\n\n\n\nThank you for using our website and we hope you enjoy!");
}






