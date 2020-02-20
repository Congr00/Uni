import { Fractal } from "fractals";
import { memory, fractal_set_bytes } from "fractals/fractal_bg"

const canvas = document.getElementById("fractal");
const fractal = Fractal.new();

const CELL_SIZE = 1;
const GRID_COLOR = "#CCCCCC";

const width = fractal.get_width();
const height = fractal.get_height();

canvas.height = (CELL_SIZE) * height + 1;
canvas.width = (CELL_SIZE) * width + 1;

const ctx = canvas.getContext('2d');

ctx.beginPath();
ctx.strokeStyle = GRID_COLOR;
ctx.lineTo(CELL_SIZE*width+1, 0);
ctx.lineTo(CELL_SIZE*width+1, CELL_SIZE*height+1);
ctx.lineTo(0, CELL_SIZE*height+1);
ctx.lineTo(0, 0);
ctx.lineTo(CELL_SIZE*width+1, 0);
ctx.stroke();

const drawCanvas = () => {
  
  const getIndex = (row, col) => {
    return row * width + col;
  }

  const ptr = fractal.mem();
  const arr = new Uint32Array(memory.buffer, ptr, width*height);
  for (let row = 0; row < height; row++){
    for (let col = 0; col < width; col++){
      const res = arr[getIndex(row, col)];
      if(res == 0){
        ctx.fillStyle = '#000';
      }
      else{
        ctx.fillStyle = 'hsl(0, 100%, ' + res + '%';
      }
      ctx.fillRect(row, col, CELL_SIZE, CELL_SIZE);
    }
  }
  /* 
  for(var x=0; x < width; x++) {
    for(var y=0; y < height; y++) {
      var res = fractal.in_set(x, y);
      if(res == 0){
        ctx.fillStyle = '#000';
      }
      else{
        ctx.fillStyle = 'hsl(0, 100%, ' + res + '%';
      }
      ctx.fillRect(x,y, CELL_SIZE, CELL_SIZE);
    }
  }*/
  
};

fractal.set_bytes();
drawCanvas();

var x_slider = document.getElementById("X");
var y_slider = document.getElementById("Y");
var m_slider = document.getElementById("MAG");
var a_slider = document.getElementById("ACC");

var lock_x = false;
var lock_y = false;
var lock_a = false;
var lock_m = false;

x_slider.oninput = function() {
  if (lock_x){
    return;
  }
  lock_x = true;
  fractal.set_x(this.value);
  fractal.set_bytes();
  drawCanvas();
  lock_x = false;
}
y_slider.oninput = function() {
  if (lock_y){
    return;
  }
  lock_y = true;
  fractal.set_y(this.value);
  fractal.set_bytes();
  drawCanvas();
  lock_y = false;
}
a_slider.oninput = function() {
  if (lock_a){
    return;
  }
  lock_a = true;
  fractal.set_acc(this.value);
  fractal.set_bytes();
  drawCanvas();
  lock_a = false;
}
m_slider.addEventListener('change', function() {
  if (lock_m){
    return;
  }
  lock_m = true;
  fractal.set_mag(this.value);
  fractal.set_bytes();
  drawCanvas();
  lock_m = false;
})